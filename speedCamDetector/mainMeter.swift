//
//  mainMeter.swift
//  speedCamDetector
//
//  Created by FalconLee on 1/05//2020.
//  Copyright © 2020 FXTLiDEV. All rights reserved.
//

import CoreLocation
import SwiftUI
import Foundation
import AVFoundation
import XGPS

struct speedCam: Codable {
    var address: String
    var direction: String
    var limit: Int
    var lat, lng: Double
}

var dataList = [NSDictionary]()
var cLim = -1.0

var warnSpeed = ud?.double(forKey: "warnSpeed") ?? 80.0
var warnHSpeed = ud?.double(forKey: "warnHSpeed") ?? 100.0
var maxSpeed = ud?.double(forKey: "maxSpeed") ?? 160.0
var iskmh = ud?.bool(forKey: "_unit") ?? true

class warnSpeedObs: ObservableObject {
    @Published var warnSpeed: Double = ud?.double(forKey: "warnSpeed") ?? 80.0
}
class warnHSpeedObs: ObservableObject {
    @Published var warnHSpeed: Double = ud?.double(forKey: "warnHSpeed") ?? 80.0
}
class maxSpeedObs: ObservableObject {
    @Published var maxSpeed: Double = ud?.double(forKey: "maxSpeed") ?? 80.0
}

struct mainMeter: View {
    
    @State var spd = 0.0
    @State var la = 0.0
    @State var lo = 0.0
    @State var clr = Color.white
    @State var cLimTxt: Double = -1
    @State var isAddingCam: String = ""
    
//    @Binding var progress: CGFloat

    var timer: Timer {
        Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) {_ in
            
            if(iskmh){
                self.spd = XGPSlib().getSpeed(lm, .kmh)
            }else{
                self.spd = XGPSlib().getSpeed(lm, .mph)
            }
//            self.spd += 1
            self.la = XGPSlib().getLatitude(lm)
            self.lo = XGPSlib().getLongitude(lm)
            self.cLimTxt = cLim
//            self.progress = CGFloat(self.spd)
        }
    }
    
//    @EnvironmentObject var warnSpeed: warnSpeedObs
    
    var body: some View {
        
        VStack(spacing: 140){
            Text("--")
            VStack(spacing: 20){
                HStack(alignment: .lastTextBaseline, spacing: 10){
                    Text(updateSpeed()).foregroundColor(updateSpeedColor()).font(.system(size: 70)).onAppear(perform: {_ = self.timer})
                    ZStack{
                        VStack(spacing: -10){
                            Text(updateLim()).foregroundColor(updateLimColor()).font(.system(size: 35))
                            if(iskmh){
                                Text("km/h").font(.system(size: 35))
                            }else{
                                Text("mph").font(.system(size: 35))
                            }
                        }
                    }

                }
                ZStack(alignment: .leading){
                    Rectangle()
                       .foregroundColor(Color.gray)
                       .opacity(0.3)
                       .frame(width: 250, height: 4.0)
                    Rectangle()
                       .foregroundColor(updateSpeedBarColor())
                        .frame(width: updateSpeedBar(), height: 4.0).animation(.linear(duration: 0.5))
                    HStack{
                        Rectangle()
                        .foregroundColor(Color.gray)
                            .frame(width: 2.5, height: 16.0).offset(x: meterPosition(250, 0, 0) - 2.5, y: 0)
                        Rectangle()
                        .foregroundColor(Color.gray)
                            .frame(width: 2.5, height: 16.0).offset(x: meterPosition(250, maxSpeed, warnSpeed) - 5, y: 0)
                        Rectangle()
                        .foregroundColor(Color.gray)
                            .frame(width: 2.5, height: 16.0).offset(x: meterPosition(250, maxSpeed, warnHSpeed) - 5, y: 0)
                        Rectangle()
                        .foregroundColor(Color.gray)
                            .frame(width: 2.5, height: 16.0).offset(x: 220 - 2.5, y: 0)
                    }
                }
                HStack(alignment: .bottom, spacing: 10){
                    Text(updateCord()).font(.system(size: 20))
                }
            }
//            Text(isAddingCamTitle())
            Text(updateCamDt()).foregroundColor(updateCamColor()).font(.system(size: 20))
        }
        .onAppear( perform: {
            self.updateVal()
            print(warnSpeed)
            print(warnHSpeed)
            print(maxSpeed)
            }
        ).gesture(
            DragGesture(minimumDistance: 50)
            .onEnded { _ in
                
                var camDct = [
                  "CityName": "",
                  "RegionName": "",
                  "Address": "新增測速照相",
                  "DeptNm": "",
                  "BranchNm": "",
                  "Longitude": "",
                  "Latitude": "",
                  "direct": "",
                  "limit": "",
                  "type": "定點測速"
                ]
                
                camDct["Longitude"] = "\(self.lo)"
                camDct["Latitude"] = "\(self.la)"
                
                dataList.append(camDct as NSDictionary)
                
//                print(dataList)
                
                
//                self.isAddingCam = "新增成功！"
            }
        )
        .statusBar(hidden: true)
        .edgesIgnoringSafeArea(.all)

    }
    
    func isAddingCamTitle() -> String{
        return self.isAddingCam
    }
    
    func meterPosition(_ maxWidth: Double, _ maxValue: Double, _ targetValue: Double) -> CGFloat{ return CGFloat(maxWidth * (targetValue / maxSpeed)) }
    func updateSpeed() -> String{ return "\(spd)" }
    func updateSpeedBar() -> CGFloat{
        if( spd <= maxSpeed ){ return CGFloat(250 * (spd / maxSpeed)) }
        else { return CGFloat(250 * (maxSpeed / maxSpeed)) }
    }
    func updateSpeedBarColor() -> Color{
        if(spd > warnHSpeed){ return .red }
        else if(spd > warnSpeed) { return .yellow }
        return .green
    }
    func updateLim() -> String{
        if(cLimTxt != -1){ return "<\(cLimTxt)" }
        return ""
    }
    func updateLimColor() -> Color{
        if(cLimTxt != -1){ return .red }
        return .white
    }
    func updateSpeedColor() -> Color{
        if(spd > cLim && cLim != -1){ return .red }
        if(spd > warnHSpeed){ return .red }
        else if(spd > warnSpeed) { return .yellow }
        return .white
    }
    func updateCamColor() -> Color{
        if(cLim != -1){ return .red; }
        return .white;
    }
    func updateVal(){
        warnSpeed = ud?.double(forKey: "warnSpeed") ?? 80.0
        warnHSpeed = ud?.double(forKey: "warnHSpeed") ?? 100.0
        maxSpeed = ud?.double(forKey: "maxSpeed") ?? 160.0
        iskmh = ud?.bool(forKey: "_unit") ?? true
    }
    func updateCord() -> String{ return "\(la) | \(lo)" }
    func updateCamDt() -> String{
        for x in dataList{
            let doubleLim = Double((x["limit"]) as? String ?? "0") ?? 0.0
            let doubleLo = Double((x["Longitude"]) as? String ?? "0") ?? 0.0
            let doubleLa = Double((x["Latitude"]) as? String ?? "0") ?? 0.0
            let direct = x["direct"] as? String ?? ""
            let address = x["Address"] as? String ?? ""
            let acc: Double = 0.0018
//            var lastGuard: String!

            if(doubleLo + acc >= lo && doubleLo - acc <= lo){
                if(doubleLa + acc >= la && doubleLa - acc <= la){
//                    lastGuard = address
                    cLim = doubleLim
                    return "\(address) | \(direct)"
//                    if lastGuard != address{
//                    }
//                    if(doubleLim == 0){
//                    }
//                    else if(doubleLim <= spd){
//                    }
//                    else{
//                    }
//                    break
                }
            }
            else{
                cLim = -1
            }
        }
        return "沒有測速照相"
    }
}

