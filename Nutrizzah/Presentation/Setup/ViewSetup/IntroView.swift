//
//  IntroView.swift
//  Nutrizzah
//
//  Created by Muhammad Maulana Husein on 20/05/26.
//

import SwiftUI

struct IntroView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Quick Setup")
                .font(.subheadline)
                .foregroundColor(.gray)
            Text("A few quick questions, then you're in.")
                .font(.title)
                .fontWeight(.bold)
                .fontDesign(.monospaced)
                .multilineTextAlignment(.center)
            
            Text("We need a bit about you to nail your daily target. Takes 60 seconds, promise.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
            
            VStack(alignment: .leading, spacing: 20) {
                FeatureRow(icon: "target", text: "Personalized calorie target")
                FeatureRow(icon: "leaf", text: "Nutrient goals")
                FeatureRow(icon: "trophy", text: "Tailored to your goals")
            }
            .padding(.top, 20)
        }
        .padding(.horizontal, 20)
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .foregroundColor(SetupTheme.primaryGreen)
                .frame(width: 24, height: 24)
                .padding(5)
                .background(SetupTheme.featureBg)
                .cornerRadius(10)
            Text(text).font(.body)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: .white, location: 0.0),
                    .init(color: SetupTheme.rowBgFeature, location: 0.1)
                ]),
                startPoint: .trailing,
                endPoint: .leading
            )
        )
        .cornerRadius(10)
    }
}

#Preview {
    ZStack {
        LinearGradient(
            colors: [Color.white, SetupTheme.bgColor],
            startPoint: .top,
            endPoint: .bottom
        ).ignoresSafeArea()
        
        IntroView()
    }
}
