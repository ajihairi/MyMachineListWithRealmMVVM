//
//  Models.swift
//  MyImageMachineApps
//
//  Created by Hamzhya Salsatinnov Hairy on 03/03/20.
//  Copyright © 2020 Hamzhya Salsatinnov Hairy. All rights reserved.
//

import RealmSwift

public class MachineModel: Object {
    
    @objc dynamic var id = 0
    @objc dynamic var name: String?
    @objc dynamic var type: String?
    var code_num = RealmOptional<Int>()
    let images = List<ImageModel>()
    override public static func primaryKey() -> String? {
        return "id"
    }
}

class ImageModel: Object {
    @objc dynamic var name: String?
    @objc dynamic var id = 0
    @objc dynamic var image: UIImage?
}
