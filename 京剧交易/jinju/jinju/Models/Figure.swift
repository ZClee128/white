import Foundation
import SwiftUI

struct Figure: Identifiable, Equatable, Codable {
    let id: UUID
    let name: String
    let imageName: String
    let characterRole: String
    let playName: String
    let price: Double
    let description: String
    let colorName: String
    
    init(id: UUID = UUID(), name: String, imageName: String, characterRole: String, playName: String, price: Double, description: String, colorName: String) {
        self.id = id
        self.name = name
        self.imageName = imageName
        self.characterRole = characterRole
        self.playName = playName
        self.price = price
        self.description = description
        self.colorName = colorName
    }
    
    var color: Color {
        switch colorName {
        case "pink": return .pink
        case "purple": return .purple
        case "red": return .red
        case "mint": return .mint
        case "blue": return .blue
        case "orange": return .orange
        case "black": return .black
        case "gray": return .gray
        case "cyan": return .cyan
        case "brown": return .brown
        case "yellow": return .yellow
        case "indigo": return .indigo
        case "primary": return .primary
        default: return .gray
        }
    }
}
