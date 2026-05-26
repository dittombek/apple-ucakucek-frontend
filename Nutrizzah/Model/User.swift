//
//  User.swift
//  Nutrizzah
//
//  Created by Ryandra Anditto on 25/05/26.
//

import Foundation

struct User: Codable, Identifiable {
    let id: Int
    let name: String
    let gender: String
    let age: Int
    let height: Double
    let weight: Double
}

struct CreateUserRequest: Codable {
    let name: String
    let gender: String
    let age: Int
    let height: Int
    let weight: Int
}
