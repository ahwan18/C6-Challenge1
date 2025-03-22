import SwiftUI

struct ActivityListsView: View {
    @State private var freeTimeIntervals: [FreeTimeSlot] = []
    @State private var isNavigatingToLoadingView = false
    @State private var activities: [(start: Date, end: Date, description: String)] = []
    @State private var showModal = false
    let times = (0..<25).map { String(format: "%02d.00", $0) } // 00.00 hingga 23.00 // mulai dari 01.00 sampai 24.00
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background image
                Image(.inputActivityBg)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Header Section
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Today's Task")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            Text(dateString(from: Date()))
                                .font(.system(size: 17, weight: .regular))
                                .foregroundColor(.white)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 16)
                    .background(Color.bgLabelToday)
                    .clipShape(RoundedCorner(radius: 8, corners: [.bottomLeft, .topLeft]))
                    .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 4)
                    .padding(.leading, 20)
                    .padding(.top, 50)
                    
                    HStack {
                        Text("Time")
                            .font(.custom("Inter24pt-Bold", size: 26))
                        
                        Spacer()
                        
                        Button(action: {
                            showModal = true
                        })
                        {
                            Text("Add +")
                                .frame(width: 80, height: 35)
                                .font(.system(size: 24, weight: .bold, design: .rounded))
                                .foregroundStyle(Color.black)
                                .background(Color.bgButton)
                                .cornerRadius(16)
                        }
                    }
                    .padding(.horizontal, 23)
                    .padding(.top, 40)
                    
                    // Scrollable Time List
                    ScrollView {
                        ZStack(alignment: .topLeading) {
                            VStack(alignment: .leading, spacing: 0) {
                                ForEach(times.indices, id: \.self) { index in
                                    HStack(alignment: .top, spacing: 0) {
                                        Text(times[index])
                                            .font(.headline)
                                            .foregroundStyle(Color.black)
                                            .frame(width: 60, alignment: .leading)
                                            .padding(.bottom, 40)

                                        VStack(spacing: 0) {
                                            ZStack {
                                                Circle()
                                                    .strokeBorder(Color.red, lineWidth: 2)
                                                    .background(Circle().fill(Color.white))
                                                    .frame(width: 16, height: 16)

                                                Circle()
                                                    .strokeBorder(Color.white, lineWidth: 1)
                                                    .background(Circle().fill(Color.red))
                                                    .frame(width: 11, height: 11)
                                            }
                                            .padding(.bottom, 3)

                                            if index < times.count - 1 {
                                                Rectangle()
                                                    .fill(Color.gray.opacity(0.4))
                                                    .frame(width: 2, height: 50)
                                            }
                                        }
                                        .padding(.top, 2)

                                        Spacer()
                                    }
                                    .padding(.leading, 13)
                                    .padding(.vertical, 0)
                                    .frame(height: 60) // Set fixed height agar setiap baris konsisten
                                }
                            }
                            .padding(.top, 11)
                            
                            // Overlay untuk Activity Cards tanpa memengaruhi layout utama
                            ForEach(activities.indices, id: \.self) { i in
                                let activity = activities[i]
                                let calendar = Calendar.current
                                let startHour = calendar.component(.hour, from: activity.start)
                                let startMinute = calendar.component(.minute, from: activity.start)
                                let duration = activity.end.timeIntervalSince(activity.start) / 60.0 // durasi dalam menit
                                let height = CGFloat(duration * 1)

                                // Posisi vertical = (startHour * tinggiBaris) + (startMinute / 60 * tinggiBaris)
                                let yOffset = CGFloat(startHour) * 61 + CGFloat(startMinute) / 60 * 61 + 8 // +8 for padding correction

                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.gray.opacity(0.6))
                                    .frame(width: 240, height: height)
                                    .overlay(
                                        VStack(alignment: .leading, spacing: 4) {
                                            Text(activity.description)
                                                .font(.headline)
                                            Text(timeRangeString(start: activity.start, end: activity.end))
                                                .font(.subheadline)
                                        }
                                        .foregroundStyle(Color.white)
                                        .padding(8),
                                        alignment: .topLeading
                                    )
                                    .offset(x: 120, y: yOffset) // x untuk geser ke kanan, y untuk posisikan secara vertikal
                            }
                        }
                        .padding(.bottom, 50)
                    }
                    .padding(.top, 20)

                    Spacer()
                    
                    NavigationLink(destination: LoadingView()) {
                        Text("Calculate")
                            .font(.system(size: 24, weight: .regular, design: .rounded))
                            .frame(width: 150, height: 25)
                            .padding()
                            .background(Color.bgButton)
                            .foregroundColor(.redTimer)
                            .cornerRadius(16)
                            .padding(.bottom, 20)
                            .shadow(radius: 4, x: 0, y: 4)
                    }
                    .padding(.bottom, 30)
                    .disabled(activities.isEmpty)
    
                }
                if showModal {
                    Color.black.opacity(0.4)
                        .edgesIgnoringSafeArea(.all)
                    
                    AddActivityModal(showModal: $showModal, activities: $activities)
                        .frame(width: 350, height: 320)
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(radius: 10)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    func timeString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH.mm"
        return formatter.string(from: date)
    }
    
    func timeRangeString(start: Date, end: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH.mm"
        return "\(formatter.string(from: start)) - \(formatter.string(from: end))"
    }

    
    func dateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM, yyyy"
        return formatter.string(from: date)
    }
    
    func calculateFreeTimeIntervals() -> [FreeTimeSlot] {
        let calendar = Calendar.current
        let startOfDay = calendar.date(bySettingHour: 0, minute: 0, second: 0, of: Date())!
        let endOfDay = calendar.date(bySettingHour: 23, minute: 59, second: 59, of: Date())!

        let sortedActivities = activities.sorted { $0.start < $1.start }
        var freeTimeSlots: [FreeTimeSlot] = []
        var lastEnd = startOfDay

        for activity in sortedActivities {
            if activity.start > lastEnd {
                let interval = FreeTimeSlot(start: lastEnd, end: activity.start)
                freeTimeSlots.append(interval)
            }
            lastEnd = max(lastEnd, activity.end)
        }

        if lastEnd < endOfDay {
            let interval = FreeTimeSlot(start: lastEnd, end: endOfDay)
            freeTimeSlots.append(interval)
        }

        return freeTimeSlots
    }

}

