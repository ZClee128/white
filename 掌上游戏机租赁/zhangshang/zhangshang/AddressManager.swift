import Foundation
import Combine
import SwiftUI

class AddressManager: ObservableObject {
    @Published var addresses: [Address] = []
    
    // Quick accessor to get the default or first available address
    var defaultOrFirstAddress: Address? {
        addresses.first(where: { $0.isDefault }) ?? addresses.first
    }
    
    private let addressesKey = "zhangshang_addresses_key"
    
    init() {
        loadAddresses()
    }
    
    func loadAddresses() {
        guard let data = UserDefaults.standard.data(forKey: addressesKey) else { return }
        do {
            let decoder = JSONDecoder()
            addresses = try decoder.decode([Address].self, from: data)
        } catch {
            print("Failed to load addresses: \(error)")
        }
    }
    
    func saveAddresses() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(addresses)
            UserDefaults.standard.set(data, forKey: addressesKey)
        } catch {
            print("Failed to save addresses: \(error)")
        }
    }
    
    func addAddress(_ address: Address) {
        var newAddress = address
        
        // If it's the first address, make it default automatically
        if addresses.isEmpty {
            newAddress.isDefault = true
        } else if newAddress.isDefault {
            // Unset other defaults if this one is set
            for index in addresses.indices {
                addresses[index].isDefault = false
            }
        }
        
        addresses.append(newAddress)
        saveAddresses()
    }
    
    func updateAddress(_ updatedAddress: Address) {
        if let index = addresses.firstIndex(where: { $0.id == updatedAddress.id }) {
            // Handle switching default status
            if updatedAddress.isDefault && !addresses[index].isDefault {
                for i in addresses.indices {
                    addresses[i].isDefault = false
                }
            }
            
            addresses[index] = updatedAddress
            saveAddresses()
        }
    }
    
    func removeAddress(at offsets: IndexSet) {
        let removedAddresses = offsets.map { addresses[$0] }
        addresses.remove(atOffsets: offsets)
        
        // If we removed the default address, and we have other addresses, make the first one default
        if removedAddresses.contains(where: { $0.isDefault }) && !addresses.isEmpty {
            addresses[0].isDefault = true
        }
        
        saveAddresses()
    }
}
