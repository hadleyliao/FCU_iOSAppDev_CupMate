//
//  ContentView.swift
//  project
//
//  Created by 訪客使用者 on 2025/8/1.
//

//import SwiftUI
//
//struct ContentView: View {
//    var body: some View {
//        VStack {
//            Image(systemName: "humidity")
//                .font(.system(size: 100))
//                .foregroundColor(.cyan)
//            Text("DROP!")
//                .font(.system(size: 50, weight: .bold))
//                .foregroundColor(.cyan)
//        }
//        .padding()
//    }
//}
//
//#Preview {
//    ContentView()
//}


import SwiftUI

struct ContentView: View {
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
        VStack(spacing: 20) {
            Image(systemName: "humidity")
                .font(.system(size: 50))
                .foregroundColor(.cyan)
            Text("本日飲水量")
                .font(.title)

            Text("\(Int(totalIntake)) / \(Int(dailyGoal)) ml")
                .font(.headline)

            // 四個杯子
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                ForEach(DrinkType.allCases) { type in
                    CupView(type: type, intakeAmount: intakeDict[type] ?? 0)
                }
            }


            Divider()

            // 輸入區塊
            VStack(spacing: 10) {
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

                    Button("加入") {
                        if let amount = Double(inputAmount), amount > 0 {
                            print("selected drink: \(selectedDrink)")
                            let current = intakeDict[selectedDrink] ?? 0
                            let newAmount = current + amount
                            intakeDict[selectedDrink] = newAmount

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
    }
}

#Preview {
    ContentView()
}
