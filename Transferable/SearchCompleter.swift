//
//  SearchBar.swift
//  Transferable
//
//  Created by Brian on 4/3/2024.
//

import Foundation
import SwiftUI
import MapKit

// SearchCompleter class is used for search competition for locations in EditBookingView
class SearchCompleter: NSObject, MKLocalSearchCompleterDelegate, ObservableObject {
    // results is an array to hold the search results
    @Published var results: [MKLocalSearchCompletion] = []
    // completer is an instance of MKLocalSearchCompleter
    private var completer: MKLocalSearchCompleter

    override init() {
        // Initialize the completer
        print("SearchCompleter initialized")
        completer = MKLocalSearchCompleter()
        super.init()
        completer.delegate = self
    }

    func search(query: String) {
        // Set the query fragment to the search query
        print("Search query: \(query)")
        completer.queryFragment = query
    }

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        // Update the results array with the search results
        self.results = completer.results
        print("Search results: \(results)")
    }

    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        // handle error
        print(error.localizedDescription)
    }
}
