import SwiftUI
import WebKit

struct PrivacyPolicyView: View {
    var body: some View {
        WebView(url: URL(string: "https://www.privacypolicies.com/live/26c61168-4dfc-409a-ae49-cfc818c6e083")!)
            .navigationTitle("Privacy Policy")
            .navigationBarTitleDisplayMode(.inline)
    }
}

struct WebView: UIViewRepresentable {
    let url: URL

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}

#Preview {
    NavigationView {
        PrivacyPolicyView()
    }
}
