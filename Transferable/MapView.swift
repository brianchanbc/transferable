//
//  MapView.swift
//  Transferable
//
//  Created by Brian on 4/3/2024.
//

import SwiftUI
import MapKit
import Foundation

// MapView interface which shows the map and search results
struct MapView: UIViewRepresentable {
    // searchString is the restaurant textfield input
    @Binding var searchString: String
    // address is the address of the restaurant
    @Binding var address: String

    // Coordinator class to handle the map view
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        var timer: Timer?
        var lastSearchString: String?

        init(_ parent: MapView) {
            self.parent = parent
        }

        // performSearch function to search for the restaurant
        func performSearch(mapView: MKMapView) {
            // Create a geocoder to convert the address to a location
            let geocoder = CLGeocoder()
            // If the address is empty, use the searchString, otherwise use the address
            let ss = parent.address.isEmpty ? parent.searchString : parent.address

            // Geocode the address
            geocoder.geocodeAddressString(ss) { (placemarks, error) in
                // Trap any errors
                guard let placemark = placemarks?.first, let location = placemark.location else {
                    print("Error: \(error?.localizedDescription ?? "Unknown error").")
                    return
                }
                
                // Create a search request
                let searchRequest = MKLocalSearch.Request()
                // Set the region to the location
                searchRequest.region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
                // Set the natural language query to the searchString
                searchRequest.naturalLanguageQuery = ss
                
                // Perform the search
                let search = MKLocalSearch(request: searchRequest)
                print("Searching for \(ss)...")

                // Handle the search response
                search.start { response, error in
                    // Trap any errors
                    guard let response = response else {
                        print("Error: \(error?.localizedDescription ?? "Unknown error").")
                        return
                    }
                    
                    // Adjust the span to zoom in closer
                    let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                    let region = MKCoordinateRegion(center: response.boundingRegion.center, span: span)
                    mapView.setRegion(region, animated: true)
                    print("Setting region")

                    // Remove old annotations
                    let oldAnnotations = mapView.annotations
                    mapView.removeAnnotations(oldAnnotations)
                    print("Removing old annotation")
                    
                    // Add new annotation
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = response.boundingRegion.center
                    annotation.title = self.parent.searchString
                    mapView.addAnnotation(annotation)
                    print("Adding new annotation")
                    
                    // Get the address and update the binding
                    if let placemark = response.mapItems.first?.placemark {
                        let thoroughfare = [placemark.subThoroughfare, placemark.thoroughfare]
                            .compactMap { $0 }
                            .joined(separator: " ")
                        let adminAreaAndPostalCode = [placemark.administrativeArea, placemark.postalCode]
                            .compactMap { $0 }
                            .joined(separator: " ")
                        let address = [
                            thoroughfare,
                            placemark.locality,
                            adminAreaAndPostalCode,
                            placemark.country
                        ].compactMap { $0 }.joined(separator: ", ")
                        print("Found address: \(address)")
                        self.parent.address = address
                    }
                }
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        // Create a new Coordinator
        Coordinator(self)
    }

    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        // Create a new MKMapView
        print("Creating map view")
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {
        // If the search string has changed, perform the search
        if context.coordinator.lastSearchString != searchString || context.coordinator.lastSearchString != address {
            print("Search string changed: \(searchString)")
            context.coordinator.timer?.invalidate()
            context.coordinator.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { _ in
                context.coordinator.performSearch(mapView: uiView)
            }
            context.coordinator.lastSearchString = searchString
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(searchString: .constant("Valois"), address: .constant("1518 E 53rd St Chicago, IL 60615 United States"))
    }
}
