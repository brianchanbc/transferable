//
//  Booking.swift
//  Transferable
//
//  Created by Brian on 3/3/2024.
//

import Foundation
import SwiftData

// Macro to enable loading and saving Booking objects using SwiftData database
// This allows SwiftData to detect when we change properties and automatically save them
// Also does lazy loading data to save memory
@Model
class Booking {
    var restaurant: String
    var party: Int
    var date: Date
    var location: String
    
    init(restaurant: String = "", party: Int = 2, date: Date = .now, location: String = "") {
        self.restaurant = restaurant
        self.party = party
        self.date = date
        self.location = location
    }
}