func readJson(){
    readJsonAPI()
//    let path = Bundle.main.path(forResource: "data", ofType: "json")
//    do{
//        let data = try Data(contentsOf: URL(fileURLWithPath: path!), options: .mappedIfSafe)
//        let jsonR = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
//        let dataCut = jsonR as? Dictionary<String, AnyObject>
//        let d2 = dataCut!["result"] as? Dictionary<String, AnyObject>
//        let d3 = d2!["records"] as! NSArray
//
//        for i in d3{
//            let xx = i as! NSDictionary
//            dataList.append(xx)
//        }
//
//    }catch{
//        print("error")
//    }
}


func readJsonAPI(){
    let url = URL(string: "https://od.moi.gov.tw/api/v1/rest/datastore/A01010000C-000674-011")!
    let request = URLRequest(url: url)

    let task = URLSession.shared.dataTask(with: request) { data, response, error in
    guard let data = data else {
//        print("request failed \(error)")
        readLocalJson()
        return
    }

    do {
        let jsonR = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
        let dataCut = jsonR as? Dictionary<String, AnyObject>
        let d2 = dataCut!["result"] as? Dictionary<String, AnyObject>
        let d3 = d2!["records"] as! NSArray

        for i in d3{
            var xx = i as! Dictionary<String, Any>
            xx["type"] = "定點測速"
            dataList.append(xx as! NSDictionary)
        }
        
        }catch let parseError {
        print("parsing error: \(parseError)")
        let responseString = String(data: data, encoding: .utf8)
//            print("raw response: \(responseString)")
        }
    }
    task.resume()
}


func readLocalJson(){
    print(readLocalJson)
    let path = Bundle.main.path(forResource: "data", ofType: "json")
    do{
        let data = try Data(contentsOf: URL(fileURLWithPath: path!), options: .mappedIfSafe)
        let jsonR = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
        let dataCut = jsonR as? Dictionary<String, AnyObject>
        let d2 = dataCut!["result"] as? Dictionary<String, AnyObject>
        let d3 = d2!["records"] as! NSArray

        for i in d3{
            let xx = i as! NSDictionary
            dataList.append(xx)
        }

    }catch{
        print("error")
    }
}