// Reusable custom shape
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

struct AddActivityModal: View {
    @Binding var showModal: Bool
    @Binding var activities: [(start: Date, end: Date, description: String)]
    
    @State private var activityDesc = ""
    @State private var startTime = Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: Date()) ?? Date()
    @State private var endTime = Calendar.current.date(bySettingHour: 1, minute: 0, second: 0, of: Date()) ?? Date()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Tombol Cancel & Save merapat ke atas
            HStack {
                Button("Cancel") {
                    showModal = false
                }
                .foregroundColor(.red)
                
                Spacer()
                
                Button("Save") {
                    if endTime > startTime {
                        activities.append((start: startTime, end: endTime, description: activityDesc))
                        showModal = false
                    }
                }
                .disabled(activityDesc.isEmpty || endTime <= startTime)

            }
            .padding(.horizontal)
            .padding(.bottom, 10) // Merapat atas
            
            // TextEditor mirip kolom komentar
            ZStack(alignment: .topLeading) {
                if activityDesc.isEmpty {
                    Text("e.g., Sleep")
                        .foregroundColor(.gray)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                    
                }
                
                TextEditor(text: $activityDesc)
                    .padding(10)
                    .cornerRadius(8)
                    .frame(height: 100)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 1)
            )
            .padding(.horizontal)
            
            VStack(spacing: 0) {
                // DatePicker Start
                DatePicker("Start Time", selection: $startTime, displayedComponents: .hourAndMinute)
                    .padding(.horizontal)
                    .padding(.vertical, 10) // biar ada jarak atas-bawah
                
                Divider()
                    .background(Color.gray.opacity(0.5)) // Divider semi-transparan
                
                // DatePicker End
                DatePicker("End Time", selection: $endTime, displayedComponents: .hourAndMinute)
                    .padding(.horizontal)
                    .padding(.vertical, 10)
            }
            .frame(width: 320)
            .background(Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray, lineWidth: 1) // Border di atas background
            )
            .cornerRadius(12)
            .padding(.horizontal)
        }
    }
}

struct FreeTimeSlot: Identifiable {
    let id = UUID()
    let start: Date
    let end: Date
}


#Preview {
    ActivityListsView()
}
