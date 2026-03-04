import SwiftUI
import WebKit

struct SettingsView: View {
    @State private var showingClearCacheAlert = false
    @State private var showingContactActionSheet = false
    
    // Simulate App Version
    let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Account & Settings")) {
                    NavigationLink(destination: AddressListView(selectedAddress: .constant(nil), isSelectionMode: false)) {
                        HStack {
                            Image(systemName: "shippingbox.fill")
                                .foregroundColor(.brown)
                                .frame(width: 24)
                            Text("Manage Addresses")
                        }
                    }
                }
                
                Section(header: Text("Support & Services")) {
                    Button(action: {
                        showingContactActionSheet = true
                    }) {
                        HStack {
                            Image(systemName: "headphones")
                                .foregroundColor(.blue)
                                .frame(width: 24)
                            Text("Contact Support")
                                .foregroundColor(.primary)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(.gray)
                                .font(.caption)
                        }
                    }
                    
                    NavigationLink(destination: TextDocumentView(title: "FAQ", content: """
Q: How long does shipping take?
A: Orders are typically processed and shipped within 1-2 business days. Delivery times vary based on your location.

Q: Is my deposit fully refundable?
A: Yes, the device deposit is fully refunded once the console is returned in its original working condition.

Q: What happens if the console is damaged during my rental period?
A: Minor wear and tear are expected. However, significant damage or missing accessories will result in a deduction from your deposit based on our Terms of Service.

Q: Can I extend my rental period?
A: You can extend your rental at any time from the 'Orders' tab before your current return date expires.

Q: How do I return the device?
A: Use the provided return label and package to mail the device back. Make sure to tap 'Return Console' in the app to initiate the process.
""")) {
                        HStack {
                            Image(systemName: "questionmark.circle.fill")
                                .foregroundColor(.orange)
                                .frame(width: 24)
                            Text("FAQ")
                        }
                    }
                }
                
                Section(header: Text("About Us")) {
                    NavigationLink(destination: WebView(url: URL(string: "https://www.privacypolicies.com/live/cba6c97c-510e-4ad5-abc4-c721ebc194ca")!)
                        .navigationTitle("Privacy Policy")
                        .navigationBarTitleDisplayMode(.inline)) {
                        HStack {
                            Image(systemName: "lock.shield.fill")
                                .foregroundColor(.green)
                                .frame(width: 24)
                            Text("Privacy Policy")
                        }
                    }
                    
//                    HStack {
//                        Image(systemName: "info.circle.fill")
//                            .foregroundColor(.purple)
//                            .frame(width: 24)
//                        Text("App Version")
//                        Spacer()
//                        Text("v\(appVersion)")
//                            .foregroundColor(.secondary)
//                    }
                }
                
                Section {
                    Button(action: {
                        showingClearCacheAlert = true
                    }) {
                        HStack {
                            Spacer()
                            Text("Clear Cache")
                                .foregroundColor(.red)
                            Spacer()
                        }
                    }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Setting")
            .confirmationDialog("Contact Support", isPresented: $showingContactActionSheet, titleVisibility: .visible) {
                 Button("Call Us: +1-800-555-0199") {
                     if let url = URL(string: "tel://+18005550199"), UIApplication.shared.canOpenURL(url) {
                         UIApplication.shared.open(url)
                     }
                 }
                 Button("Email: support@gamehub.example.com") {
                     if let url = URL(string: "mailto:support@gamehub.example.com"), UIApplication.shared.canOpenURL(url) {
                         UIApplication.shared.open(url)
                     }
                 }
                 Button("Cancel", role: .cancel) { }
             }
            .alert("Clear Cache", isPresented: $showingClearCacheAlert) {
                Button("Cancel", role: .cancel) { }
                Button("Confirm", role: .destructive) {
                    // Simulated clear action
                }
            } message: {
                Text("Cache cleared successfully. Freed up 12.5 MB of space.")
            }
        }
    }
}

struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

// Simple text view for policies to fulfill review requirements
struct TextDocumentView: View {
    let title: String
    let content: String
    
    var body: some View {
        ScrollView {
            Text(content)
                .padding()
                .font(.body)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SettingsView()
}
