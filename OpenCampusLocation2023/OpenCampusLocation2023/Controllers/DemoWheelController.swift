//
//  DemoWheelController.swift
//  OpenCampusLocation2023
//
//  Created by 戸川浩汰 on 2023/07/08.
//

import Foundation
import CoreBluetooth

// CentralManagerは、セントラル（Apple Watch）の役割を担当するクラスです
class DemoWheelCentralController: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
    @Published var isConnected = false
    @Published var isScanning = false
    @Published var currentWheelRssi = 0
    @Published var currentPersonRssi = 0
    @Published var pastWheelRssi = 0
    @Published var pastPersonRssi = 0
    @Published var intervalSec = 0.2
    @Published var currentTime = 0
    var centralManager: CBCentralManager!
    var peripheral: CBPeripheral?
    var sumScanning = 0
    var scanTimer: Timer?
    @Published var rssisWheel:[Int] = []
    @Published var rssisPerson:[Int] = []
    let serviceUUIDString = "e7d61ea3-f8dd-49c8-8f2f-f24a0020002e"  // 見せるだけのやつ
    let serviceUUID = CBUUID(string: "0000feaa-0000-1000-8000-00805f9b34fb")  // BP108
    //let serviceUUID = CBUUID(string: "e7d61ea3-f8dd-49c8-8f2f-f24a0020002e")    // iPhoneのBLE
    //let serviceUUID = CBUUID(string: "0000180f-0000-1000-8000-00805f9b34fb")  // FSC-1301
    let characteristicUUID = CBUUID(string: "74278bda-b644-4520-8f0c-720eaf059935") // 今回はUUIDの形式ならなんでもよい
    
    let wheelBeaconIdentifyUUIDForiPad = "59A4EB13-DD22-2F71-2E52-260074C52CBB"
    let personBeaconIdentifyUUIDForiPad = "E9F944B0-8353-3AF4-0816-E2A59BB2204B"
    
    let wheelBeaconIdentifyUUIDForiPhone = "C9FF8828-C590-C4BE-FE22-83F008E7B9FA"
    let personBeaconIdentifyUUIDForiPhone = "7FB3D0FA-D610-89C4-1482-FE45364C90A5"
    
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
        //centralManager.scanForPeripherals(withServices: [serviceUUID], options: nil)
        centralManager.scanForPeripherals(withServices: nil, options: nil)
        
        // intervalSec後にスキャン停止
        scanTimer = Timer.scheduledTimer(withTimeInterval: intervalSec, repeats: false) { [weak self] _ in
            self?.stopScanning()
        }
    }
    
    
    // ペリフェラルを検出したときに呼ばれるメソッドです。サービス見つかった時に呼ばれるデリゲートメソッド
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        
        // タイヤにつけたビーコン
        if(peripheral.identifier.uuidString == wheelBeaconIdentifyUUIDForiPad){
            print("タイヤ：\(RSSI.intValue)")
            
            // 現在のRSSIの値を保存
            currentWheelRssi = RSSI.intValue
        }
        // 介護者のビーコン
        else if(peripheral.identifier.uuidString == personBeaconIdentifyUUIDForiPad){
            print("介護者：\(RSSI.intValue)")
            
            // 現在のRSSIの値を保存
            currentPersonRssi = RSSI.intValue
        }
    }
    
    // BLEの受信終了
    func stopScanning() {
        //print("受信終了")
        isScanning = false
        centralManager.stopScan()
        
        currentTime = currentTime + 1
        // RSSIの配列に入れる
        rssisWheel.append((currentWheelRssi + pastWheelRssi) / 2)
        rssisPerson.append((currentPersonRssi + pastPersonRssi) / 2)
        
        pastWheelRssi = currentWheelRssi
        pastPersonRssi = currentPersonRssi
        scanTimer?.invalidate()
        scanTimer = nil
        startScanning()
    }
}
