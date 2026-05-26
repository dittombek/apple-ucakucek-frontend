//
//  AddView.swift
//  Nutrizzah
//
//  Created by Ryandra Anditto on 24/05/26.
//

import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("userId") private var userId = 0
    @State private var foodName = ""
    @State private var selectedPortion = "Small"
    @State private var selectedMeal = "Lunch"
    @State private var showFoodList = false
    @State private var addedFoods: [FoodItem] = []
    @State private var isSaving = false
    @State private var saveError: String? = nil

    private let foodLogService = FoodLogRemoteDataSource()

    let portions = ["Small", "Medium", "Large"]
    let portionDescriptions = [
        "Small": "Sebesar telapak tanganmu",
        "Medium": "Sebesar dua telapak tanganmu",
        "Large": "Sebesar tiga telapak tanganmu"
    ]

    let meals: [(String, String)] = [
        ("Breakfast", "sunrise.fill"),
        ("Lunch", "sun.max.fill"),
        ("Dinner", "moon.fill"),
        ("Snack", "carrot.fill")
    ]
    let mealDescriptions = [
        "Breakfast": "Your morning fuel to start the day.",
        "Lunch": "Your midday refuel, typically between 11 AM and 3 PM.",
        "Dinner": "Your evening meal to wind down.",
        "Snack": "A light bite between meals."
    ]

    var isFoodNameEmpty: Bool { foodName.trimmingCharacters(in: .whitespaces).isEmpty }

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.black)
                }

                Spacer().frame(width: 18)

                HStack(spacing: 8) {
                    ZStack(alignment: .topTrailing) {
                        Button {
                            showFoodList = true
                        } label: {
                            Image(systemName: "fork.knife")
                                .frame(width: 48, height: 48)
                                .background(Circle().fill(.ultraThinMaterial))
                        }
                        .foregroundStyle(.black)

                        if !addedFoods.isEmpty {
                            Text("\(addedFoods.count)")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundStyle(.white)
                                .padding(6)
                                .background(Circle().fill(.red))
                                .offset(x: 6, y: -6)
                        }
                    }
                    Text("Add meal")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.black)
                }
                Spacer()
                Button {
                    guard !addedFoods.isEmpty else { dismiss(); return }
                    isSaving = true
                    Task {
                        do {
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "yyyy-MM-dd"
                            let today = dateFormatter.string(from: Date())
                            for food in addedFoods {
                                _ = try await foodLogService.createFoodLog(CreateFoodLogRequest(
                                    userId: userId,
                                    foodName: food.name,
                                    portion: food.portion,
                                    meal: food.meal,
                                    date: today
                                ))
                            }
                            dismiss()
                        } catch {
                            saveError = error.localizedDescription
                            isSaving = false
                        }
                    }
                } label: {
                    if isSaving {
                        ProgressView().tint(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Capsule().fill(Color.brown))
                    } else {
                        Text("Done")
                            .foregroundStyle(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Capsule().fill(Color.brown))
                    }
                }
                .disabled(isSaving || addedFoods.isEmpty)
                .alert("Failed to save", isPresented: .constant(saveError != nil)) {
                    Button("OK") { saveError = nil }
                } message: {
                    Text(saveError ?? "")
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            Spacer().frame(height: 28)

            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {

                        // Food name
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Food Name")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(.secondary)
                            TextField("", text: $foodName)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(
                                    RoundedRectangle(cornerRadius: 100)
                                        .fill(Color(.systemGray5))
                                )
                        }

                        // Portion
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Portion")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(.secondary)
                            HStack(spacing: 10) {
                                ForEach(portions, id: \.self) { portion in
                                    Button {
                                        selectedPortion = portion
                                    } label: {
                                        Text(portion)
                                            .font(.system(size: 15, weight: .medium))
                                            .foregroundStyle(selectedPortion == portion ? .white : .primary)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 10)
                                            .background(
                                                RoundedRectangle(cornerRadius: 100)
                                                    .fill(selectedPortion == portion ? Color.matchaGreen : Color(.systemGray5))
                                            )
                                    }
                                }
                            }
                            HStack(spacing: 4) {
                                Image(systemName: "info.circle")
                                    .font(.system(size: 12))
                                Text(portionDescriptions[selectedPortion] ?? "")
                                    .font(.system(size: 12))
                            }
                            .foregroundStyle(.secondary)
                        }

                        // Meal category
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Meal Category")
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(.secondary)
                            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                                ForEach(meals, id: \.0) { meal, icon in
                                    Button {
                                        selectedMeal = meal
                                    } label: {
                                        HStack(spacing: 6) {
                                            Image(systemName: icon)
                                            Text(meal)
                                                .font(.system(size: 15, weight: .medium))
                                        }
                                        .foregroundStyle(selectedMeal == meal ? .white : .primary)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 14)
                                        .background(
                                            RoundedRectangle(cornerRadius: 100)
                                                .fill(selectedMeal == meal ? Color.matchaGreen : Color(.systemGray5))
                                        )
                                    }
                                }
                            }
                            HStack(spacing: 4) {
                                Image(systemName: "info.circle")
                                    .font(.system(size: 12))
                                Text(mealDescriptions[selectedMeal] ?? "")
                                    .font(.system(size: 12))
                            }
                            .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 32)
                    .padding(.bottom, 16)
                }

                // Add food button
                Button {
                    let newFood = FoodItem(
                        name: foodName.trimmingCharacters(in: .whitespaces),
                        portion: selectedPortion,
                        meal: selectedMeal
                    )
                    addedFoods.append(newFood)
                    foodName = ""
                } label: {
                    HStack(spacing: 8) {
                        Image(systemName: "plus")
                            .font(.system(size: 16, weight: .semibold))
                        Text("Add food")
                            .font(.system(size: 16, weight: .semibold))
                    }
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 100)
                            .fill(isFoodNameEmpty ? Color.matchaGreen.opacity(0.4) : Color.matchaGreen)
                    )
                }
                .disabled(isFoodNameEmpty)
                .padding(.horizontal, 16)
                .padding(.vertical, 16)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(.secondarySystemGroupedBackground))
            .clipShape(UnevenRoundedRectangle(topLeadingRadius: 32, topTrailingRadius: 32))
            .ignoresSafeArea(edges: .bottom)
        }
        .background(Color.matchaGreen)
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $showFoodList) {
            FoodListView(foods: $addedFoods)
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
                .presentationBackground(.white)
        }
    }
}

struct FoodItem: Identifiable {
    let id = UUID()
    let name: String
    let portion: String
    let meal: String
}

struct FoodListView: View {
    @Binding var foods: [FoodItem]

    var body: some View {
        VStack(spacing: 0) {
            Text("Meal List")
                .font(.system(size: 17, weight: .semibold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)

            Divider()

            if foods.isEmpty {
                ContentUnavailableView(
                    "No food added yet",
                    systemImage: "fork.knife",
                    description: Text("Add food using the form below.")
                )
            } else {
                List {
                    ForEach(foods) { food in
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(food.name)
                                    .font(.system(size: 16, weight: .semibold))
                                Text("\(food.portion) · \(food.meal)")
                                    .font(.system(size: 14))
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Button {
                                foods.removeAll { $0.id == food.id }
                            } label: {
                                Image(systemName: "trash")
                                    .foregroundStyle(.red)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .listStyle(.plain)
            }
        }
    }
}

#Preview {
    AddView()
}
