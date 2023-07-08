//
//  DemoBasicController.swift
//  OpenCampusLocation2023
//
//  Created by 戸川浩汰 on 2023/07/08.
//

import Foundation
import CoreBluetooth

// CentralManagerは、セントラル（Apple Watch）の役割を担当するクラスです
class DemoBasicCentralController: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    @Published var isConnected = false
    @Published var isScanning = false
    @Published var currentRssi = 0
    @Published var pastRssi = 0
    @Published var intervalSec = 0.2
    @Published var currentTime = 0
    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral?
    var sumScanning = 0
    var scanTimer: Timer?
    @Published var rssis:[Int] = []
    let serviceUUID = CBUUID(string: "0000180f-0000-1000-8000-00805f9b34fb")  // FSC-1301
    
    let beaconIdentifyUUIDForiPad = "998330A6-702C-B1EA-2C10-B107B9116B96"
    let beaconIdentifyUUIDForiPhone = "6FFD20E4-6260-944E-5A75-9D3EA9063815"
    
    @Published var isOneMeterAway = false
    
    
    var rssiUpdateTimer: Timer?
    
    
    
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        print("初期化(Central)")
    }
    
    //centralManagerDidUpdateStateメソッドで、セントラルマネージャの状態(central.state)が変更されたことを検知します。
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("セントラルマネージャの状態の変更を検知")
        print("state: \(central.state)")
        if central.state == .poweredOn {
            print("Central Manager is powered on.")
            // 将来的にここにスキャン開始処理を書く（power offだとスキャン不可なため）
            startScanning()
        } else {
            print("Central Manager is not powered on.")
        }
    }
    
    //startScanningメソッドで、指定されたサービスUUIDを持つペリフェラルをスキャンします。
    func startScanning() {
        print("スキャン開始")
        isScanning = true
        centralManager.scanForPeripherals(withServices: [serviceUUID], options: nil)
        //centralManager.scanForPeripherals(withServices: nil, options: nil)
        
        // intervalSec後にスキャン停止
        scanTimer = Timer.scheduledTimer(withTimeInterval: intervalSec, repeats: false) { [weak self] _ in
            self?.stopScanning()
        }
    }
    
    
    // ペリフェラルを検出したときに呼ばれるメソッドです。サービス見つかった時に呼ばれるデリゲートメソッド
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {

        print(RSSI.intValue)
        print(peripheral.identifier.uuidString)
        
        //FCS-1301でやる場合
        if(peripheral.identifier.uuidString == beaconIdentifyUUIDForiPad){
            //print("ペリフェラル（送信機）を検出したよ")
            let uuid = peripheral.identifier.uuidString
            //let name = peripheral.name
            print(RSSI.intValue)
            print(uuid)
            //print(advertisementData[CBAdvertisementDataOverflowServiceUUIDsKey])
            
            
            if let serviceUUIDs = advertisementData[CBAdvertisementDataServiceUUIDsKey] as? [CBUUID] {
                for uuid in serviceUUIDs {
                    print("Service UUID: \(uuid.uuidString)")
                }
            }
            self.peripheral = peripheral
            
            // 現在のRSSIの値を保存
            currentRssi = RSSI.intValue
        }
        
        // BP108でやる場合
        //        if(peripheral.identifier.uuidString == "FDF8AF2F-D064-46CB-29F7-688078606E16"){
        //            //print("ペリフェラル（送信機）を検出したよ")
        //            let uuid = peripheral.identifier.uuidString
        //            //let name = peripheral.name
        //            print(RSSI.intValue)
        //            print(uuid)
        //            //print(advertisementData[CBAdvertisementDataOverflowServiceUUIDsKey])
        //
        //
        //            if let serviceUUIDs = advertisementData[CBAdvertisementDataServiceUUIDsKey] as? [CBUUID] {
        //                for uuid in serviceUUIDs {
        //                    print("Service UUID: \(uuid.uuidString)")
        //                }
        //            }
        //            self.peripheral = peripheral
        //
        //            // 現在のRSSIの値を保存
        //            currentRssi = RSSI.intValue
        //        }
    }
    
    // BLEの受信終了
    func stopScanning() {
        //print("受信終了")
        isScanning = false
        centralManager.stopScan()
        
        currentTime = currentTime + 1
        // RSSIの配列に入れる
        rssis.append((currentRssi + pastRssi) / 2)
        
        pastRssi = currentRssi
        scanTimer?.invalidate()
        scanTimer = nil
        startScanning()
    }
}

