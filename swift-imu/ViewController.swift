//
//  ViewController.swift
//  swift-imu
//
//  Created by Alejandro Mendoza on 5/8/19.
//  Copyright © 2019 Alejandro Mendoza. All rights reserved.
//

import UIKit
import CoreMotion

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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        startGettingSensorsData()
        // Do any additional setup after loading the view.
    }
    
    func startGettingSensorsData(){
        motionManager.accelerometerUpdateInterval = updateSpeed
        motionManager.magnetometerUpdateInterval = updateSpeed
        motionManager.deviceMotionUpdateInterval = updateSpeed

        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { data, error in
            if let accelerometerData = data {
                DispatchQueue.main.async {
                    self.accelerometerXLabel.text = "X: \(accelerometerData.acceleration.x)"
                    self.accelerometerYLabel.text = "Y: \(accelerometerData.acceleration.y)"
                    self.accelerometerZLabel.text = "Z: \(accelerometerData.acceleration.z)"
                }
            }
        }

        motionManager.startDeviceMotionUpdates(to: OperationQueue.current!) { motion, error in
            if let motionData = motion {
                DispatchQueue.main.async {
                    self.gyroRoll.text = "Roll: \(motionData.attitude.roll)"
                    self.gyroPitch.text = "Pitch: \(motionData.attitude.pitch)"
                    self.gyroYaw.text = "Yaw: \(motionData.attitude.yaw)"
                }
            }
        }

        motionManager.startMagnetometerUpdates(to: OperationQueue.current!) { data, error in
            if let magnetoData = data {
                DispatchQueue.main.async {
                    self.magnetoX.text = "X: \(magnetoData.magneticField.x)"
                    self.magnetoY.text = "Y: \(magnetoData.magneticField.y)"
                    self.magnetoZ.text = "Z: \(magnetoData.magneticField.z)"
                }
            }
        }

        altimeterManager.startRelativeAltitudeUpdates(to: OperationQueue.current!) { data, error in
            if let altimeterData = data {
                DispatchQueue.main.async {
                    self.relativeAltitudeLabel.text = "relative altitude: \(altimeterData.relativeAltitude)"
                    self.pressureLabel.text = "pressure: \(altimeterData.pressure)"

                }
            }
        }

    }


}

