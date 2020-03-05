//
//  Binary + Extension.swift
//  MyImageMachineApps
//
//  Created by Hamzhya Salsatinnov Hairy on 05/03/20.
//  Copyright © 2020 Hamzhya Salsatinnov Hairy. All rights reserved.
//

import Foundation
extension BinaryInteger {
    var digits: [Int] {
        return String(describing: self).compactMap { Int(String($0)) }
    }
}
