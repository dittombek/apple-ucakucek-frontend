//
//  AddView.swift
//  Nutrizzah
//
//  Created by Ryandra Anditto on 24/05/26.
//

import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var foodName = ""
    @State private var selectedPortion = "Small"
    @State private var selectedMeal = "Lunch"
    @State private var showFoodList = false
    
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
                        
                        // Badge
                        Text("3")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(6)
                            .background(Circle().fill(.red))
                            .offset(x: 6, y: -6)
                    }
                    Text("Add meal")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(.black)
                }
                Spacer()
                Button {  } label: {
                    Text("Done")
                        .foregroundStyle(.white)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Capsule().fill(Color.brown))
                    
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
                    // Add food action
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
                    .background(RoundedRectangle(cornerRadius: 100).fill(Color.matchaGreen))
                }
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
            FoodListView()
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
    let calories: Int
}

struct FoodListView: View {
    let foods: [FoodItem] = [
        FoodItem(name: "Omelette", portion: "Medium", calories: 140),
        FoodItem(name: "Dimsum Mentai", portion: "Medium", calories: 101),
        FoodItem(name: "Nasi Padang", portion: "Large", calories: 650),
        FoodItem(name: "Foie Gras", portion: "Large", calories: 460),
        FoodItem(name: "Boba Thaitea", portion: "Large", calories: 400),
        FoodItem(name: "Americano", portion: "Large", calories: 0),
    ]

    var body: some View {
        NavigationStack {
            List(foods) { food in
                NavigationLink {
                    Text(food.name)
                } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(food.name)
                                .font(.system(size: 16, weight: .semibold))
                            Text(food.portion)
                                .font(.system(size: 14))
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text("\(food.calories) cal")
                            .font(.system(size: 15))
                            .foregroundStyle(.primary)
                    }
                }
            }
            .navigationTitle("Meal List")
            .navigationBarTitleDisplayMode(.inline)
            .listStyle(.plain)
        }
    }
}

#Preview {
    AddView()
}
