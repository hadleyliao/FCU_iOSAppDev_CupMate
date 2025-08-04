// MARK: - CupView.swift
// 個別杯子視圖，負責顯示單一飲品容器的狀態和動畫效果

import SwiftUI

struct CupView: View {
    // MARK: - 屬性
    let type: DrinkType          // 飲品類型
    let intakeAmount: Double     // 當前攝取量
    let globalMax: Double = 2000 // 統一的最大值基準，用於計算水位高度比例

    // MARK: - 動畫狀態
    @State private var shake: Bool = false        // 控制杯子搖晃動畫
    @State private var wavePhase: CGFloat = 0     // 控制水波相位，影響波浪流動

    // MARK: - 計算屬性
    // 計算水位進度（0-1 之間），用於決定水面高度
    var progress: Double {
        min(intakeAmount / globalMax, 1.0)  // 確保進度不超過 100%
    }

    // MARK: - 主要視圖
    var body: some View {
        ZStack {
            VStack(spacing: 4) {
                // MARK: - 杯子主體區域
                ZStack(alignment: .bottom) {
                    // 杯子圖示（作為背景容器）
                    Image(systemName: type.systemImageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray.opacity(0.8))  // 半透明灰色

                    // MARK: - 水波動畫效果
                    // 只有當攝取量大於 0 時才顯示水波
                    if intakeAmount > 0 {
                        WaveView(
                            progress: progress,                    // 水位高度比例
                            phase: wavePhase,                     // 波浪相位
                            color: type.color.opacity(0.5)        // 根據飲品類型設定顏色
                        )
                        .frame(width: 100, height: 100)
                        // 關鍵功能：clipShape 將水波限制在杯子形狀內
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .blendMode(.plusLighter)               // 混合模式，增加發光效果
                        .allowsHitTesting(false)               // 不接受觸控事件
                        .transition(.opacity)                   // 出現/消失時的透明度轉場
                        .animation(.easeInOut(duration: 0.4), value: intakeAmount)
                    }

                    // MARK: - 數值顯示
                    // 當有攝取量時顯示具體數值
                    if intakeAmount > 0 {
                        Text("\(Int(intakeAmount))ml")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.gray)
                            .padding(4)
                            .cornerRadius(5)
                            .padding(.bottom, 10)
                    }
                }
                // MARK: - 搖晃動畫效果
                .rotationEffect(.degrees(shake ? 2 : -2))  // 左右搖擺 2 度
                .animation(
                    shake
                    ? .easeInOut(duration: 0.15).repeatCount(3, autoreverses: true)  // 搖晃時：快速來回 3 次
                    : .default,                                                       // 靜止時：預設動畫
                    value: shake
                )
                
                // MARK: - 攝取量變化監聽
                // 功能：當攝取量改變時觸發動畫效果
                .onChange(of: intakeAmount) { _ in
                    shake = true                              // 開始搖晃
                    withAnimation(.easeInOut(duration: 0.4)) {
                        wavePhase += 60                       // 波浪向右移動，模擬倒水效果
                    }
                    // 0.5 秒後停止搖晃
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        shake = false
                    }
                }

                // MARK: - 容器名稱標籤
                Text(type.rawValue)
                    .font(.caption)
                    .foregroundColor(.primary)
            }
        }
        .frame(width: 100, height: 160)  // 固定杯子視圖大小
    }
}

// MARK: - 預覽
#Preview {
    ContentView()
}

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
