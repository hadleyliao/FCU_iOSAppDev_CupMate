import SwiftUI

struct ProgressPage: View {
    // 傳入飲水類型與對應毫升數的字典
    @Binding var intakeDict: [DrinkType: Double]
    // 每日喝水目標（ml）
    var dailyGoal: Double

    // 計算總飲水量
    var totalIntake: Double {
        intakeDict.values.reduce(0, +)
    }

    var body: some View {
        VStack(spacing: 30) {
            // 上方 Logo 與標題
            HStack {
                Image(systemName: "humidity")
                    .font(.system(size: 50))
                    .foregroundColor(.cyan)

                Text("CupMate 日日飲")
                    .font(.title)
                    .foregroundColor(.cyan)
                    .bold()
            }

            // 進度標題
            Text("今日飲水進度")
                .font(.title)
                .bold()
            
            Spacer().frame(height: 30)
            
            // 環形進度條與飲水資訊
            ZStack {
                // 灰色底圈
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 30)
                
                // 多層環形：每種飲品各一段
                ForEach(Array(intakeDict.keys.enumerated()), id: \.element) { index, drink in
                    let startAngle = startAngle(for: index)
                    let endAngle = startAngle + Angle(degrees: 360 * (intakeDict[drink]! / max(totalIntake, dailyGoal)))
                    
                    Circle()
                        .trim(from: CGFloat(startAngle.degrees / 360), to: CGFloat(endAngle.degrees / 360))
                        .stroke(color(for: drink), style: StrokeStyle(lineWidth: 30, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .animation(.easeOut(duration: 1), value: intakeDict[drink])
                }
                
                // 中間顯示總量與各飲品百分比
                VStack {
                    Text("\(Int(totalIntake))/\(Int(dailyGoal)) ml")
                        .font(.title2)
                        .bold()
                    
                    // 各飲品比例（四捨五入到整數%）
                    ForEach(Array(intakeDict.keys), id: \.self) { drink in
                        Text("\(drink.rawValue.capitalized): \(Int((intakeDict[drink]! / max(totalIntake, dailyGoal)) * 100))%")
                            .font(.subheadline)
                    }
                }
            }
            .frame(width: 280, height: 280)
        }
        .padding()
    }

    // MARK: - 計算每種飲品起始角度（累積之前飲品的比例）
    func startAngle(for index: Int) -> Angle {
        let values = Array(intakeDict.values)
        let total = values.reduce(0, +)
        let prior = values.prefix(index).reduce(0, +)
        return Angle(degrees: 360 * (prior / max(total, dailyGoal)))
    }

    // MARK: - 各飲品對應顏色
    func color(for drink: DrinkType) -> Color {
        switch drink {
        case .drink: return Color.pink.opacity(0.3)
        case .coffee: return Color.brown.opacity(0.8)
        case .water: return Color.blue.opacity(0.3)
        case .soup: return Color.yellow.opacity(0.3)
        }
    }
}

// MARK: - 預覽
#Preview {
    ProgressPage(
        intakeDict: .constant([
            .drink: 300,
            .coffee: 300,
            .water: 500,
            .soup: 400
        ]),
        dailyGoal: 3000
    )
}
