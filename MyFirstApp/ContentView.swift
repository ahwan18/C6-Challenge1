import SwiftUI

struct ContentView: View {
    init() {
        for family in UIFont.familyNames {
            print("Font Family: \(family)")
            for fontName in UIFont.fontNames(forFamilyName: family) {
                print("  - \(fontName)")
            }
        }
    }
    var body: some View {
        NavigationStack {
            ZStack {
                Image(.welcome2Bg)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea(.all)
                
                VStack {
                    Spacer()
                    VStack(spacing: 11) {
                        Text("Let's get your schedule set up for a productive day!")
                            .font(.custom("Inter 24pt", size: 22))
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                        
                        Text("Fill in your daily activities and we will help you find the best study time using Pomodoro technique")
                            .font(.system(size: 16, weight: .regular, design: .default))
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)
                            .lineSpacing(1)

                    }
                    .frame(width: 340, height: 190, alignment: .center)
                    .background(Color.containerGray)
                    .cornerRadius(10)
                    .padding(.top, 30)
                    .shadow(radius: 2, x: 0, y: 4)
                    
                    Spacer()
                    
                    // Ganti Button jadi NavigationLink
                    NavigationLink(destination: ActivityListsView()) {
                        Text("START")
                            .frame(maxWidth: .infinity, maxHeight: 50)
                            .background(Color.redButton)
                            .foregroundColor(.white)
                            .font(.system(size: 24))
                            .fontWeight(.bold)
                            .cornerRadius(10)
                            .padding(.horizontal)
                            .shadow(radius: 2, x: 0, y: 2)
                    }
                    .padding(.bottom, 70)
                }
                .navigationBarHidden(true) // Sembunyikan bar atas jika tidak ingin muncul
            }
        }
    }
}

#Preview {
    ContentView()
}
