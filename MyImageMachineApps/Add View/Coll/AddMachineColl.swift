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