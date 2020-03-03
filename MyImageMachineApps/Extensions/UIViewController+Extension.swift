//
//  UIViewController+Extension.swift
//  MyImageMachineApps
//
//  Created by Hamzhya Salsatinnov Hairy on 03/03/20.
//  Copyright © 2020 Hamzhya Salsatinnov Hairy. All rights reserved.
//

import Foundation
import UIKit


extension UIViewController {
    func goToScreen(_ screen: UIViewController) {
        self.navigationController?.pushViewController(screen, animated: true)
    }
}
