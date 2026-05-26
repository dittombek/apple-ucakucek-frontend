//
//  NutrizzahApp.swift
//  Nutrizzah
//
//  Created by Ryandra Anditto on 20/05/26.
//

import SwiftUI

@main
struct NutrizzahApp: App {
    init() {
        UserDefaults.standard.removeObject(forKey: "userId")
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
