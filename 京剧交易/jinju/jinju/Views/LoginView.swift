import SwiftUI

struct LoginView: View {
    @EnvironmentObject var store: StoreData
    @Environment(\.presentationMode) var presentationMode
    
    @State private var phone = ""
    @State private var password = ""
    @State private var isRegistering = false
    @State private var alertMessage = ""
    @State private var showAlert = false
    
    var body: some View {
        NavigationView {
            ZStack {
                // Background Gradient
                LinearGradient(gradient: Gradient(colors: [Color.red.opacity(0.8), Color.black]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 30) {
                    VStack(spacing: 10) {
                        Image(systemName: "person.crop.artframe")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.white)
                            .padding(.bottom, 10)
                        
                        Text("Peking Opera Figures")
                            .font(.system(size: 32, weight: .bold, design: .serif))
                            .foregroundColor(.white)
                        
                        Text("Experience the beauty of national heritage, collect masterpieces.")
                            .font(.subheadline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.top, 50)
                    
                    VStack(spacing: 20) {
                        // Phone Field
                        HStack {
                            Image(systemName: "iphone")
                                .foregroundColor(.gray)
                            TextField("Enter Phone Number", text: $phone)
                                .keyboardType(.numberPad)
                                .foregroundColor(.primary)
                        }
                        .padding()
                        .background(Color(.systemBackground).opacity(0.9))
                        .cornerRadius(12)
                        
                        // Password Field
                        HStack {
                            Image(systemName: "lock")
                                .foregroundColor(.gray)
                            SecureField(isRegistering ? "Set Password" : "Enter Password", text: $password)
                                .foregroundColor(.primary)
                        }
                        .padding()
                        .background(Color(.systemBackground).opacity(0.9))
                        .cornerRadius(12)
                        
                        // Login Action Button
                        Button(action: handleAction) {
                            Text(isRegistering ? "Register Now" : "Login")
                                .font(.headline)
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(.systemBackground))
                                .cornerRadius(25)
                                .shadow(radius: 5)
                        }
                        .padding(.top, 10)
                        
                        // Switch Mode
                        Button(action: {
                            withAnimation {
                                isRegistering.toggle()
                            }
                        }) {
                            Text(isRegistering ? "Have an account? Login" : "No account? Register")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.8))
                        }
                    }
                    .padding(.horizontal, 30)
                    
                    Spacer()
                }
            }
            .navigationBarHidden(true)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Notice"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func handleAction() {
        if phone.isEmpty {
            alertMessage = "Enter Phone Number"
            showAlert = true
            return
        }
        if password.isEmpty {
            alertMessage = "Enter Password"
            showAlert = true
            return
        }
        if phone.count < 11 {
            alertMessage = "Invalid phone format"
            showAlert = true
            return
        }
        
        // Simulating successful networking logic
        store.login(phone: phone)
        presentationMode.wrappedValue.dismiss()
    }
}

#Preview {
    LoginView()
        .environmentObject(StoreData())
}
