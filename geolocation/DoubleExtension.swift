//
//  DoubleExtension.swift
//  geolocation
//
//  Created by Goh Chun Lin on 6/5/20.
//  Copyright © 2020 GCL Project. All rights reserved.
//

import Foundation

extension Double {
    func round(to places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
