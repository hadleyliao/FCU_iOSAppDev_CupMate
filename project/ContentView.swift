// MARK: - ContentView.swift
// 主要內容視圖，負責管理整個飲水記錄應用程式的界面

import SwiftUI

struct ContentView: View {
    // MARK: - 狀態管理
    // 使用字典來管理各種飲品的攝取量，每種飲品類型對應一個數值
    @State private var intakeDict: [DrinkType: Double] = [
        .drink: 0,  // 飲料杯攝取量
        .coffee: 0, // 咖啡杯攝取量
        .water: 0,  // 水杯攝取量
        .soup: 0    // 湯碗攝取量
    ]
    
    // 目前選擇的飲品類型，預設為飲料杯
    @State private var selectedDrink: DrinkType = .drink
    
    // 輸入框的文字內容，用於記錄用戶輸入的攝取量
    @State private var inputAmount: String = ""
    
    
    // MARK: - 計算屬性
    // 計算總攝取量：將所有飲品的攝取量相加
    var totalIntake: Double {
        intakeDict.values.reduce(0, +)
    }
    
    // 每日目標攝取量（毫升）
    var dailyGoal = 3000.0
    
    
    // MARK: - 主要視圖
    var body: some View {
        TabView {

            // MARK: - 第1️⃣頁：原本的飲水紀錄
            VStack(spacing: 20) {
                Image(systemName: "humidity")
                    .font(.system(size: 50))
                    .foregroundColor(.cyan)
                Text("本日飲水量")
                    .font(.title)
                Text("\(Int(totalIntake)) / \(Int(dailyGoal)) ml")
                    .font(.headline)
                
                // MARK: - 杯子顯示區域
                // 使用 LazyVGrid 建立 2x2 的網格佈局來顯示四個杯子
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                    // 遍歷所有飲品類型，為每種類型建立一個 CupView
                    ForEach(DrinkType.allCases) { type in
                        CupView(type: type, intakeAmount: intakeDict[type] ?? 0)
                    }
                }
                
                Divider() // 分隔線
                
                // MARK: - 輸入控制區域
                VStack(spacing: 10) {
                    // 飲品類型選擇器，使用分段控制器樣式
                    Picker("選擇飲料", selection: $selectedDrink) {
                        ForEach(DrinkType.allCases) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(.segmented)
                    
                    // 輸入量區塊
                    HStack {
                        // 輸入框
                        TextField("輸入攝取量 (ml)", text: $inputAmount)
                            .keyboardType(.numberPad)           // 設定鍵盤為數字鍵盤
                            .textFieldStyle(.roundedBorder)     // 使用圓角邊框樣式
                        
                        // 按鈕
                        Button("加入") {
                            // 功能：將用戶輸入的攝取量加到選定的飲品類型中
                            if let amount = Double(inputAmount), amount > 0 {
                                
                                // 取得目前該飲品類型的攝取量
                                let current = intakeDict[selectedDrink] ?? 0
                                intakeDict[selectedDrink] = current + amount
                                
                                // 清空輸入框，方便下次輸入
                                inputAmount = ""
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
                .padding()
                
                Spacer()
            }
            .padding()
            .tabItem {
                Label("紀錄", systemImage: "cup.and.saucer.fill")
            }
            
            // MARK: - 第2️⃣頁：總水量進度環
            ProgressPage(intakeDict: $intakeDict, dailyGoal: dailyGoal)
                .tabItem {
                    Label("進度", systemImage: "chart.pie.fill")
                }
        }
    }
}


// MARK: - 預覽
#Preview {
    ContentView()
}
