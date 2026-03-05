import SwiftUI

struct PaymentView: View {
    @EnvironmentObject var store: RentalStore
    let order: RentalOrder

    @State private var showSuccess = false

    var body: some View {
        if #available(iOS 16.0, *) {
            ScrollView {
                VStack(spacing: 24) {
                    // Order Summary
                    orderSummarySection

                    // Payment Method
                    paymentMethodSection

                    // COD Info
                    codInfoSection

                    // Confirm Button
                    confirmButton

                    Spacer(minLength: 40)
                }
                .padding(16)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Payment")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(isPresented: $showSuccess) {
                OrderSuccessView(order: order)
            }
        } else {
            // Fallback on earlier versions
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
                        .fill(Color(hex: "0f3460"))
                        .frame(width: 46, height: 46)
                    Image(systemName: "banknote.fill")
                        .foregroundColor(.white)
                        .font(.title3)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text("Cash on Delivery")
                        .font(.headline)
                    Text("Pay when your device arrives")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                Spacer()

                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(.green)
                    .font(.title3)
            }
            .padding(16)
            .background(Color(.systemBackground))
            .cornerRadius(12)
        }
    }

    // MARK: COD Info
    private var codInfoSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top, spacing: 10) {
                Image(systemName: "info.circle.fill")
                    .foregroundColor(Color(hex: "0f3460"))
                    .font(.subheadline)
                    .padding(.top, 1)
                VStack(alignment: .leading, spacing: 6) {
                    Text("How it works")
                        .font(.subheadline.bold())
                        .foregroundColor(Color(hex: "0f3460"))
                    Text("1. Place your order by tapping Confirm below.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("2. Our team will contact you to arrange delivery.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("3. Pay in cash when the device is delivered to you.")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding(14)
            .background(Color(hex: "0f3460").opacity(0.07))
            .cornerRadius(12)
        }
    }

    // MARK: Confirm Button
    private var confirmButton: some View {
        Button {
            store.confirmPayment(for: order.id)
            showSuccess = true
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "checkmark.seal.fill")
                Text("Confirm Order — $\(String(format: "%.0f", order.totalPrice))")
                    .font(.headline)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(hex: "0f3460"))
            )
        }
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
    if #available(iOS 16.0, *) {
        NavigationStack {
            PaymentView(order: order)
                .environmentObject(RentalStore())
        }
    } else {
        // Fallback on earlier versions
    }
}
