import SwiftUI

struct ContactUsView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Image(systemName: "headphones.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.accentColor)
                    .padding(.top, 40)
                
                Text("How can we help you?")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Our customer service team is available 24/7 to assist you with any inquiries regarding our arcade machines.")
                    .font(.body)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 30)
                
                VStack(spacing: 20) {
                    Button(action: {
                        if let url = URL(string: "tel:+14155552671") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack(spacing: 20) {
                            Image(systemName: "phone.fill")
                                .font(.title2)
                                .foregroundColor(.white)
                            
                            VStack(alignment: .leading) {
                                Text("Call Us")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("+1 (415) 555-2671")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            Spacer()
                        }
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(16)
                    }
                    
                    Button(action: {
                        if let url = URL(string: "mailto:support@arcadetrading.com") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack(spacing: 20) {
                            Image(systemName: "envelope.fill")
                                .font(.title2)
                                .foregroundColor(.white)
                            
                            VStack(alignment: .leading) {
                                Text("Email Us")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("support@arcadetrading.com")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            Spacer()
                        }
                        .padding()
                        .background(Color.purple)
                        .cornerRadius(16)
                    }
                }
                .padding(.horizontal, 24)
                
                Spacer()
            }
        }
        .navigationTitle("Contact Us")
    }
}
