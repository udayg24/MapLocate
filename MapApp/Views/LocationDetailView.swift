//
//  LocationDetailView.swift
//  MapApp
//
//  Created by Uday Gajera on 19/01/24.
//

import SwiftUI
import MapKit

struct LocationDetailView: View {
    
    @EnvironmentObject private var vm: LocationsViewModel
    
    let location: Location
    var body: some View {
        ScrollView {
            
            VStack{
               imageSection
                    .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 10)
                
                VStack(alignment: .leading, spacing: 16) {
                    titleSection
                    Divider()
                    descriptionSection
                    Divider()
                    mapLayer
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
        }
        .ignoresSafeArea()
        .background(.ultraThinMaterial)
        .overlay(alignment: .topLeading) {
            backButton
        }
    }
}

#Preview {
    LocationDetailView(location: LocationsDataService.locations.first!).environmentObject(LocationsViewModel())
}

extension LocationDetailView {
    
    private var imageSection: some View {
        TabView {
            ForEach(location.imageNames, id: \.self) { imageName in
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? nil : UIScreen.main.bounds.width)
                    .clipped()
            }
        }
        .frame(height: 500)
        .tabViewStyle(PageTabViewStyle())
    }
    
    private var titleSection: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            Text(location.name)
                .font(.largeTitle)
                .fontWeight(.semibold)
            Text(location.cityName)
                .font(.title3)
                .foregroundColor(.secondary)
        }
    }
    
    private var descriptionSection: some View {
        
        VStack(alignment: .leading, spacing: 8) {
            Text(location.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            if let url = URL(string: location.link) {
                Link("Read more on Wikipedia", destination: url)
                    .font(.headline)
                    .tint(.blue)
            }
            
        }
    }
    
    private var mapLayer: some View {
        
         Map(coordinateRegion: .constant(MKCoordinateRegion(center: location.coordinates, 
                                                            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01) )),
            annotationItems: [location]) { location in
            MapAnnotation(coordinate: location.coordinates) {
                LocationMapAnnotationView()
                    .shadow(radius: 30)
            }
        }
            .aspectRatio(1, contentMode: .fit)
            .cornerRadius(30)
            .allowsHitTesting(false)
        
//        Map(coordinateRegion: $vm.mapRegion)
//        return Map(coordinateRegion: $vm.mapRegion,
//            annotationItems: vm.locations,
//            annotationContent: { location in
//            MapAnnotation(coordinate: location.coordinates) {
//                LocationMapAnnotationView()
//                    .scaleEffect(vm.mapLocation == location ? 1 : 0.7)
//                    .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
//                    .onTapGesture {
//                        vm.showNextLocation(location: location)
//                    }
//            }
//        })
   }
       
    private var backButton: some View {
        Button {
            vm.sheetLocation = nil
        } label: {
            Image(systemName: "xmark")
                .font(.headline)
                .padding(16)
                .foregroundColor(.primary)
                .background(.thickMaterial)
                .cornerRadius(10)
                .shadow(radius: 4)
                .padding()
        }

    }
        
}
