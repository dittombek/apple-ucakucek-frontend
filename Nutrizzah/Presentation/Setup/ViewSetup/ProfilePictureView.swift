//
//  ProfilePictureView.swift
//  Nutrizzah
//
//  Created by Muhammad Maulana Husein on 22/05/26.
//

import SwiftUI

struct ProfilePictureView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Profile picture")
                .font(.title)
                .fontDesign(.serif)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.top, 30)
            
            Text("Optional, you can change it later")
                .font(.footnote).foregroundColor(.gray)
            
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(Color.red.opacity(0.1))
                    .frame(width: 140, height: 140)
                    .overlay(Text("🍅").font(.system(size: 70)))
                
                Image(systemName: "camera.fill")
                    .padding(10)
                    .background(SetupTheme.primaryGreen)
                    .foregroundColor(.white)
                    .clipShape(Circle())
            }
            .padding(.top, 30)
            
            Spacer()
        }
    }
}

#Preview {
    ZStack {
        LinearGradient(
            colors: [Color.white, SetupTheme.bgColor],
            startPoint: .top,
            endPoint: .bottom
        ).ignoresSafeArea()
        
        ProfilePictureView()
    }
    
}
