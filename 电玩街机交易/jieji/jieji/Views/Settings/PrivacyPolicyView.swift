import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Privacy Policy")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.bottom, 10)
                
                Text("Last updated: March 2026")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Group {
                    Text("1. Introduction")
                        .font(.headline)
                    Text("Welcome to the Arcade Machine Trading App. We respect your privacy and are committed to protecting your personal data.")
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    Text("2. Data Collection")
                        .font(.headline)
                    Text("We do not require user accounts. All data such as shipping addresses, cart items, and order history are stored locally on your device. We do not transmit this data to external servers.")
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    Text("3. Payment Processing")
                        .font(.headline)
                    Text("Payments are processed securely via WeChat Pay. We do not store your financial information or payment details on our servers or your device.")
                        .font(.body)
                        .foregroundColor(.secondary)
                    
                    Text("4. Contact Us")
                        .font(.headline)
                    Text("If you have any questions about this Privacy Policy, please contact us at support@arcadetrading.com.")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
            }
            .padding(24)
        }
        .navigationTitle("Privacy")
    }
}
