//
//  MeasurementView.swift
//  Nutrizzah
//
//  Created by Muhammad Maulana Husein on 22/05/26.
//

import SwiftUI

struct MeasurementView: View {
    let title: String
    @Binding var value: String
    var unit: String? = nil
    
    var body: some View {
        VStack(spacing: 16) {
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                .fontDesign(.monospaced)
                .multilineTextAlignment(.center)
                .padding(.top, 30)
            
            HStack {
                TextField("0", text: $value)
                    .keyboardType(.numberPad)
                
                if let unit = unit {
                    Text(unit)
                        .font(.footnote).bold()
                        .padding(.horizontal, 8).padding(.vertical, 4)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(20)
            .padding(.top, 20)
            .shadow(color: .black.opacity(0.1), radius: 2, x: 4, y: 4)
            
            Spacer()
        }
        .padding(.horizontal, 16)
    }
}

#Preview("Age") {
    ZStack {
        LinearGradient(
            colors: [Color.white, Color.potOfCream400],
            startPoint: .top,
            endPoint: .bottom
        ).ignoresSafeArea()
        
        MeasurementView(title: "How old are you?", value: .constant("")) }
}
