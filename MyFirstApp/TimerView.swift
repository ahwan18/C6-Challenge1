import SwiftUI

struct TimerView: View {
    @State private var timeRemaining = 5 // 25 * 60
    @State private var isRunning = false
    @State private var sessionCount = 0
    @State private var isBreakTime = false
    @State var showBreakAlert = false

    // Distraction Counters
    @State private var showResetAlert = false
    @State private var leavingAppCount = 0
    var totalDistractions: Int {
        leavingAppCount
    }

    let totalTime = 5 // 25 minutes
    var breakTime = 5 // 5 minutes
    let maxSessions = 4

    var body: some View {
        Group {
            if isBreakTime {
                BreakView(timeRemaining: $timeRemaining, isBreakTime: $isBreakTime, sessionCount: $sessionCount, distractionsCount: $leavingAppCount, breakTime: breakTime)
            } else {
                studyView
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            leavingAppCount += 1
        }
    }

    var studyView: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)

            VStack(spacing: 30) {
                Text("Study Session")
                    .font(.largeTitle)
                    .fontWeight(.regular)
                    .foregroundColor(.black)
                    .padding(.bottom, 50)

                // Circular Progress Timer
                ZStack {
                    Circle()
                        .stroke(Color.redTimer.opacity(0.2), lineWidth: 10)
                        .frame(width: 275, height: 275)
                    
                    Circle()
                        .stroke(Color.redTimer, lineWidth: 4)
                        .frame(width: 270, height: 270)

                    Circle()
                        .trim(from: 0, to: progressFraction(total: totalTime))
                        .stroke(progressColor(total: totalTime), style: StrokeStyle(lineWidth: 15, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .frame(width: 250, height: 250)
                        .animation(.linear(duration: 1), value: timeRemaining)

                    Text(timeString())
                        .font(.system(size: 48, weight: .bold, design: .monospaced))
                        .foregroundColor(.redTimer)
                }
                .padding(.top, 20)

                // Session Progress Checkpoints
                HStack(spacing: 20) {
                    ForEach(0..<maxSessions, id: \.self) { index in
                        Circle()
                            .fill(index < sessionCount ? Color.redTimer : Color.clear)
                            .frame(width: 12, height: 12)
                            .overlay(Circle().stroke(Color.redTimer, lineWidth: 2))
                    }
                }
                .padding(.top, 20)

                Text("Before your next break")
                    .foregroundColor(.black)
                    .font(.subheadline)

                // Play/Pause Button
                Button(action: {
                    isRunning.toggle()
                    if isRunning {
                        startTimer()
                    }
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.redButton)
                            .frame(width: 60, height: 60)

                        Image(systemName: isRunning ? "pause.fill" : "play.fill")
                            .foregroundColor(.bgButton)
                            .font(.title)
                    }
                }
                .padding(.top, 0)

                // Distractions Count
                VStack(spacing: 8) {
                    Text("Distractions Count :")
                        .foregroundColor(.redTimer)
                        .font(.subheadline)
                        .fontWeight(.semibold)

                    Text("Leaving App \(leavingAppCount)/3")
                        .foregroundColor(.redTimer)
                        .font(.footnote)
                        .onChange(of: totalDistractions) {
                            if totalDistractions > 3 {
                                resetTimer()
                                showResetAlert = true
                            }
                        }
                        .alert(isPresented: $showResetAlert) {
                            Alert(title: Text("Too Many Distractions"),
                                  message: Text("Timer has been reset."),
                                  dismissButton: .default(Text("OK")))
                        }

                }
                .padding(.bottom, 20)
            }
            .padding()
        }
    }

    func timeString() -> String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    func progressFraction(total: Int) -> CGFloat {
        return CGFloat(total - timeRemaining) / CGFloat(total)
    }

    func progressColor(total: Int) -> Color {
        let fraction = progressFraction(total: total)
        switch fraction {
        case 0..<0.33:
            return Color.green
        case 0.33..<0.66:
            return Color.yellow
        default:
            return Color.orange
        }
    }

    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if timeRemaining > 0 && isRunning {
                timeRemaining -= 1
            } else {
                timer.invalidate()
                if timeRemaining == 0 {
                    isRunning = false
                    isBreakTime = true
                    timeRemaining = breakTime
                }
            }
        }
    }

    func resetTimer() {
        timeRemaining = totalTime
        isRunning = false
        leavingAppCount = 0
    }
    
    func startBreakTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer.invalidate()
                isBreakTime = false
                showBreakAlert = true
            }
        }
    }

}

struct BreakView: View {
    @Binding var timeRemaining: Int
    @Binding var isBreakTime: Bool
    @Binding var sessionCount: Int
    @Binding var distractionsCount: Int
    var breakTime: Int

    @State private var showAlert = false
    @State private var animatePulse = false

    var body: some View {
        ZStack {
            Color.red.edgesIgnoringSafeArea(.all)

            VStack(spacing: 40) {
                Text("BREAK TIME!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)

                ZStack {
                    Circle()
                        .stroke(Color.white.opacity(0.2), lineWidth: 20)
                        .frame(width: 250, height: 250)

                    Circle()
                        .trim(from: 0, to: progressFraction())
                        .stroke(progressColor(), style: StrokeStyle(lineWidth: 20, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        .frame(width: 250, height: 250)
                        .animation(.linear(duration: 1), value: timeRemaining)
                        .scaleEffect(animatePulse ? 1.05 : 1.0)
                        .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: animatePulse)

                    Text(timeString())
                        .font(.system(size: 48, weight: .bold, design: .monospaced))
                        .foregroundColor(.white)
                }

                Button(action: {
                    // Aksi tombol TURN OFF
                    timeRemaining = 1500
                    isBreakTime = false
                    sessionCount += 1
                    distractionsCount = 0
                }) {
                    Text("TURN OFF")
                        .fontWeight(.bold)
                        .padding()
                        .frame(width: 140)
                        .background(timeRemaining == 0 ? Color.yellow : Color.gray.opacity(0.7))
                        .foregroundColor(.black)
                        .cornerRadius(10)
                }
                .disabled(timeRemaining > 0)
            }
        }
        .onAppear {
            startBreakTimer()
            distractionsCount = 0 // Matikan distractions saat break
            animatePulse = true   // Start pulsing animation
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Break Over"),
                  message: Text("Break time is over! Press TURN OFF to continue."),
                  dismissButton: .default(Text("OK")))
        }
    }

    func timeString() -> String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    func progressFraction() -> CGFloat {
        return CGFloat(breakTime - timeRemaining) / CGFloat(breakTime)
    }

    func progressColor() -> Color {
        let fraction = progressFraction()
        switch fraction {
        case 0..<0.33:
            return Color.green
        case 0.33..<0.66:
            return Color.yellow
        default:
            return Color.orange
        }
    }

    func startBreakTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timer.invalidate()
                showAlert = true // Show alert ketika waktu habis
                // Jangan langsung masuk session → tunggu user tekan TURN OFF
            }
        }
    }
}



#Preview {
    TimerView()
}
