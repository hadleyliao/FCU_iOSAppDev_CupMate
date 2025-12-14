import SwiftUI

struct ReminderView: View {
    // 主開關
    @State private var notificationEnabled: Bool = false

    // 提醒自訂化
    @State private var customMessage: String = "該喝水囉💧"
    let systemSounds = ["預設", "水滴聲", "鳥鳴聲", "自訂音樂"]
    @State private var selectedSound: String = "預設"

    // 工作日（預設星期一到星期五，1~7: 一~日）
    @State private var workdayEnabled: Bool = true
    @State private var activeWeekdays: Set<Int> = [1,2,3,4,5] // 1~5: 一~五

    // 工作區段（多組，僅允許一組開啟）
    struct WorkPeriod: Identifiable, Equatable {
        let id = UUID()
        var start: Date
        var end: Date
        var enabled: Bool
    }
    @State private var workPeriods: [WorkPeriod] = []
    @State private var showAddWorkPeriod = false

    // 提醒間隔
    @State private var intervalHour = 1
    @State private var intervalMinute = 30

    // 狀態
    @State private var isConfigured = false
    @State private var scheduledTimes: [Date] = []

    let days = ["一","二","三","四","五","六","日"] // 1: 一, 2: 二 ...

    // 將高亮色改為 cyan，且根據開關決定是否使用灰色
    var highlightColor: Color { notificationEnabled ? .cyan : .gray }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Logo與標題，皆改成 cyan
                    HStack {
                        Image(systemName: "humidity")
                            .font(.system(size: 50))
                            .foregroundColor(.cyan)

                        Text("CupMate 日日飲")
                            .font(.title)
                            .foregroundColor(.cyan)
                            .bold()
                    }

                    // 開啟提醒總開關
                    HStack {
                        Text("喝水提醒設定")
                            .font(.title)
                            .bold()
                        Spacer()
                        Toggle(isOn: $notificationEnabled) {
                            Image(systemName: notificationEnabled ? "bell.fill" : "bell.slash.fill")
                        }
                        // 將藍色 toggle 改為 cyan
                        .toggleStyle(SwitchToggleStyle(tint: .cyan))
                        .labelsHidden()
                    }
                    .padding(.bottom, 10)

                    // 工作日（預設Mon-Fri：1~5）
                    GroupBox(label: HStack {
                        Label("工作日", systemImage: "calendar")
                        Toggle("", isOn: $workdayEnabled)
                            .labelsHidden()
                            // 這裡也用 highlightColor，以便根據主開關變色
                            .toggleStyle(SwitchToggleStyle(tint: highlightColor))
                    }) {
                        WeekdayPicker(
                            selectedDays: $activeWeekdays,
                            disabled: !notificationEnabled || !workdayEnabled,
                            highlightColor: highlightColor // 這裡 highlightColor 會是 cyan
                        )
                    }
                    .disabled(!notificationEnabled)

