//
//  RoutingData.swift
//  MyImageMachineApps
//
//  Created by Hamzhya Salsatinnov Hairy on 03/03/20.
//  Copyright © 2020 Hamzhya Salsatinnov Hairy. All rights reserved.
//

import Foundation
import UIKit

public class RoutingData {
    
    public func machineListScreen() -> UIViewController {
        let machineList = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "MachineListViewController") as! MachineListViewController
        return machineList
    }
    
    public func codeScannerScreen() -> UIViewController {
        let codeScanner = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "CodeScannerViewController") as! CodeScannerViewController
        return codeScanner
    }
    
    public func addMachineScreen() -> UIViewController {
        let addView = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "AddMachineViewController") as! AddMachineViewController
        return addView
    }
}
