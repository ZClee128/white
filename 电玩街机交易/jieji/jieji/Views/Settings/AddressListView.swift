import SwiftUI

struct AddressListView: View {
    @EnvironmentObject var addressManager: AddressManager
    
    var body: some View {
        Group {
            if addressManager.addresses.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "house.circle")
                        .font(.system(size: 80))
                        .foregroundColor(.gray)
                    Text("No saved addresses")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
            } else {
                List {
                    ForEach(addressManager.addresses) { address in
                        NavigationLink(destination: AddressEditView(address: address)) {
                            VStack(alignment: .leading, spacing: 6) {
                                HStack {
                                    Text(address.fullName)
                                        .font(.headline)
                                    Spacer()
                                    if address.isDefault {
                                        Text("Default")
                                            .font(.caption)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 6)
                                            .padding(.vertical, 2)
                                            .background(Color.accentColor)
                                            .cornerRadius(4)
                                    }
                                }
                                
                                Text(address.phoneNumber)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                
                                Text("\(address.streetAddress), \(address.city), \(address.state) \(address.zipCode)")
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                    .onDelete(perform: addressManager.deleteAddress)
                }
                .listStyle(InsetGroupedListStyle())
            }
        }
        .navigationTitle("Addresses")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink(destination: AddressEditView(address: nil)) {
                    Image(systemName: "plus")
                }
            }
        }
    }
}
