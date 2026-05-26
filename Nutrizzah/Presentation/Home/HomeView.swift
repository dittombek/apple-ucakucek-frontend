//
//  HomeView.swift
//  Nutrizzah
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var selectedDate: Date = .now
    @State private var nutritionPage: Int? = 0
    @State private var showDatePicker = false
    
    var greetingText: String {
        let hour = Calendar.current.component(.hour, from: .now)
        if hour < 12 { return "Morning" }
        if hour < 17 { return "Afternoon" }
        return "Evening"
    }
    
    var mealSuggestion: String {
        let hour = Calendar.current.component(.hour, from: .now)
        if hour < 10 { return "Ready to log breakfast?" }
        if hour < 14 { return "Ready to log lunch?" }
        if hour < 18 { return "Ready to log dinner?" }
        return "Ready to log a snack?"
    }
    
    var greetingIcon: String {
        let hour = Calendar.current.component(.hour, from: .now)
        if hour < 12 { return "sunrise.fill" }
        if hour < 17 { return "sun.max.fill" }
        return "moon.fill"
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color(.systemGroupedBackground)
                .ignoresSafeArea()
            
            VStack(spacing: 16) {
                // MARK: — Greeting Banner
                HStack(spacing: 10) {
                    Image(systemName: greetingIcon)
                        .font(.system(size: 20))
                        .foregroundColor(.matchaGreen)
                    Text("\(greetingText), \(viewModel.userName). \(mealSuggestion)")
                        .font(.system(size: 14))
                        .foregroundColor(.darkGreen)
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.veryLightGreen)
                )
                .padding(.horizontal, 16)
                
                // MARK: — Daily Intake + Nutrition PageView
                DailyIntakeCard(
                    consumed: viewModel.caloriesConsumed,
                    goal: viewModel.caloriesGoal
                )
                .padding(.horizontal, 16)

                // MARK: - Nutrition
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 0) {
                        // Page 1: Carbs, Protein, Fat
                        MacroDetailCard(
                            carbs: viewModel.dailyTotal.carbs,
                            carbsGoal: viewModel.target?.carbs ?? 0,
                            protein: viewModel.dailyTotal.protein,
                            proteinGoal: viewModel.target?.protein ?? 0,
                            fat: viewModel.dailyTotal.fat,
                            fatGoal: viewModel.target?.fat ?? 0
                        )
                        .containerRelativeFrame(.horizontal)
                        .id(0)

                        // Page 2: Vitamin, Mineral
                        MacroDetailCard(
                            carbs: viewModel.dailyTotal.vitamin,
                            carbsGoal: viewModel.target?.vitamin ?? 0,
                            protein: viewModel.dailyTotal.mineral,
                            proteinGoal: viewModel.target?.mineral ?? 0,
                            fat: 0, fatGoal: 0,
                            labels: ("Vitamin", "Mineral", nil),
                            units: ("mg", "mg", "mg")
                        )
                        .containerRelativeFrame(.horizontal)
                        .id(1)
                    }
                    .scrollTargetLayout()
                }
                .scrollTargetBehavior(.paging)
                .scrollPosition(id: $nutritionPage)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal, 16)
                
                // Page dots
                HStack(spacing: 6) {
                    ForEach(0..<2, id: \.self) { i in
                        Circle()
                            .frame(width: 7, height: 7)
                            .foregroundColor((nutritionPage ?? 0) == i ? .darkGreen : Color(.systemGray4))
                    }
                }
                
                VStack(spacing: 16) {
                    // MARK: — Date Navigation
                    HStack {
                        Button {
                            selectedDate = Calendar.current.date(byAdding: .day, value: -1, to: selectedDate) ?? selectedDate
                        } label: {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.secondary)
                        }
                        .frame(width: 36, height: 36)
                        .background(
                            RoundedRectangle(cornerRadius: 100)
                                .fill(Color(.gray).opacity(0.15))
                        )
                        
                        Button {
                            showDatePicker = true
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "calendar")
                                    .foregroundColor(.secondary)
                                Text(dateLabel(for: selectedDate))
                                    .font(.system(size: 15, weight: .medium))
                                    .foregroundColor(.primary)
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .frame(maxWidth: .infinity)
                            .frame(height: 36)
                            .background(
                                RoundedRectangle(cornerRadius: 100)
                                    .fill(Color(.gray).opacity(0.15))
                            )
                        }
                        .sheet(isPresented: $showDatePicker) {
                            DatePicker("", selection: $selectedDate, displayedComponents: .date)
                                .datePickerStyle(.graphical)
                                .tint(.matchaGreen)
                                .padding()
                                .presentationDetents([.medium])
                                .presentationBackground(.white)
                        }
                        
                        Button {
                            selectedDate = Calendar.current.date(byAdding: .day, value: 1, to: selectedDate) ?? selectedDate
                        } label: {
                            Image(systemName: "chevron.right")
                                .foregroundColor(.secondary)
                        }
                        .frame(width: 36, height: 36)
                        .background(
                            RoundedRectangle(cornerRadius: 100)
                                .fill(Color(.gray).opacity(0.15))
                        )
                    }
                    .padding(.horizontal, 16)
                    
                    // MARK: — Meal Sections
                    VStack(spacing: 16) {
                        MealRow(icon: "sunrise.fill", title: "Breakfast", foods: viewModel.foodLogs.filter { $0.meal == "Breakfast" })
                        MealRow(icon: "sun.max.fill", title: "Lunch", foods: viewModel.foodLogs.filter { $0.meal == "Lunch" })
                        MealRow(icon: "moon.fill", title: "Dinner", foods: viewModel.foodLogs.filter { $0.meal == "Dinner" })
                        MealRow(icon: "leaf.fill", title: "Snack", foods: viewModel.foodLogs.filter { $0.meal == "Snack" })
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color(.secondarySystemGroupedBackground))
                    )
                }
                .padding(.horizontal, 16)
                .padding(.top, 16)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .background(Color(.secondarySystemGroupedBackground))
                .clipShape(UnevenRoundedRectangle(topLeadingRadius: 32, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 32))
                .ignoresSafeArea(edges: .bottom)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .task { await viewModel.load(for: selectedDate) }
        .onChange(of: selectedDate) { _, newDate in
            Task { await viewModel.load(for: newDate) }
        }
    }

    func dateLabel(for date: Date) -> String {
        if Calendar.current.isDateInToday(date) { return "Today" }
        if Calendar.current.isDateInYesterday(date) { return "Yesterday" }
        if Calendar.current.isDateInTomorrow(date) { return "Tomorrow" }
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: date)
    }
}

