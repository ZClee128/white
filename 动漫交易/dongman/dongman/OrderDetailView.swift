import SwiftUI
import PassKit

struct OrderDetailView: View {
    let originalOrder: Order
    @EnvironmentObject var store: DataStore
    @Environment(\.dismiss) var dismiss
    
    @State private var isProcessing = false
    @State private var showConfirm = false
    
    private var order: Order {
        store.orders.first(where: { $0.id == originalOrder.id }) ?? originalOrder
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
                                handleApplePay()
                            } label: {
                                HStack {
                                    Spacer()
                                    if isProcessing {
                                        ProgressView()
                                            .progressViewStyle(CircularProgressViewStyle(tint: .black))
                                    } else {
                                        HStack(spacing: 6) {
                                            Image(systemName: "apple.logo")
                                            Text("Pay with Apple Pay")
                                                .fontWeight(.bold)
                                        }
                                    }
                                    Spacer()
                                }
                                .font(.headline)
                                .foregroundColor(.black)
                                .frame(height: 56)
                                .background(Color.white)
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

    // MARK: - Apple Pay Processing
    private func handleApplePay() {
        guard PKPaymentAuthorizationController.canMakePayments() else { return }

        let request = PKPaymentRequest()
        request.merchantIdentifier = "merchant.com.dongman.app"
        request.supportedNetworks = [.visa, .masterCard, .amex, .chinaUnionPay]
        request.merchantCapabilities = .capability3DS
        request.countryCode = "US"
        request.currencyCode = "USD"
        request.paymentSummaryItems = [
            PKPaymentSummaryItem(label: order.figure.name,
                                 amount: NSDecimalNumber(value: order.figure.price)),
            PKPaymentSummaryItem(label: "Shipping",
                                 amount: NSDecimalNumber(value: 4.99)),
            PKPaymentSummaryItem(label: "Platform Fee",
                                 amount: NSDecimalNumber(value: 1.50)),
            PKPaymentSummaryItem(label: "Dongman Market",
                                 amount: NSDecimalNumber(value: order.total + 4.99 + 1.50))
        ]

        let controller = PKPaymentAuthorizationController(paymentRequest: request)
        let delegate = OrderApplePayDelegate {
            // Because there's no backend, don't actually confirm the order:
            // store.payForOrder(order)
            showConfirm = true
        }
        controller.delegate = delegate
        objc_setAssociatedObject(controller, "applePayDelegate", delegate,
                                 .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        controller.present(completion: nil)
    }
}

class OrderApplePayDelegate: NSObject, PKPaymentAuthorizationControllerDelegate {
    private let onSuccess: () -> Void
    init(onSuccess: @escaping () -> Void) { self.onSuccess = onSuccess }

    func paymentAuthorizationController(
        _ controller: PKPaymentAuthorizationController,
        didAuthorizePayment payment: PKPayment,
        handler completion: @escaping (PKPaymentAuthorizationResult) -> Void
    ) {
        completion(PKPaymentAuthorizationResult(status: .success, errors: []))
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.onSuccess()
        }
    }

    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss(completion: nil)
    }
}
