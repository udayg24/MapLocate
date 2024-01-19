//
//  LocationsViewModel.swift
//  MapApp
//
//  Created by Uday Gajera on 19/01/24.
//

import Foundation
import MapKit
import SwiftUI

class LocationsViewModel: ObservableObject {
    
    //all loaded locations
    @Published var locations: [Location]
    //Current location on map
    @Published var mapLocation: Location {
        didSet {
            updateMapRegion(location: mapLocation)
        }
    }
    
    // current region on map
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
    
    //show list of locations
    @Published var showLocationsList: Bool = false
    
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    
    //show location detail via sheet
    @Published var sheetLocation: Location? = nil
    
    init(){
        let locations = LocationsDataService.locations
        self.locations = locations
        self.mapLocation = locations.first!
        self.updateMapRegion(location: locations.first!)
    }

    private func updateMapRegion(location: Location) {
        withAnimation(.easeInOut) {
            mapRegion = MKCoordinateRegion(center: location.coordinates,
                                           span: mapSpan)
        }
        
        withAnimation(.easeInOut) {
            mapRegion = MKCoordinateRegion(center: location.coordinates,
                                           span: mapSpan)
        }
        
    }
    
     func toggleLocationsList() {
        withAnimation(.easeInOut) {
            showLocationsList = !showLocationsList
        }
    }
    
    func showNextLocation(location: Location) {
        withAnimation(.easeInOut) {
            mapLocation = location
            showLocationsList = false
        }
    }
    
    func nextButtonPressed(){
        
        //get the current index
        guard let currentIndex = locations.firstIndex (where:{ $0 == mapLocation })
        else {
            return
        }
        
        //check if current index is valid
        let nextIndex = currentIndex + 1
        guard locations.indices.contains(nextIndex) else {
            //next index is not valid
            //restart from 0
            guard let firstLocation = locations.first else {return}
            showNextLocation(location: firstLocation)
            return
        }
        
        //next index is valid
        let nextLocation = locations[nextIndex]
        showNextLocation(location: nextLocation)
    }
}
