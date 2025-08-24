// MARK: - DrinkType.swift
// 飲品類型枚舉，定義各種飲品的屬性和特徵

import SwiftUI

enum DrinkType: String, CaseIterable, Identifiable {
    case drink = "飲料杯"
    case coffee = "咖啡杯"
    case water = "水杯"
    case soup = "湯碗"
    

    // 實現 Identifiable 協議，用於 ForEach 迴圈
    var id: String { self.rawValue }

    // MARK: - 顏色配置
    // 功能：為每種飲品類型定義專屬顏色
    var color: Color {
        switch self {
        case .drink:
            return Color.pink.opacity(0.5)     // 粉紅色（飲料）
        case .coffee:
            return Color.brown.opacity(0.8)     // 棕色（咖啡）
        case .water:
            return Color.blue.opacity(0.7)      // 藍色（水）
        case .soup:
            return Color.yellow.opacity(0.5)    // 黃色（湯）
        }
    }

    // MARK: - 圖示配置
    // 功能：為每種飲品類型指定對應的 SF Symbol 圖示
    var systemImageName: String {
        switch self {
        case .drink:
            return "wineglass.fill"                        // 酒杯圖示
        case .coffee:
            return "cup.and.saucer.fill"                   // 咖啡杯和茶碟圖示
        case .water:
            return "mug.fill"                              // 馬克杯圖示
        case .soup:
            return "takeoutbag.and.cup.and.straw.fill"     // 外帶餐飲圖示
        }
    }

    // MARK: - 容量配置
    // 功能：定義每種容器的最大容量（毫升）
    // 注意：目前程式中未使用此屬性，但為未來擴展功能預留
    var maxCapacity: Double {
        switch self {
        case .drink:
            return 1000     // 飲料杯：1000ml
        case .coffee:
            return 500      // 咖啡杯：500ml
        case .water:
            return 1500     // 水杯：1500ml
        case .soup:
            return 800      // 湯碗：800ml
            
        }
    }
}

// MARK: - 預覽
#Preview {
    ContentView()
}

// MARK: - 單獨杯子預覽
#Preview("Drink") {
    CupView(type: .drink, intakeAmount: 1200)
        .scaleEffect(3) // 放大 3 倍
}

#Preview("Coffee") {
    CupView(type: .coffee, intakeAmount: 1000)
        .scaleEffect(3) // 放大 3 倍
}

#Preview("Water") {
    CupView(type: .water, intakeAmount: 1000)
        .scaleEffect(3) // 放大 3 倍
}

#Preview("Soup") {
    CupView(type: .soup, intakeAmount: 900)
        .scaleEffect(3) // 放大 3 倍
}