// MARK: — Daily Intake Card
struct DailyIntakeCard: View {
    let consumed: Double
    let goal: Double

    var isOver: Bool { consumed > goal }
    var progress: Double { goal > 0 ? min(consumed / goal, 1.0) : 0 }
    var percentage: Int { goal > 0 ? Int((consumed / goal) * 100) : 0 }
    var displayValue: Int { isOver ? Int(consumed - goal) : Int(max(goal - consumed, 0)) }

    var ringColor: Color { isOver ? .darkGreen : .matchaGreen }
    var bgColor: Color { isOver ? Color.pink.opacity(0.15) : Color.veryLightGreen }
    var textColor: Color { isOver ? Color(red: 0.6, green: 0.2, blue: 0.2) : .darkGreen }

    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Daily Intake")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(textColor)
                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text("\(displayValue)")
                        .font(.custom("PPEditorialNew-UltraboldItalic", size: 48))
                        .foregroundColor(textColor)
                    Text(isOver ? "Calories in excess" : "Calories left")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
            ZStack {
                Circle()
                    .stroke(Color(.systemGray5), lineWidth: 10)
                    .frame(width: 90, height: 90)
                Circle()
                    .trim(from: 0, to: CGFloat(progress))
                    .stroke(ringColor, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .frame(width: 90, height: 90)
                Text("\(percentage)%")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(textColor)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, minHeight: 140)
        .background(RoundedRectangle(cornerRadius: 18).fill(bgColor))
        .animation(.easeInOut(duration: 0.3), value: isOver)
    }
}

// MARK: — Macro Cards
struct MacroDetailCard: View {
    let carbs: Double
    let carbsGoal: Double
    let protein: Double
    let proteinGoal: Double
    let fat: Double
    let fatGoal: Double
    var labels: (String, String, String?) = ("Carbs", "Protein", "Fat")
    var units: (String, String, String) = ("g", "g", "g")

    var body: some View {
        HStack(spacing: 12) {
            MacroCard(value: carbs, goal: carbsGoal, label: labels.0, unit: units.0)
            MacroCard(value: protein, goal: proteinGoal, label: labels.1, unit: units.1)
            if let thirdLabel = labels.2 {
                MacroCard(value: fat, goal: fatGoal, label: thirdLabel, unit: units.2)
            }
        }
        .padding(.horizontal, 4)
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

struct MacroCard: View {
    let value: Double
    let goal: Double
    let label: String
    var unit: String = "g"

    var isOver: Bool { goal > 0 && value > goal }
    var progress: Double { goal > 0 ? min(value / goal, 1.0) : 0 }
    var ringColor: Color { isOver ? .darkGreen : .matchaGreen }

    private func format(_ v: Double) -> String {
        let rounded = Int(v.rounded())
        if rounded == 0 && v > 0 { return String(format: "%.1f", v) }
        return "\(rounded)"
    }

    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .stroke(Color(.systemGray5), lineWidth: 8)
                Circle()
                    .trim(from: 0, to: CGFloat(progress))
                    .stroke(ringColor, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                VStack(spacing: 2) {
                    Text(format(value))
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(isOver ? .darkGreen : .darkGreen)
                    Text("/\(format(goal))\(unit)")
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                }
            }
            .frame(width: 72, height: 72)
            Text(label)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.darkGreen)
        }
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.secondarySystemGroupedBackground))
        )
    }
}

// MARK: — Meal Row
struct MealRow: View {
    let icon: String
    let title: String
    let foods: [FoodLogWithCalories]

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(.matchaGreen)
                    .frame(width: 32)
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                Spacer()
            }
            if !foods.isEmpty {
                Text(foods.map { "\($0.foodName) (\(Int($0.calories.rounded())) Cal)" }.joined(separator: ", "))
                    .font(.system(size: 13))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                    .padding(.leading, 46)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 10)
        .overlay(RoundedRectangle(cornerRadius: 8)
            .stroke(Color.gray.opacity(0.30), lineWidth: 1))
    }
}

#Preview {
    MainTabView()
}
