//
//  MainTabView.swift
//  Nutrizzah
//
//  Created by Ryandra Anditto on 23/05/26.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    
    var body: some View {
        NavigationStack {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tag(0)
                    .toolbar(.hidden, for: .tabBar)
                ProfileView()
                    .tag(1)
                    .toolbar(.hidden, for: .tabBar)
            }
            .overlay(alignment: .bottom) {
                HStack(alignment: .center, spacing: 0) {
                    // Tab group — satu kapsul putih
                    HStack(spacing: 0) {
                        CustomTabItem(icon: "clipboard.fill", label: "Journal", tag: 0, selectedTab: $selectedTab)
                        CustomTabItem(icon: "person.fill", label: "Profile", tag: 1, selectedTab: $selectedTab)
                    }
                    .padding(4)
                    .background(
                        Capsule()
                            .fill(Color(.systemBackground))
                            .shadow(color: .black.opacity(0.10), radius: 8, x: 0, y: 2)
                    )
                    
                    Spacer()
                    
                    NavigationLink {
                        AddView()

                    } label : {
                        Image(systemName: "plus")
                            .font(.system(size: 22, weight: .semibold))
                            .foregroundColor(.white)
                            .frame(width: 52, height: 52)
                            .background(Circle().fill(Color.matchaGreen))
                            .shadow(color: .black.opacity(0.15), radius: 6, x: 0, y: 3)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

struct CustomTabItem: View {
    let icon: String
    let label: String
    let tag: Int
    @Binding var selectedTab: Int
    
    var isSelected: Bool { selectedTab == tag }
    
    var body: some View {
        Button {
            selectedTab = tag
        } label: {
            VStack(spacing: 3) {
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundColor(isSelected ? .white : Color(.systemGray2))
                Text(label)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(isSelected ? .white : Color(.systemGray2))
            }
            .frame(width: 76, height: 48)
            .background(
                Capsule()
                    .fill(isSelected ? Color.matchaGreen : Color.clear)
            )
        }
    }
}

#Preview {
    MainTabView()
}


