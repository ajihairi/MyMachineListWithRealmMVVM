//
//  AddMachineColl.swift
//  MyImageMachineApps
//
//  Created by Hamzhya Salsatinnov Hairy on 03/03/20.
//  Copyright © 2020 Hamzhya Salsatinnov Hairy. All rights reserved.
//

import UIKit

protocol addMachineCollDelegate {
    func didDelete(index: Int)
    func didView(image: UIImage)
}

class AddMachineColl: UICollectionViewCell {

    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var imageAsset: GSImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var delegate: addMachineCollDelegate?
    var index = 0
    var section = 0
    
    var data: ImageModelObject? {
        didSet {
            if data != nil {
                self.titleLabel.text = self.data!.name
                if data!.id != 0 {
                    let image = DataManager().load(fileName: self.data!.name)
                    self.imageAsset.image = image
                } else {
                    let image = DataManager().retrieveImage(forKey: self.data!.name, inStorageType: .userDefaults)
                    self.imageAsset.image = image
                }
                self.imageAsset.contentMode = .scaleAspectFill
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imageAsset.isUserInteractionEnabled = true
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        self.delegate?.didDelete(index: index)
    }
    class var reusableIndentifier: String { return String(describing: self) }
    static func reusableNIB() -> UINib {
        return UINib(nibName: self.reusableIndentifier , bundle: Bundle.main)
    }
    
}

