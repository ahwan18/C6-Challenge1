import SwiftUI

struct AvailableHoursView: View {
    var body: some View {
        VStack(alignment: .leading) {
            // Back button
//            HStack {
//                Image(systemName: "chevron.left")
//                    .font(.title2)
//                    .foregroundColor(.blue)
//                Spacer()
//            }
//            .padding(.horizontal)
            
            // Title & Clock
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Available")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("Free Time")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    HStack {
                        Circle()
                            .fill(Color.gray)
                            .frame(width: 10, height: 10)
                            .padding(.leading, 5)
                        Text("Total Activity Time : 19 Hours")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(6)
                    }
                    .background(Color(UIColor.systemGray5))
                    .cornerRadius(10)
                    .padding(.top, 10)
                }
                
                Spacer()
                
                // Clock UI
                ZStack {
                    Circle()
                        .stroke(lineWidth: 3)
                        .foregroundColor(.black)
                        .frame(width: 120, height: 120)
                    
                    Text("5 Hours")
                        .font(.title2)
                        .fontWeight(.bold)
                }
            }
            .padding()
            
            // Time Slots Header
            Text("Time slots available")
                .font(.headline)
                .padding(.horizontal)
            
            // Time Slots List
            VStack(spacing: 8) {
                HStack() {
                    Text("Time")
                        .font(.headline)
                    
                    Spacer()
                    
                    Text("Duration")
                        .font(.headline)
                    
                    Spacer()
                }
                .frame(width: 330, height: 0)
                .padding(.vertical)
                .padding(.top, 5)
                
                ForEach(freeTimeSlots, id: \.time) { slot in
                    HStack {
                        Text(slot.time)
                            .font(.subheadline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(slot.duration)
                            .font(.subheadline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(8)
                    .background(Color.gray.opacity(0.4))
                    .cornerRadius(10)
                }
            }
            .padding([.leading, .trailing, .bottom])
            .background(Color(UIColor.systemGray5))
            .cornerRadius(10)
            .padding(.horizontal)
            
            Spacer()
            
            // Free Time Info
            Text("You have 5 hours of free time today!")
                .foregroundColor(.blue)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(UIColor.systemGray5))
                .cornerRadius(15)
                .padding(.horizontal)
            
            // Next Button
            Button("Next >>", action: {})
                .padding(.top, 20)
                .frame(maxWidth: .infinity, alignment: .center)
            
            
            Spacer()
        }
    }
}

// Data model untuk time slots
struct TimeSlot {
    var time: String
    var duration: String
}

// Contoh data dummy
let freeTimeSlots: [TimeSlot] = [
    TimeSlot(time: "10.00 - 10.30", duration: "30 Minutes"),
    TimeSlot(time: "14.30 - 16.00", duration: "1 Hour 30 Minutes"),
    TimeSlot(time: "21.00 - 22.30", duration: "1 Hour 30 Minutes"),
    TimeSlot(time: "22.30 - 23.30", duration: "1 Hour")
]

#Preview {
    AvailableHoursView()
}
