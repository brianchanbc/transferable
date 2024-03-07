//
//  SplashView.swift
//  Transferable
//
//  Created by Brian on 6/3/2024.
//

import SwiftUI

struct SplashView: View {
    // SplashView interface which shows the app's logo, app name and developer name when the app launches

    // Set the initial size, opacity, and rotation of the logo
    @State private var size = 0.8
    @State private var opacity = 0.5
    @State private var rotation: Double = 0
    // Use binding to control the visibility of the splash screen. This will be communicated back to the TransferableApp.swift file.
    @Binding var showSplash: Bool
    
    // Customise your SplashScreen here
    var body: some View {
        ZStack {
            // Set the background color of the splash screen
            Color.orange.edgesIgnoringSafeArea(.all)

            VStack {
                // Set the app's logo and name
                Image("AppIconImage")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100)
                    .rotationEffect(.degrees(rotation))
                // Set the app's name
                Text("Transferable")
                    .font(.title2)
                    .fontDesign(.monospaced)
                    .foregroundColor(.black.opacity(0.80))
                    .padding()
                // Set the app's developer
                Text("Developed by Brian Chan")
                    .font(.callout)
                    .fontDesign(.monospaced)
                    .foregroundColor(.black.opacity(0.80))
            }
            .scaleEffect(size)
            .opacity(opacity)
            .onAppear {
                print("SplashView started")
                // Animate the splash screen to scale up, fade in, and rotate
                withAnimation(.easeIn(duration: 0.7)) {
                    self.size = 0.9
                    self.opacity = 1.00
                    self.rotation = 360 * 4
                }
            }
        }
        .onAppear {
            print("SplashView completed")
            // After 1 second, hide the splash screen
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                withAnimation {
                    self.showSplash = false
                }
            }
        }
        
    }
}

struct SplashView_Previews: PreviewProvider {
    @State static var showSplash = true
    static var previews: some View {
        SplashView(showSplash: $showSplash)
    }
}
