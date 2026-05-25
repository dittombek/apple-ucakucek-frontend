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

// MARK: - Main Orchestrator (Tab View Native)
struct MainTabView: View {
    // Warna hijau utama dari desain
    let primaryGreen = Color(red: 0.60, green: 0.68, blue: 0.48)
    
    var body: some View {
        TabView {
            // TAB 1: Journal (Placeholder)
            NavigationStack {
                Text("Halaman Journal")
                    .navigationTitle("Journal")
            }
            .tabItem {
                Label("Journal", systemImage: "clipboard.list")
            }
            
            // TAB 2: Profile (Sesuai Desain)
            NavigationStack {
                ProfileView()
                    // HIG: Aksi utama (Tambah) diletakkan di Toolbar kanan atas
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: {
                                print("Tombol Add (+) ditekan")
                            }) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(primaryGreen)
                                    .font(.title2)
                            }
                        }
                    }
            }
            .tabItem {
                Label("Profile", systemImage: "person.fill")
            }
        }
        // Mengubah warna ikon tab yang aktif menjadi hijau
        .tint(primaryGreen)
    }
}

// MARK: - Profile Screen
struct ProfileView: View {
    // State Data User
    @State private var userName = "Husein"
    @State private var height = 172
    @State private var weight = 69
    @State private var age = 28
    
    // State Filter Chart
    @State private var selectedTrend = "7 days"
    let trendOptions = ["7 days", "30 days", "90 days"]
    
    // Data Dummy Chart
    let chartData: [DailyCalorie] = [
        DailyCalorie(day: "Sun", calories: 1800),
        DailyCalorie(day: "Mon", calories: 2000),
        DailyCalorie(day: "Tue", calories: 1400),
        DailyCalorie(day: "Wed", calories: 1100),
        DailyCalorie(day: "Thu", calories: 2300),
        DailyCalorie(day: "Fri", calories: 1500),
        DailyCalorie(day: "Sat", calories: 1900)
    ]
    
    // Tema Warna
    let bgGradient = LinearGradient(
        colors: [Color(red: 0.95, green: 0.94, blue: 0.90), Color(red: 0.65, green: 0.75, blue: 0.55)],
        startPoint: .top, endPoint: .bottom
    )
    let primaryGreen = Color(red: 0.60, green: 0.68, blue: 0.48)
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // 1. Latar Belakang Gradien
            bgGradient.ignoresSafeArea()
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    
                    // MARK: Header (Nama & Avatar)
                    VStack(spacing: 16) {
                        Text(userName)
                            .font(.system(size: 34, weight: .semibold, design: .serif))
                            .minimumScaleFactor(0.8) // HIG: Mendukung Dynamic Type
                            .padding(.top, 20)
                        
                        ZStack {
                            Circle()
                                .fill(Color.pink.opacity(0.3))
                                .frame(width: 120, height: 120)
                            
                            Text("🍅") // Placeholder avatar
                                .font(.system(size: 60))
                        }
                        // HIG: Aksesibilitas VoiceOver
                        .accessibilityElement(children: .ignore)
                        .accessibilityLabel("Profile picture")
                        .padding(.bottom, 32)
                    }
                    .padding(.bottom, 60) // Ruang untuk efek overlap Metrics Card
                    
                    // MARK: Bottom Sheet Area
                    VStack(spacing: 24) {
                        
                        // 2. Metrics Card (Overlapping ke atas)
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
                        .offset(y: -60) // Menarik card ke atas memotong batas background
                        .padding(.bottom, -40) // Menetralkan spacing yang bergeser
                        .padding(.horizontal, 24)
                        
                        // 3. Calories Trend
                        VStack(alignment: .leading, spacing: 20) {
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
                            
                            // 4. Framework Charts Apple
                            Chart(chartData) { item in
                                BarMark(
                                    x: .value("Day", item.day),
                                    y: .value("Calories", item.calories)
                                )
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [Color.pink.opacity(0.8), Color.pink.opacity(0.3)],
                                        startPoint: .top, endPoint: .bottom
                                    )
                                )
                                .cornerRadius(4)
                                
                                // Mockup Tooltip statis (di hari Selasa)
                                if item.day == "Tue" {
                                    RuleMark(x: .value("Day", item.day))
                                        .foregroundStyle(Color.clear)
                                        .annotation(position: .top) {
                                            Text("1,200 cal")
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
                        }
                        .padding(.horizontal, 24)
                        .padding(.top, 16)
                        
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
                        
                        // Memberi sedikit ruang kosong sebelum tab bar bawah
                        Spacer().frame(height: 20)
                    }
                    .background(
                        Color.white
                            // Membuat sudut lengkung hanya di atas
                            .clipShape(UnevenRoundedRectangle(topLeadingRadius: 32, topTrailingRadius: 32))
                            .padding(.bottom, -1000)
                            
                    )
                }
            }
        }
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
        // HIG: Menggabungkan elemen agar VoiceOver membacanya sebagai kalimat utuh
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title), \(value) \(unit == "cm" ? "centimeters" : unit == "kg" ? "kilograms" : "years")")
    }
}

// MARK: - Preview
#Preview {
    MainTabView()
}
