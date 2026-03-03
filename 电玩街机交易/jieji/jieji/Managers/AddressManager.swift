import Foundation
import Combine
import SwiftUI

class AddressManager: ObservableObject {
    @Published var addresses: [Address] = [] {
        didSet {
            save()
        }
    }
    
    private let key = "SavedAddresses"
    
    init() {
        load()
    }
    
    func addAddress(_ address: Address) {
        var newAddress = address
        if addresses.isEmpty {
            newAddress.isDefault = true
        } else if newAddress.isDefault {
            for i in 0..<addresses.count {
                addresses[i].isDefault = false
            }
        }
        addresses.append(newAddress)
    }
    
    func updateAddress(_ address: Address) {
        if let index = addresses.firstIndex(where: { $0.id == address.id }) {
            if address.isDefault {
                for i in 0..<addresses.count {
                    addresses[i].isDefault = false
                }
            }
            addresses[index] = address
        }
    }
    
    func deleteAddress(at indexSet: IndexSet) {
        addresses.remove(atOffsets: indexSet)
        if let first = addresses.first, !addresses.contains(where: { $0.isDefault }) {
            addresses[0].isDefault = true
        }
    }
    
    func setDefault(id: UUID) {
        for i in 0..<addresses.count {
            addresses[i].isDefault = (addresses[i].id == id)
        }
        save() // trigger save explicitly if needed or rely on didSet if elements mutating triggers it. Note: mutating array elements doesn't trigger didSet unless re-assigned.
        // Actually to trigger didSet properly:
        addresses = addresses
    }
    
    private func save() {
        if let data = try? JSONEncoder().encode(addresses) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    private func load() {
        if let data = UserDefaults.standard.data(forKey: key),
           let saved = try? JSONDecoder().decode([Address].self, from: data) {
            addresses = saved
        }
    }
}
