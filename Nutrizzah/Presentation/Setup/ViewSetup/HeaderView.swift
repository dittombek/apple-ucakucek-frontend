//
//  HeaderView.swift
//  Nutrizzah
//
//  Created by Muhammad Maulana Husein on 22/05/26.
//

import SwiftUI

struct HeaderView: View {
    let currentStep: Int
    let totalSteps: Int
    var onBack: () -> Void
    var body: some View {
        HStack {
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .frame(width: 44, height: 44)
                    .foregroundColor(currentStep == 0 ? .clear : .gray)
                    .background(Color.gray.opacity(currentStep == 0 ? 0 : 0.2))
                    .shadow(color: .black.opacity(0.1), radius: 2, x: 4, y: 4)
                    .clipShape(Circle())
            }
            .opacity(currentStep == 0 ? 0 : 1)
            
            Spacer()
            if currentStep > 0 {
                HStack(spacing: 6) {
                    ForEach(1...totalSteps, id: \.self) { i in
                        RoundedRectangle(cornerRadius: 2)
                            .fill(i <= currentStep ? SetupTheme.primaryGreen : Color.gray.opacity(0.2))
                            .frame(width: 25, height: 4)
                    }
                }
            }
            Spacer()
            Color.clear.frame(width: 44, height: 44)
        }.padding(.horizontal)
    }
}
