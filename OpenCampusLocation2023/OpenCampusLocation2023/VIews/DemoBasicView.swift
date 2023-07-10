//
//  DemoBasicView.swift
//  OpenCampusLocation2023
//
//  Created by 戸川浩汰 on 2023/07/08.
//

import Foundation

import SwiftUI
import CoreBluetooth

// Centralを見るためのContentView
struct DemoBasicView: View {
    
    @StateObject var centralManager = DemoBasicCentralController()
    
    var body: some View {
        // graph
        ChartView(y:centralManager.rssis, intervalSec:centralManager.intervalSec, countScanning: centralManager.countScanning)
    }
}
