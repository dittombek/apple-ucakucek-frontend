//
//  OnboardingView.swift
//  Nutrizzah
//
//  Created by Ryandra Anditto on 20/05/26.
//

import SwiftUI



// MARK: - Model tiap halaman onboarding
struct OnboardingPage {
    let imageName: String
    let imageWidth: CGFloat
    let imageHeight: CGFloat
    let title: String
    let sizeTitle: CGFloat
    let subtitle: String
    let isLastPage: Bool
}

// MARK: - Main Onboarding View
struct OnboardingView: View {
    @State private var currentPage = 0
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var splashTimer: Timer? = nil

    let pages: [OnboardingPage] = [
        OnboardingPage(
            imageName: "nutrizzahIcon",
            imageWidth: 112,
            imageHeight: 126,
            title: "Nutrizzah",
            sizeTitle: 48,
            subtitle: "Catatan Nutrisi Harianmu Azzah",
            isLastPage: false
        ),
        OnboardingPage(
            imageName: "onboardingIllustration1",
            imageWidth: 282,
            imageHeight: 243.98,
            title: "Know what's actually\non your plate.",
            sizeTitle: 36,
            subtitle: "Log meals in seconds",
            isLastPage: false
        ),
        OnboardingPage(
            imageName: "onboardingIllustration2",
            imageWidth: 402,
            imageHeight: 280,
            title: "See the full picture.",
            sizeTitle: 36,
            subtitle: "Calories, macros, vitamins, minerals\neverything you eat, all in one view.",
            isLastPage: false
        ),
        OnboardingPage(
            imageName: "onboardingIllustration3",
            imageWidth: 280,
            imageHeight: 280,
            title: "Hit your goals, your way.",
            sizeTitle: 36,
            subtitle: "We'll do the math. You just eat and log. Easy.",
            isLastPage: true
        )
    ]

    var contentPages: [OnboardingPage] { Array(pages.dropFirst()) }
    var contentIndex: Int { max(0, currentPage - 1) }

    var body: some View {
        ZStack {
            backgroundGradient
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 0.5), value: currentPage)

