//
//  LocationsView.swift
//  MapApp
//
//  Created by Uday Gajera on 19/01/24.
//

import SwiftUI
import MapKit

struct LocationsView: View {

    @EnvironmentObject private var vm: LocationsViewModel
    let maxWidthForIpda: CGFloat = 700
    
    var body: some View {
        ZStack{
            mapLayer.ignoresSafeArea()
            
            VStack(spacing:0){
                
                header
                .padding()
                .frame(maxWidth: maxWidthForIpda)
                Spacer()
                
                locationsPreviewStack
               
            }
        }
        .sheet(item: $vm.sheetLocation, onDismiss: nil) { location in
            LocationDetailView(location: location)
        }
    }
}

#Preview {
    LocationsView()
        .environmentObject(LocationsViewModel())
}

extension LocationsView {
    
    private var header: some View {
        VStack {
            
            Button(action: vm.toggleLocationsList) {
                Text(vm.mapLocation.name + "," + vm.mapLocation.cityName)
                    .font(.title2)
                    .fontWeight(.black)
                    .foregroundColor(.primary)
                    .frame(height: 55)
                .frame(maxWidth: .infinity)
                .animation(.none, value: vm.mapLocation)
                .overlay(alignment: .leading) {
                    Image(systemName: "arrow.down")
                        .font(.headline)
                        .foregroundColor(.primary)
                        .padding()
                        .rotationEffect(Angle(degrees: vm.showLocationsList ? 180 : 0))
                }
            }
            
            if vm.showLocationsList{
                LocationsListView()
            }
        }
        .background(.thickMaterial)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 15)
    }
    
    private var mapLayer: some View {
        Map(coordinateRegion: $vm.mapRegion)
        return Map(coordinateRegion: $vm.mapRegion,
            annotationItems: vm.locations,
            annotationContent: { location in
            MapAnnotation(coordinate: location.coordinates) {
                LocationMapAnnotationView()
                    .scaleEffect(vm.mapLocation == location ? 1 : 0.7)
                    .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                    .onTapGesture {
                        vm.showNextLocation(location: location)
                    }
            }
        })
    }
    
    private var locationsPreviewStack: some View {
        
        ZStack {
            ForEach(vm.locations) { location in
                
                if vm.mapLocation == location {
                    LocationPreviewView(location: location)
                        .shadow(color: Color.black.opacity(0.3),
                                radius: 20, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/)
                        .padding()
                        .frame(maxWidth: maxWidthForIpda)
                        .frame(maxWidth: .infinity)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .leading)))
                }

            }
        }
    }
    
}
