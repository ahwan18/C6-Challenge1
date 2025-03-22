import SwiftUI

struct LoadingView: View {
    @State private var progress: CGFloat = 0.0
    @State private var navigate = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Image(.loadingBg)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea(.all)
                
                
                    VStack(spacing: 20) {
                        Image(systemName: "hourglass")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.black)
                        
                        ZStack(alignment: .leading) {
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.black, lineWidth: 1)
                                .frame(width: 200, height: 10)
                            
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.red)
                                .frame(width: progress * 200, height: 10)
                                .animation(.linear(duration: 0.05), value: progress)
                        }
                        
                        Text("Calculating..")
                            .font(.headline)
                            .foregroundColor(.black)
                    }
                    .padding()
                    .onAppear {
                        // Progress berjalan tiap 0.05 detik
                        Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { timer in
                            if progress < 1.0 {
                                progress += 0.01
                            } else {
                                timer.invalidate()
                                navigate = true
                            }
                        }
                    }
                    // Navigasi otomatis setelah loading selesai
                    .navigationDestination(isPresented: $navigate) {
                        TimerView()
                }
            }
        }
    }
}

#Preview {
    LoadingView()
}
