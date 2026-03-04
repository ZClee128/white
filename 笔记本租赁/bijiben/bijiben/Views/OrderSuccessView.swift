import SwiftUI

struct OrderSuccessView: View {
    let order: RentalOrder
    var isFromHistory: Bool = false
    @Environment(\.dismiss) var dismiss

    @State private var animate = false

    var estimatedDelivery: String {
        let cal = Calendar.current
        let deliveryDate = cal.date(byAdding: .hour, value: 4, to: order.createdAt) ?? order.createdAt
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        return formatter.string(from: deliveryDate)
    }

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            if !isFromHistory {
                // Success animation
                VStack(spacing: 24) {
                    ZStack {
                        Circle()
                            .fill(Color(hex: "0f3460").opacity(0.08))
                            .frame(width: 120, height: 120)
                            .scaleEffect(animate ? 1.1 : 0.8)
                            .animation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true), value: animate)

                        Circle()
                            .fill(Color(hex: "0f3460"))
                            .frame(width: 90, height: 90)

                        Image(systemName: "checkmark")
                            .font(.system(size: 38, weight: .bold))
                            .foregroundColor(.white)
                    }
                    .onAppear { animate = true }

                    VStack(spacing: 8) {
                        Text("Order Confirmed!")
                            .font(.title.bold())
                            .foregroundColor(.primary)

                        Text("Your payment was received.")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
            } else {
                Spacer().frame(height: 30)
            }

            // Order info card
            VStack(spacing: 0) {
                infoRow(icon: "number", label: "Order Number", value: order.orderNumber)
                Divider().padding(.leading, 50)
                infoRow(icon: "laptopcomputer", label: "Device", value: order.laptopName)
                Divider().padding(.leading, 50)
                infoRow(icon: "calendar", label: "Duration", value: order.duration.label)
                Divider().padding(.leading, 50)
                infoRow(icon: "shippingbox.fill", label: "Est. Delivery", value: estimatedDelivery)
                Divider().padding(.leading, 50)
                infoRow(icon: "dollarsign.circle.fill", label: "Total Paid", value: "$\(String(format: "%.0f", order.totalPrice))")
            }
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 8, y: 2)
            .padding(.horizontal, 20)

            Spacer()

            // CTAs
            if !isFromHistory {
                VStack(spacing: 12) {
                    NavigationLink(destination: MyOrdersView()) {
                        HStack {
                            Image(systemName: "list.bullet.clipboard.fill")
                            Text("View My Orders")
                                .font(.headline)
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(RoundedRectangle(cornerRadius: 14).fill(Color(hex: "0f3460")))
                    }

                    Button {
                        // Pop to root by dismissing all the way
                        dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            dismiss()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                dismiss()
                            }
                        }
                    } label: {
                        Text("Back to Home")
                            .font(.subheadline.weight(.medium))
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 36)
            }
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationTitle(isFromHistory ? "Order Details" : "Success")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(!isFromHistory)
    }

    private func infoRow(icon: String, label: String, value: String) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .frame(width: 20)
                .foregroundColor(Color(hex: "0f3460"))
                .font(.subheadline)

            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)

            Spacer()

            Text(value)
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.primary)
                .multilineTextAlignment(.trailing)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 13)
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
        deliveryAddress: "123 Main St",
        status: .paid
    )
    if #available(iOS 16.0, *) {
        NavigationStack {
            OrderSuccessView(order: order)
                .environmentObject(RentalStore())
        }
    } else {
        // Fallback on earlier versions
    }
}