                    // 工作區段配置（多組+每組開關，僅允許一組開啟）
                    GroupBox(label: Label("工作區段", systemImage: "clock")) {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(workPeriods) { period in
                                HStack {
                                    Text("\(timeString(from: period.start)) ~ \(timeString(from: period.end))")
                                        .foregroundColor(period.enabled ? .primary : .secondary)
                                    Spacer()
                                    Toggle(isOn: Binding(
                                        get: { period.enabled },
                                        set: { newValue in
                                            // 僅允許一組開啟
                                            if newValue {
                                                for idx in workPeriods.indices {
                                                    workPeriods[idx].enabled = (workPeriods[idx].id == period.id)
                                                }
                                            } else {
                                                if let idx = workPeriods.firstIndex(of: period) {
                                                    workPeriods[idx].enabled = false
                                                }
                                            }
                                        }
                                    )) {
                                        EmptyView()
                                    }
                                    // 將 Toggle 顏色設為 cyan
                                    .labelsHidden()
                                    .toggleStyle(SwitchToggleStyle(tint: highlightColor))
                                    .disabled(!notificationEnabled || (period.enabled && workPeriods.filter{$0.enabled}.count == 1))
                                    Button("刪除") {
                                        if let idx = workPeriods.firstIndex(of: period) {
                                            workPeriods.remove(at: idx)
                                        }
                                    }
                                    .foregroundColor(.red)
                                    .disabled(!notificationEnabled)
                                }
                            }
                            Button("新增工作區段") { showAddWorkPeriod = true }
                                // 新增按鈕顏色也改成 cyan
                                .foregroundColor(notificationEnabled ? .cyan : .gray)
                                .disabled(!notificationEnabled)
                        }
                    }
                    .disabled(!notificationEnabled)

                    // 提醒間隔
                    GroupBox(label: Label("提醒間隔", systemImage: "timer")) {
                        HStack {
                            Picker("每隔", selection: $intervalHour) {
                                ForEach(0..<4) { Text("\($0)小時") }
                            }.frame(width: 100)
                            // 這裡會跟隨 highlightColor 變色
                            .accentColor(highlightColor)
                            .disabled(!notificationEnabled)

                            Picker("", selection: $intervalMinute) {
                                ForEach([0, 15, 30, 45], id: \.self) { Text("\($0)分鐘") }
                            }.frame(width: 100)
                            .accentColor(highlightColor)
                            .disabled(!notificationEnabled)
                        }
//                        Text("每隔 \(intervalHour)小時\(intervalMinute)分鐘提醒一次")
//                            .font(.caption)
//                            .foregroundColor(.gray)
                    }
                    .disabled(!notificationEnabled)

                    // 提醒自訂化區塊
                    GroupBox(label: Label("提醒自訂化", systemImage: "bell")) {
                        VStack(alignment: .leading, spacing: 12) {
                            TextField("提醒內容", text: $customMessage)
                                .textFieldStyle(.roundedBorder)
                                .disabled(!notificationEnabled)
                            Picker("提醒鈴聲", selection: $selectedSound) {
                                ForEach(systemSounds, id: \.self) { Text($0) }
                            }
                            .pickerStyle(.menu)
                            .accentColor(highlightColor)
                            .disabled(!notificationEnabled)
                        }
                    }
                    .disabled(!notificationEnabled)

                    // 啟用提醒按鈕
                    Button(action: {
                        if notificationEnabled {
                            scheduleReminders()
                            isConfigured = true
                        } else {
                            scheduledTimes.removeAll()
                            isConfigured = false
                        }
                    }) {
                        Text(notificationEnabled ? "啟用提醒" : "提醒未啟用")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            // 這裡將背景色由 .blue 改為 .cyan
                            .background(notificationEnabled ? Color.cyan : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .padding(.top)
                    .disabled(!notificationEnabled)

                    // 今日提醒時段預覽
                    if notificationEnabled, isConfigured {
                        if !scheduledTimes.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("今日將在以下時間提醒：")
                                    .font(.headline)
                                VStack(alignment: .leading, spacing: 4) {
                                    ForEach(scheduledTimes, id: \.self) { date in
                                        Text(timeString(from: date))
                                            .padding(.vertical, 2)
                                            .padding(.horizontal, 12)
                                            // 這裡 Capsule 的背景由 .blue 改為 .cyan
                                            .background(Capsule().fill(Color.cyan.opacity(0.18)))
                                    }
                                }
                            }
                            .padding(.top)
                        } else {
                            Text("你設定的區段或間隔沒有可用提醒時間。")
                                .foregroundColor(.red)
                                .padding(.top)
                        }
                    }

                    Spacer()
                }
                .padding()
            }
            .sheet(isPresented: $showAddWorkPeriod) {
                WorkPeriodPicker { start, end in
                    if start < end {
                        // 第一個區段預設開啟，其餘預設關閉
                        let enable = workPeriods.isEmpty
                        workPeriods.append(.init(start: start, end: end, enabled: enable))
                    }
                    showAddWorkPeriod = false
                }
            }
        }
        .onAppear {
            NotificationManager.shared.requestAuthorization()
        }
    }

    // 時間格式：08:00
    func timeString(from date: Date) -> String {
        let f = DateFormatter()
        f.dateFormat = "HH:mm"
        return f.string(from: date)
    }

    // 排程所有提醒
    func scheduleReminders() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        scheduledTimes.removeAll()
        let calendar = Calendar.current
        let now = Date()

        // 工作日判斷
        let weekday = calendar.component(.weekday, from: now)
        if workdayEnabled && !activeWeekdays.contains(weekday) { return }

        // 僅用啟用的工作區段
        guard let period = workPeriods.first(where: { $0.enabled }) else { return }

        var triggerTime = period.start
        while triggerTime <= period.end {
            if triggerTime > now {
                scheduledTimes.append(triggerTime)
                NotificationManager.shared.scheduleDrinkWaterReminder(
                    at: triggerTime,
                    customMessage: customMessage,
                    sound: selectedSound
                )
            }
            triggerTime = triggerTime.addingTimeInterval(TimeInterval(intervalHour * 3600 + intervalMinute * 60))
        }
        scheduledTimes.sort()
    }
}

// 複選星期元件（可自訂高亮顏色），1~7: 一~日
struct WeekdayPicker: View {
    @Binding var selectedDays: Set<Int>
    var disabled: Bool = false
    var highlightColor: Color = .cyan // 預設改為 cyan
    let days = ["一","二","三","四","五","六","日"]
    var body: some View {
        HStack(spacing: 6) {
            ForEach(1...7, id: \.self) { i in
                Button(action: {
                    guard !disabled else { return }
                    if selectedDays.contains(i) { selectedDays.remove(i) }
                    else { selectedDays.insert(i) }
                }) {
                    Text(days[i-1])
                        .font(.subheadline)
                        // 高亮色由 blue 改為 cyan
                        .frame(width: 28, height: 28)
                        .background(selectedDays.contains(i) ? highlightColor : Color.gray.opacity(0.3))
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
                .disabled(disabled)
            }
        }
    }
}

// 新增工作區段的 Picker
struct WorkPeriodPicker: View {
    // 預設 9:00~18:00
    @State var start = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date())!
    @State var end = Calendar.current.date(bySettingHour: 18, minute: 0, second: 0, of: Date())!
    var onDone: (Date, Date) -> Void
    var body: some View {
        NavigationView {
            Form {
                DatePicker("開始", selection: $start, displayedComponents: .hourAndMinute)
                DatePicker("結束", selection: $end, displayedComponents: .hourAndMinute)
            }
            .navigationTitle("新增工作區段")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("完成") { onDone(start, end) }
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("取消") { onDone(start, start) } // 不新增
                }
            }
        }
    }
}

// 通知管理
class NotificationManager {
    static let shared = NotificationManager()
    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { _, _ in }
    }
    func scheduleDrinkWaterReminder(
        at date: Date,
        customMessage: String,
        sound: String
    ) {
        let content = UNMutableNotificationContent()
        content.title = "喝水提醒"
        content.body = customMessage
        switch sound {
        case "水滴聲":
            content.sound = UNNotificationSound(named: UNNotificationSoundName("waterdrop.caf"))
        case "鳥鳴聲":
            content.sound = UNNotificationSound(named: UNNotificationSoundName("bird.caf"))
        case "自訂音樂":
            content.sound = UNNotificationSound(named: UNNotificationSoundName("custom.caf"))
        default:
            content.sound = .default
        }
        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
}

#Preview {
    ReminderView()
}
