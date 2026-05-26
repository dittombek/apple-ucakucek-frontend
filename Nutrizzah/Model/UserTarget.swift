import Foundation

struct UserTarget: Codable {
    let id: Int
    let userId: Int
    let calories: Double
    let carbs: Double
    let protein: Double
    let fat: Double
    let vitamin: Double
    let mineral: Double
}

struct DailyTotal: Codable {
    let calories: Double
    let carbs: Double
    let protein: Double
    let fat: Double
    let vitamin: Double
    let mineral: Double

    static let empty = DailyTotal(calories: 0, carbs: 0, protein: 0, fat: 0, vitamin: 0, mineral: 0)
}
