//
//  FlashEmulatorView.swift
//  StikEMU
//
//  Created by Blu on 10/11/24.
//

import SwiftUI
import WebKit

struct FlashEmulatorView: View {
    @StateObject private var flashServer = FlashEmulatorServer()

    var body: some View {
        VStack(spacing: 0) {
            // Custom header with gradient background and title "StikEMU - Flash"
            HStack {
                Text("StikEMU - Flash")
                    .font(.system(size: 24, weight: .semibold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.leading, 16)
                Spacer()
            }
            .frame(height: 60)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.purple, Color.blue]),
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(20)
            .shadow(radius: 10)
            .padding()

            // WebView with responsive Flash player
            WebView(url: URL(string: "http://localhost:8080")!)
                .cornerRadius(20)
                .shadow(radius: 10)
                .padding([.leading, .trailing, .bottom])
        }
        .onAppear {
            flashServer.start()
        }
        .onDisappear {
            flashServer.stop()
        }
        .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all))
    }
}
