//
//  BookingListingView.swift
//  Transferable
//
//  Created by Brian on 3/3/2024.
//

import SwiftUI
import SwiftData

// BookingListingView interface which shows the list of bookings
struct BookingListingView: View {
    // modelContext is used to update the Swift data model
    @Environment(\.modelContext) var modelContext
    // Read all Booking objects
    // Load all bookings immediately when the view appears
    // Watch database changes and update bookings property automatically
    @Query(sort: [SortDescriptor(\Booking.date, order: .reverse), SortDescriptor(\Booking.restaurant)]) var bookings: [Booking]
    
    var body: some View {
        List {
            // Show the list of bookings
            ForEach(bookings) { booking in
                // NavigationLink is used to create a navigation link to edit the booking
                NavigationLink(value: booking) {
                    // Below is like a table view before the user taps any booking
                    VStack(alignment: .leading) {
                        // Show the restaurant name of the booking
                        Text(booking.restaurant)
                            .font(.headline)
                            .foregroundColor(Color("ThemeColor"))
                            .fontWeight(.bold)
                        // Show the party size of the booking
                        Text("Party of \(booking.party)")
                        // Show the date and time of the booking
                        Text(booking.date.formatted(date: .long, time: .shortened))
                        // Show the location of the booking
                        Text(booking.location)
                            .font(.subheadline)
                    }
                    .foregroundColor(booking.date < Date() ? .gray : .primary)
                    .fontDesign(.monospaced)
                }
            }
            .onDelete(perform: deleteBookings)
        }
    }
    
    init(sort: SortDescriptor<Booking>, searchString: String) {
        // Initialize the query with the sort descriptor
        // Use _booking instead of booking
        _bookings = Query(filter: #Predicate {
            if searchString.isEmpty {
                // Return everything
                return true
            } else {
                // This is the best way for user-facing string searches. Returns a Boolean value indicating whether the string contains a given string by performing a case and diacritic insensitive, locale-aware search.
                // Basically checking if this booking name contains the search string text
                return $0.restaurant.localizedStandardContains(searchString)
            }
        }, sort: [sort])
    }
    
    func deleteBookings(_ indexSet: IndexSet) {
        // Loop through the indexSet and delete the bookings
        for index in indexSet {
            let booking = bookings[index]
            modelContext.delete(booking)
        }
    }
}

#Preview {
    BookingListingView(sort: SortDescriptor(\Booking.date, order: .reverse), searchString: "")
}
