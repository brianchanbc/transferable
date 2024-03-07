//
//  TransferableApp.swift
//  Transferable
//
//  Created by Brian on 3/3/2024.
//

import SwiftUI
import SwiftData
@main
struct TransferableApp: App {
    // TransferableApp is the main entry point for the app. It is the root of the app's view hierarchy.
    
    // @AppStorage is a property wrapper that reads and writes to UserDefaults.
    @AppStorage("appLaunches") var appLaunches: Int = 0
    @AppStorage("hasOnboarded") var hasOnboarded: Bool = false
    // @State is a property wrapper that allows us to store simple values in a struct or class. It will automatically update the view when the value changes.
    @State private var showRateAppAlert = false
    @State private var showSplash = true
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                // If the user has onboarded, show the ContentView. Otherwise, show the OnboardingView.
                if hasOnboarded {
                    ContentView()
                        .onAppear {
                            // Each time the app launches, increment the appLaunches counter by 1
                            appLaunches += 1
                            print("App has launched \(appLaunches) times.")
                            print("User onboarded before? \(hasOnboarded)")
                            // If the app has launched 3 times, show the rate app alert
                            if appLaunches == 3 {
                                showRateAppAlert = true
                            }
                        }
                        .alert(isPresented: $showRateAppAlert) {
                            // Show the rate app alert
                            Alert(title: Text("Rate this App"), message: Text("Would you like to rate this app in the App Store?"), primaryButton: .default(Text("Yes"), action: {
                                // This is the place to do the actual rating request to the App Store
                            }), secondaryButton: .cancel())
                        }
                } else {
                    OnboardingView()
                        .onAppear {
                            print("App has launched \(appLaunches) times.")
                            print("User onboarded before? \(hasOnboarded)")
                        }
                }
                // Overlay the splash screen on top of the ContentView or OnboardingView if showSplash is true
                if showSplash {
                    SplashView(showSplash: $showSplash)
                }
            }
        }
        // Create storage for Booking object or load it if created previously
        // Use that to store all data inside the window group
        .modelContainer(for: Booking.self)
    }

    init() {
        // Set initial launch date in settings bundle
        if UserDefaults.standard.object(forKey: "initialLaunch") == nil {
            let dateString = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)
            UserDefaults.standard.set(dateString, forKey: "Initial Launch")
            print("App first launched on \(dateString)")
        }
        // For debugging purpose. If there is something wrong with the model container store, just delete all files (default.store, default.store-shm, default.store-walin) in the path below. This will clear the SwiftData files.
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
}
