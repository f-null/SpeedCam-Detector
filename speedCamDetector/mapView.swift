//
//  mapView.swift
//  speedCamDetector
//
//  Created by FalconLee on 1/06//2020.
//  Copyright © 2020 FXTLiDEV. All rights reserved.
//

import SwiftUI
import MapKit
import XGPS

struct mapView: UIViewRepresentable {
    /**
     - Description - Replace the body with a make UIView(context:) method that creates and return an empty MKMapView
     */
    
    func makeCoordinator() -> mapCoordinator {
        mapCoordinator(self)
    }

    func makeUIView(context: Context) -> MKMapView{
        MKMapView(frame: .zero)
    }
    
    func updateUIView(_ view: MKMapView, context: Context){
        let coordinate = CLLocationCoordinate2D(latitude: XGPSlib().getLatitude(lm), longitude: XGPSlib().getLongitude(lm))
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        view.setRegion(region, animated: true)
//        view.mapType = MKMapType.hybrid
        
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = CLLocationCoordinate2D(latitude: XGPSlib().getLatitude(lm), longitude: XGPSlib().getLongitude(lm))
//
//        annotation.title = "You are here"
//
//        view.addAnnotation(annotation)
        
        view.delegate = context.coordinator

        for x in dataList{
            let doubleLim = Double((x["limit"]) as? String ?? "0") ?? 0.0
            let doubleLo = Double((x["Longitude"]) as? String ?? "0") ?? 0.0
            let doubleLa = Double((x["Latitude"]) as? String ?? "0") ?? 0.0
            let direct = x["direct"] as? String ?? ""
            let address = x["Address"] as? String ?? ""
            let type = x["type"] as? String ?? ""

            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: doubleLa, longitude: doubleLo)

            annotation.title = String(format: "%.0f", doubleLim) + "公里"
            annotation.subtitle = "\(address) | \(direct) | \(type)"
            
            view.addAnnotation(annotation)
        }

    }

}

struct mapView_Previews: PreviewProvider {
    static var previews: some View {
        mapView()
    }
}

