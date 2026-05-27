import SwiftUI

struct MealDetailView: View {
    let meal: String
    let icon: String
    let date: Date

    @Environment(\.dismiss) private var dismiss
    @AppStorage("userId") private var userId = 0
    @State private var foods: [FoodLogWithCalories] = []

    private let foodLogService = FoodLogRemoteDataSource()
    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()

    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.veryLightGreen)
                        .frame(width: 44, height: 44)
                    Image(systemName: icon)
                        .font(.system(size: 18))
                        .foregroundColor(.matchaGreen)
                }
                Text(meal)
                    .font(.system(size: 20, weight: .semibold))
                Spacer()
                Button("Done") { dismiss() }
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Capsule().fill(Color.matchaGreen))
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)

            // Food list
            if foods.isEmpty {
                Spacer()
                ContentUnavailableView(
                    "No food logged",
                    systemImage: "fork.knife",
                    description: Text("Tap \"Add another food\" to log your \(meal.lowercased()).")
                )
                Spacer()
            } else {
                List {
                    ForEach(foods) { food in
                        NavigationLink {
                            FoodDetailView(food: food)
                        } label: {
                            HStack(spacing: 12) {
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(food.foodName)
                                        .font(.system(size: 16, weight: .semibold))
                                    Text(food.portion)
                                        .font(.system(size: 13))
                                        .foregroundColor(.secondary)
                                }
                                Spacer()
                                Text("\(Int(food.calories.rounded())) cal")
                                    .font(.system(size: 14))
                                    .foregroundColor(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
                .listStyle(.plain)
            }

            // Add another food
            NavigationLink {
                AddView(initialMeal: meal)
            } label: {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                        .font(.system(size: 15, weight: .semibold))
                    Text("Add another food")
                        .font(.system(size: 16, weight: .semibold))
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(Capsule().fill(Color.matchaGreen))
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationBarHidden(true)
        .onAppear { Task { await loadFoods() } }
    }

    private func loadFoods() async {
        do {
            let all = try await foodLogService.fetchFoodLogs(userId: userId, date: dateFormatter.string(from: date))
            foods = all.filter { $0.meal == meal }
        } catch {
            print("MealDetailView load error: \(error)")
        }
    }
}
