//
//  MachineTableViewCell.swift
//  MyImageMachineApps
//
//  Created by Hamzhya Salsatinnov Hairy on 03/03/20.
//  Copyright © 2020 Hamzhya Salsatinnov Hairy. All rights reserved.
//

import UIKit

class MachineTableViewCell: UITableViewCell {

    @IBOutlet weak var machineImage: GSImageView!
    @IBOutlet weak var machineName: UILabel!
    @IBOutlet weak var machineType: UILabel!
    @IBOutlet weak var machineCode: UILabel!
    
    var index = 0
    var id = 0
    var data: MachineModelObject? {
        didSet {
            if self.data != nil {
                if self.data!.images.count > 0 {
                    self.machineImage.image = self.load(fileName: self.data!.images.first!.name)
                }
                self.machineImage.contentMode = .scaleAspectFill
                self.machineName.text = self.data!.name
                self.machineType.text = self.data!.type
                self.machineCode.text = "\(self.data!.code_num)"
                
                self.id = self.data!.id
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
        // Initialization code
    }
    
    var documentsUrl: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    private func load(fileName: String) -> UIImage? {
        let fileURL = documentsUrl.appendingPathComponent(fileName)
        do {
            let imageData = try Data(contentsOf: fileURL)
            return UIImage(data: imageData)
        } catch {
            print("Error loading image : \(error)")
        }
        return nil
    }
    class var reusableIndentifier: String { return String(describing: self) }
    static func reusableNIB() -> UINib {
        return UINib(nibName: self.reusableIndentifier , bundle: Bundle.main)
    }
    
}
