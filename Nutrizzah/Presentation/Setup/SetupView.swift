//
//  SetupView.swift
//  Nutrizzah
//
//  Created by Ryandra Anditto on 20/05/26.
//

import SwiftUI

struct SetupView: View {
    @State private var step = 0
    @State private var name = ""
    @State private var gender = ""
    @State private var age = ""
    @State private var height = ""
    @State private var weight = ""
    
    var body: some View {
        VStack {
            HeaderView(currentStep: step, totalSteps: 6) { if step > 0 { step -= 1 } }
            
            Spacer()
            
            ZStack {
                switch step {
                case 0: IntroView()
                case 1: NameEntryView(name: $name)
                case 2: GenderSelectionView(selectedGender: $gender)
                case 3: MeasurementView(title: "How old are you?", value: $age)
                case 4: MeasurementView(title: "What is your height?", value: $height, unit: "cm")
                case 5: MeasurementView(title: "What is your weight?", value: $weight, unit: "kg")
                case 6: ProfilePictureView()
                default: EmptyView()
                }
            }
            .padding(.horizontal, 24)
            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            
            Spacer()
            
            Button(action: { withAnimation { if step < 6 { step += 1 } } }) {
                Text(step == 0 ? "Get started" : "Next")
                    .font(.headline).foregroundColor(.white)
                    .frame(maxWidth: .infinity).padding(.vertical, 16)
                    .background(SetupTheme.primaryGreen)
                    .clipShape(Capsule())
            }
            .padding(.horizontal, 24).padding(.bottom, 20)
            .shadow(color: .black.opacity(0.1), radius: 2, x: 4, y: 4)
        }
        .background(LinearGradient(
            colors: [Color.white, SetupTheme.bgColor],
            startPoint: .top,
            endPoint: .bottom
        ))
    }
}

#Preview {
    SetupView()
}
