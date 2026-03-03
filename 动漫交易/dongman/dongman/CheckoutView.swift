import SwiftUI
import UIKit

struct CheckoutView: View {
    let figure: Figure
    @EnvironmentObject var store: DataStore
    @EnvironmentObject var addressStore: AddressStore
    @Environment(\.dismiss) var dismiss
    @State private var showConfirm: Bool = false
    @State private var isProcessing: Bool = false
    @State private var showWeChatNotInstalled: Bool = false

    private var isWeChatInstalled: Bool {
        guard let url = URL(string: "weixin://") else { return false }
        return UIApplication.shared.canOpenURL(url)
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.07, green: 0.07, blue: 0.12).ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        // Item summary
                        itemCard
                            .padding(.top, 20)

                        // Shipping
                        shippingCard

                        // Payment — WeChat Pay
                        paymentCard

                        // Price breakdown
                        priceBreakdown

                        // Confirm button
                        confirmButton
                            .padding(.bottom, 30)
                    }
                    .padding(.horizontal, 20)
                }
            }
            .navigationTitle("Checkout")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.gray)
                }
            }
            .fullScreenCover(isPresented: $showConfirm) {
                OrderConfirmView(figure: figure)
                    .environmentObject(store)
            }
            .alert("WeChat Not Installed", isPresented: $showWeChatNotInstalled) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Please install WeChat to use WeChat Pay.")
            }
        }
    }

    // MARK: - Item Card
    private var itemCard: some View {
        CheckoutSection(title: "Order Summary") {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(red: 0.12, green: 0.12, blue: 0.2))
                        .frame(width: 60, height: 60)
                    Image(systemName: figure.systemImageName)
                        .font(.system(size: 28))
                        .foregroundColor(.white.opacity(0.8))
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(figure.name)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    Text(figure.series)
                        .font(.caption)
                        .foregroundColor(.gray)
                    HStack(spacing: 6) {
                        Circle().fill(figure.condition.color).frame(width: 7, height: 7)
                        Text(figure.condition.rawValue)
                            .font(.caption)
                            .foregroundColor(figure.condition.color)
                    }
                }
                Spacer()
                VStack(alignment: .trailing) {
                    Text("$\(String(format: "%.2f", figure.price))")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Text("Qty: 1")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
        }
    }

    // MARK: - Shipping
    private var shippingCard: some View {
        CheckoutSection(title: "Shipping Address") {
            if let addr = addressStore.defaultAddress {
                HStack(spacing: 12) {
                    Image(systemName: "location.fill")
                        .foregroundColor(Color(red: 0.42, green: 0.36, blue: 0.91))
                    VStack(alignment: .leading, spacing: 3) {
                        Text(addr.name)
                            .font(.subheadline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        Text(addr.fullAddress)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
            } else {
                HStack(spacing: 10) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.orange)
                    Text("No address saved – go to Settings to add one")
                        .font(.caption)
                        .foregroundColor(.orange)
                }
            }
        }
    }

    // MARK: - WeChat Pay Card
    private var paymentCard: some View {
        CheckoutSection(title: "Payment Method") {
            HStack(spacing: 14) {
                // WeChat green icon
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(red: 0.07, green: 0.73, blue: 0.18))
                        .frame(width: 44, height: 44)
                    Image(systemName: "message.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                }

                VStack(alignment: .leading, spacing: 3) {
                    Text("WeChat Pay")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    if isWeChatInstalled {
                        HStack(spacing: 4) {
                            Image(systemName: "checkmark.circle.fill")
                                .font(.caption)
                                .foregroundColor(Color(red: 0.07, green: 0.73, blue: 0.18))
                            Text("WeChat detected")
                                .font(.caption)
                                .foregroundColor(Color(red: 0.07, green: 0.73, blue: 0.18))
                        }
                    } else {
                        HStack(spacing: 4) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.caption)
                                .foregroundColor(.orange)
                            Text("WeChat not installed")
                                .font(.caption)
                                .foregroundColor(.orange)
                        }
                    }
                }

                Spacer()

                Image(systemName: isWeChatInstalled ? "checkmark.circle.fill" : "xmark.circle.fill")
                    .foregroundColor(isWeChatInstalled ?
                        Color(red: 0.07, green: 0.73, blue: 0.18) : .orange)
                    .font(.title3)
            }
            .padding(4)
        }
    }

    // MARK: - Price Breakdown
    private var priceBreakdown: some View {
        CheckoutSection(title: "Price Breakdown") {
            VStack(spacing: 10) {
                PriceLine(label: "Item price", value: figure.price)
                PriceLine(label: "Shipping", value: 4.99)
                PriceLine(label: "Platform fee", value: 1.50)
                Divider().background(Color.white.opacity(0.1))
                HStack {
                    Text("Total")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    Spacer()
                    Text("$\(String(format: "%.2f", figure.price + 4.99 + 1.50))")
                        .font(.headline)
                        .fontWeight(.black)
                        .foregroundColor(Color(red: 0.42, green: 0.36, blue: 0.91))
                }
            }
        }
    }

    // MARK: - Confirm Button
    private var confirmButton: some View {
        Button {
            guard isWeChatInstalled else {
                showWeChatNotInstalled = true
                return
            }
            isProcessing = true
            // Launch WeChat Pay flow (stub: open WeChat app)
            if let url = URL(string: "weixin://") {
                UIApplication.shared.open(url, options: [:]) { _ in }
            }
            // Simulate payment success after delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                _ = store.purchaseFigure(figure)
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
                    // WeChat Pay green button
                    HStack(spacing: 8) {
                        Image(systemName: "message.fill")
                        Text("Pay with WeChat")
                            .fontWeight(.bold)
                    }
                }
                Spacer()
            }
            .font(.headline)
            .foregroundColor(.white)
            .frame(height: 58)
            .background(
                isWeChatInstalled ?
                    LinearGradient(colors: [Color(red: 0.07, green: 0.73, blue: 0.18), Color(red: 0.05, green: 0.58, blue: 0.13)],
                                   startPoint: .leading, endPoint: .trailing) :
                    LinearGradient(colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.2)],
                                   startPoint: .leading, endPoint: .trailing)
            )
            .cornerRadius(18)
            .shadow(color: isWeChatInstalled ?
                Color(red: 0.07, green: 0.73, blue: 0.18).opacity(0.4) : .clear,
                    radius: 12, y: 6)
        }
        .disabled(isProcessing)
    }
}

// MARK: - Helpers (shared)

struct CheckoutSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
                .textCase(.uppercase)
                .tracking(0.8)
            content
        }
        .padding(16)
        .background(Color(red: 0.1, green: 0.1, blue: 0.15))
        .cornerRadius(16)
    }
}

struct PriceLine: View {
    let label: String
    let value: Double

    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.gray)
            Spacer()
            Text("$\(String(format: "%.2f", value))")
                .font(.subheadline)
                .foregroundColor(.white)
        }
    }
}
