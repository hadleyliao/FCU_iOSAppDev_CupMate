import SwiftUI

struct CupView: View {
    let type: DrinkType
    let intakeAmount: Double
    let globalMax: Double = 2000  // 統一水位動畫基準

    @State private var shake: Bool = false
    @State private var wavePhase: CGFloat = 0

    var progress: Double {
        min(intakeAmount / globalMax, 1.0)
    }

    var body: some View {
        ZStack {
            VStack(spacing: 4) {
                ZStack(alignment: .bottom) {
                    // 杯子圖示（背景透明）
                    Image(systemName: type.systemImageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray.opacity(0.8))

                    // 水波動畫（重點在 clipShape）
                    if intakeAmount > 0 {
                        WaveView(progress: progress, phase: wavePhase, color: type.color.opacity(0.5))
                            .frame(width: 100, height: 100)
                            // 利用 clipShape 將水波圖層"限制"在杯子圖形的範圍內。這樣水波動畫或顏色填充只會顯示在杯子形狀內部，不會蔓延到外部。
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .blendMode(.plusLighter)
                            .allowsHitTesting(false)
                            .transition(.opacity)
                            .animation(.easeInOut(duration: 0.4), value: intakeAmount)
                    }

                    // 水位數字顯示（加背景）
                    if intakeAmount > 0 {
                        Text("\(Int(intakeAmount))ml")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundColor(.gray)
                            .padding(4)
                            .cornerRadius(5)
                            .padding(.bottom, 10)
                    }
                }
                .rotationEffect(.degrees(shake ? 2 : -2))
                .animation(
                    shake
                    ? .easeInOut(duration: 0.15).repeatCount(3, autoreverses: true)
                    : .default,
                    value: shake
                )
                
                // 每當攝取量改變時，會觸發水波相位移動與杯身搖晃的動畫
                .onChange(of: intakeAmount) { _ in
                    shake = true
                    withAnimation(.easeInOut(duration: 0.4)) {
                        wavePhase += 60  // 波動向右移動，呈現入水搖晃感
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        shake = false
                    }
                }

                // 容器名稱
                Text(type.rawValue)
                    .font(.caption)
                    .foregroundColor(.primary)
            }
        }
        .frame(width: 100, height: 160)
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
