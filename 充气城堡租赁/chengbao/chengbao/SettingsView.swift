import SwiftUI

struct SettingsView: View {
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var alertTitle = ""
    
    var body: some View {
        Group {
            ZStack {
                Color(hex: "#FAFAFA").edgesIgnoringSafeArea(.all)
                
                VStack(spacing: 0) {
                    // Header
                    HStack {
                        Text("Settings")
                            .font(.system(size: 32, weight: .black, design: .rounded))
                            .foregroundColor(.black)
                        Spacer()
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 20)
                    .padding(.bottom, 16)
                    
                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 24) {
                            
                            VStack(spacing: 0) {
                                SettingsRow(icon: "lock.shield.fill", color: .green, title: "Privacy Policy")
                                    .onTapGesture {
                                        showMyAlert(
                                            title: "Privacy Policy",
                                            message: "All order data is stored locally on your device and is never uploaded to any server. We do not collect any personal information."
                                        )
                                    }
                                Divider().padding(.leading, 56)
                                SettingsRow(icon: "message.fill", color: Color(hex: "#07C160"), title: "Contact Support")
                                    .onTapGesture {
                                        showMyAlert(
                                            title: "Contact Support",
                                            message: "For any questions or rental inquiries, please email us at support@bouncycastle.app or call 1-800-BOUNCY."
                                        )
                                    }
                                Divider().padding(.leading, 56)
                                SettingsRow(icon: "questionmark.circle.fill", color: .purple, title: "FAQ")
                                    .onTapGesture {
                                        showMyAlert(
                                            title: "FAQ",
                                            message: "Q: How do I rent?\nA: Browse castles, select one, enter your address, and pay via WeChat.\n\nQ: What areas do you serve?\nA: We deliver within 30 miles of your location.\n\nQ: Can I cancel my order?\nA: Orders can be cancelled up to 48 hours before the rental date."
                                        )
                                    }
                            }
                            .background(Color.white)
                            .cornerRadius(20)
                            .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                            
                            Spacer().frame(height: 140)
                        }
                        .padding(24)
                    }
                }
            }
            .navigationBarHidden(true)
            .alert(isPresented: $showingAlert) {
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    private func showMyAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showingAlert = true
    }
}

struct SettingsRow: View {
    let icon: String
    let color: Color
    let title: String
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(color.opacity(0.1))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(color)
            }
            
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.black)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
                .font(.system(size: 14))
        }
        .padding()
        .contentShape(Rectangle())
    }
}
