import SwiftUI

struct PrivacyPolicyView: View {
    var body: some View {
        WebView(urlString: "https://www.privacypolicies.com/live/b0e3c229-7d9f-4f5a-90bc-6643db8e4f8d")
            .navigationTitle("Privacy")
            .navigationBarTitleDisplayMode(.inline)
    }
}
