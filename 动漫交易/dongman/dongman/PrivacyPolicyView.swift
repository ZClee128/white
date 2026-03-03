import SwiftUI

struct PrivacyPolicyView: View {
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.07, green: 0.07, blue: 0.12).ignoresSafeArea()
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        policySection(title: "Overview",
                            body: "AniTrade is a marketplace for anime collectible figures. We are committed to protecting your privacy and being transparent about how we handle your information.")

                        policySection(title: "Information We Collect",
                            body: "• Shipping addresses you enter (stored locally on your device only)\n• Order history (stored locally on your device only)\n• App usage data for improving the experience\n\nWe do NOT collect personal accounts, passwords, or payment credentials.")

                        policySection(title: "Payment",
                            body: "All payments are processed through WeChat Pay. AniTrade does not store, transmit, or have access to your payment information. Please refer to WeChat's privacy policy for details on payment data handling.")

                        policySection(title: "Local Data Storage",
                            body: "Your shipping addresses and order history are saved locally on your device using standard iOS storage. This data is not transmitted to any server and is removed when you uninstall the app.")

                        policySection(title: "Third-Party Services",
                            body: "AniTrade may link to external sites (e.g. App Store reviews). We are not responsible for the privacy practices of these third-party services.")

                        policySection(title: "Contact Us",
                            body: "If you have questions about this Privacy Policy, please contact us:\n\nWeChat ID: AniTrade_Support\nEmail: support@anitrade.app")

                        Text("Last updated: February 2026")
                            .font(.caption)
                            .foregroundColor(.gray.opacity(0.5))
                            .padding(.top, 8)
                            .padding(.bottom, 40)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Privacy Policy")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") { dismiss() }
                        .foregroundColor(Color(red: 0.42, green: 0.36, blue: 0.91))
                }
            }
        }
    }

    private func policySection(title: String, body: String) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.white)
            Text(body)
                .font(.subheadline)
                .foregroundColor(.gray)
                .lineSpacing(4)
        }
        .padding(16)
        .background(Color(red: 0.1, green: 0.1, blue: 0.15))
        .cornerRadius(14)
    }
}
