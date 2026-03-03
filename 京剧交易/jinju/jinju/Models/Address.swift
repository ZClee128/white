import Foundation

struct Address: Identifiable, Equatable, Codable {
    var id = UUID()
    var name: String
    var phone: String
    var detail: String
    var isDefault: Bool
}
