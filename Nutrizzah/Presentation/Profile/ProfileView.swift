//
//  ProfileView.swift
//  Nutrizzah
//
//  Created by Muhammad Maulana Husein on 24/05/26.
//

import SwiftUI
import Charts

// MARK: - Data Models
struct DailyCalorie: Identifiable {
    let id = UUID()
    let day: String
    let calories: Int
}

// MARK: - Profile Screen
struct ProfileView: View {
    // State Data User
    @State private var userName = "Husein"
    @State private var height = 172
    @State private var weight = 69
    @State private var age = 28
    
    // State Filter Chart & Animasi
    @State private var selectedTrend = "7 days"
    @State private var animateChart = false
    @State private var selectedDay: String? = nil
    
    let trendOptions = ["7 days", "30 days", "90 days"]
    
    // Tema Warna
    let bgGradient = LinearGradient(
        colors: [Color(red: 0.95, green: 0.94, blue: 0.90), Color(red: 0.65, green: 0.75, blue: 0.55)],
        startPoint: .top, endPoint: .bottom
    )
    let primaryGreen = Color(red: 0.60, green: 0.68, blue: 0.48)
    
    // MARK: - Algoritma Chart Dinamis
    var currentChartData: [DailyCalorie] {
        switch selectedTrend {
        case "7 days":
            // Data 7 hari (Tanpa dirata-rata)
            return [
                DailyCalorie(day: "Sun", calories: 1800),
                DailyCalorie(day: "Mon", calories: 2000),
                DailyCalorie(day: "Tue", calories: 1400),
                DailyCalorie(day: "Wed", calories: 1100),
                DailyCalorie(day: "Thu", calories: 2300),
                DailyCalorie(day: "Fri", calories: 1500),
                DailyCalorie(day: "Sat", calories: 1900)
            ]
            
        case "30 days":
            // PRO-TIP: Gunakan 28 Hari (Persis 4 Minggu)
            // Simulasi Data API: 28 hari ke belakang
            let apiData28Days = (1...28).map { _ in Int.random(in: 1200...2200) }
            return calculateAverages(from: apiData28Days, daysPerGroup: 7, isBiWeekly: false)
            
        case "90 days":
            // PRO-TIP: Gunakan 84 Hari (Persis 12 Minggu)
            // Simulasi Data API: 84 hari ke belakang
            let apiData84Days = (1...84).map { _ in Int.random(in: 1200...2200) }
            return calculateAverages(from: apiData84Days, daysPerGroup: 14, isBiWeekly: true)
            
        default:
            return []
        }
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            bgGradient.ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    
                    // MARK: Header (Nama & Avatar)
                    VStack(spacing: 16) {
                        Text(userName)
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
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel("Profile picture")
                        .padding(.bottom, 32)
                    }
                    .padding(.bottom, 48)
                    
                    // MARK: Bottom Sheet Area
                    VStack {
                        
                        // 2. Metrics Card
                        HStack(spacing: 0) {
                            MetricItem(title: "Height", value: "\(height)", unit: "cm")
                            Divider().frame(height: 50)
                            MetricItem(title: "Weight", value: "\(weight)", unit: "kg")
                            Divider().frame(height: 50)
                            MetricItem(title: "Age", value: "\(age)", unit: "tahun")
                        }
                        .padding(.vertical, 16)
                        .background(Color(red: 0.95, green: 0.96, blue: 0.93))
                        .cornerRadius(16)
                        .offset(y: -60)
                        .padding(.bottom, -40)
                        .padding(.horizontal, 24)
                        
                        // 3. Calories Trend
                        VStack(alignment: .leading, spacing: 48) {
                            HStack {
                                Text("Calories trend")
                                    .font(.title3.weight(.bold))
                                
                                Spacer()
                                
                                Picker("Trend Filter", selection: $selectedTrend) {
                                    ForEach(trendOptions, id: \.self) { option in
                                        Text(option).tag(option)
                                    }
                                }
                                .pickerStyle(.segmented)
                                .frame(width: 200)
                            }
                            
                            // 4. Framework Charts Apple (Animated & Interactive)
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
                                
                                // Interactive Pop-up
                                if let selectedDay = selectedDay, item.day == selectedDay {
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
                            // Interaktivitas (Tap & Scrubbing)
                            .chartOverlay { proxy in
                                GeometryReader { geometry in
                                    Rectangle().fill(.clear).contentShape(Rectangle())
                                        .gesture(
                                            DragGesture(minimumDistance: 0)
                                                .onChanged { value in
                                                    let xLocation = value.location.x - geometry[proxy.plotFrame!].origin.x
                                                    if let day: String = proxy.value(atX: xLocation) {
                                                        selectedDay = day
                                                    }
                                                }
                                                .onEnded { _ in
                                                    selectedDay = nil
                                                }
                                        )
                                }
                            }
                        }
                        .padding(.horizontal, 24)
                        
                        // 5. Settings Menu
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Settings")
                                .font(.headline)
                                .foregroundColor(.gray)
                            
                            Button(action: { print("Personal information tapped") }) {
                                HStack {
                                    Text("Personal information")
                                        .foregroundColor(.primary)
                                    Spacer()
                                    Image(systemName: "chevron.right")
                                        .foregroundColor(.gray)
                                }
                            }
                            
                            Divider()
                            
                            Button(action: { print("Logout tapped") }) {
                                Text("Log out")
                                    .foregroundColor(.red)
                            }
                        }
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
        // Animasi saat load pertama
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                animateChart = true
            }
        }
        // Animasi saat Picker diubah
        .onChange(of: selectedTrend) {
            animateChart = false
            selectedDay = nil
            
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).delay(0.1)) {
                animateChart = true
            }
        }
    }
}

// MARK: - Helper Algoritma
extension ProfileView {
    func calculateAverages(from rawData: [Int], daysPerGroup: Int, isBiWeekly: Bool = false) -> [DailyCalorie] {
        var processedData: [DailyCalorie] = []
        var groupIndex = 1
        
        for startIndex in stride(from: 0, to: rawData.count, by: daysPerGroup) {
            let endIndex = min(startIndex + daysPerGroup, rawData.count)
            let chunk = Array(rawData[startIndex..<endIndex])
            
            let totalCalories = chunk.reduce(0, +)
            // Mencegah pembagian dengan 0 jika data kosong
            let averageCalories = chunk.isEmpty ? 0 : totalCalories / chunk.count
            
            let label: String
            if isBiWeekly {
                label = "W\(groupIndex * 2 - 1)-\(groupIndex * 2)"
            } else {
                label = "W\(groupIndex)"
            }
            
            processedData.append(DailyCalorie(day: label, calories: averageCalories))
            groupIndex += 1
        }
        
        return processedData
    }
}

// MARK: - Reusable Components
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
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title), \(value) \(unit == "cm" ? "centimeters" : unit == "kg" ? "kilograms" : "years")")
    }
}

#Preview {
    ProfileView()
}
