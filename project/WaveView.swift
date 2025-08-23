// MARK: - WaveView.swift
// 水波動畫視圖，負責繪製動態的波浪效果

import SwiftUI

struct WaveView: View {
    // MARK: - 屬性
    var progress: Double        // 水位進度（0-1），決定水面高度
    var phase: CGFloat = 0      // 波浪相位，控制波浪的水平位置
    var color: Color           // 水波顏色

    var body: some View {
        // MARK: - 幾何讀取器
        // 功能：取得容器的實際尺寸，用於繪製波浪
        GeometryReader { geo in
            let width = geo.size.width      // 容器寬度
            let height = geo.size.height    // 容器高度
            let waveHeight: CGFloat = 5    // 波浪振幅（波峰到波谷的高度）
            
            // MARK: - 波浪路徑繪製
            // 功能：使用 Path 動態繪製波浪形狀
            Path { path in
                // 從左下角開始繪製
                path.move(to: CGPoint(x: 0, y: height))
                
                // 逐點繪製波浪曲線
                for x in stride(from: 0, through: width, by: 1) {
                    let relativeX = x / width                    // 將 x 座標標準化為 0-1
                    let sine = sin(relativeX * .pi * 2 + phase)  // 計算正弦波值
                    
                    // 計算 y 座標：
                    // - (1 - progress) * height：根據水位進度計算基準高度
                    // - sine * waveHeight：加上波浪起伏
                    let y = (1 - CGFloat(progress)) * height + sine * waveHeight
                    
                    path.addLine(to: CGPoint(x: x, y: y))
                }
                
                // 連接到右下角並閉合路徑，形成填充區域
                path.addLine(to: CGPoint(x: width, y: height))
                path.closeSubpath()
            }
            .fill(color)  // 使用指定顏色填充路徑
        }
        .clipped()  // 裁剪超出邊界的部分
    }
}

// MARK: - 預覽
#Preview {
    ContentView()
}

// MARK: - 單獨杯子預覽
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
