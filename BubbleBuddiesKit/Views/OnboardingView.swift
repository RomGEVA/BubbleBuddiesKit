import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding: Bool?
    @State private var page = 0
    @State private var showMain = false
    
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [.blue.opacity(0.3), .purple.opacity(0.3)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            VStack {
                TabView(selection: $page) {
                    ZStack(alignment: .bottom) {
                        Image("onboarding1")
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                            .padding()
                        VStack(spacing: 30) {
                            
                            Text("Welcome to Bubble Buddies!")
                                .font(.largeTitle).bold()
                            Text("Pop bubbles to rescue cute animals. Enjoy chain reactions and realistic physics!")
                                .font(.title2)
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                        .background(content: {
                            Color.white.opacity(0.7).cornerRadius(32)
                        })
                        .padding()
                        .tag(0)
                    }
                    
                    ZStack(alignment: .bottom) {
                        Image("onboarding2")
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
                            .padding()
                        VStack(spacing: 30) {
                            
                            Text("Achievements & Fun")
                                .font(.largeTitle).bold()
                            Text("Unlock achievements, customize settings, and have fun with friends!")
                                .font(.title2)
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                        .background(content: {
                            Color.white.opacity(0.7).cornerRadius(32)
                        })
                        .padding()
                        .tag(1)
                    }
                }
                .tabViewStyle(PageTabViewStyle())
                Spacer()
                Button(page == 1 ? "Start" : "Next") {
                    if page == 1 {
                        hasSeenOnboarding = true
                        showMain = true
                    } else {
                        page = 1
                    }
                }
                .buttonStyle(.borderedProminent)
            }
            .fullScreenCover(isPresented: $showMain, content: {
                StartView()
            })
        }
    }
}

#Preview {
    OnboardingView()
} 
