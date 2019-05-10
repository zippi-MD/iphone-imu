//
// Created by Alejandro Mendoza on 2019-05-08.
// Copyright (c) 2019 Alejandro Mendoza. All rights reserved.
//
import UIKit
import CoreBluetooth
extension ViewController: CBCentralManagerDelegate, CBPeripheralDelegate {

    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        var msg = ""

        switch central.state {

        case .poweredOff:
            msg = "Bluetooth is Off"
        case .poweredOn:
            msg = "Bluetooth is On"
            manager.scanForPeripherals(withServices: nil, options: nil)
        case .unsupported:
            msg = "Not Supported"
        default:
            msg = "😔"

        }

        print("STATE: " + msg)
    }

    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {

        print("Name: \(peripheral.name)")

        if peripheral.name == "BT05" {

            self.myBluetoothPeripheral = peripheral
            self.myBluetoothPeripheral.delegate = self

            manager.stopScan()
            manager.connect(myBluetoothPeripheral, options: nil)

        }
    }

    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        isMyPeripheralConnected = true
        print("Conectado correctamente con: \(peripheral.name ?? "no tiene nombre...")")
        peripheral.delegate = self
        peripheral.discoverServices(nil)

    }

    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        isMyPeripheralConnected = false
        print("Se perdió la conexión con el dispositivo")
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
//here
        if let servicePeripheral = peripheral.services as [CBService]? {

            for service in servicePeripheral {

                peripheral.discoverCharacteristics(nil, for: service)

            }

        }
    }

    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
//here
        if let characterArray = service.characteristics as [CBCharacteristic]? {

            for cc in characterArray {

                if(cc.uuid.uuidString == "FFE1") {

                    myCharacteristic = cc

                    peripheral.readValue(for: cc)
                }

            }
        }

    }

    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {

        if (characteristic.uuid.uuidString == "FFE1") {

            let readValue = characteristic.value

            let value = (readValue! as NSData).bytes.bindMemory(to: Int.self, capacity: readValue!.count).pointee

            print (value)
        }
    }


    func writeValue(value: String) {

        if isMyPeripheralConnected {
            var dataToSend: Data
            let info = value
            dataToSend = info.data(using: String.Encoding.utf8)!

            if let characteristic = myCharacteristic {
                myBluetoothPeripheral.writeValue(dataToSend, for: characteristic, type: CBCharacteristicWriteType.withoutResponse)
            }
        } else {
            print("Not connected")
        }
    }





}

