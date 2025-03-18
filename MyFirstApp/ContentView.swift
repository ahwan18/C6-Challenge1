import SwiftUI

struct ContentView: View {
  var body: some View {
      VStack {
          Spacer()
          VStack(spacing: 11) {
              Text("Let's get yout schedule set up for a productive day !")
                  .font(.system(size: 23))
                  .fontWeight(.bold)
                  .multilineTextAlignment(.center)
                  .padding(.horizontal, 20)
              
              Text("Fill in your daily activities and we will help you find the best study time using Pomodoro technique !")
                  .font(.subheadline)
                  .multilineTextAlignment(.center)
                  .padding(.horizontal, 20)
          }
          .frame(width: 340, height: 220, alignment: .center)
          .border(Color.gray)
          .background(Color(red: 235/255, green: 235/255, blue: 235/255))
          .cornerRadius(10)
          .padding(.top, 30)
          
          Spacer()
          
          Button("START", action: {})
              .frame(width: 200, height: 40)
              .background(Color.blue)
              .foregroundStyle(Color.white)
              .font(.system(size: 20))
              .fontWeight(.bold)
              .cornerRadius(10)
              .padding(.bottom, 100)
      }
    }
}

#Preview {
  ContentView()
}
