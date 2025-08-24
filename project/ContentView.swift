import SwiftUI

struct ContentView: View {
    // MARK: - 狀態管理：追蹤每種飲料的攝取量、目前選擇的飲料與輸入量
    @State private var intakeDict: [DrinkType: Double] = [
        .drink: 0,
        .coffee: 0,
        .water: 0,
        .soup: 0
    ]
    @State private var selectedDrink: DrinkType = .drink
    @State private var inputAmount: String = ""

    // MARK: - 計算總攝取量
    var totalIntake: Double {
        intakeDict.values.reduce(0, +)
    }
    // MARK: - 每日目標
    var dailyGoal = 3000.0

    var body: some View {
        TabView {
            // MARK: - 第一頁：紀錄飲料攝取
            ScrollView {
                VStack(spacing: 15) {
                    // 頁首標題與圖示
                    HStack {
                        Image(systemName: "humidity")
                            .font(.system(size: 50))
                            .foregroundColor(.cyan) // 標題圖示顏色

                        Text("Cup Mate 日日飲")
                            .font(.title)
                            .foregroundColor(.cyan) // 標題文字顏色
                            .bold()
                    }

                    // MARK: - 杯子圖示區：每種飲品的圖示、名稱、攝取量
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                        ForEach(DrinkType.allCases) { type in
                            VStack(spacing: 5){
                                CupView(type: type, intakeAmount: intakeDict[type] ?? 0)
                                Text(type.rawValue)
                                    .font(.subheadline)
                                Text("\(Int(intakeDict[type] ?? 0)) ml")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                // 當前選擇飲料顯示 cyan 勾勾
                                if type == selectedDrink {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.cyan)
                                }
                            }
                            .onTapGesture {
                                selectedDrink = type // 點擊切換選擇
                            }
                        }
                    }
                    .padding(.horizontal)

                    // MARK: - 控制區：選擇飲料、輸入與調整攝取量
                    VStack(spacing: 20) {
                        // 選擇飲料類型
                        Picker("選擇飲料", selection: $selectedDrink) {
                            ForEach(DrinkType.allCases) { type in
                                Text(type.rawValue).tag(type)
                            }
                        }
                        .pickerStyle(.segmented)

                        // 輸入攝取量
                        HStack {
                            TextField("輸入攝取量 (ml)", text: $inputAmount)
                                .keyboardType(.numberPad)
                                .textFieldStyle(.roundedBorder)
                                .multilineTextAlignment(.center)
                                .font(.system(size: 20, weight: .medium, design: .default))
                        }

                        // 操作按鈕：增加、減少、重置
                        HStack(spacing: 20) {
                            Button("增加") {
                                if let amount = Double(inputAmount), amount > 0 {
                                    let current = intakeDict[selectedDrink] ?? 0
                                    intakeDict[selectedDrink] = current + amount
                                    inputAmount = ""
                                }
                            }
                            .buttonStyle(.bordered)
                            .foregroundColor(.cyan)

                            Button("減少") {
                                if let amount = Double(inputAmount), amount > 0 {
                                    let current = intakeDict[selectedDrink] ?? 0
                                    intakeDict[selectedDrink] = max(current - amount, 0)
                                    inputAmount = ""
                                }
                            }
                            .buttonStyle(.bordered)
                            .foregroundColor(.cyan)

                            Button("重置") {
                                intakeDict[selectedDrink] = 0
                                inputAmount = ""
                            }
                            .buttonStyle(.bordered)
                            .foregroundColor(.cyan)
                        }
                    }
                    .padding()
                }
                .padding()
            }
            .tabItem {
                Label("紀錄", systemImage: "cup.and.saucer.fill")
            }

            // MARK: - 第二頁：顯示總水量進度環
            ProgressPage(intakeDict: $intakeDict, dailyGoal: dailyGoal)
                .tabItem {
                    Label("進度", systemImage: "chart.pie.fill")
                }

            // MARK: - 第三頁：提醒功能（需要 ReminderView.swift）
            ReminderView()
                .tabItem {
                    Label("提醒", systemImage: "bell")
                }
        }
        .tint(.cyan) // TabView選中分頁顏色設為cyan
    }
}

// MARK: - 預覽
#Preview {
    ContentView()
}
