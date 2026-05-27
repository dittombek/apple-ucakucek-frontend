import Foundation

struct FoodLogRemoteDataSource {
    private let baseURL = AppConfig.baseURL

    func createFoodLog(_ request: CreateFoodLogRequest) async throws -> CreateFoodLogResponse {
        let url = URL(string: "\(baseURL)/food-logs")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(request)
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        return try JSONDecoder().decode(CreateFoodLogResponse.self, from: data)
    }

    func fetchFoodLogs(userId: Int, date: String) async throws -> [FoodLogWithCalories] {
        let url = URL(string: "\(baseURL)/food-logs/user/\(userId)?date=\(date)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([FoodLogWithCalories].self, from: data)
    }

    func fetchFoodLog(id: Int) async throws -> FoodLogWithCalories {
        let url = URL(string: "\(baseURL)/food-logs/\(id)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(FoodLogWithCalories.self, from: data)
    }

    func updateFoodLog(id: Int, portion: String) async throws -> CreateFoodLogResponse {
        let url = URL(string: "\(baseURL)/food-logs/\(id)")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "PATCH"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(["portion": portion])
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        return try JSONDecoder().decode(CreateFoodLogResponse.self, from: data)
    }

    func deleteFoodLog(id: Int) async throws {
        let url = URL(string: "\(baseURL)/food-logs/\(id)")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "DELETE"
        _ = try await URLSession.shared.data(for: urlRequest)
    }

    func fetchCalorieHistory(userId: Int, days: Int) async throws -> [CalorieHistory] {
        let url = URL(string: "\(baseURL)/food-logs/user/\(userId)/calorie-history?days=\(days)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([CalorieHistory].self, from: data)
    }

    func fetchDailyTotal(userId: Int, date: String) async throws -> DailyTotal {
        let url = URL(string: "\(baseURL)/food-logs/user/\(userId)/daily-total?date=\(date)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(DailyTotal.self, from: data)
    }
}
