//
// Created by Alejandro Mendoza on 2019-05-09.
// Copyright (c) 2019 Alejandro Mendoza. All rights reserved.
//

import Foundation

extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}