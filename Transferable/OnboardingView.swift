//
//  OnboardingView.swift
//  Transferable
//
//  Created by Brian on 6/3/2024.
//

import SwiftUI

// OnboardingView interface which shows the user how to use the app
struct OnboardingView: View {
    // Set the initial value of hasOnboarded to false in UserDefaults
    @AppStorage("hasOnboarded") var hasOnboarded: Bool = false

    var body: some View {
        // Create a TabView with 6 tabs to show the user how to use the app
        TabView {
            VStack {
                Text("This is your list of bookings")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .fontDesign(.monospaced)
                    .foregroundStyle(.white)
                Image("DemoBookings")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300)
            }
            .tag(0)
            .background(Color.gray)
            
            VStack {
                Text("You can add a new booking here")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .fontDesign(.monospaced)
                    .foregroundStyle(.white)
                Image("DemoAddBooking")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300)
            }
            .tag(1)
            .background(Color.gray)
            
            VStack {
                Text("You can also sort your booking")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .fontDesign(.monospaced)
                    .foregroundStyle(.white)
                Image("DemoSort")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300)
            }
            .tag(2)
            .background(Color.gray)
            
            VStack {
                Text("Search specific booking(s)")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .fontDesign(.monospaced)
                    .foregroundStyle(.white)
                Image("DemoSearchBooking")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300)
            }
            .tag(3)
            .background(Color.gray)
            
            VStack {
                Text("Search for a restaurant and update details. When you're done, click on the search result")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .fontDesign(.monospaced)
                    .foregroundStyle(.white)
                    .padding()
                Image("DemoSearchRestaurant")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300)
            }
            .tag(4)
            .background(Color.gray)
            
            VStack {
                Spacer()
                Text("The map below is now updated")
                    .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    .fontDesign(.monospaced)
                    .foregroundStyle(.white)
                Image("DemoMap")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300)
                Spacer()
                // Add a button to allow the user to complete the onboarding process and return to the ContentView
                Button(action: {
                    hasOnboarded = true
                    print("Onboarding completion button tapped")
                }) {
                    Text("I am ready")
                        .padding(10)
                        .background(Color.white)
                        .cornerRadius(10)
                        .foregroundStyle(.orange)
                        .fontWeight(.bold)
                }
                Spacer()
            }
            .tag(5)
            .background(Color.gray)
            
        }
        .tabViewStyle(PageTabViewStyle())
        .background(Color.gray)
    }
}

#Preview {
    OnboardingView()
}
