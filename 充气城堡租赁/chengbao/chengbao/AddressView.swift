import SwiftUI

struct AddressView: View {
    let castle: BouncyCastle
    let rentalDays: Int
    @Binding var goHome: Bool
    @Environment(\.presentationMode) var presentationMode
    
    @State private var fullName = ""
    @State private var phoneNumber = ""
    @State private var streetAddress = ""
    @State private var city = ""
    @State private var state = ""
    @State private var zipCode = ""
    
    @State private var showingCheckout = false
    
    var isFormValid: Bool {
        !fullName.isEmpty && !phoneNumber.isEmpty && !streetAddress.isEmpty && !city.isEmpty && !state.isEmpty && !zipCode.isEmpty
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Context Header
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "arrow.left")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                }
                Spacer()
                Text("Delivery Address")
                    .font(.system(size: 18, weight: .bold))
                Spacer()
                // Placeholder to balance the back button
                Image(systemName: "arrow.left").opacity(0)
            }
            .padding()
            .background(Color.white)
            
            ScrollView {
                VStack(spacing: 20) {
                    CustomTextField(placeholder: "Full Name", text: $fullName)
                    CustomTextField(placeholder: "Phone Number", text: $phoneNumber, keyboardType: .phonePad)
                    CustomTextField(placeholder: "Street Address", text: $streetAddress)
                    
                    HStack(spacing: 16) {
                        CustomTextField(placeholder: "City", text: $city)
                        CustomTextField(placeholder: "State", text: $state)
                    }
                    
                    CustomTextField(placeholder: "ZIP Code", text: $zipCode, keyboardType: .numberPad)
                }
                .padding(24)
            }
            
            VStack {
                Divider()
                NavigationLink(
                    destination: CheckoutView(
                        castle: castle,
                        address: Address(fullName: fullName, phoneNumber: phoneNumber, streetAddress: streetAddress, city: city, state: state, zipCode: zipCode),
                        rentalDays: rentalDays,
                        goHome: $goHome
                    ),
                    isActive: $showingCheckout
                ) {
                    Text("Continue to Checkout")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(isFormValid ? Color.black : Color.gray)
                        .cornerRadius(25)
                }
                .disabled(!isFormValid)
                .padding(.horizontal, 24)
                .padding(.top, 16)
                .padding(.bottom, 36)
            }
            .background(Color.white)
        }
        .navigationBarHidden(true)
        .background(Color(hex: "#FAFAFA").edgesIgnoringSafeArea(.all))
    }
}

struct CustomTextField: View {
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        TextField(placeholder, text: $text)
            .keyboardType(keyboardType)
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
