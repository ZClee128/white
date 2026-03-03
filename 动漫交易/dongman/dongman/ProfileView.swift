import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var addressStore: AddressStore
    @State private var showContactSheet = false
    @State private var showPrivacySheet = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 0.07, green: 0.07, blue: 0.12).ignoresSafeArea()

                VStack(spacing: 0) {
                    // Address prompt banner (if no address saved)
                    if addressStore.addresses.isEmpty {
                        addressBanner
                            .padding(.horizontal, 16)
                            .padding(.top, 20)
                            .padding(.bottom, 4)
                    }

                    ScrollView(showsIndicators: false) {
                        VStack(spacing: 0) {
                            settingsGroup
                                .padding(.horizontal, 16)
                                .padding(.top, 20)

//                            Text("AniTrade v1.0.0")
//                                .font(.caption)
//                                .foregroundColor(.gray.opacity(0.4))
//                                .padding(.top, 30)
//                                .padding(.bottom, 40)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .confirmationDialog("Contact Support", isPresented: $showContactSheet, titleVisibility: .visible) {
                Button("Call +1 (888) 926-4783") {
                    if let url = URL(string: "tel://+18889264783") {
                        UIApplication.shared.open(url)
                    }
                }
                Button("Copy Email: support@anitrade.app") {
                    UIPasteboard.general.string = "support@anitrade.app"
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Our support team is available Mon–Fri, 9am–6pm EST.")
            }
            .sheet(isPresented: $showPrivacySheet) {
                PrivacyPolicyView()
            }
        }
    }

    // MARK: - No-address Banner
    private var addressBanner: some View {
        NavigationLink(destination: AddressListView().environmentObject(addressStore)) {
            HStack(spacing: 14) {
                Image(systemName: "mappin.circle.fill")
                    .font(.system(size: 28))
                    .foregroundColor(.orange)
                VStack(alignment: .leading, spacing: 3) {
                    Text("No shipping address saved")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    Text("Tap to add an address before checkout")
                        .font(.caption)
                        .foregroundColor(.orange.opacity(0.8))
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(16)
            .background(Color.orange.opacity(0.1))
            .cornerRadius(14)
            .overlay(
                RoundedRectangle(cornerRadius: 14)
                    .stroke(Color.orange.opacity(0.3), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Settings Group (3 items only)
    private var settingsGroup: some View {
        VStack(spacing: 0) {
            // 1. Contact Support
            Button {
                showContactSheet = true
            } label: {
                SettingsRow(icon: "message.badge.filled.fill", color: Color(red: 0.07, green: 0.73, blue: 0.18), label: "Contact Support")
            }
            .buttonStyle(.plain)

            Divider()
                .background(Color.white.opacity(0.06))
                .padding(.leading, 58)

            // 2. Address Management
            NavigationLink(destination: AddressListView().environmentObject(addressStore)) {
                SettingsRow(
                    icon: "mappin.and.ellipse",
                    color: Color(red: 0.42, green: 0.36, blue: 0.91),
                    label: "Address Management",
                    badge: addressStore.addresses.isEmpty ? "Add" : "\(addressStore.addresses.count)"
                )
            }
            .buttonStyle(.plain)

            Divider()
                .background(Color.white.opacity(0.06))
                .padding(.leading, 58)

            // 3. Privacy Policy
            Button {
                showPrivacySheet = true
            } label: {
                SettingsRow(icon: "hand.raised.fill", color: .blue, label: "Privacy Policy")
            }
            .buttonStyle(.plain)
        }
        .background(Color(red: 0.1, green: 0.1, blue: 0.15))
        .cornerRadius(16)
    }
}

// MARK: - Settings Row

struct SettingsRow: View {
    let icon: String
    let color: Color
    let label: String
    var badge: String? = nil

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(color.opacity(0.18))
                    .frame(width: 34, height: 34)
                Image(systemName: icon)
                    .font(.system(size: 15))
                    .foregroundColor(color)
            }
            Text(label)
                .font(.subheadline)
                .foregroundColor(.white)
            Spacer()
            if let badge {
                Text(badge)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color(red: 0.42, green: 0.36, blue: 0.91).opacity(0.3))
                    .cornerRadius(8)
            }
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.gray.opacity(0.5))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}

// MARK: - StatCell (kept for any reuse)
struct StatCell: View {
    let value: String
    let label: String
    var body: some View {
        VStack(spacing: 4) {
            Text(value).font(.title2).fontWeight(.black).foregroundColor(.white)
            Text(label).font(.caption).foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
    }
}
