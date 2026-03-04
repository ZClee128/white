import SwiftUI

struct OrderDetailView: View {
    let originalOrder: Order
    @EnvironmentObject var store: DataStore
    @Environment(\.dismiss) var dismiss
    
    @State private var isProcessing = false
    @State private var showWeChatNotInstalled = false
    @State private var showConfirm = false
    
    private var order: Order {
        store.orders.first(where: { $0.id == originalOrder.id }) ?? originalOrder
    }
    
    private var isWeChatInstalled: Bool {
        guard let url = URL(string: "weixin://") else { return false }
        return UIApplication.shared.canOpenURL(url)
    }

    var body: some View {
        ZStack {
            Color(red: 0.07, green: 0.07, blue: 0.12).ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Status Card
                    VStack(spacing: 12) {
                        Image(systemName: order.status.icon)
                            .font(.system(size: 40))
                            .foregroundColor(order.status.color)
                        Text(order.status.rawValue)
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        Text("Order #\(order.orderNumber)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 20)
                    
                    // Order Info
                    VStack(spacing: 0) {
                        detailRow(label: "Item", value: order.figure.name)
                        Divider().background(Color.white.opacity(0.1))
                        detailRow(label: "Date", value: orderDate(order.orderDate))
                        Divider().background(Color.white.opacity(0.1))
                        detailRow(label: "Total", value: "$\(String(format: "%.2f", order.total + 4.99 + 1.50))")
                    }
                    .background(Color(red: 0.1, green: 0.1, blue: 0.15))
                    .cornerRadius(16)
                    
                    // Payment Section
                    if order.status == .pending {
                        VStack(spacing: 16) {
                            Text("This order is pending payment.")
                                .font(.subheadline)
                                .foregroundColor(.orange)
                            
                            Button {
                                if !isWeChatInstalled {
                                    showWeChatNotInstalled = true
                                    return
                                }
                                isProcessing = true
                                if let url = URL(string: "weixin://") {
                                    UIApplication.shared.open(url, options: [:]) { _ in }
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                    store.payForOrder(order)
                                    isProcessing = false
                                    showConfirm = true
                                }
                            } label: {
                                HStack {
                                    Spacer()
                                    if isProcessing {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    } else {
                                        Image(systemName: "message.fill")
                                        Text("Pay now with WeChat")
                                            .fontWeight(.bold)
                                    }
                                    Spacer()
                                }
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(height: 56)
                                .background(
                                    LinearGradient(colors: [Color(red: 0.07, green: 0.73, blue: 0.18), Color(red: 0.05, green: 0.58, blue: 0.13)],
                                                   startPoint: .leading, endPoint: .trailing)
                                )
                                .cornerRadius(16)
                            }
                            .disabled(isProcessing)
                        }
                        .padding(20)
                        .background(Color(red: 0.1, green: 0.1, blue: 0.15))
                        .cornerRadius(16)
                    }
                    Spacer()
                }
                .padding(.horizontal, 20)
            }
        }
        .navigationTitle("Order Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .alert("WeChat Not Installed", isPresented: $showWeChatNotInstalled) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Please install WeChat to use WeChat Pay.")
        }
        // When payment succeeds, we can show a brief confirmation
        .fullScreenCover(isPresented: $showConfirm) {
            OrderConfirmView(figure: order.figure, isFromRepayment: true)
                .environmentObject(store)
        }
    }
    
    private func detailRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.gray)
            Spacer()
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
    }
    
    private func orderDate(_ date: Date) -> String {
        let fmt = DateFormatter()
        fmt.dateStyle = .medium
        fmt.timeStyle = .short
        return fmt.string(from: date)
    }
}
