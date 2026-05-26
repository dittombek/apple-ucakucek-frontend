//
//  SetupView.swift
//  Nutrizzah
//
//  Created by Ryandra Anditto on 20/05/26.
//

import SwiftUI

struct SetupView: View {
    @StateObject private var viewModel = SetupViewModel()
    
    var body: some View {
        VStack {
            HeaderView(currentStep: viewModel.step, totalSteps: 6) { viewModel.prevStep() }
            
            Spacer()
            
            ZStack {
                switch viewModel.step {
                case 0: IntroView()
                case 1: NameEntryView(name: $viewModel.name)
                case 2: GenderSelectionView(selectedGender: $viewModel.gender)
                case 3: MeasurementView(title: "How old are you?", value: $viewModel.age)
                case 4: MeasurementView(title: "What is your height?", value: $viewModel.height, unit: "cm")
                case 5: MeasurementView(title: "What is your weight?", value: $viewModel.weight, unit: "kg")
                case 6: ProfilePictureView()
                default: EmptyView()
                }
            }
            .padding(.horizontal, 24)
            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
            
            Spacer()
            
            Button(action: {
                if viewModel.step == 6 {
                    Task {
                        do {
                            try await viewModel.createUser()
                        } catch {
                            print("Failed to create user: \(error)")
                        }
                    }
                } else {
                    withAnimation { viewModel.nextStep() }
                }
            }) {
                Text(viewModel.step == 0 ? "Get started" : viewModel.step == 6 ? "Finish" : "Next")
                    .font(.headline).foregroundColor(.white)
                    .frame(maxWidth: .infinity).padding(.vertical, 16)
                    .background(Color.machaMecha400)
                    .clipShape(Capsule())
            }
            .padding(.horizontal, 24).padding(.bottom, 20)
            .shadow(color: .black.opacity(0.1), radius: 2, x: 4, y: 4)
        }
        .background(LinearGradient(
            colors: [Color.white, Color.potOfCream400],
            startPoint: .top,
            endPoint: .bottom
        ))
    }
}

#Preview {
    SetupView()
}
