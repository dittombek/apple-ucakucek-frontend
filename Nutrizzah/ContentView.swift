//
//  ContentView.swift
//  Nutrizzah
//
//  Created by Ryandra Anditto on 20/05/26.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("userId") private var userId = 0

    var body: some View {
        if userId > 0 {
            MainTabView()
        } else {
            SetupView()
        }
    }
}

#Preview {
    ContentView()
}
