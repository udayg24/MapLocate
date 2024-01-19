//
//  MapAppApp.swift
//  MapApp
//
//  Created by Uday Gajera on 19/01/24.
//

import SwiftUI

@main
struct MapAppApp: App {
    
    @StateObject private var vm = LocationsViewModel()
    
    var body: some Scene {
        WindowGroup {
            LocationsView()
                .environmentObject(vm)
        }
    }
}
