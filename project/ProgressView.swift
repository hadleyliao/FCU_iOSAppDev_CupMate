import SwiftUI

// -------------------------- ProgressPage --------------------------
struct ProgressPage: View {
    @Binding var intakeDict: [DrinkType: Double]
    var dailyGoal: Double

    var totalIntake: Double {
        intakeDict.values.reduce(0, +)
    }

    var body: some View {
        VStack(spacing: 80) {
            Text("今日飲水進度")
                .font(.title)
                .bold()

            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 30)

                // 四種飲品的環形
                ForEach(Array(intakeDict.keys.enumerated()), id: \.element) { index, drink in
                    let startAngle = startAngle(for: index)
                    let endAngle = startAngle + Angle(degrees: 360 * (intakeDict[drink]! / max(totalIntake, dailyGoal)))
                    
                    Circle()
                        .trim(from: CGFloat(startAngle.degrees / 360), to: CGFloat(endAngle.degrees / 360))
                        .stroke(color(for: drink), style: StrokeStyle(lineWidth: 30, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .animation(.easeOut(duration: 1), value: intakeDict[drink])
                }

                VStack {
                    Text("\(Int(totalIntake))/\(Int(dailyGoal)) ml")
                        .font(.title2)
                        .bold()
                    
                    // 百分比顯示
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

    // 計算每個飲品環形的起始角度
    func startAngle(for index: Int) -> Angle {
        let values = Array(intakeDict.values)
        let total = values.reduce(0, +)
        let prior = values.prefix(index).reduce(0, +)
        return Angle(degrees: 360 * (prior / max(total, dailyGoal)))
    }

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
