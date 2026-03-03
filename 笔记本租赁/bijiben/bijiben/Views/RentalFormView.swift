import SwiftUI

struct RentalFormView: View {
    @Environment(RentalStore.self) var store
    let laptop: Laptop
    @State var selectedDuration: RentalDuration

    @AppStorage("savedContactName") private var contactName = ""
    @AppStorage("savedContactPhone") private var contactPhone = ""
    @AppStorage("savedDeliveryAddress") private var deliveryAddress = ""
    @State private var showPayment = false
    @State private var createdOrder: RentalOrder?
    @State private var showValidationError = false

    var totalPrice: Double {
        selectedDuration.totalPrice(
            daily: laptop.dailyPrice,
            weekly: laptop.weeklyPrice,
            monthly: laptop.monthlyPrice
        )
    }

    var isFormValid: Bool {
        !contactName.trimmingCharacters(in: .whitespaces).isEmpty &&
        contactPhone.count >= 3 &&
        !deliveryAddress.trimmingCharacters(in: .whitespaces).isEmpty
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Order Summary Card
                orderSummaryCard

                // Rental Duration
                durationPickerSection

                // Contact Info
                contactSection

                // Delivery Address
                addressSection

                // Proceed Button
                proceedButton

                Spacer(minLength: 40)
            }
            .padding(16)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Rental Details")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showPayment) {
            if let order = createdOrder {
                PaymentView(order: order)
            }
        }
        .alert("Please Complete All Fields", isPresented: $showValidationError) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("Please enter:\n• Your Name\n• A Phone Number (at least 3 digits)\n• A Delivery Address")
        }
    }

    // MARK: Summary Card
    private var orderSummaryCard: some View {
        HStack(spacing: 14) {
            Image(laptop.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 48, height: 48)
                .padding(4)
                .background(Color(hex: "f4f4f4"))
                .cornerRadius(8)

            VStack(alignment: .leading, spacing: 4) {
                Text(laptop.name)
                    .font(.headline)
                Text(laptop.brand)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text("$\(Int(totalPrice))")
                    .font(.title3.bold())
                    .foregroundColor(Color(hex: "0f3460"))
                Text("total")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(16)
        .background(RoundedRectangle(cornerRadius: 16).fill(Color(.systemBackground)))
        .shadow(color: .black.opacity(0.05), radius: 6, y: 2)
    }

    // MARK: Duration Picker
    private var durationPickerSection: some View {
        FormSection(title: "Rental Duration") {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(RentalDuration.allCases, id: \.self) { duration in
                        DurationOption(
                            duration: duration,
                            laptop: laptop,
                            isSelected: selectedDuration == duration
                        ) {
                            withAnimation(.spring(response: 0.3)) {
                                selectedDuration = duration
                            }
                        }
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }

    // MARK: Contact
    private var contactSection: some View {
        FormSection(title: "Contact Information") {
            VStack(spacing: 0) {
                FormField(
                    icon: "person.fill",
                    placeholder: "Full Name",
                    text: $contactName,
                    keyboardType: .default
                )
                Divider().padding(.leading, 46)
                FormField(
                    icon: "phone.fill",
                    placeholder: "Phone Number",
                    text: $contactPhone,
                    keyboardType: .phonePad
                )
            }
            .background(Color(.systemBackground))
            .cornerRadius(12)
        }
    }

    // MARK: Address
    private var addressSection: some View {
        FormSection(title: "Delivery Address") {
            FormField(
                icon: "location.fill",
                placeholder: "Street, City, ZIP",
                text: $deliveryAddress,
                keyboardType: .default
            )
            .background(Color(.systemBackground))
            .cornerRadius(12)
        }
    }

    // MARK: Proceed Button
    private var proceedButton: some View {
        Button {
            if isFormValid {
                let order = store.createOrder(
                    laptop: laptop,
                    duration: selectedDuration,
                    totalPrice: totalPrice,
                    contactName: contactName.trimmingCharacters(in: .whitespaces),
                    contactPhone: contactPhone,
                    deliveryAddress: deliveryAddress.trimmingCharacters(in: .whitespaces)
                )
                createdOrder = order
                showPayment = true
            } else {
                showValidationError = true
            }
        } label: {
            HStack {
                Image(systemName: "creditcard.fill")
                Text("Proceed to Payment")
                    .font(.headline)
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 54)
            .background(RoundedRectangle(cornerRadius: 14).fill(Color(hex: "0f3460")))
        }
    }
}

// MARK: - Reusable Form Section
struct FormSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.subheadline.bold())
                .foregroundColor(.secondary)
                .padding(.leading, 4)
            content
        }
    }
}

// MARK: - Reusable Form Field
struct FormField: View {
    let icon: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .frame(width: 20)
                .foregroundColor(Color(hex: "0f3460"))

            TextField(placeholder, text: $text)
                .keyboardType(keyboardType)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}

#Preview {
    NavigationStack {
        RentalFormView(laptop: Laptop.sampleData[0], selectedDuration: .sevenDays)
            .environment(RentalStore())
    }
}
