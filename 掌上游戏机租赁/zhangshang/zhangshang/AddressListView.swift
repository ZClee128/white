import SwiftUI

struct AddressListView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var addressManager: AddressManager
    
    // Optional binding to support selecting an address and passing it back
    @Binding var selectedAddress: Address?
    var isSelectionMode: Bool
    
    // Add new address trigger
    @State private var showingAddEditView = false
    @State private var editingAddress: Address? = nil
    
    var body: some View {
        Group {
            if addressManager.addresses.isEmpty {
                VStack(spacing: 20) {
                    Image(systemName: "shippingbox")
                        .font(.system(size: 60))
                        .foregroundColor(.gray.opacity(0.5))
                    Text("No Shipping Address")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    Text("Please add an address to continue.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Button(action: {
                        editingAddress = nil
                        showingAddEditView = true
                    }) {
                        Text("Add Address")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.purple)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal, 40)
                    .padding(.top, 10)
                }
            } else {
                List {
                    ForEach(addressManager.addresses) { address in
                        AddressRowView(
                            address: address,
                            isSelected: isSelectionMode && selectedAddress?.id == address.id,
                            onSelect: {
                                if isSelectionMode {
                                    selectedAddress = address
                                    presentationMode.wrappedValue.dismiss()
                                }
                            },
                            onEdit: {
                                editingAddress = address
                                showingAddEditView = true
                            }
                        )
                    }
                    .onDelete(perform: addressManager.removeAddress)
                }
                .listStyle(InsetGroupedListStyle())
            }
        }
        .navigationTitle(isSelectionMode ? "Select Address" : "Manage Addresses")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: 
            Group {
                if !addressManager.addresses.isEmpty {
                    Button(action: {
                        editingAddress = nil
                        showingAddEditView = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
        )
        // This makes sure re-rendering works fine after saving edit view
        .sheet(isPresented: $showingAddEditView) {
            AddressEditView(addressToEdit: editingAddress)
                .environmentObject(addressManager)
        }
    }
}

// Separate highly reusable subview:
struct AddressRowView: View {
    let address: Address
    let isSelected: Bool
    let onSelect: () -> Void
    let onEdit: () -> Void
    
    var body: some View {
        Button(action: onSelect) {
            HStack(alignment: .top) {
                // Radio button style if in selection mode
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.purple)
                        .font(.system(size: 20))
                        .padding(.trailing, 8)
                        .padding(.top, 4)
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text(address.name)
                            .font(.headline)
                            .foregroundColor(.primary)
                        Text(address.phoneNumber)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        if address.isDefault {
                            Text("Default")
                                .font(.caption2).bold()
                                .padding(.horizontal, 6)
                                .padding(.vertical, 2)
                                .background(Color.red.opacity(0.1))
                                .foregroundColor(.red)
                                .cornerRadius(4)
                        }
                    }
                    
                    Text(address.fullAddress)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                // Edit Icon
//                Button(action: onEdit) {
//                    Image(systemName: "square.and.pencil")
//                        .foregroundColor(.gray)
//                        .padding(8)
//                }
//                .buttonStyle(PlainButtonStyle()) // Prevent triggering the row button
            }
            .padding(.vertical, 4)
        }
        .foregroundColor(.primary) // prevent default button coloring everything blue
    }
}

#Preview {
    NavigationView {
        AddressListView(selectedAddress: .constant(nil), isSelectionMode: false)
            .environmentObject(AddressManager())
    }
}
