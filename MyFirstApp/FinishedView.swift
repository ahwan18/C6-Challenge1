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

                    Spacer()
                    
                    Image(.tomatoIcon)
                        .resizable()
                        .frame(width: 238, height: 209)
                        .padding(.bottom, 40)
                    
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
                            .frame(width: 270, height: 20)
                            .padding()
                            .background(Color.white)
                            .foregroundColor(.redTimer)
                            .cornerRadius(10)
                            .padding(.horizontal, 20)
                            .padding(.bottom, 20)
                            .shadow(radius: 4, x: 0, y: 4)
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
