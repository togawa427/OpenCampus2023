//
//  ContentView.swift
//  OpenCampusLocation2023
//
//  Created by 戸川浩汰 on 2023/07/08.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: DemoBasicView()){
                    Text("オーキャン（BLEの紹介）")
                        .padding(5)
                }
                NavigationLink(destination: DemoWheelView()){
                    Text("オーキャン（車椅子への応用）")
                        .padding(5)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
