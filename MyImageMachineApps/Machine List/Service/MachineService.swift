//
//  MachineService.swift
//  MyImageMachineApps
//
//  Created by Hamzhya Salsatinnov Hairy on 03/03/20.
//  Copyright © 2020 Hamzhya Salsatinnov Hairy. All rights reserved.
//

import Foundation
import RealmSwift

class MachineService: MachineListProtocol {
    
    private var realm = try! Realm()
    
    func getMachineList(type: Object.Type, success: @escaping (Array<MachineModelObject>) -> (), failure: @escaping (String) -> ()) {
        if type == MachineModelObject.self {
            let result = realm.objects(MachineModelObject.self)
            success(result.toArray(ofType: MachineModelObject.self) as [MachineModelObject])
        }
    }
    
    func addMachineList(data: MachineModelObject, success: @escaping (String) -> (), failure: @escaping (String) -> ()) {
        do {
            try realm.write {
                realm.add(data)
                success("data created")
            }
        } catch {
            failure("error writing data")
        }
    }
    
    func editMachineList(data: MachineModelObject, success: @escaping (String) -> (), failure: @escaping (String) -> ()) {
        
    }
    
    func deleteMachineList(id: MachineModelObject, success: @escaping (String) -> (), failure: @escaping (String) -> ()) {
        if let userObject = realm.objects(MachineModelObject.self).filter("id == \(id.id)").first {
            print("In process of deleting")
            try! realm.write {
                realm.delete(userObject)
            }
            success("Object deleted")
        }
        else{
            print("Object not found.")
        }
    }
    
}
