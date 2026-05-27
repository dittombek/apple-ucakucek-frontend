//
//  SetupView.swift
//  Nutrizzah
//
//  Created by Ryandra Anditto on 20/05/26.
//

import SwiftUI

struct SetupView: View {
    @StateObject private var viewModel = SetupViewModel()
    @State private var showRevealTarget = false // State pemicu
    
    private var isNextButtonDisabled: Bool {
            if viewModel.isLoading { return true } // Disable saat loading
            
            switch viewModel.step {
            case 1:
                return viewModel.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            case 2:
                return viewModel.gender.isEmpty
            case 3:
                return viewModel.age.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            case 4:
                return viewModel.height.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            case 5:
                return viewModel.weight.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            default:
                return false // Step 0 (Intro) dan Step 6 (Photo) selalu valid dan bisa di-next
            }
        }
    
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
                        await viewModel.createUser()
                        // 👇 Cek apakah ID dan Target berhasil didapatkan
                        if viewModel.newlyCreatedUserId != nil && viewModel.target != nil {
                            showRevealTarget = true
                        }
                    }
                } else {
                    withAnimation { viewModel.nextStep() }
                }
            }) {
                Group {
                    if viewModel.isLoading {
                        ProgressView().tint(.white)
                    } else {
                        Text(viewModel.step == 0 ? "Get started" : viewModel.step == 6 ? "Finish" : "Next")
                            .font(.headline).foregroundColor(.white)
                    }
                }
                .frame(maxWidth: .infinity).padding(.vertical, 16)
                .background(isNextButtonDisabled ? Color.gray.opacity(0.5) : Color.machaMecha400)
                .clipShape(Capsule())
            }
            .disabled(isNextButtonDisabled)
            .padding(.horizontal, 24).padding(.bottom, 20)
            .shadow(color: .black.opacity(0.1), radius: 2, x: 4, y: 4)
            .alert("Error", isPresented: Binding(
                get: { viewModel.errorMessage != nil },
                set: { if !$0 { viewModel.errorMessage = nil } }
            )) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage ?? "")
            }
        }
        .background(LinearGradient(
            colors: [Color.white, Color.potOfCream400],
            startPoint: .top,
            endPoint: .bottom
        ))
        .fullScreenCover(isPresented: $showRevealTarget) {
            if let target = viewModel.target, let newId = viewModel.newlyCreatedUserId {
                
                let nutritionData = NutritionTarget(
                    calories: Int(target.calories),
                    carbs: Int(target.carbs),
                    protein: Int(target.protein),
                    fat: Int(target.fat),
                    vitamin: target.vitamin,
                    mineral: target.mineral
                )
                
                // Oper data nutrisi DAN userId barunya
                RevealTargetView(targetData: nutritionData, newUserId: newId)
            }
        }
    }
}

#Preview {
    SetupView()
}
