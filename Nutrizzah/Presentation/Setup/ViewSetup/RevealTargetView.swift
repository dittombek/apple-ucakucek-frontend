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
                .frame(width: 360, height: 440)
                .background(Color(red: 0.95, green: 0.94, blue: 0.90))
                .cornerRadius(16)
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
    @State private var showCircle1 = false
    @State private var showCircle2 = false
    @State private var showCircle3 = false
    
    var body: some View {
        VStack(spacing: 40) {
            VStack {
                Text("Congratulations!")
                    .font(.system(size: 28, weight: .bold, design: .serif))
                    .padding(.top, 40)
                
                Text("Tap to reveal your target!")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.60, green: 0.68, blue: 0.48))
            }
            
            // Mascot & Controlled Ripple Effect
            ZStack {
                // Lingkaran 3 (Luar)
                Circle().fill(Color.matchaMecha200.opacity(0.2))
                    .frame(height: 220)
                    // Ukuran awal 0.5 agar pergerakan membesarnya lebih smooth dan tidak terlalu jauh
                    .scaleEffect(showCircle3 ? 1.0 : 0.5)
                    .opacity(showCircle3 ? 1.0 : 0.0)
                
                // Lingkaran 2 (Tengah)
                Circle().fill(Color.matchaMecha300.opacity(0.2))
                    .frame(height: 180)
                    .scaleEffect(showCircle2 ? 1.0 : 0.5)
                    .opacity(showCircle2 ? 1.0 : 0.0)
                
                // Lingkaran 1 (Dalam)
                Circle().fill(Color.matchaMecha400.opacity(0.2))
                    .frame(height: 140)
                    .scaleEffect(showCircle1 ? 1.0 : 0.5)
                    .opacity(showCircle1 ? 1.0 : 0.0)
                    
                Image("iconOnTapCard")
            }
            .task {
                await runChoreography()
            }
            
            .padding(.horizontal, 24)
            Spacer()
        }
    }
    
    // MARK: - Logic Koreografi Smooth
    private func runChoreography() async {
        while !Task.isCancelled {
            
            // STEP 0: Reset perlahan (Smooth fade out) agar tidak kaku saat mengulang
            withAnimation(.easeInOut(duration: 0.8)) {
                showCircle1 = false
                showCircle2 = false
                showCircle3 = false
            }
            // Tunggu sampai benar-benar memudar dan mengecil
            try? await Task.sleep(nanoseconds: 800_000_000)
            
            // STEP 1: Munculkan Lingkaran 1 (Sangat halus dengan durasi 0.8 detik)
            withAnimation(.easeInOut(duration: 0.8)) {
                showCircle1 = true
            }
            // Biarkan mengembang setengah jalan (0.4 detik) sebelum memanggil yang kedua
            try? await Task.sleep(nanoseconds: 400_000_000)
            
            // STEP 2: Munculkan Lingkaran 2
            withAnimation(.easeInOut(duration: 0.8)) {
                showCircle2 = true
            }
            try? await Task.sleep(nanoseconds: 400_000_000)
            
            // STEP 3: Munculkan Lingkaran 3
            withAnimation(.easeInOut(duration: 0.8)) {
                showCircle3 = true
            }
            
            // STEP 4: Semuanya terbuka penuh, tahan posisi ini sejenak
            try? await Task.sleep(nanoseconds: 1_500_000_000) // Tahan 1.5 detik
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
            
            // 👇 BAGIAN YANG DIUBAH
            VStack(spacing: 14) {
                // Menambahkan judul bagian agar persis seperti gambar referensi
                Text("Nutritional facts")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom, 4)
                
                MacroRow(title: "Carbs", value: "\(data.carbs)g")
                MacroRow(title: "Protein", value: "\(data.protein)g")
                MacroRow(title: "Fat", value: "\(data.fat)g")
                
                // Karena data dummy vitamin/mineral bertipe Double, kita format agar tampil rapi
                MacroRow(title: "Vitamin", value: String(format: "%.1f g", data.vitamin))
                MacroRow(title: "Mineral", value: String(format: "%.0f g", data.mineral))
            }
            .padding(.horizontal, 28)
            
            Spacer()
        }
        // Background ditambahkan di sini agar tidak tembus pandang saat animasi flip
        .background(Color(red: 0.95, green: 0.94, blue: 0.90))
        .cornerRadius(16)
    }
}

// 👇 KOMPONEN MACROROW YANG BARU (Lebih Bersih dan Ringan)
struct MacroRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            // Garis tipis penghubung yang otomatis mengisi ruang kosong
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 1)
                .padding(.horizontal, 8)
            
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(Color.black.opacity(0.7))
        }
    }
}

// MARK: - PREVIEW
#Preview {
    RevealTargetView()
}
