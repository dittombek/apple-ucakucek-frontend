import Foundation

struct FoodLogRemoteDataSource {
    private let baseURL = "http://localhost:3000"

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

    func fetchDailyTotal(userId: Int, date: String) async throws -> DailyTotal {
        let url = URL(string: "\(baseURL)/food-logs/user/\(userId)/daily-total?date=\(date)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(DailyTotal.self, from: data)
    }
}
