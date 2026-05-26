import Combine
import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
    @AppStorage("userId") private var userId = 0

    @Published var userName = ""
    @Published var target: UserTarget?
    @Published var dailyTotal: DailyTotal = .empty
    @Published var isLoading = false

    private let userService = UserRemoteDataSource()
    private let foodLogService = FoodLogRemoteDataSource()
    private let dateFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()

    var caloriesConsumed: Double { dailyTotal.calories }
    var caloriesGoal: Double { target?.calories ?? 2000 }
    var caloriesLeft: Double { max(caloriesGoal - caloriesConsumed, 0) }
    var caloriesProgress: Double { caloriesGoal > 0 ? min(caloriesConsumed / caloriesGoal, 1.0) : 0 }

    func load(for date: Date) async {
        isLoading = true
        defer { isLoading = false }
        do {
            async let userResult = userService.fetchUser(id: userId)
            async let targetResult = userService.fetchUserTarget(userId: userId)
            async let totalResult = foodLogService.fetchDailyTotal(userId: userId, date: dateFormatter.string(from: date))
            let (user, fetchedTarget, total) = try await (userResult, targetResult, totalResult)
            userName = user.name
            target = fetchedTarget
            dailyTotal = total
        } catch {
            print("HomeViewModel load error: \(error)")
        }
    }
}
