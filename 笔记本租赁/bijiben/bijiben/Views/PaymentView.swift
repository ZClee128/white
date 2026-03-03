import SwiftUI

struct PaymentView: View {
    @Environment(RentalStore.self) var store
    let order: RentalOrder

    @State private var showSuccess = false
    @State private var weChatLaunched = false
    @State private var showNoWeChatAlert = false

    var weChatInstalled: Bool {
        store.isWeChatInstalled()
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Order Summary
                orderSummarySection

                // Payment Method
                paymentMethodSection

                // WeChat CTA
                weChatCTA

                // After-payment confirm
                if weChatLaunched {
                    confirmButton
                }

                Spacer(minLength: 40)
            }
            .padding(16)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Payment")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(weChatLaunched)
        .navigationDestination(isPresented: $showSuccess) {
            OrderSuccessView(order: order)
        }
        .alert("WeChat Not Installed", isPresented: $showNoWeChatAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Please install WeChat to complete the payment.")
        }
    }

    // MARK: Order Summary
    private var orderSummarySection: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionHeader("Order Summary")

            VStack(spacing: 0) {
                summaryRow(label: "Device", value: order.laptopName)
                Divider().padding(.leading, 16)
                summaryRow(label: "Brand", value: order.laptopBrand)
                Divider().padding(.leading, 16)
                summaryRow(label: "Duration", value: order.duration.label)
                Divider().padding(.leading, 16)
                summaryRow(label: "Contact", value: order.contactName)
                Divider().padding(.leading, 16)
                summaryRow(label: "Phone", value: order.contactPhone)
                Divider().padding(.leading, 16)
                summaryRow(label: "Delivery", value: order.deliveryAddress)
            }
            .background(Color(.systemBackground))
            .cornerRadius(12)

            // Total
            HStack {
                Text("Order #\(order.orderNumber)")
                    .font(.caption)
                    .foregroundColor(.secondary)

                Spacer()

                HStack(alignment: .lastTextBaseline, spacing: 2) {
                    Text("Total")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    Text("$\(String(format: "%.0f", order.totalPrice))")
                        .font(.title2.bold())
                        .foregroundColor(Color(hex: "0f3460"))
                }
            }
            .padding(.horizontal, 4)
        }
    }

    // MARK: Payment Method
    private var paymentMethodSection: some View {
        VStack(alignment: .leading, spacing: 14) {
            sectionHeader("Payment Method")

            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color(hex: "07C160"))
                        .frame(width: 46, height: 46)
                    Image(systemName: "message.fill")
                        .foregroundColor(.white)
                        .font(.title3)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text("WeChat Pay")
                        .font(.headline)
                    Text("Secure · Instant · Widely Accepted")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Image(systemName: weChatInstalled ? "checkmark.circle.fill" : "exclamationmark.circle.fill")
                    .foregroundColor(weChatInstalled ? .green : .orange)
                    .font(.title3)
            }
            .padding(16)
            .background(Color(.systemBackground))
            .cornerRadius(12)

            if !weChatInstalled {
//                HStack(spacing: 8) {
//                    Image(systemName: "info.circle.fill")
//                        .foregroundColor(.orange)
//                        .font(.footnote)
//                    Text("WeChat is not installed on this device. Please download it to complete payment.")
//                        .font(.footnote)
//                        .foregroundColor(.secondary)
//                }
//                .padding(12)
//                .background(Color.orange.opacity(0.08))
//                .cornerRadius(10)
            }
        }
    }

    // MARK: WeChat CTA
    private var weChatCTA: some View {
        VStack(spacing: 12) {
            if weChatInstalled {
                Button {
                    store.openWeChat(amount: order.totalPrice, orderNumber: order.orderNumber)
                    withAnimation {
                        weChatLaunched = true
                    }
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "arrow.up.forward.app.fill")
                        Text("Pay with WeChat — $\(String(format: "%.0f", order.totalPrice))")
                            .font(.headline)
                    }
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 54)
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color(hex: "07C160"))
                    )
                }
            } else {
//                Button {
//                    showNoWeChatAlert = true
//                } label: {
//                    HStack(spacing: 10) {
//                        Image(systemName: "arrow.down.circle.fill")
//                        Text("Download WeChat to Pay")
//                            .font(.headline)
//                    }
//                    .foregroundColor(.white)
//                    .frame(maxWidth: .infinity)
//                    .frame(height: 54)
//                    .background(
//                        RoundedRectangle(cornerRadius: 14)
//                            .fill(Color(hex: "07C160"))
//                    )
//                }
            }
        }
    }

    // MARK: Confirm Button
    private var confirmButton: some View {
        VStack(spacing: 10) {
            Text("After completing payment in WeChat, tap the button below.")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            Button {
                store.confirmPayment(for: order.id)
                showSuccess = true
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.seal.fill")
                    Text("I've Completed Payment")
                        .font(.headline)
                }
                .foregroundColor(Color(hex: "0f3460"))
                .frame(maxWidth: .infinity)
                .frame(height: 54)
                .background(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color(hex: "0f3460"), lineWidth: 2)
                )
            }
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }

    // MARK: Helpers
    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.subheadline.bold())
            .foregroundColor(.secondary)
            .padding(.leading, 4)
    }

    private func summaryRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.subheadline.weight(.medium))
                .foregroundColor(.primary)
                .multilineTextAlignment(.trailing)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

#Preview {
    let order = RentalOrder(
        laptopId: "preview-id",
        laptopName: "MacBook Pro 14\"",
        laptopBrand: "Apple",
        duration: .sevenDays,
        totalPrice: 499,
        contactName: "John Doe",
        contactPhone: "138-0000-0000",
        deliveryAddress: "123 Main St, San Francisco"
    )
    NavigationStack {
        PaymentView(order: order)
            .environment(RentalStore())
    }
}
