//
//  SetupViewModel.swift
//  Nutrizzah
//
//  Created by Ryandra Anditto on 25/05/26.
//

import SwiftUI
import Combine

@MainActor
class SetupViewModel: ObservableObject {
    @Published var step = 0
    @Published var name = ""
    @Published var gender = ""
    @Published var age = ""
    @Published var height = ""
    @Published var weight = ""

    @Published var isLoading = false
    @Published var errorMessage: String?

    private let userService = UserRemoteDataSource()
    @AppStorage("userId") private var userId = 0
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false

    func nextStep() {
        if step < 6 { step += 1 }
    }

    func prevStep() {
        if step > 0 { step -= 1 }
    }

    func createUser() async {
        isLoading = true
        errorMessage = nil
        do {
            let request = CreateUserRequest(
                name: name,
                gender: gender.lowercased(),
                age: Int(age) ?? 0,
                height: Int(height) ?? 0,
                weight: Int(weight) ?? 0
            )
            let user = try await userService.createUser(request)
            userId = user.id
            hasSeenOnboarding = true
        } catch {
            errorMessage = "Failed to save profile. Please try again.\n\(error.localizedDescription)"
        }
        isLoading = false
    }
}

