import Foundation

struct FoodLog: Codable, Identifiable {
    let id: Int
    let userId: Int
    let foodName: String
    let portion: String
    let meal: String
    let date: String
}

struct NutritionLog: Codable, Identifiable {
    let id: Int
    let foodLogId: Int
    let calories: Double
    let carbs: Double
    let protein: Double
    let fat: Double
    let vitamin: Double
    let mineral: Double
    let imageUrl: String?
}

struct CreateFoodLogResponse: Codable {
    let foodLog: FoodLog
    let nutrition: NutritionLog
}

struct CalorieHistory: Codable {
    let date: String
    let calories: Double
}

struct FoodLogWithCalories: Codable, Identifiable {
    let id: Int
    let foodName: String
    let portion: String
    let meal: String
    let date: String
    let calories: Double
    let carbs: Double
    let protein: Double
    let fat: Double
    let vitamin: Double
    let mineral: Double
    let imageUrl: String?
}

struct CreateFoodLogRequest: Codable {
    let userId: Int
    let foodName: String
    let portion: String
    let meal: String
    let date: String
}
