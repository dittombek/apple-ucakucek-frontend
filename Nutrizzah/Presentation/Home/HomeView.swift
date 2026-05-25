//
//  HomeView.swift
//  Nutrizzah
//

import SwiftUI

struct HomeView: View {
    @State private var selectedDate: Date = .now
    @State private var nutritionPage: Int? = 0
    @State private var showDatePicker = false
    
    // Sample data
    let userName = "Ditto"
    let caloriesLeft: Int = 1680
    let caloriesGoal: Int = 2000
    let carbs: Double = 0
    let carbsGoal: Double = 216
    let protein: Double = 0
    let proteinGoal: Double = 87
    let fat: Double = 0
    let fatGoal: Double = 58
    
    var caloriesProgress: Double {
        let consumed = Double(caloriesGoal - caloriesLeft)
        return consumed / Double(caloriesGoal)
    }
    
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
                    Text("\(greetingText), \(userName). \(mealSuggestion)")
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
                    caloriesLeft: caloriesLeft,
                    progress: caloriesProgress
                )
                .padding(.horizontal, 16)
                
                // MARK: - Nutrition
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 0) {
                        // Page 1: Carbs, Protein, Fat
                        MacroDetailCard(
                            carbs: carbs, carbsGoal: carbsGoal,
                            protein: protein, proteinGoal: proteinGoal,
                            fat: fat, fatGoal: fatGoal
                        )
                        .containerRelativeFrame(.horizontal)
                        .id(0)
                        
                        // Page 2: Vitamin, Mineral
                        MacroDetailCard(
                            carbs: carbs, carbsGoal: carbsGoal,
                            protein: protein, proteinGoal: proteinGoal,
                            fat: fat, fatGoal: fatGoal
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
                        MealRow(icon: "sunrise.fill", title: "Breakfast")
                        MealRow(icon: "sun.max.fill", title: "Lunch")
                        MealRow(icon: "moon.fill", title: "Dinner")
                        MealRow(icon: "leaf.fill", title: "Snack")
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
    let caloriesLeft: Int
    let progress: Double
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 6) {
                Text("Daily Intake")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.darkGreen)
                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text("\(caloriesLeft)")
                        .font(.custom("PPEditorialNew-UltraboldItalic", size: 48))
                        .foregroundColor(.darkGreen)
                    Text("Calories left")
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
                    .stroke(Color.matchaGreen, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .frame(width: 90, height: 90)
                Text("\(Int(progress * 100))%")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.darkGreen)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, minHeight: 140)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.veryLightGreen)
        )
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
    
    var body: some View {
        HStack(spacing: 12) {
            MacroCard(value: carbs, goal: carbsGoal, label: "Carbs")
            MacroCard(value: protein, goal: proteinGoal, label: "Protein")
            MacroCard(value: fat, goal: fatGoal, label: "Fat")
        }
        .padding(.horizontal, 4)
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

struct MacroCard: View {
    let value: Double
    let goal: Double
    let label: String
    
    var progress: Double { goal > 0 ? min(value / goal, 1.0) : 0 }
    
    var body: some View {
        VStack(spacing: 10) {
            ZStack {
                Circle()
                    .stroke(Color(.systemGray5), lineWidth: 8)
                Circle()
                    .trim(from: 0, to: CGFloat(progress))
                    .stroke(Color.matchaGreen, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                VStack(spacing: 2) {
                    Text("\(Int(value))")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.darkGreen)
                    Text("/\(Int(goal))g")
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
    
    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 18))
                .foregroundColor(.matchaGreen)
                .frame(width: 32)
            Text(title)
                .font(.system(size: 16, weight: .medium))
            Spacer()
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 8)
        .overlay(RoundedRectangle(cornerRadius: 8)
            .stroke(Color.gray.opacity(0.30), lineWidth: 1))
    }
}

#Preview {
    MainTabView()
}
