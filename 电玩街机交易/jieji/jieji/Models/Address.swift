import Foundation

struct Address: Identifiable, Codable, Hashable {
    var id = UUID()
    var fullName: String
    var phoneNumber: String
    var streetAddress: String
    var city: String
    var state: String
    var zipCode: String
    var isDefault: Bool
}
