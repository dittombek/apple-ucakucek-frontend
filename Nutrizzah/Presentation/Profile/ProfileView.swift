//
//  ProfileView.swift
//  Nutrizzah
//
//  Created by Muhammad Maulana Husein on 24/05/26.
//

import SwiftUI
import Charts

struct DailyCalorie: Identifiable {
    let id = UUID()
    let day: String
    let calories: Int
}

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @AppStorage("userId") private var userId = 0
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false

    @State private var selectedTrend = "7 days"
    @State private var animateChart = false
    @State private var selectedDay: String? = nil

    let trendOptions = ["7 days", "30 days", "90 days"]

    let bgGradient = LinearGradient(
        colors: [Color(red: 0.95, green: 0.94, blue: 0.90), Color(red: 0.65, green: 0.75, blue: 0.55)],
        startPoint: .top, endPoint: .bottom
    )
    let primaryGreen = Color(red: 0.60, green: 0.68, blue: 0.48)

    var currentChartData: [DailyCalorie] {
        guard !viewModel.calorieHistory.isEmpty else { return [] }
        switch selectedTrend {
        case "7 days":
            let inputFmt = DateFormatter()
            inputFmt.dateFormat = "yyyy-MM-dd"
            let outputFmt = DateFormatter()
            outputFmt.dateFormat = "EEE"
            outputFmt.locale = Locale(identifier: "en_US")
            return viewModel.calorieHistory.map { item in
                let label = inputFmt.date(from: String(item.date.prefix(10)))
                    .map { outputFmt.string(from: $0) } ?? item.date
                return DailyCalorie(day: label, calories: Int(item.calories.rounded()))
            }
        case "30 days":
            return calculateAverages(
                from: viewModel.calorieHistory.map { Int($0.calories.rounded()) },
                daysPerGroup: 7, isBiWeekly: false
            )
        case "90 days":
            return calculateAverages(
                from: viewModel.calorieHistory.map { Int($0.calories.rounded()) },
                daysPerGroup: 14, isBiWeekly: true
            )
        default:
            return []
        }
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            bgGradient.ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {

                    // MARK: Header
                    VStack(spacing: 16) {
                        Text(viewModel.user?.name ?? "")
                            .font(.system(size: 34, weight: .semibold, design: .serif))
                            .minimumScaleFactor(0.8)
                            .padding(.top, 20)

                        ZStack {
                            Circle()
                                .fill(Color.pink.opacity(0.3))
                                .frame(width: 120, height: 120)
                            Text("🍅")
                                .font(.system(size: 60))
                        }
                        .padding(.bottom, 32)
                    }
                    .padding(.bottom, 48)

                    // MARK: Bottom Sheet
                    VStack {

                        // Metrics Card
                        HStack(spacing: 0) {
                            MetricItem(
                                title: "Height",
                                value: viewModel.user.map { "\(Int($0.height))" } ?? "--",
                                unit: "cm"
                            )
                            Divider().frame(height: 50)
                            MetricItem(
                                title: "Weight",
                                value: viewModel.user.map { "\(Int($0.weight))" } ?? "--",
                                unit: "kg"
                            )
                            Divider().frame(height: 50)
                            MetricItem(
                                title: "Age",
                                value: viewModel.user.map { "\($0.age)" } ?? "--",
                                unit: "tahun"
                            )
                        }
                        .padding(.vertical, 16)
                        .background(Color(red: 0.95, green: 0.96, blue: 0.93))
                        .cornerRadius(16)
                        .offset(y: -60)
                        .padding(.bottom, -40)
                        .padding(.horizontal, 24)

                        // Calories Trend
                        VStack(alignment: .leading, spacing: 48) {
                            HStack {
                                Text("Calories trend")
                                    .font(.title3.weight(.bold))
                                Spacer()
                                Picker("Trend Filter", selection: $selectedTrend) {
                                    ForEach(trendOptions, id: \.self) { Text($0).tag($0) }
                                }
                                .pickerStyle(.segmented)
                                .frame(width: 200)
                            }

                            Chart(currentChartData) { item in
                                BarMark(
                                    x: .value("Day", item.day),
                                    y: .value("Calories", animateChart ? item.calories : 0)
                                )
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [Color.pink.opacity(0.8), Color.pink.opacity(0.3)],
                                        startPoint: .top, endPoint: .bottom
                                    )
                                )
                                .cornerRadius(4)

                                if let selectedDay, item.day == selectedDay {
                                    RuleMark(x: .value("Day", item.day))
                                        .foregroundStyle(Color.gray.opacity(0.3))
                                        .annotation(position: .top) {
                                            Text("\(item.calories) cal")
                                                .font(.caption).bold()
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 4)
                                                .background(primaryGreen.opacity(0.3))
                                                .cornerRadius(8)
                                        }
                                }
                            }
                            .frame(height: 180)
                            .chartYAxis {
                                AxisMarks(position: .leading, values: .automatic(desiredCount: 5)) {
                                    AxisGridLine(stroke: StrokeStyle(lineWidth: 1, dash: [4]))
                                    AxisValueLabel()
                                }
                            }
                            .chartOverlay { proxy in
                                GeometryReader { geometry in
                                    Rectangle().fill(.clear).contentShape(Rectangle())
                                        .gesture(
                                            DragGesture(minimumDistance: 0)
                                                .onChanged { value in
                                                    let x = value.location.x - geometry[proxy.plotFrame!].origin.x
                                                    if let day: String = proxy.value(atX: x) {
                                                        selectedDay = day
                                                    }
                                                }
                                                .onEnded { _ in selectedDay = nil }
                                        )
                                }
                            }
                        }
                        .padding(.horizontal, 24)

                        // Settings
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Settings")
                                .font(.headline)
                                .foregroundColor(.gray)

                            // Personal information — hidden for now
                            // Button(action: {}) {
                            //     HStack {
                            //         Text("Personal information").foregroundColor(.primary)
                            //         Spacer()
                            //         Image(systemName: "chevron.right").foregroundColor(.gray)
                            //     }
                            // }
                            // Divider()

                            Button {
                                userId = 0
                                hasSeenOnboarding = false
                            } label: {
                                Text("Log out")
                                    .foregroundColor(.red)
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 16)

                        Spacer().frame(height: 20)
                    }
                    .background(
                        Color.white
                            .clipShape(UnevenRoundedRectangle(topLeadingRadius: 32, topTrailingRadius: 32))
                            .padding(.bottom, -1000)
                    )
                }
            }
        }
        .task {
            await viewModel.loadUser()
            await viewModel.loadHistory(days: 7)
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                animateChart = true
            }
        }
        .onChange(of: selectedTrend) { _, trend in
            animateChart = false
            selectedDay = nil
            let days = trend == "7 days" ? 7 : trend == "30 days" ? 30 : 90
            Task {
                await viewModel.loadHistory(days: days)
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1)) {
                    animateChart = true
                }
            }
        }
    }
}

extension ProfileView {
    func calculateAverages(from rawData: [Int], daysPerGroup: Int, isBiWeekly: Bool = false) -> [DailyCalorie] {
        var result: [DailyCalorie] = []
        var groupIndex = 1
        for start in stride(from: 0, to: rawData.count, by: daysPerGroup) {
            let chunk = Array(rawData[start..<min(start + daysPerGroup, rawData.count)])
            let avg = chunk.isEmpty ? 0 : chunk.reduce(0, +) / chunk.count
            let label = isBiWeekly ? "W\(groupIndex * 2 - 1)-\(groupIndex * 2)" : "W\(groupIndex)"
            result.append(DailyCalorie(day: label, calories: avg))
            groupIndex += 1
        }
        return result
    }
}

struct MetricItem: View {
    let title: String
    let value: String
    let unit: String

    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(value)
                    .font(.title2.weight(.bold))
                Text(unit)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ProfileView()
}
