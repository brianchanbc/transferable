//
//  EditBookingView.swift
//  Transferable
//
//  Created by Brian on 3/3/2024.
//

import SwiftUI
import SwiftData
import MapKit

// EditBookingView interface which allows the user to edit a booking
struct EditBookingView: View {
    // Binding is a property wrapper that is used to create a two-way binding to a value meaning it can both read and write the value. If the value is modified, the change will be reflected back in the original place
    @Bindable var booking: Booking
    // modelContext is used to update the Swift data model
    @Environment(\.modelContext) var modelContext
    // searchText is used to hold the search text
    @State private var searchText = ""
    // searchCompleter is an instance of SearchCompleter
    @ObservedObject private var searchCompleter = SearchCompleter()
    // showResults is used to check whether search results should be shown
    @State private var showResults = false
    
    var body: some View {
        VStack {
            // Form is used to create a form to input the booking details
            Form {
                // $ is used to create a binding to the name property such that change is propagated back to the source
                // TextField is used to create a text field to input the restaurant name
                TextField("Restaurant", text: Binding(
                    get: { self.booking.restaurant },
                    set: { newValue in self.booking.restaurant = newValue }
                ), onCommit: {
                    searchCompleter.search(query: booking.restaurant)
                    showResults = !booking.restaurant.isEmpty
                })
                // Picker is used to create a picker to select the party size
                Picker("Party", selection: Binding(
                    get: { self.booking.party - 1 },
                    set: { newValue in self.booking.party = newValue + 1 }
                )) {
                    ForEach(1..<31) {
                        Text("\($0) people")
                    }
                }
                // DatePicker is used to create a date picker to select the date
                DatePicker("Date", selection: $booking.date)
                // TextField is used to create a text field to input/update the location
                TextField("Location", text: $booking.location)
                // If showResults is true, show the list of search results
                if showResults {
                    List(searchCompleter.results, id: \.title) { result in
                        Button(action: {
                            booking.restaurant = result.title
                            booking.location = result.subtitle
                            searchText = ""
                            showResults = false
                        }) {
                            VStack(alignment: .leading) {
                                Text(result.title)
                                Text(result.subtitle)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
            }
            .onAppear {
                // Restrict date time interval to be every 15 minutes only
                UIDatePicker.appearance().minuteInterval = 15
            }
            .onDisappear {
                // Update the date time interval back to every 1 minute to avoid affecting other date pickers
                UIDatePicker.appearance().minuteInterval = 1
                // Check if a restaurant is inputted, if not then delete it
                if booking.restaurant.isEmpty {
                    modelContext.delete(booking)
                }
            }
            .navigationTitle("Edit Booking")
            .navigationBarTitleDisplayMode(.inline)
            .fontDesign(.monospaced)
            
            // Show map
            MapView(searchString: $booking.restaurant, address: $booking.location)
        }
        .ignoresSafeArea(.keyboard)
    }
}

#Preview {
    // Create mock data for preview as we added booking above, it won't work
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Booking.self, configurations: config)
        let example = Booking(restaurant: "Valois", party: 2)
        return EditBookingView(booking: example)
            .modelContainer(container)
        
    } catch {
        fatalError("Failed to create model container.")
    }
}
