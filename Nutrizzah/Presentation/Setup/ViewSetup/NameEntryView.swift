//
//  NameEntryView.swift
//  Nutrizzah
//
//  Created by Muhammad Maulana Husein on 21/05/26.
//

import SwiftUI

struct NameEntryView: View {
    
    @Binding var name: String
    @ScaledMetric var customPadding: CGFloat = 16
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Haloow, \nWhat’s your name?")
                .font(.title)
                .fontDesign(.monospaced)
                .multilineTextAlignment(.center)
                .padding(.top, 30)
                .fontWeight(.bold)
            
            Text("Let’s get to know each other")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .fontWeight(.light)
                
            
            TextField("Your name?", text: $name)
                .font(.body)    
                .padding(customPadding)
                .background(Color(.systemGray6))
                .cornerRadius(20)
                .autocorrectionDisabled(true)
                .shadow(color: .black.opacity(0.1), radius: 2, x: 4, y: 4)
            
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    ZStack {
        LinearGradient(
            colors: [Color.white, Color.potOfCream400],
            startPoint: .top,
            endPoint: .bottom
        ).ignoresSafeArea()
        
        NameEntryView(name: .constant(""))
    }
}
