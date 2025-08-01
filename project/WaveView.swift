//import SwiftUI
//
//struct WaveView: View {
//    var progress: Double  // 0~1，水位高低
//    var color: Color      // 水色
//    var waveHeight: CGFloat = 10
//    var waveLength: CGFloat = 150
//    @State private var phase: CGFloat = 0
//
//    var body: some View {
//        GeometryReader { geo in
//            let width = geo.size.width
//            let height = geo.size.height
//            let waterHeight = CGFloat(1 - progress) * height
//
//            ZStack {
//                color
//                    .mask(
//                        WaveShape(phase: phase, amplitude: waveHeight, waveLength: waveLength)
//                            .offset(y: waterHeight)
//                    )
//                    .animation(.easeInOut(duration: 0.3), value: progress)
//            }
//            .onAppear {
//                withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
//                    phase = .pi * 2
//                }
//            }
//        }
//    }
//}
//
//struct WaveShape: Shape {
//    var phase: CGFloat
//    var amplitude: CGFloat
//    var waveLength: CGFloat
//
//    var animatableData: CGFloat {
//        get { phase }
//        set { phase = newValue }
//    }
//
//    func path(in rect: CGRect) -> Path {
//        var path = Path()
//        let midHeight = rect.height / 2
//
//        path.move(to: CGPoint(x: 0, y: midHeight))
//
//        for x in stride(from: 0, through: rect.width, by: 1) {
//            let relativeX = x / waveLength
//            let y = amplitude * sin(relativeX * .pi * 2 + phase) + midHeight
//            path.addLine(to: CGPoint(x: x, y: y))
//        }
//
//        // 封閉底部
//        path.addLine(to: CGPoint(x: rect.width, y: rect.height))
//        path.addLine(to: CGPoint(x: 0, y: rect.height))
//        path.closeSubpath()
//
//        return path
//    }
//}


import SwiftUI

struct WaveView: View {
    var progress: Double
    var phase: CGFloat = 0
    var color: Color

    var body: some View {
        GeometryReader { geo in
            let width = geo.size.width
            let height = geo.size.height
            let waveHeight: CGFloat = 6

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
