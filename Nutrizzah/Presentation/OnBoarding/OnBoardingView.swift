
import SwiftUI

struct OnBoardingPage {
    let imageName: String
    let title: String
    let subtitle: String
    let isLast: Bool
}


struct OnBoardingView: View {
    
    @State private var currentPage = 0
    
    let pages: [OnBoardingPage] = [
        OnBoardingPage(
            imageName: "fork.knife.circle.fill",
            title: "Know what's actually\non your plate.",
            subtitle: "Log meals in seconds",
            isLast: false
        ),
        OnBoardingPage(
            imageName: "chart.pie.fill",
            title: "See the full picture.",
            subtitle: "Calories, macros, vitamins, minerals\neverything you eat, all in one view.",
            isLast: false
        ),
        OnBoardingPage(
            imageName: "trophy.fill",
            title: "Hit your goals,\nyour way.",
            subtitle: "We'll do the math. You just eat and log.\nEasy.",
            isLast: true
        )
    ]
    
    var body: some View {
        ZStack {
            // Background hijau seperti di design
            LinearGradient(
                colors: [
                    Color(red: 0.498, green: 0.557, blue: 0.341), // warna atas
                    Color(red: 0.773, green: 0.816, blue: 0.655)  // warna bawah
                ],
                startPoint: .bottom,
                endPoint: .top
            )
            .ignoresSafeArea()
            
            VStack {
                // Skip button
                // AFTER - dengan back button
                HStack {
                    // Tombol Back (muncul di slide 2 dan 3)
                    if currentPage > 0 {
                        Button(action: {
                            withAnimation {
                                currentPage -= 1
                            }
                        }) {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.black)
                                .frame(width: 44, height: 44)  // ← tambah ini sebelum glassEffect
                                .glassEffect(.regular.interactive(), in: Circle())  // ← kasih shape Circle
                                .padding(.horizontal, 10)
                                .padding(.bottom, 5)
                        }
                        .padding(.horizontal, 13)
                    } else {
                        // Spacer biar Skip tetap di kanan saat slide 1
                        Spacer().frame(width: 44)
                    }
                    
                    Spacer()
                    
                    // Tombol Skip (muncul di slide 1 dan 2, hilang di slide 3)
                    if currentPage < pages.count - 1 {
                        Button("Skip") {
                            withAnimation {
                                currentPage = pages.count - 1
                            }
                        }
                        .foregroundColor(.black)
                        .padding(12)
                        .glassEffect()                          // ✨ INI DOANG!
                        .padding(.horizontal, 10)
                        .padding(.bottom, 5)
                    }
                }
                .padding(.horizontal, 8)
                
                // Carousel utama
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnBoardingSlideView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                
                // Dot indicator custom
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        Capsule()
                            .fill(index == currentPage ? Color.white : Color.white.opacity(0.4))
                            .frame(width: index == currentPage ? 20 : 8, height: 8)
                            .animation(.spring(), value: currentPage)
                    }
                }
                .padding(.bottom, 16)
                
                // Tombol Next / Let's Go
                Button(action: {
                    if currentPage < pages.count - 1 {
                        withAnimation {
                            currentPage += 1
                        }
                    } else {
                        // Nanti kita sambung ke halaman berikutnya
                        print("Onboarding selesai!")
                    }
                }) {
                    Text(pages[currentPage].isLast ? "Let's go" : "Next")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(red: 0.2, green: 0.25, blue: 0.18))
                        .cornerRadius(116)
                    
                }
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
                .animation(.none, value: currentPage)
            }
        }
    }
}


struct OnBoardingSlideView: View {
    let page: OnBoardingPage
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // Ilustrasi (pakai SF Symbol dulu sebagai placeholder)
            Image(systemName: page.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 160, height: 160)
                .foregroundColor(.white.opacity(0.9))
                .padding(40)
                .background(Color.white.opacity(0.15))
                .clipShape(Circle())
            
            Spacer()
            
            // Teks
            VStack(spacing: 12) {
                Text(page.title)
                    .font(.system(size: 28, weight: .bold))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .shadow(color: .white.opacity(0.1), radius: 4, x: 0, y: 2)
                
                Text(page.subtitle)
                    .font(.system(size: 15))
                    .foregroundColor(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                    .lineSpacing(4)
            }
            .padding(.horizontal, 32)
            
            Spacer()
        }
    }
}


#Preview {
    OnBoardingView()
}
