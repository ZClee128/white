import Foundation
import SwiftUI
import Combine

// MARK: - Address Model

struct Address: Identifiable, Codable, Equatable {
    let id: UUID
    var name: String
    var phone: String
    var street: String
    var city: String
    var state: String
    var country: String
    var postalCode: String
    var isDefault: Bool

    var fullAddress: String {
        "\(street), \(city), \(state) \(postalCode), \(country)"
    }
}

// MARK: - AddressStore (UserDefaults persistence)

class AddressStore: ObservableObject {
    @Published var addresses: [Address] = []

    private let key = "anit_saved_addresses"

    init() {
        load()
    }

    var defaultAddress: Address? {
        addresses.first(where: { $0.isDefault }) ?? addresses.first
    }

    func add(_ address: Address) {
        var updated = address
        // If it's the first address, set as default
        if addresses.isEmpty {
            updated.isDefault = true
        }
        addresses.append(updated)
        save()
    }

    func delete(at offsets: IndexSet) {
        let wasDefaultDeleted = offsets.contains(where: { addresses[$0].isDefault })
        addresses.remove(atOffsets: offsets)
        // Reassign default if needed
        if wasDefaultDeleted && !addresses.isEmpty {
            addresses[0].isDefault = true
        }
        save()
    }

    func setDefault(_ address: Address) {
        for i in addresses.indices {
            addresses[i].isDefault = (addresses[i].id == address.id)
        }
        save()
    }

    private func save() {
        if let data = try? JSONEncoder().encode(addresses) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: key),
              let decoded = try? JSONDecoder().decode([Address].self, from: data) else { return }
        addresses = decoded
    }
}
