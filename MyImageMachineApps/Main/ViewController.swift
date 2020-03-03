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
    }
    @IBAction func machineDataAction(_ sender: Any) {
        self.goToScreen(RoutingData().machineListScreen())
    }
    
    @IBAction func codeReaderAction(_ sender: Any) {
        self.goToScreen(RoutingData().codeScannerScreen())
    }
    
}

