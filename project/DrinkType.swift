import SwiftUI

enum DrinkType: String, CaseIterable, Identifiable {
    case drink = "飲料杯"
    case coffee = "咖啡杯"
    case water = "水杯"
    case soup = "湯碗"

    var id: String { self.rawValue }

    var color: Color {
        switch self {
        case .drink:
            return Color.pink.opacity(0.3)
        case .coffee:
            return Color.brown.opacity(0.8)
        case .water:
            return Color.blue.opacity(0.3)
        case .soup:
            return Color.yellow.opacity(0.3)
        }
    }

    // 容器形狀
    var systemImageName: String {
        switch self {
        case .drink:
            return "wineglass.fill"
        case .coffee:
            return "cup.and.saucer.fill"
        case .water:
            return "mug.fill"
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


// 預覽整體
#Preview {
    ContentView()
}

// 預覽每個杯子的狀態
#Preview("Drink") {
    CupView(type: .drink, intakeAmount: 1000)
}

#Preview("Coffee") {
    CupView(type: .coffee, intakeAmount: 1000)
}

#Preview("Water") {
    CupView(type: .water, intakeAmount: 1000)
}

#Preview("Soup") {
    CupView(type: .soup, intakeAmount: 900)
}
