import Combine
import SwiftUI

@MainActor
class ProfileViewModel: ObservableObject {
    @AppStorage("userId") private var userId = 0

    @Published var user: User?
    @Published var calorieHistory: [CalorieHistory] = []

    private let userService = UserRemoteDataSource()
    private let foodLogService = FoodLogRemoteDataSource()

    func loadUser() async {
        guard userId > 0 else { return }
        do {
            user = try await userService.fetchUser(id: userId)
        } catch {
            print("ProfileViewModel loadUser error: \(error)")
        }
    }

    func loadHistory(days: Int) async {
        guard userId > 0 else { return }
        do {
            calorieHistory = try await foodLogService.fetchCalorieHistory(userId: userId, days: days)
        } catch {
            print("ProfileViewModel loadHistory error: \(error)")
        }
    }
}
