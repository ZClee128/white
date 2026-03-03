import SwiftUI

// MARK: - Address List View

struct AddressListView: View {
    @EnvironmentObject var addressStore: AddressStore
    @State private var showAddAddress: Bool = false

    var body: some View {
        ZStack {
            Color(red: 0.07, green: 0.07, blue: 0.12).ignoresSafeArea()

            Group {
                if addressStore.addresses.isEmpty {
                    emptyState
                } else {
                    addressList
                }
            }
        }
        .navigationTitle("Address Management")
        .navigationBarTitleDisplayMode(.large)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showAddAddress = true
                } label: {
                    Image(systemName: "plus")
                        .fontWeight(.semibold)
                        .foregroundColor(Color(red: 0.42, green: 0.36, blue: 0.91))
                }
            }
        }
        .sheet(isPresented: $showAddAddress) {
            AddAddressView()
                .environmentObject(addressStore)
        }
    }

    // MARK: - Empty State
    private var emptyState: some View {
        VStack(spacing: 20) {
            Spacer()
            Image(systemName: "mappin.slash.circle")
                .font(.system(size: 72))
                .foregroundColor(.gray.opacity(0.3))
            Text("No Saved Addresses")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
            Text("Add a shipping address to speed up checkout")
                .font(.subheadline)
                .foregroundColor(.gray.opacity(0.6))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Button {
                showAddAddress = true
            } label: {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Address")
                        .fontWeight(.semibold)
                }
                .font(.subheadline)
                .foregroundColor(.white)
                .padding(.horizontal, 28)
                .padding(.vertical, 14)
                .background(
                    LinearGradient(colors: [Color(red: 0.42, green: 0.36, blue: 0.91), Color(red: 0.6, green: 0.1, blue: 0.8)],
                                   startPoint: .leading, endPoint: .trailing)
                )
                .cornerRadius(14)
            }
            .padding(.top, 4)
            Spacer()
        }
    }

    // MARK: - Address List
    private var addressList: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 12) {
                ForEach(addressStore.addresses) { address in
                    AddressCard(address: address)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
        }
    }
}

// MARK: - Address Card

struct AddressCard: View {
    let address: Address
    @EnvironmentObject var addressStore: AddressStore

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                HStack(spacing: 6) {
                    Image(systemName: "person.fill")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(address.name)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                    Text(address.phone)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Spacer()
                if address.isDefault {
                    Text("Default")
                        .font(.caption2)
                        .fontWeight(.bold)
                        .foregroundColor(Color(red: 0.42, green: 0.36, blue: 0.91))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color(red: 0.42, green: 0.36, blue: 0.91).opacity(0.15))
                        .cornerRadius(6)
                }
            }

            Text(address.fullAddress)
                .font(.subheadline)
                .foregroundColor(.gray)
                .lineSpacing(2)

            if !address.isDefault {
                Button {
                    addressStore.setDefault(address)
                } label: {
                    Text("Set as Default")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(red: 0.42, green: 0.36, blue: 0.91))
                }
            }
        }
        .padding(16)
        .background(Color(red: 0.1, green: 0.1, blue: 0.15))
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(address.isDefault ?
                    Color(red: 0.42, green: 0.36, blue: 0.91).opacity(0.5) :
                    Color.clear, lineWidth: 1.5)
        )
        .swipeActions(edge: .trailing) {
            Button(role: .destructive) {
                if let idx = addressStore.addresses.firstIndex(where: { $0.id == address.id }) {
                    addressStore.delete(at: IndexSet([idx]))
                }
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}
