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
    
    var notificationToken: NotificationToken?
    let realm = try! Realm()
    
    func getMachineList(type: Object.Type, success: @escaping (Results<MachineModel>) -> (), failure: @escaping (String) -> ()) {
        if type == MachineModel.self {
            let result = realm.objects(MachineModel.self)
            notificationToken = result.observe({ (changes: RealmCollectionChange) in
                switch changes {
                case .initial:
                    success(result)
                case .update(_, let deletions, let insertions, let modifications):
                    /**Query results have changed, so apply them to the TableView
                    self.tableView.beginUpdates()
                    self.tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                    self.tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                    self.tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .automatic)
                    self.tableView.endUpdates()
                     */
                    success(result)
                    
                case .error(let error):
                    failure(error as! String)
                }
            })
        }
    }
    
    func addMachineList(data: MachineModel, success: @escaping (String) -> (), failure: @escaping (String) -> ()) {
        
    }
    
    func editMachineList(data: MachineModel, success: @escaping (String) -> (), failure: @escaping (String) -> ()) {
        
    }
    
    func deleteMachineList(id: MachineModel, success: @escaping (String) -> (), failure: @escaping (String) -> ()) {
        
    }
    
}
