//
//  DemoWheelView.swift
//  OpenCampusLocation2023
//
//  Created by 戸川浩汰 on 2023/07/08.
//

import Foundation

import SwiftUI
import CoreBluetooth

// Centralを見るためのContentView
struct DemoWheelView: View {
    
    @StateObject var centralManager = DemoWheelCentralController()
    
    var body: some View {
        // graph
        ChartDualView(yWheel:centralManager.rssisWheel,yPerson:centralManager.rssisPerson, intervalSec:centralManager.intervalSec)
    }
}
