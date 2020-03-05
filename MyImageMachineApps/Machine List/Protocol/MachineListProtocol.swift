//
//  MachineListProtocol.swift
//  MyImageMachineApps
//
//  Created by Hamzhya Salsatinnov Hairy on 03/03/20.
//  Copyright © 2020 Hamzhya Salsatinnov Hairy. All rights reserved.
//

import Foundation
import RealmSwift

protocol MachineListProtocol {
    func getMachineList(type: Object.Type, success: @escaping(Array<MachineModelObject>) -> (), failure: @escaping(String) -> ())
    func addMachineList(data: MachineModelObject, success: @escaping(String) -> (), failure: @escaping(String) -> ())
    func editMachineList(data: MachineModelObject, success: @escaping(String) -> (), failure: @escaping(String) -> ())
    func deleteMachineList(id: MachineModelObject, success: @escaping(String) -> (), failure: @escaping(String) -> ())
}
