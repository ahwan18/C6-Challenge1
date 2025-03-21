//
//  PomodoroSelectionView.swift
//  MyFirstApp
//
//  Created by Ahmad Kurniawan Ibrahim on 19/03/25.
//

import SwiftUI

struct PomodoroSelectionView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(.blue)
                Spacer()
            }
            .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Choose your focus time!")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(Color("Tomato1"))
                
                Text("Pick your pomodoro schedule")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(6)
                    .background(Color(UIColor.systemGray5))
                    .cornerRadius(10)
            }
            .padding()
            
            Spacer()
            
            Text("Sessions")
                .font(.title3)
                .padding(.horizontal)
            
            VStack(spacing: 10) {
                ForEach(sessionData, id: \.id) {session in
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(session.timeRange)
                                .font(.body)
                                .fontWeight(.semibold)
                            
                            Text("Session : \(session.sessionNumber)")
                                .font(.caption)
                            Text("Study Duration : \(session.studyDuration) minutes")
                                .font(.caption)
                            Text("Break Duration : \(session.breakDuration) minutes")
                                .font(.caption)
                        }
                        
                        Spacer()
                        
                        VStack {
                            Spacer()
                            
                            Button(action: {}) {
                                Text("Choose >")
                                    .font(.caption)
                                    .foregroundColor(Color.black)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(Color("Color"))
                                    .cornerRadius(10)
                            }
                            .padding(.trailing, 5)
                        }
                    
                    }
                    .padding(7)
                    .background(Color("Tomato1"))
                    .cornerRadius(10)
                }
            }
            .foregroundStyle(Color.white)
            .padding()
            .background(Color(red: 245/255, green: 245/255, blue: 245/255))
            .cornerRadius(10)
            .padding(.horizontal, 9)
        }
    }
}

struct Session: Identifiable {
    let id = UUID()
    let timeRange: String
    let sessionNumber: Int
    let studyDuration: Int
    let breakDuration: Int
}

let sessionData: [Session] = [
    Session(timeRange: "10:00 - 10:30", sessionNumber: 1, studyDuration: 25, breakDuration: 5),
    Session(timeRange: "14:30 - 16:00", sessionNumber: 3, studyDuration: 75, breakDuration: 15),
    Session(timeRange: "14:30 - 14:55", sessionNumber: 1, studyDuration: 25, breakDuration: 5),
    Session(timeRange: "15:00 - 15:25", sessionNumber: 1, studyDuration: 25, breakDuration: 5),
    Session(timeRange: "15:30 - 15:55", sessionNumber: 1, studyDuration: 25, breakDuration: 5),
    Session(timeRange: "21:00 - 22:30", sessionNumber: 3, studyDuration: 75, breakDuration: 15)
]


#Preview {
    PomodoroSelectionView()
}
