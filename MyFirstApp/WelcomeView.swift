//
//  WelcomeView.swift
//  MyFirstApp
//
//  Created by Ahmad Kurniawan Ibrahim on 20/03/25.
//

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        ZStack {
            Image("backgroundWelcome")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea(.all)
            
            VStack {
                ZStack {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 250, height: 250)
                    
                    Text("Logo")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundStyle(.gray)
                }
                .padding(.bottom, 80)
                
                Text("TickTask.")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.fontBrand)
                    .padding(.bottom, 90)
                
            }
        }
    }
}

#Preview {
    WelcomeView()
}
