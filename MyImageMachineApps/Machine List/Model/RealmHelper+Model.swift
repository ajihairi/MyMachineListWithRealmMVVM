//
//  Models.swift
//  MyImageMachineApps
//
//  Created by Hamzhya Salsatinnov Hairy on 03/03/20.
//  Copyright © 2020 Hamzhya Salsatinnov Hairy. All rights reserved.
//

import RealmSwift
import UIKit
import ObjectMapper
import SwiftyJSON

class MachineModelObject: Object {
    @objc dynamic var id = 0
    @objc dynamic var name: String = ""
    @objc dynamic var type: String = ""
    @objc dynamic var code_num = 0
    var images = List<ImageModelObject>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class ImageModelObject: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var id = 0
    @objc dynamic var imageString: String = ""
    var imageData: UIImage?
}

struct ImageModel {
    var name: String?
    var id: Int?
    var imageString: String?
    var imageData: UIImage?
}




