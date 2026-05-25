//
//  ContentView.swift
//  Nutrizzah
//
//  Created by Ryandra Anditto on 20/05/26.
//

import SwiftUI

struct ContentView: View {
    @AppStorage("isSetupDone") private var isSetupDone = false

    var body: some View {
        if isSetupDone {
            MainTabView()
        } else {
            SetupView(isSetupDone: $isSetupDone)
        }
    }
}

#Preview {
    ContentView()
}
