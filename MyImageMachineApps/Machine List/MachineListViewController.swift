//
//  MachineListViewController.swift
//  MyImageMachineApps
//
//  Created by Hamzhya Salsatinnov Hairy on 03/03/20.
//  Copyright © 2020 Hamzhya Salsatinnov Hairy. All rights reserved.
//

import UIKit

class MachineListViewController: UIViewController {

    @IBOutlet weak var machineTableView: UITableView!
    @IBOutlet weak var addButton: BXButton!
    @IBOutlet weak var sortNameBtn: BXButton!
    @IBOutlet weak var sortTypeBtn: BXButton!
    
    var machineList = Array<MachineModelObject>()
    var viewModel = MachineViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        machineTableView.delegate = self
        machineTableView.dataSource = self
        machineTableView.register(MachineTableViewCell.reusableNIB(), forCellReuseIdentifier: MachineTableViewCell.reusableIndentifier)
        machineTableView.register(EmptyTableViewCell.reusableNIB(), forCellReuseIdentifier: EmptyTableViewCell.reusableIndentifier)
        machineTableView.estimatedRowHeight = 60
        machineTableView.rowHeight = UITableView.automaticDimension
        machineTableView.separatorStyle = .none
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        setupViewModel()
    }

    func setupViewModel() {
        self.viewModel.showAlertClosure = { [weak self] in
            let alert = self?.viewModel.alertMessage ?? ""
            print(alert)
        }
        
        self.viewModel.updateLoadingStatus = { [weak self] in
            if self?.viewModel.isLoading ?? true {
                // is loading here
                print("loading")
            } else {
                print("loaded")
                self?.machineTableView.reloadData()
            }
        }
        
        self.viewModel.getMachineList {
            self.machineList = self.viewModel.machineList
            self.machineTableView.reloadData()
        }
        print("ini list", machineList)
        self.machineTableView.reloadData()
    }
    
    @IBAction func addAction(_ sender: BXButton) {
        self.goToScreen(RoutingData().addMachineScreen())
    }
    @IBAction func sortNameAction(_ sender: BXButton) {
    }
    @IBAction func sortTypeAction(_ sender: BXButton) {
    }
    
}

extension MachineListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.machineList.count > 0 {
            self.sortNameBtn.isHidden = false
            self.sortTypeBtn.isHidden = false
            return self.machineList.count
        } else {
            self.sortNameBtn.isHidden = true
            self.sortTypeBtn.isHidden = true
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.machineList.count > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: MachineTableViewCell.reusableIndentifier, for: indexPath) as! MachineTableViewCell
            cell.index = indexPath.row
            cell.data = self.machineList[indexPath.row]
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: EmptyTableViewCell.reusableIndentifier, for: indexPath) as! EmptyTableViewCell
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let deletingData = self.machineList[indexPath.row]
            self.viewModel.deleteMachineData(id: deletingData) {
                self.setupViewModel()
            }
        } else if editingStyle == .insert {
            self.goToScreen(RoutingData().addMachineScreen())
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
    
    
}
