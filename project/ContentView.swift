import SwiftUI

struct ContentView: View {
    // MARK: - 狀態管理
    @State private var intakeDict: [DrinkType: Double] = [
        .drink: 0,
        .coffee: 0,
        .water: 0,
        .soup: 0
    ]
    @State private var selectedDrink: DrinkType = .drink
    @State private var inputAmount: String = ""

    var totalIntake: Double {
        intakeDict.values.reduce(0, +)
    }
    var dailyGoal = 3000.0

    var body: some View {
        TabView {
            ScrollView {
                VStack(spacing: 15) {
                    HStack {
                        Image(systemName: "humidity")
                            .font(.system(size: 50))
                            .foregroundColor(.cyan)

                        Text("Cup Mate 日日飲")
                            .font(.title)
                            .foregroundColor(.cyan)
                            .bold()
                    }
                    
//                    Text("\(Int(totalIntake)) / \(Int(dailyGoal)) ml")
//                        .font(.headline)

                    // 杯子圖示區
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                        ForEach(DrinkType.allCases) { type in
                            VStack(spacing: 5){
                                CupView(type: type, intakeAmount: intakeDict[type] ?? 0)
                                Text(type.rawValue)
                                    .font(.subheadline)
                                Text("\(Int(intakeDict[type] ?? 0)) ml")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                                // 選擇框視覺提示
                                if type == selectedDrink {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.blue)
                                }
                            }
//                            .padding(.vertical, 3)
                            .onTapGesture {
                                selectedDrink = type
                            }
                        }
                    }
                    .padding(.horizontal)

                    // 控制區
                    VStack(spacing: 16) {
                        Picker("選擇飲料", selection: $selectedDrink) {
                            ForEach(DrinkType.allCases) { type in
                                Text(type.rawValue).tag(type)
                            }
                        }
                        .pickerStyle(.segmented)

                        HStack {
                            TextField("輸入攝取量 (ml)", text: $inputAmount)
                                .keyboardType(.numberPad)
                                .textFieldStyle(.roundedBorder)
                                .multilineTextAlignment(.center)    // 置中
                                .font(.system(size: 20, weight: .medium, design: .default))
                        }

                        HStack(spacing: 20) {
                            Button("增加") {
                                if let amount = Double(inputAmount), amount > 0 {
                                    let current = intakeDict[selectedDrink] ?? 0
                                    intakeDict[selectedDrink] = current + amount
                                    inputAmount = ""
                                }
                            }
                            .buttonStyle(.bordered)
                            .foregroundColor(.gray)

                            Button("減少") {
                                if let amount = Double(inputAmount), amount > 0 {
                                    let current = intakeDict[selectedDrink] ?? 0
                                    intakeDict[selectedDrink] = max(current - amount, 0)
                                    inputAmount = ""
                                }
                            }
                            .buttonStyle(.bordered)
                            .foregroundColor(.gray)

                            Button("重置") {
                                intakeDict[selectedDrink] = 0
                                inputAmount = ""
                            }
                            .buttonStyle(.bordered)
                            .foregroundColor(.gray)
                        }
                    }
                    .padding()
                }
                .padding()
            }
            .tabItem {
                Label("紀錄", systemImage: "cup.and.saucer.fill")
            }
            
            // MARK: - 第2頁：總水量進度環
            ProgressPage(intakeDict: $intakeDict, dailyGoal: dailyGoal)
                .tabItem {
                    Label("進度", systemImage: "chart.pie.fill")
                }
            // MARK: - 第3頁：提醒功能
                        ReminderView() // 這裡要有 ReminderView.swift
                            .tabItem {
                                Label("提醒", systemImage: "bell") // 這裡加上你的 Label
                            }
        }
    }
}


// MARK: - 預覽
#Preview {
    ContentView()
}
