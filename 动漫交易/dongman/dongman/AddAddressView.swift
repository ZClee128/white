import SwiftUI

// MARK: - Reusable text field

struct AniTextField: View {
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default

    var body: some View {
        TextField(placeholder, text: $text)
            .foregroundColor(.white)
            .tint(Color(red: 0.42, green: 0.36, blue: 0.91))
            .keyboardType(keyboardType)
            .padding(14)
            .background(Color.white.opacity(0.06))
            .cornerRadius(12)
    }
}


struct AddAddressView: View {
    @EnvironmentObject var addressStore: AddressStore
    @Environment(\.dismiss) var dismiss

    @State private var name: String = ""
    @State private var phone: String = ""
    @State private var street: String = ""
    @State private var city: String = ""
    @State private var state: String = ""
    @State private var country: String = ""
    @State private var postalCode: String = ""
    @State private var setAsDefault: Bool = true

    var isValid: Bool {
        !name.isEmpty && !phone.isEmpty && !street.isEmpty &&
        !city.isEmpty && !country.isEmpty
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.07, green: 0.07, blue: 0.12).ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 16) {
                        // Icon
                        ZStack {
                            Circle()
                                .fill(Color(red: 0.42, green: 0.36, blue: 0.91).opacity(0.15))
                                .frame(width: 72, height: 72)
                            Image(systemName: "mappin.circle.fill")
                                .font(.system(size: 36))
                                .foregroundColor(Color(red: 0.42, green: 0.36, blue: 0.91))
                        }
                        .padding(.top, 12)

                        // Contact Info
                        addrSection(title: "Contact Info") {
                            AniTextField(placeholder: "Full Name", text: $name)
                            AniTextField(placeholder: "Phone Number", text: $phone, keyboardType: .phonePad)
                        }

                        // Address
                        addrSection(title: "Address") {
                            AniTextField(placeholder: "Street Address", text: $street)
                            AniTextField(placeholder: "City", text: $city)
                            AniTextField(placeholder: "State / Province", text: $state)
                            AniTextField(placeholder: "Postal Code", text: $postalCode, keyboardType: .numberPad)
                            AniTextField(placeholder: "Country", text: $country)
                        }

                        // Default toggle
                        HStack {
                            VStack(alignment: .leading, spacing: 3) {
                                Text("Set as Default")
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                Text("Use this address at checkout")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Toggle("", isOn: $setAsDefault)
                                .tint(Color(red: 0.42, green: 0.36, blue: 0.91))
                        }
                        .padding(16)
                        .background(Color(red: 0.1, green: 0.1, blue: 0.15))
                        .cornerRadius(14)

                        // Save button
                        Button {
                            let address = Address(
                                id: UUID(),
                                name: name,
                                phone: phone,
                                street: street,
                                city: city,
                                state: state,
                                country: country,
                                postalCode: postalCode,
                                isDefault: setAsDefault || addressStore.addresses.isEmpty
                            )
                            addressStore.add(address)
                            dismiss()
                        } label: {
                            HStack {
                                Spacer()
                                Image(systemName: "mappin.and.ellipse")
                                Text("Save Address")
                                    .fontWeight(.bold)
                                Spacer()
                            }
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(height: 56)
                            .background(
                                isValid ?
                                    LinearGradient(colors: [Color(red: 0.42, green: 0.36, blue: 0.91), Color(red: 0.6, green: 0.1, blue: 0.8)],
                                                   startPoint: .leading, endPoint: .trailing) :
                                    LinearGradient(colors: [Color.gray.opacity(0.3), Color.gray.opacity(0.2)],
                                                   startPoint: .leading, endPoint: .trailing)
                            )
                            .cornerRadius(16)
                        }
                        .disabled(!isValid)
                        .padding(.bottom, 30)
                    }
                    .padding(.horizontal, 16)
                }
            }
            .navigationTitle("Add Address")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(.gray)
                }
            }
        }
    }

    private func addrSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
                .textCase(.uppercase)
                .tracking(0.8)
            VStack(spacing: 8) {
                content()
            }
        }
        .padding(16)
        .background(Color(red: 0.1, green: 0.1, blue: 0.15))
        .cornerRadius(14)
    }
}
