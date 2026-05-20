//
//  SetupView.swift
//  Nutrizzah
//
//  Created by Ryandra Anditto on 20/05/26.
//

import SwiftUI

struct SetupView: View {
    var body: some View {
        
        VStack {

            Spacer()

            // CONTENT
            VStack(spacing: 32) {

                VStack(spacing: 8) {

                    Text("Quick Setup")
                        .font(.system(size: 12))
                        .opacity(0.6)

                    Text("A few quick questions, then you're in.")
                        .font(.system(size: 34))
                        .multilineTextAlignment(.center)
                        .bold()

                    Text("We need a bit about you to nail your daily target. Takes 60 seconds, promise.")
                        .font(.system(size: 16))
                        .multilineTextAlignment(.center)
                        .opacity(0.6)
                }

                VStack(spacing: 16) {

                    HStack {

                        Image(systemName: "chart.pie")
                            .font(.system(size: 16, weight: .medium))
                            .frame(width: 32, height: 32)
                            .background(Color.lightGreen)
                            .cornerRadius(10)

                        Text("Personalized calorie target")
                            .font(.system(size: 13))


                        Spacer()
                    }
                    .padding(8)
                    .background(Color.veryLightGreen)
                    .cornerRadius(16)

                    
                    HStack {

                        Image(systemName: "tree")
                            .font(.system(size: 16, weight: .medium))
                            .frame(width: 32, height: 32)
                            .background(Color.lightGreen)
                            .cornerRadius(10)

                        Text("Nutrient goals")
                            .font(.system(size: 13))

                        Spacer()
                    }
                    .padding(8)
                    .background(Color.veryLightGreen)
                    .cornerRadius(16)

                    
                    HStack {

                        Image(systemName: "trophy")
                            .font(.system(size: 16, weight: .medium))
                            .frame(width: 32, height: 32)
                            .background(Color.lightGreen)
                            .cornerRadius(10)

                        Text("Tailored to your goals")
                            .font(.system(size: 13))

                        Spacer()
                    }
                    .padding(8)
                    .background(Color.veryLightGreen)
                    .cornerRadius(16)
                }
                .padding(.horizontal, 16)
            }
            .padding(.horizontal, 24)

            Spacer()

            // BUTTON
            Button {

            } label: {

                Text("Get started")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(Color.matchaGreen)
                    .cornerRadius(32)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                colors: [.gradien1, .gradien2],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
    }
}

#Preview {
    SetupView()
}
