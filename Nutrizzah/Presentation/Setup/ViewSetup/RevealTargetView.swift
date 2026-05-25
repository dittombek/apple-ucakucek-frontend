//
//  RevealTargetView.swift
//  Nutrizzah
//
//  Created by Muhammad Maulana Husein on 23/05/26.
//

import SwiftUI

// MARK: - Dummy Data Models
struct UserProfile {
    var name: String
    var gender: String
    var age: Int
    var height: Double
    var weight: Double
}

struct NutritionTarget {
    var calories: Int
    var carbs: Int
    var protein: Int
    var fat: Int
    var vitamin: Double
    var mineral: Double
}

// MARK: - Main View
struct RevealTargetView: View {
    let dummyData = NutritionTarget(calories: 1680, carbs: 216, protein: 87, fat: 58, vitamin: 131.7, mineral: 7932)
    
    // State Animasi Kartu
    @State private var isFlipped = false
    @State private var flipDegrees = 0.0
    @State private var cardScale = 1.0
    @State private var cardOffset: CGFloat = 0.0
    
    // State Efek
    @State private var showAura = false
    @State private var flashOpacity = 0.0
    @State private var cardGlow = 0.0
    
    // 👇 STATE BARU KHUSUS UNTUK TOMBOL
    @State private var showDoneButton = false
    
    let darkBgGreen = Color(red: 0.55, green: 0.65, blue: 0.45)
    let darkButtonGreen = Color(red: 0.20, green: 0.30, blue: 0.15)
    
    var body: some View {
        ZStack {
            // Background & Aura (mengikuti custom background-mu di screenshot)
            darkBgGreen.ignoresSafeArea()
            
            VStack {
                Spacer()
                
                // KARTU
                ZStack {
                    if flipDegrees < 90 {
                        CongratsCardFace()
                    } else {
                        DailyTargetCardFace(data: dummyData)
                            .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                    }
                }
                .frame(width: 320, height: 480)
                .background(Color(red: 0.95, green: 0.94, blue: 0.90))
                .cornerRadius(24)
                .shadow(color: Color.white.opacity(cardGlow), radius: 50, x: 0, y: 0)
                .shadow(color: .black.opacity(0.2), radius: 15, x: 0, y: 10)
                
                .offset(x: cardOffset)
                .scaleEffect(cardScale)
                .rotation3DEffect(
                    .degrees(flipDegrees),
                    axis: (x: 0, y: 1, z: 0),
                    perspective: 0.3
                )
                .onTapGesture {
                    if !isFlipped { executeLegendaryAnimation() }
                }
                
                Spacer()
                
                // 👇 GUNAKAN STATE BARU DI SINI
                if showDoneButton {
                    Button(action: { print("Done di-tap") }) {
                        Text("Done")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(darkButtonGreen)
                            .clipShape(Capsule())
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 30)
                    // Animasi muncul dari bawah perlahan
                    .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
            
            // Flash Putih
            Color.white
                .ignoresSafeArea()
                .opacity(flashOpacity)
                .allowsHitTesting(false)
        }
    }
    
    // MARK: - Logic Animasi
    private func executeLegendaryAnimation() {
        isFlipped = true
        
        // Fase 1: Getar
        withAnimation(.easeIn(duration: 0.5)) {
            showAura = true
            cardGlow = 0.4
            cardScale = 0.85
        }
        withAnimation(.linear(duration: 0.05).repeatCount(10, autoreverses: true)) {
            cardOffset = 10
        }
        
        // Fase 2: Meledak
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            cardOffset = 0
            withAnimation(.easeOut(duration: 0.3)) {
                cardScale = 1.4
                flipDegrees = 90
            }
            withAnimation(.easeIn(duration: 0.15).delay(0.15)) {
                flashOpacity = 1.0
            }
        }
        
        // Fase 3: Bantingan
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation(.easeOut(duration: 0.5)) {
                flashOpacity = 0.0
            }
            withAnimation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0)) {
                cardScale = 1.0
                flipDegrees = 180
                cardGlow = 0.8
            }
            
            // 👇 FASE 4: MUNCULKAN TOMBOL DONE (Delay sedikit setelah kartu mendarat)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                    showDoneButton = true
                }
            }
        }
    }
}

// MARK: - Komponen Sisi Depan
struct CongratsCardFace: View {
    var body: some View {
        VStack(spacing: 60) {
            VStack {
                Text("Congratulations!")
                    .font(.system(size: 28, weight: .bold, design: .serif))
                    .padding(.top, 40)
                
                Text("Tap to reveal your target!") // Dibuat lebih mengajak
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.60, green: 0.68, blue: 0.48))
            }
            
            // Mascot
            ZStack {
                Circle().fill(Color.pink.opacity(0.2)).frame(width: 140)
                Text("🍠").font(.system(size: 80))
            }
            
            Button(action: { print("Done di-tap") }) {
                Text("Done")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.matchaMecha700)
                    .clipShape(Capsule())
            }
            .padding(.horizontal, 24)
            Spacer()
        }
    }
}

// MARK: - Komponen Sisi Belakang
struct DailyTargetCardFace: View {
    let data: NutritionTarget
    let primaryGreen = Color(red: 0.60, green: 0.68, blue: 0.48)
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Your daily target")
                .font(.system(size: 28, weight: .bold, design: .serif))
                .padding(.top, 30)
            
            ZStack {
                Circle().stroke(lineWidth: 8).opacity(0.3).foregroundColor(primaryGreen)
                Circle()
                    .trim(from: 0.0, to: 1.0)
                    .stroke(style: StrokeStyle(lineWidth: 8, lineCap: .round, lineJoin: .round))
                    .foregroundColor(primaryGreen)
                    .rotationEffect(Angle(degrees: 270.0))
                
                VStack {
                    Text("\(data.calories)")
                        .font(.system(size: 36, weight: .bold, design: .serif))
                    Text("Calories /day")
                        .font(.caption).foregroundColor(.gray)
                }
            }
            .frame(width: 120, height: 120)
            
            VStack(spacing: 12) {
                MacroRow(title: "Carbs", value: "\(data.carbs)g", color: .orange, width: 0.8)
                MacroRow(title: "Protein", value: "\(data.protein)g", color: .brown, width: 0.6)
                MacroRow(title: "Fat", value: "\(data.fat)g", color: .yellow, width: 0.4)
                MacroRow(title: "Vitamin", value: "\(data.vitamin)g", color: .pink, width: 0.5)
                MacroRow(title: "Mineral", value: "\(data.mineral)g", color: .blue, width: 0.3)
            }
            .padding(.horizontal, 24)
            
            Spacer()
        }
    }
}

struct MacroRow: View {
    let title: String; let value: String; let color: Color; let width: CGFloat
    var body: some View {
        HStack {
            Text(title).font(.footnote).frame(width: 50, alignment: .leading)
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Capsule().frame(height: 6).foregroundColor(color.opacity(0.2))
                    Capsule().frame(width: geometry.size.width * width, height: 6).foregroundColor(color)
                }
            }.frame(height: 6)
            Text(value).font(.footnote).bold().frame(width: 55, alignment: .trailing)
        }
    }
}

// MARK: - PREVIEW
#Preview {
    RevealTargetView()
}
