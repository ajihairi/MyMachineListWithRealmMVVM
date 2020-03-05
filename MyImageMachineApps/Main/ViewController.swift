//
//  ViewController.swift
//  MyImageMachineApps
//
//  Created by Hamzhya Salsatinnov Hairy on 03/03/20.
//  Copyright © 2020 Hamzhya Salsatinnov Hairy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var codeReaderBtn: BXButton!
    @IBOutlet weak var machineDataBtn: BXButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        let timeInterval = Date().timeIntervalSince1970
        
//        let machine = MachineModelData(id: Int.random(in: 0 ..< 10000), name: "Machine 1", type: "type 1", code_num: Int(timeInterval))
//
//        let container = try! Container()
//
//        try! container.write { transaction in
//            transaction.add(machine, update: false)
//        }
    }
    @IBAction func machineDataAction(_ sender: Any) {
        self.goToScreen(RoutingData().machineListScreen())
    }
    
    @IBAction func codeReaderAction(_ sender: Any) {
        self.goToScreen(RoutingData().codeScannerScreen())
    }
    
}

