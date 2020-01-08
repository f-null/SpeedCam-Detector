//
//  ContentView.swift
//  speedCamDetector
//
//  Created by FalconLee on 1/05//2020.
//  Copyright © 2020 FXTLiDEV. All rights reserved.
//

import CoreLocation
import SwiftUI
import Foundation
import AVFoundation

let lm = CLLocationManager()
let ud = UserDefaults(suiteName: "FXCLi.XHUD")


struct ContentView: View {
    init() {
//        UITabBar.appearance().unselectedItemTintColor = UIColor.white
//        UITabBar.appearance().tintColor = UIColor.green
    }
    var body: some View {
        TabView{
            mainMeter().tabItem{
                VStack{
                    Image(systemName: "light.max")
                    Text("METER")
                }
            }
            mapView().tabItem{
                VStack{
                    Image(systemName: "map")
                    Text("MAP")
                }
            }
            settingsView().tabItem{
                VStack{
                    Image(systemName: "hammer")
                    Text("SETTINGS")
                }
            }
            }.onAppear(perform: rquAuth).onAppear(perform: readJson)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func rquAuth(){
    initValue()
    switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            lm.requestWhenInUseAuthorization()
            break
        case .denied, .restricted:
            let alert = UIAlertController(title: "Location service not allowed.", message: "Please allow location service to use this app.", preferredStyle: .alert)
            let ok = UIAlertAction(title: "ok", style: .default, handler: nil)
            alert.addAction(ok)
            break
        case .authorizedWhenInUse, .authorizedAlways:
            break
        default:
            break
    }
}

func loadSettings(){
    
}
