//
//  UserRemoteDataSource.swift
//  Nutrizzah
//
//  Created by Ryandra Anditto on 25/05/26.
//

import Foundation

struct UserRemoteDataSource {
    private let baseURL = "http://localhost:3000"

    func createUser(_ request: CreateUserRequest) async throws -> User {
        let url = URL(string: "\(baseURL)/users")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try JSONEncoder().encode(request)

        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        return try JSONDecoder().decode(User.self, from: data)
    }

    func fetchUsers() async throws -> [User] {
        let url = URL(string: "\(baseURL)/users")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([User].self, from: data)
    }

    func fetchUser(id: Int) async throws -> User {
        let url = URL(string: "\(baseURL)/users/\(id)")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(User.self, from: data)
    }

    func fetchUserTarget(userId: Int) async throws -> UserTarget {
        let url = URL(string: "\(baseURL)/users/\(userId)/target")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode(UserTarget.self, from: data)
    }
}