            if currentPage == 0 {
                splashPage
                    .transition(.opacity)
            } else {
                onboardingContent
                    .transition(.opacity)
            }
        }
        .onAppear { startSplashTimer() }
        .onDisappear { splashTimer?.invalidate() }
    }

    // MARK: - Splash Page
    var splashPage: some View {
        VStack(spacing: 24) {
            Spacer()
            Image(pages[0].imageName)
                .resizable()
                .scaledToFit()
                .frame(width: pages[0].imageWidth, height: pages[0].imageHeight)
            VStack(spacing: 12) {
                Text(pages[0].title)
                    .font(.custom("PPEditorialNew-Ultrabold", size: pages[0].sizeTitle))
                    .multilineTextAlignment(.center)
                Text(pages[0].subtitle)
                    .font(.system(size: 16))
                    .multilineTextAlignment(.center)
                    .opacity(0.6)
            }
            .padding(.horizontal, 32)
            Spacer()
        }
    }

    // MARK: - Onboarding Content (halaman 1–3)
    var onboardingContent: some View {
        VStack(spacing: 0) {

            // ── Top nav: Back + Skip (glass effect) ──
            HStack {
                // Back button (disembunyikan di halaman pertama konten)
                if currentPage > 1 {
                    Button {
                        withAnimation { currentPage -= 1 }
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 15, weight: .semibold))
                            .foregroundColor(.primary)
                            .frame(width: 36, height: 36)
                            .background(.ultraThinMaterial, in: Circle())
                    }
                } else {
                    // Placeholder agar Skip tetap di kanan
                    Spacer().frame(width: 36, height: 36)
                }

                Spacer()

                // Skip button
                if currentPage < pages.count - 1 {
                    Button("Skip") {
                        withAnimation { currentPage = pages.count - 1 }
                    }
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.primary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(.ultraThinMaterial)
                    .clipShape(Capsule())
                }
            }
            .padding(.horizontal, 24)
            .padding(.top, 16)
            .frame(height: 60)

            // ── Ilustrasi (TabView, bisa digeser) ──
            TabView(selection: $currentPage) {
                ForEach(1..<pages.count, id: \.self) { index in
                    OnboardingIllustrationView(page: pages[index])
                        .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .animation(.easeInOut, value: currentPage)
            .frame(maxHeight: .infinity)

            // ── Dots (center, tidak ikut geser) ──
            PageIndicatorView(count: contentPages.count, currentIndex: contentIndex)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)

            // ── Teks (center, tidak geser) ──
            OnboardingTextView(page: pages[currentPage])
                .padding(.horizontal, 32)
                .animation(.easeInOut(duration: 0.3), value: currentPage)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .padding(.bottom, 50)

            Spacer().frame(height: 32)

            // ── Tombol aksi ──
            actionButton
                .padding(.horizontal, 24)
                .padding(.bottom, 40)
        }
    }

    // MARK: - Auto-swipe splash
    func startSplashTimer() {
        splashTimer?.invalidate()
        splashTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
            withAnimation(.easeInOut(duration: 0.6)) { currentPage = 1 }
        }
    }

    // MARK: - Background
    @ViewBuilder
    var backgroundGradient: some View {
        switch currentPage {
        case 0:
            LinearGradient(colors: [.gradien1, .gradien2],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
        case 1:
            //halaman 1 konten
            LinearGradient(
                colors: [Color(hex: "#C5D0A7"), Color(hex: "#7F8E57")],
                startPoint: .topLeading,
                endPoint: .bottomTrailing)
        case 2:
            RadialGradient(
                colors: [Color(hex:"#7F8E57"), Color(hex:"#C5D0A7")],
                center: .init(x: 0.5, y: 0.25),
                startRadius: 0,
                endRadius: 420)
        case 3:
            RadialGradient(
                colors: [Color(hex:"#C5D0A7"), Color(hex:"#7F8E57")],
                center: .init(x: 0.5, y: 0.25),
                startRadius: 0,
                endRadius: 600)
        default:
            LinearGradient(colors: [Color(hex: "#8FAF6E"), Color(hex: "#6B8F4E")],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }

    // MARK: - Tombol Next / Let's Go
    @ViewBuilder
    var actionButton: some View {
        if currentPage == pages.count - 1 {
            Button("Let's go") { hasSeenOnboarding = true }
                .buttonStyle(OnboardingButtonStyle())
        } else {
            Button("Next") {
                withAnimation { currentPage += 1 }
            }
            .buttonStyle(OnboardingButtonStyle())
        }
    }
}

// MARK: - Ilustrasi saja (masuk TabView)
struct OnboardingIllustrationView: View {
    let page: OnboardingPage
    var body: some View {
        VStack {
            Spacer()
            Image(page.imageName)
                .resizable()
                .scaledToFit()
                .frame(width: page.imageWidth, height: page.imageHeight)
            Spacer()
        }
    }
}

// MARK: - Teks saja (di luar TabView, statis)
struct OnboardingTextView: View {
    let page: OnboardingPage
    var body: some View {
        VStack(spacing: 12) {
            Text(page.title)
                .font(.custom("PPEditorialNew-Ultrabold", size: page.sizeTitle))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)

            Text(page.subtitle)
                .font(.system(size: 16))
                .multilineTextAlignment(.center)
                .opacity(0.6)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

// MARK: - Dots
struct PageIndicatorView: View {
    let count: Int
    let currentIndex: Int
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<count, id: \.self) { index in
                Capsule()
                    .fill(index == currentIndex ? Color.white : Color.white.opacity(0.3))
                    .frame(width: index == currentIndex ? 20 : 8, height: 8)
                    .animation(.spring(response: 0.3), value: currentIndex)
            }
        }
    }
}

// MARK: - Button Style
struct OnboardingButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 17, weight: .semibold))
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(Color.veryDarkGreen)
            .cornerRadius(30)
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
            .animation(.spring(response: 0.2), value: configuration.isPressed)
    }
}

// MARK: - Color Extension
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r = Double((int >> 16) & 0xFF) / 255
        let g = Double((int >> 8) & 0xFF) / 255
        let b = Double(int & 0xFF) / 255
        self.init(red: r, green: g, blue: b)
    }
    // gradien1 & gradien2 dari Assets kamu
}

#Preview {
    OnboardingView()
}
