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
    var machineList: Array<MachineModelObject> = Array<MachineModelObject>()
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
        self.service.getMachineList(type: MachineModelObject.self, success: { (data) in
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
    
    func addMachineData(data: MachineModelObject, completion: @escaping() -> Void) {
        var arrayNum = Int(Date().timeIntervalSince1970).digits
        arrayNum.append(incrementID())
        let joined = arrayNum.map(String.init).joined()
        data.code_num = Int(joined) ?? 0
        if data.name == "" {
            self.alertMessage = "data name cannot be empty"
        } else if data.type == "" {
            self.alertMessage = "data type cannot be empty"
        } else if data.images.count == 0 {
            self.alertMessage = "select at least 1 image"
        } else if data.code_num == 0 {
            self.alertMessage = "error generating data code number"
        } else {
            data.id = incrementID()
            for (index,item) in data.images.enumerated() {
                item.id = data.id
                guard let docPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first else {return}
                guard let writePath = NSURL(fileURLWithPath: docPath).appendingPathComponent("MachineName_\(index).JPG") else { return }
                if let dataImgs = item.imageData?.jpegData(compressionQuality: 10), !FileManager.default.fileExists(atPath: writePath.path) {
                    do {
                        try dataImgs.write(to: writePath)
                        item.name = writePath.lastPathComponent
                        item.imageString = writePath.absoluteString
                            print("file saved")
                        
                        if index == data.images.count - 1 {
                            self.service.addMachineList(data: data, success: { doneData in
                                completion()
                            }) { (error) in
                                self.alertMessage = error
                            }
                        }
                        item.imageData = nil
                    } catch {
                            print("error saving file:", error)
                    }
                }
            }
        }
    }
    
    func deleteMachineData(id: MachineModelObject, completion: @escaping() -> Void) {
        
        self.service.deleteMachineList(id: id, success: { (done) in
            self.alertMessage = done
            completion()
        }) { (erro) in
            self.alertMessage = erro
        }
    }
    
    func incrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(MachineModelObject.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
}
