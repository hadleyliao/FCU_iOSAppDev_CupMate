import SwiftUI

struct WaveView: View {
    var progress: Double
    var phase: CGFloat = 0
    var color: Color

    var body: some View {
        //這個元件能讓水面隨水位高度動態改變，波紋則隨 phase 參數流動
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            let waveHeight: CGFloat = 6
            
            // 用 Path 動態繪製波紋，但不管怎麼繪製，裁剪之後只會顯示在「杯子」內
            Path { path in
                path.move(to: CGPoint(x: 0, y: height))
                for x in stride(from: 0, through: width, by: 1) {
                    let relativeX = x / width
                    let sine = sin(relativeX * .pi * 2 + phase)
                    let y = (1 - CGFloat(progress)) * height + sine * waveHeight
                    path.addLine(to: CGPoint(x: x, y: y))
                }
                path.addLine(to: CGPoint(x: width, y: height))
                path.closeSubpath()
            }
            .fill(color)
        }
        .clipped()
    }
}
