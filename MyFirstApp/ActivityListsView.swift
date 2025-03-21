import SwiftUI

struct ActivityListsView: View {
    @State private var activities: [(start: Date, end: Date, description: String)] = []
    @State private var showModal = false
    let times = (0...24).map { String(format: "%02d.00", $0) } // mulai dari 01.00 sampai 24.00
    
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
                    .padding(.top, 50)
                    
                    // Scrollable Time List
                    ScrollView {
                        VStack(alignment: .leading, spacing: 0) {
                            ForEach(times.indices, id: \.self) { index in
                                HStack(alignment: .top, spacing: 0) {
                                    Text(times[index])
                                        .font(.headline)
                                        .foregroundStyle(Color.black)
                                        .frame(width: 60, alignment: .leading)
                                        .padding(.horizontal, 0)
                                    
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
                            }
                        }
                        .padding(.bottom, 50)
                    }
                    .padding(.top, 10)
                    
                    Spacer()
                    
                    Button(action: {
                        // Action here
                    }) {
                        Text("Calculate")
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
                    .disabled(true)
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
    }
    
    func dateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM, yyyy"
        return formatter.string(from: date)
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
                    activities.append((start: startTime, end: endTime, description: activityDesc))
                    showModal = false
                }
                .disabled(activityDesc.isEmpty)
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

#Preview {
    ActivityListsView()
}
