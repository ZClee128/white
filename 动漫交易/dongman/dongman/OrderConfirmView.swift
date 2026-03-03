import SwiftUI

struct OrderConfirmView: View {
    let figure: Figure
    @EnvironmentObject var store: DataStore
    @Environment(\.dismiss) var dismiss
    @State private var checkmarkScale: CGFloat = 0
    @State private var contentOpacity: Double = 0
    @State private var orderNumber: String = "ANT-\(Int.random(in: 100000...999999))"

    var body: some View {
        ZStack {
            Color(red: 0.07, green: 0.07, blue: 0.12).ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()

                // Animated checkmark
                ZStack {
                    Circle()
                        .fill(Color(red: 0.0, green: 0.78, blue: 0.55).opacity(0.15))
                        .frame(width: 130, height: 130)
                    Circle()
                        .fill(Color(red: 0.0, green: 0.78, blue: 0.55).opacity(0.25))
                        .frame(width: 100, height: 100)
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 64))
                        .foregroundColor(Color(red: 0.0, green: 0.78, blue: 0.55))
                        .scaleEffect(checkmarkScale)
                }

                VStack(spacing: 10) {
                    Text("Order Placed!")
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .foregroundColor(.white)
                    Text("Your figure is on its way.")
                        .font(.body)
                        .foregroundColor(.gray)
                }

                // Order details card
                VStack(spacing: 0) {
                    ConfirmRow(label: "Order Number", value: orderNumber)
                    Divider().background(Color.white.opacity(0.08))
                    ConfirmRow(label: "Item", value: figure.name)
                    Divider().background(Color.white.opacity(0.08))
                    ConfirmRow(label: "Total Paid", value: "$\(String(format: "%.2f", figure.price + 4.99 + 1.50))")
                    Divider().background(Color.white.opacity(0.08))
                    ConfirmRow(label: "Est. Delivery", value: estimatedDelivery())
                }
                .background(Color(red: 0.1, green: 0.1, blue: 0.15))
                .cornerRadius(16)
                .padding(.horizontal, 24)
                .opacity(contentOpacity)

                Spacer()

                // Done button
                Button {
                    dismiss()
                    // Also dismiss checkout
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        dismiss()
                    }
                } label: {
                    HStack {
                        Spacer()
                        Text("Done")
                            .fontWeight(.bold)
                        Spacer()
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 56)
                    .background(
                        LinearGradient(colors: [Color(red: 0.42, green: 0.36, blue: 0.91), Color(red: 0.6, green: 0.1, blue: 0.8)],
                                       startPoint: .leading, endPoint: .trailing)
                    )
                    .cornerRadius(16)
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
                .opacity(contentOpacity)
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
                checkmarkScale = 1.0
            }
            withAnimation(.easeIn(duration: 0.5).delay(0.3)) {
                contentOpacity = 1
            }
        }
    }

    private func estimatedDelivery() -> String {
        let delivery = Date().addingTimeInterval(60 * 60 * 24 * 7)
        let fmt = DateFormatter()
        fmt.dateStyle = .medium
        return fmt.string(from: delivery)
    }
}

struct ConfirmRow: View {
    let label: String
    let value: String

    var body: some View {
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
        .padding(.vertical, 14)
    }
}
