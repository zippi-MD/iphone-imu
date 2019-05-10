//
//  ViewController.swift
//  swift-imu
//
//  Created by Alejandro Mendoza on 5/8/19.
//  Copyright © 2019 Alejandro Mendoza. All rights reserved.
//

import UIKit
import CoreMotion
import CoreBluetooth

class ViewController: UIViewController {
    
    @IBOutlet weak var accelerometerXLabel: UILabel!
    @IBOutlet weak var accelerometerYLabel: UILabel!
    @IBOutlet weak var accelerometerZLabel: UILabel!
    
    @IBOutlet weak var gyroRoll: UILabel!
    @IBOutlet weak var gyroYaw: UILabel!
    @IBOutlet weak var gyroPitch: UILabel!
    
    
    @IBOutlet weak var magnetoX: UILabel!
    @IBOutlet weak var magnetoY: UILabel!
    @IBOutlet weak var magnetoZ: UILabel!
    
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var relativeAltitudeLabel: UILabel!
    
    
    let motionManager = CMMotionManager()
    let altimeterManager = CMAltimeter()
    
    let updateSpeed = 0.05

    var manager: CBCentralManager!

    var myBluetoothPeripheral: CBPeripheral!
    var myCharacteristic: CBCharacteristic!

    var isMyPeripheralConnected = false

    var timer: Timer? = nil

    var accelerometerXData: Double = 0.0
    var accelerometerYData: Double = 0.0
    var accelerometerZData: Double = 0.0

    var gyroXData: Double = 0.0
    var gyroZData: Double = 0.0
    var gyroYData: Double = 0.0

    var magnetoXData: Double = 0.0
    var magnetoYData: Double = 0.0
    var magnetoZData: Double = 0.0

    var pressureData: Double = 0.0
    var relativeData: Double = 0.0

    var valuesCounter = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        manager = CBCentralManager(delegate: self, queue: nil)
        startGettingSensorsData()
        startTimer()
        // Do any additional setup after loading the view.
    }
    
    func startGettingSensorsData(){
        motionManager.accelerometerUpdateInterval = updateSpeed
        motionManager.magnetometerUpdateInterval = updateSpeed
        motionManager.gyroUpdateInterval = updateSpeed

        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { data, error in
            if let accelerometerData = data {
                DispatchQueue.main.async {
                    self.accelerometerXLabel.text = "X: \(accelerometerData.acceleration.x)"
                    self.accelerometerXData = accelerometerData.acceleration.x

                    self.accelerometerYLabel.text = "Y: \(accelerometerData.acceleration.y)"
                    self.accelerometerYData = accelerometerData.acceleration.y

                    self.accelerometerZLabel.text = "Z: \(accelerometerData.acceleration.z)"
                    self.accelerometerZData = accelerometerData.acceleration.z
                }
            }
        }

        motionManager.startGyroUpdates(to: OperationQueue.current!) { data, error in
            if let gyroData = data {
                DispatchQueue.main.async {
                    self.gyroRoll.text = "x: \(gyroData.rotationRate.x)"
                    self.gyroXData = gyroData.rotationRate.x

                    self.gyroPitch.text = "y: \(gyroData.rotationRate.y)"
                    self.gyroYData = gyroData.rotationRate.y

                    self.gyroYaw.text = "z: \(gyroData.rotationRate.z)"
                    self.gyroZData = gyroData.rotationRate.z
                }
            }
        }

        motionManager.startMagnetometerUpdates(to: OperationQueue.current!) { data, error in
            if let magnetoData = data {
                DispatchQueue.main.async {
                    self.magnetoX.text = "X: \(magnetoData.magneticField.x)"
                    self.magnetoXData = magnetoData.magneticField.x

                    self.magnetoY.text = "Y: \(magnetoData.magneticField.y)"
                    self.magnetoYData = magnetoData.magneticField.y

                    self.magnetoZ.text = "Z: \(magnetoData.magneticField.z)"
                    self.magnetoZData = magnetoData.magneticField.z
                }
            }
        }

        altimeterManager.startRelativeAltitudeUpdates(to: OperationQueue.current!) { data, error in
            if let altimeterData = data {
                DispatchQueue.main.async {
                    self.relativeAltitudeLabel.text = "relative altitude: \(altimeterData.relativeAltitude)"
                    self.pressureLabel.text = "pressure: \(altimeterData.pressure)"
                    self.pressureData = Double(altimeterData.pressure)
                    self.relativeData = Double(altimeterData.relativeAltitude)

                }
            }
        }

    }

    func startTimer(){
        if timer == nil {
            timer = Timer.scheduledTimer(
                    timeInterval: 0.05,
                    target: self,
                    selector: #selector(sendData),
                    userInfo: nil,
                    repeats: true
            )
        }
    }


    @objc func sendData(){
        let numberOfDecimals = 3
        switch valuesCounter {
        case 0:
            print("Sending Accelerometer")
            writeValue(value: "i,\(accelerometerXData.roundToDecimal(numberOfDecimals)),\(accelerometerYData.roundToDecimal(numberOfDecimals)),\(accelerometerZData.roundToDecimal(numberOfDecimals)),")
        case 1:
            print("Sending temperature")
            writeValue(value: "20,")
        case 2:
            print("Sending Pressure")
            writeValue(value: "\(pressureData.roundToDecimal(numberOfDecimals)),\(relativeData.roundToDecimal(numberOfDecimals)),")
        case 3:
            print("Sending gyro")
            writeValue(value: "\(gyroXData.roundToDecimal(numberOfDecimals)),\(gyroYData.roundToDecimal(numberOfDecimals)),\(gyroZData.roundToDecimal(numberOfDecimals)),")
        case 4:
            print("Sending magneto")
            writeValue(value: "\(magnetoXData.roundToDecimal(numberOfDecimals)),\(magnetoYData.roundToDecimal(numberOfDecimals)),\(magnetoZData.roundToDecimal(numberOfDecimals)),")
        case 5:
            print("Sending last")
            writeValue(value: "\(0.0456)\n")

        default:
            print("Out of data cases")

        }

        valuesCounter += 1

        if valuesCounter > 5 {
            valuesCounter = 0
        }

    }


}

