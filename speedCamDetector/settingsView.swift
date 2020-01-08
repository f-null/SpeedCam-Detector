//
//  settingsView.swift
//  speedCamDetector
//
//  Created by FalconLee on 1/06//2020.
//  Copyright © 2020 FXTLiDEV. All rights reserved.
//

import SwiftUI
import XGPS

struct settingItem {
    var title: String
    var icon: String
}

struct settingsView: View {
    
    let settingsItem:[settingItem] = [
        settingItem(title: "About", icon: "text.alignleft"),
        settingItem(title: "Meter Settings", icon: "light.max")
    ]
    var body: some View {
        NavigationView{
            List{
                HStack {
                    NavigationLink(destination: about()){
                        Image(systemName: self.settingsItem[0].icon).font(.system(size: 20))
                        Text(self.settingsItem[0].title).font(.system(size: 20))
                    }
                }
                HStack {
                    NavigationLink(destination: setting()){
                        Image(systemName: self.settingsItem[1].icon).font(.system(size: 20))
                        Text(self.settingsItem[1].title).font(.system(size: 20))
                    }
                }
            }.navigationBarTitle(Text("Settings"))
        }
    }
}

struct setting: View {
    @State var isKMH = ud?.bool(forKey: "_unit") ?? true
    @State var isSoundOn = false
    @State var warnSpeed = String(format: "%.1f", ud?.double(forKey: "warnSpeed") ?? 80.0)
    @State var warnHSpeed = String(format: "%.1f", ud?.double(forKey: "warnHSpeed") ?? 100.0)
    @State var maxSpeed = String(format: "%.1f", ud?.double(forKey: "maxSpeed") ?? 160.0)

    var body: some View {
        List{
            HStack(alignment: .center){
                Toggle(isOn: self.$isKMH) {
                    VStack(alignment: .leading){
                        Text("Use km/h").font(.system(size: 15))
                        Text("Enable for km/h, desable for mph").font(.subheadline)
                    }
                    if(self.isKMH){ Text(self.setUnit(isKMH)) }
                    else { Text(self.setUnit(isKMH)) }
                }
            }.disabled(false)
            
            HStack(alignment: .center){
                Toggle(isOn: $isSoundOn) {
                    VStack(alignment: .leading){
                        Text("Sound").font(.system(size: 15))
                        Text("Toggle sound").font(.subheadline)
                    }
                }
            }.disabled(true)
            HStack(alignment: .center){
                VStack(alignment: .leading){
                    Text("Warn Speed - Mid").font(.system(size: 15))
                    Text("When speed is higher than this value, meter turns yellow.").font(.subheadline)
                }.frame(width: 200, alignment: Alignment.leading)
                TextField(self.warnSpeed, text: $warnSpeed, onEditingChanged: {
                    isEditing in
                    ud?.set(self.warnSpeed, forKey: "warnSpeed")
                    print(self.warnSpeed)
                }).keyboardType(.decimalPad)
                //.textFieldStyle(RoundedBorderTextFieldStyle()).padding()
            }
            HStack(alignment: .center){
                VStack(alignment: .leading){
                    Text("Warn Speed - High").font(.system(size: 15))
                    Text("When speed is higher than this value, meter turns red.").font(.subheadline)
                }.frame(width: 200, alignment: Alignment.leading)
                TextField(self.warnHSpeed, text: $warnHSpeed, onEditingChanged: {
                    isEditing in
                    ud?.set(self.warnHSpeed, forKey: "warnHSpeed")
                    print(self.warnHSpeed)
                }).keyboardType(.decimalPad)
                //.textFieldStyle(RoundedBorderTextFieldStyle()).padding()
            }
            HStack(alignment: .center){
                VStack(alignment: .leading){
                    Text("Max Speed").font(.system(size: 15))
                    Text("Max Speed for the meter.").font(.subheadline)
                }.frame(width: CGFloat(200), alignment: Alignment.leading)
                TextField(self.maxSpeed, text: $maxSpeed, onEditingChanged: {
                    isEditing in
                    ud?.set(self.maxSpeed, forKey: "maxSpeed")
                    print(self.maxSpeed)
                }).keyboardType(.decimalPad)
                //.textFieldStyle(RoundedBorderTextFieldStyle()).padding()
            }
        }.onAppear {
            self.updateVal()
        }
    }
    func setUnit(_ isKMH: Bool) -> String{
        if(isKMH){ ud?.set(true, forKey: "_unit") }
        else{ ud?.set(false, forKey: "_unit") }
//        print(ud?.bool(forKey: "_unit"))
        return ""
    }
    func getUnit() -> Bool{
        return self.isKMH
    }
    func updateVal(){
        self.warnSpeed = String(format: "%.1f", ud?.double(forKey: "warnSpeed") ?? 80.0)
        self.warnHSpeed = String(format: "%.1f", ud?.double(forKey: "warnHSpeed") ?? 100.0)
        self.maxSpeed = String(format: "%.1f", ud?.double(forKey: "maxSpeed") ?? 160.0)
        self.isKMH = ud?.bool(forKey: "_unit") ?? true
        print(self.isKMH)
    }
}

struct about: View {
    @State var aboutTxt_raw = "它其實是我一年多前開始撰寫研究的APP\n起因是因為我太愛飆車，但是不想被罰錢www\n當時使用的是 StoryBoard + UIKit\n以及自己撰寫的Class們(包含了動畫的UILabel、UIProgressView、UIViewControllerAnimatedTransitioning、簡化Core Location)\n預計會上架，不過因為一些Bug以及效能問題目前這個專案仍然在開發中的階段⋯⋯\n剛好這次期末 App 可以用上，順便翻新一下整個UI (￣∀￣) "
    
    @State var aboutTxt = ""
    
    var typeWriter: Timer {
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) {_ in
            if(self.aboutTxt_raw.count > 0){
                self.aboutTxt += String(self.aboutTxt_raw[self.aboutTxt_raw.startIndex])
                self.aboutTxt_raw.remove(at: self.aboutTxt_raw.startIndex)
            }
        }
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 20){
            Text("關於這個App").font(.system(size: 35)).padding()
            Text(show()).padding()
            Spacer()
        }.onAppear(
            perform: self.startType
        )
    }
    
    func show() -> String { return self.aboutTxt }
    func startType() { self.typeWriter }
}

struct settingsView_Previews: PreviewProvider {
    static var previews: some View {
        settingsView()
    }
}

func initValue(){
    if(ud?.double(forKey: "warnSpeed") == 0){
        ud?.set(80.0, forKey: "warnSpeed")
    }
    print(String(format: "%.1f", ud?.double(forKey: "warnSpeed") ?? 80.0))
    if(ud?.double(forKey: "warnHSpeed") == 0){
        ud?.set(100.0, forKey: "warnHSpeed")
    }
    print(String(format: "%.1f", ud?.double(forKey: "warnHSpeed") ?? 100.0))
    if(ud?.double(forKey: "maxSpeed") == 0){
        ud?.set(160.0, forKey: "maxSpeed")
    }
    print(String(format: "%.1f", ud?.double(forKey: "maxSpeed") ?? 160.0))
}
