import SwiftUI

enum DrinkType: String, CaseIterable, Identifiable {
    case drink = "飲料"
    case coffee = "咖啡"
    case water = "水"
    case soup = "湯"

    var id: String { self.rawValue }

    var color: Color {
        switch self {
        case .drink:
            return Color.blue.opacity(0.6) // 紅茶色
        case .coffee:
            return Color.blue.opacity(0.6)   // 深咖啡色
        case .water:
            return Color.blue.opacity(0.6)                           // 淺藍色
        case .soup:
            return Color.yellow.opacity(0.7)                         // 玉米濃湯色
        }
    }

    var systemImageName: String {
        switch self {
        case .drink:
            return "cup.and.saucer.fill"
        case .coffee:
            return "cup.and.saucer"
        case .water:
            return "drop.fill"
        case .soup:
            return "takeoutbag.and.cup.and.straw.fill"
        }
    }

    var maxCapacity: Double {
        switch self {
        case .drink:
            return 1000
        case .coffee:
            return 500
        case .water:
            return 1500
        case .soup:
            return 800
        }
    }
}
