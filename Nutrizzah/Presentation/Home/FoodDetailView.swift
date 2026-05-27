import SwiftUI

struct FoodDetailView: View {
    let initialFood: FoodLogWithCalories

    @Environment(\.dismiss) private var dismiss
    @State private var food: FoodLogWithCalories
    @State private var selectedPortion: String
    @State private var isSaving = false
    @State private var isDeleting = false
    @State private var showDeleteConfirm = false

    private let portions = ["Small", "Medium", "Large"]
    private let foodLogService = FoodLogRemoteDataSource()

    init(food: FoodLogWithCalories) {
        self.initialFood = food
        self._food = State(initialValue: food)
        self._selectedPortion = State(initialValue: food.portion)
    }

    var hasChanges: Bool { selectedPortion != food.portion }

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Image area
                    ZStack(alignment: .bottom) {
                        Group {
                            if let urlString = food.imageUrl, let url = URL(string: urlString) {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(maxWidth: .infinity, maxHeight: 280)
                                            .clipped()
                                    case .failure:
                                        LinearGradient(
                                            colors: [Color(.systemGray3), Color(.systemGray5)],
                                            startPoint: .topLeading, endPoint: .bottomTrailing
                                        )
                                        .frame(maxWidth: .infinity, maxHeight: 280)
                                    default:
                                        ZStack {
                                            Color(.systemGray5)
                                            ProgressView().tint(.white).scaleEffect(1.5)
                                        }
                                        .frame(maxWidth: .infinity, maxHeight: 280)
                                    }
                                }
                            } else {
                                ZStack {
                                    LinearGradient(
                                        colors: [Color(.systemGray3), Color(.systemGray5)],
                                        startPoint: .topLeading, endPoint: .bottomTrailing
                                    )
                                    ProgressView().tint(.white).scaleEffect(1.5)
                                }
                                .frame(maxWidth: .infinity, maxHeight: 280)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: 280)
                        .clipped()

                        LinearGradient(
                            colors: [.clear, .black.opacity(0.65)],
                            startPoint: .top, endPoint: .bottom
                        )
                        .frame(height: 280)

                        // Back button
                        VStack {
                            HStack {
                                Button { dismiss() } label: {
                                    Image(systemName: "chevron.left")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                        .frame(width: 36, height: 36)
                                        .background(Circle().fill(.black.opacity(0.35)))
                                }
                                Spacer()
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 56)
                            Spacer()
                        }
                        .frame(height: 280)

                        Text(food.foodName)
                            .font(.custom("PPEditorialNew-Ultrabold", size: 28))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                    }

                    // Content card
                    VStack(alignment: .leading, spacing: 24) {
                        // Portion + calories row
                        HStack(spacing: 10) {
                            Text("1 porsi")
                                .font(.system(size: 15, weight: .medium))
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Capsule().fill(Color(.systemGray6)))

                            Menu {
                                ForEach(portions, id: \.self) { p in
                                    Button(p) { selectedPortion = p }
                                }
                            } label: {
                                HStack(spacing: 4) {
                                    Text(selectedPortion)
                                        .font(.system(size: 15, weight: .medium))
                                    Image(systemName: "chevron.down")
                                        .font(.system(size: 11, weight: .medium))
                                }
                                .foregroundColor(.primary)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Capsule().fill(Color(.systemGray6)))
                            }

                            Spacer()

                            if isSaving {
                                ProgressView()
                            } else if hasChanges {
                                Button("Save") {
                                    Task { await savePortion() }
                                }
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(Capsule().fill(Color.matchaGreen))
                            } else {
                                Text("\(Int(food.calories.rounded())) cal")
                                    .font(.system(size: 17, weight: .bold))
                            }
                        }

                        // Nutritional facts
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Nutritional facts")
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.secondary)
                                .padding(.bottom, 12)

                            NutritionRow(label: "Carbs",   value: food.carbs,   unit: "g")
                            NutritionRow(label: "Protein", value: food.protein, unit: "g")
                            NutritionRow(label: "Fat",     value: food.fat,     unit: "g")
                            NutritionRow(label: "Vitamin", value: food.vitamin, unit: "mg")
                            NutritionRow(label: "Mineral", value: food.mineral, unit: "mg")
                        }
                    }
                    .padding(24)
                    .background(Color(.systemBackground))
                    .clipShape(UnevenRoundedRectangle(topLeadingRadius: 24, topTrailingRadius: 24))
                    .offset(y: -20)

                    Spacer().frame(height: 80)
                }
            }
            .ignoresSafeArea(edges: .top)

            // Delete button
            HStack {
                Button {
                    showDeleteConfirm = true
                } label: {
                    if isDeleting {
                        ProgressView().tint(.white)
                    } else {
                        Image(systemName: "trash")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.white)
                    }
                }
                .frame(width: 52, height: 52)
                .background(Circle().fill(Color(red: 0.75, green: 0.3, blue: 0.3)))
                .padding(.leading, 24)
                .padding(.bottom, 32)

                Spacer()
            }
        }
        .navigationBarHidden(true)
        .alert("Delete Food", isPresented: $showDeleteConfirm) {
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                Task { await deleteFood() }
            }
        } message: {
            Text("Are you sure want to delete this food?")
        }
        .onAppear {
            Task { await refreshFood() }
            Task {
                try? await Task.sleep(nanoseconds: 4_000_000_000)
                if food.imageUrl == nil { await refreshFood() }
            }
        }
    }

    private func refreshFood() async {
        guard let updated = try? await foodLogService.fetchFoodLog(id: food.id) else { return }
        food = updated
        selectedPortion = updated.portion
    }

    private func savePortion() async {
        isSaving = true
        do {
            let response = try await foodLogService.updateFoodLog(id: food.id, portion: selectedPortion)
            food = FoodLogWithCalories(
                id: response.foodLog.id,
                foodName: response.foodLog.foodName,
                portion: response.foodLog.portion,
                meal: response.foodLog.meal,
                date: response.foodLog.date,
                calories: response.nutrition.calories,
                carbs: response.nutrition.carbs,
                protein: response.nutrition.protein,
                fat: response.nutrition.fat,
                vitamin: response.nutrition.vitamin,
                mineral: response.nutrition.mineral,
                imageUrl: response.nutrition.imageUrl
            )
        } catch {
            print("FoodDetailView save error: \(error)")
        }
        isSaving = false
    }

    private func deleteFood() async {
        isDeleting = true
        do {
            try await foodLogService.deleteFoodLog(id: food.id)
            dismiss()
        } catch {
            print("FoodDetailView delete error: \(error)")
            isDeleting = false
        }
    }
}

struct NutritionRow: View {
    let label: String
    let value: Double
    let unit: String

    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 15))
                .foregroundColor(.primary)
            Spacer()
            Text("\(Int(value.rounded())) \(unit)")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 12)
        Divider()
    }
}
