import SwiftUI

struct ActivityInputView: View {
  @State private var activities: [(start: Date, end: Date, description: String)] = []
  @State private var showModal = false

  let timeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "HH:mm"
    return formatter
  }()

  var body: some View {
    ZStack {
      VStack(alignment: .leading) {
        // Header
        HStack {
          VStack(alignment: .leading) {
            Text("Today")
              .font(.largeTitle)
              .fontWeight(.bold)
            Text(dateString(from: Date()))
              .font(.title2)
          }

          Spacer()

          Button(action: {
            showModal = true
          }) {
            Image(systemName: "plus")
              .font(.title2)
          }
          .buttonStyle(.bordered)
        }
        .padding()

        Rectangle()
          .frame(height: 2)
          .foregroundColor(.blue)
          .padding(.trailing, 200)
          .padding(.leading)

        Text("Activity Lists")
          .fontWeight(.bold)
          .font(.title)
          .padding(.horizontal)

        // ScrollView Timeline
        ScrollView {
          HStack(alignment: .top) {
            // Time Bar
            VStack(alignment: .trailing, spacing: 20) {
              ForEach(0..<25) { hour in
                Text(String(format: "%02d.00", hour))
                  .font(.headline)
                  .frame(width: 50, alignment: .trailing)
              }
            }

            // Timeline & Activities
            ZStack(alignment: .topLeading) {
              // Garis-garis jam
              VStack(spacing: 40) {
                ForEach(0..<25) { _ in
                  Divider()
                    .background(Color.gray)
                }
              }

              // Card aktivitas
              ForEach(activities.indices, id: \.self) { index in
                let activity = activities[index]
                let yOffset = timeOffset(for: activity.start)
                let height = timeOffset(for: activity.end) - yOffset

                VStack(alignment: .leading) {
                  Text(activity.description)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                  Text("• \(timeFormatter.string(from: activity.start)) - \(timeFormatter.string(from: activity.end))")
                    .foregroundColor(.white)
                    .font(.subheadline)
                }
                .padding()
                .frame(width: 250, height: height)
                .background(Color.gray)
                .cornerRadius(8)
                .offset(y: yOffset)
              }
            }
          }
          .padding()
        }

        // Tombol START
        Button("START") {
          // Aksi tombol START
        }
        .font(.headline)
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.blue)
        .foregroundColor(.white)
        .cornerRadius(10)
        .padding()
      }

      // Modal Tambah Aktivitas
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

  // Fungsi untuk menghitung offset Y berdasarkan waktu
  func timeOffset(for date: Date) -> CGFloat {
    let calendar = Calendar.current
    let startHour = calendar.date(bySettingHour: 1, minute: 0, second: 0, of: date) ?? date
    let components = calendar.dateComponents([.hour, .minute], from: startHour, to: date)
    let totalMinutes = (components.hour ?? 0) * 60 + (components.minute ?? 0)
    return CGFloat(totalMinutes) / 60.0 * 40.0
  }

  // Fungsi untuk mendapatkan string tanggal hari ini
  func dateString(from date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "d MMMM, yyyy"
    return formatter.string(from: date)
  }
}


// Modal pakai ZStack
struct AddActivityModal: View {
  @Binding var showModal: Bool
  @Binding var activities: [(start: Date, end: Date, description: String)]

  @State private var activityDesc = ""
  @State private var startTime = Calendar.current.date(bySettingHour: 7, minute: 0, second: 0, of: Date()) ?? Date()
  @State private var endTime = Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: Date()) ?? Date()

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
      .padding(.top, 10) // Merapat atas

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
  ActivityInputView()
}
