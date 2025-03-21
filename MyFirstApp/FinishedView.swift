import SwiftUI

struct FinishedView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                Image(.finishedBg)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea(.all)
                
                VStack {
                    Spacer()
                    
                    Text("Congratulations!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.white)
                    
                    Image(.tomatoIcon)
                        .resizable()
                        .frame(width: 238, height: 209)
                    
                    Text("Great Job Today!")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundStyle(Color.white)
                    
                    Spacer()
                    
                    Button(action: {
                        // Action here
                    }) {
                        Text("Next >>")
                            .font(.system(size: 24, weight: .regular, design: .rounded))
                            .frame(width: 200)
                            .padding()
                            .background(Color.black.opacity(0.2))
                            .foregroundColor(.white.opacity(0.4))
                            .cornerRadius(16)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                    }
                    .padding(.bottom, 30)
                }
            }
        }
    }
}

#Preview {
    FinishedView()
}
