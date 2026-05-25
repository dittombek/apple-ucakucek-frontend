//
//  GenderSelectedView.swift
//  Nutrizzah
//
//  Created by Muhammad Maulana Husein on 22/05/26.
//

import SwiftUI

struct GenderSelectionView: View {
    @Binding var selectedGender: String
    
    var body: some View {
        VStack(spacing: 16) {
            Text("What is your gender?")
                .font(.title)
                .fontDesign(.serif)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.top, 30)
            
            HStack(spacing: 16) {
                GenderButton(title: "Male",icon: "manIcon", isSelected: selectedGender == "Male") { selectedGender = "Male" }
                GenderButton(title: "Female", icon: "womanIcon", isSelected: selectedGender == "Female") { selectedGender = "Female" }
            }
            .padding(.horizontal, 32)
            
            Spacer()
        }
    }
}

struct GenderButton: View {
    let title: String;
    let icon: String;
    let isSelected: Bool;
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack {
                Image(icon)
                    .renderingMode(.template)
                Text(title)
            }
            .font(.headline)
            .foregroundColor(isSelected ? .white : .gray)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(isSelected ? Color(.nightSnow500) : .white)
            .cornerRadius(20)
        }
    }
}

#Preview {
    ZStack {
        LinearGradient(
            colors: [Color.white, Color.potOfCream400],
            startPoint: .top,
            endPoint: .bottom
        ).ignoresSafeArea()
        
     GenderSelectionView(selectedGender: .constant("Male")) }
}
