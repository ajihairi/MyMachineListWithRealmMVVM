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
    func getMachineList(type: Object.Type, success: @escaping(Results<MachineModel>) -> (), failure: @escaping(String) -> ())
    func addMachineList(data: MachineModel, success: @escaping(String) -> (), failure: @escaping(String) -> ())
    func editMachineList(data: MachineModel, success: @escaping(String) -> (), failure: @escaping(String) -> ())
    func deleteMachineList(id: MachineModel, success: @escaping(String) -> (), failure: @escaping(String) -> ())
}
