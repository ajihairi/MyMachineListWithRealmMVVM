//
//  MachineViewModel.swift
//  MyImageMachineApps
//
//  Created by Hamzhya Salsatinnov Hairy on 03/03/20.
//  Copyright © 2020 Hamzhya Salsatinnov Hairy. All rights reserved.
//

import Foundation
import RealmSwift

class MachineViewModel {
    private let service: MachineListProtocol
    var machineList: [MachineModel] = [MachineModel]()
    var realm = try! Realm()
    
    //MARK: -- Closure Collection
    var showAlertClosure: (() -> ())?
    var updateLoadingStatus: (() -> ())?
    
    var isLoading: Bool = false {
        didSet {
            self.updateLoadingStatus?()
        }
    }

    /// Showing alert message, use UIAlertController or other Library
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }
    
    init(withMachine serviceProtocol: MachineListProtocol = MachineService() ) {
        self.service = serviceProtocol
    }
    
    func getMachineList(completion: @escaping() -> Void) {
        self.service.getMachineList(type: MachineModel.self, success: { (data) in
            /**convert result to list type
            let converted = data.reduce(List<MachineModel>()) { (list, element) -> List<MachineModel> in
                list.append(element)
                return list
            }
             */
            self.machineList = Array(data)
            completion()
        }) { (error) in
            self.alertMessage = error
        }
    }
}
