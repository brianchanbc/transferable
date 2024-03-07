//
//  ContentView.swift
//  Transferable
//
//  Created by Brian on 3/3/2024.
//
import SwiftData
import SwiftUI

// ContentView interface is the first interface the user sees when they open the app
struct ContentView: View {
    // Model context tracks all objects currently actively being used by the app
    // Get the modelContext created from modelContainer and place that into the environment for use
    @Environment(\.modelContext) var modelContext
    // Tracking the paths of the navigation stack. Using "State" to adjust what is showing in the stack dynamically, when there are changes
    @State private var path = [Booking]()
    // Tracking the sort order
    @State private var sortOrder = SortDescriptor(\Booking.date, order: .reverse)
    // Tracking the search text
    @State private var searchText = ""
    
    var body: some View {
        // NavigationStack is used to create a navigation stack to navigate to edit the booking
        NavigationStack(path: $path) {
            // Passing in the sort order for the view to enforce
            BookingListingView(sort: sortOrder, searchString: searchText)
                .toolbarBackground(.visible, for: .navigationBar)
                .navigationTitle("Bookings")
                // When the user taps, the navigation will go to EditBookingView
                .navigationDestination(for: Booking.self) { booking in
                    EditBookingView(booking: booking)
                }
                // Show the search bar and take in the text into searchText
                .searchable(text: $searchText)
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        HStack {
                            // Button is used to create a button to add a booking
                            Button(action: addBooking) {
                                Label("Add Booking", systemImage: "plus")
                            }
                            
                            // Menu is used to create a menu to sort the bookings
                            Menu("Sort", systemImage: "arrow.up.arrow.down") {
                                Picker("Sort", selection: $sortOrder) {
                                    Text("Date")
                                        .tag(SortDescriptor(\Booking.date, order: .reverse))
                                    Text("Name")
                                        .tag(SortDescriptor(\Booking.restaurant))
                                    Text("Party")
                                        .tag(SortDescriptor(\Booking.party, order: .reverse))
                                }
                                .pickerStyle(.inline)
                            }
                        }
                    }
                }
                .fontDesign(.monospaced)
        }
    }
    
    func addBooking() {
        // Create a new booking and insert into SwiftData model
        let booking = Booking()
        modelContext.insert(booking)
        // Navigate to the EditBookingView and reflect the new booking
        path = [booking]
    }
}

#Preview {
    ContentView()
}
