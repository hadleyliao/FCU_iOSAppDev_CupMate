//import SwiftUI
//
//struct WaterLevelView: View {
//    @Binding var progress: Double  // 接收外部進度數值（0.0 ~ 1.0）
//
//    var body: some View {
//        ZStack(alignment: .bottom) {
//            Image(systemName: "cup.and.saucer") // 系統圖示，之後可換成圖片資產
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .foregroundColor(.gray.opacity(0.3))
//
//            Rectangle()
//                .fill(Color.blue.opacity(0.6))
//                .frame(height: CGFloat(progress) * 200)
//                .clipShape(RoundedRectangle(cornerRadius: 10))
//                .animation(.easeInOut(duration: 0.3), value: progress)
//        }
//        .frame(height: 300)
//    }
//}
