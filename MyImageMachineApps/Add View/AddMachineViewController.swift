//
//  AddMachineViewController.swift
//  MyImageMachineApps
//
//  Created by Hamzhya Salsatinnov Hairy on 03/03/20.
//  Copyright © 2020 Hamzhya Salsatinnov Hairy. All rights reserved.
//

import UIKit
import YPImagePicker
import RealmSwift
import AVFoundation
import AVKit
import Photos

enum whichView {
    case add
    case edit
}


class AddMachineViewController: UIViewController {

    @IBOutlet weak var nameMachineTF: UITextField!
    @IBOutlet weak var typeMachineTF: UITextField!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var saveBtn: BXButton!
    @IBOutlet weak var qrImageView: UIImageView!
    @IBOutlet weak var codeNumLabel: UILabel!
    
    var dataAdd = MachineModelObject()
    var filteredImages = Array<ImageModel>()
    var dataImageObject = ImageModelObject()
    var dataImg: ImageModel = ImageModel()
    var selectedItems = [YPMediaItem]()
    var whichShow = whichView.add

    var viewModel = MachineViewModel()
    
    // MARK: - Setting up image picker
    
    // MARK: - CLASS FUNCs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.register(AddMachineColl.reusableNIB(), forCellWithReuseIdentifier: AddMachineColl.reusableIndentifier)
        imageCollectionView.register(AddNewCollectionViewCell.reusableNIB(), forCellWithReuseIdentifier: AddNewCollectionViewCell.reusableIndentifier)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.setupViewModel()
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
            }
        }
        
        if self.whichShow == .add {
            self.qrImageView.isHidden = true
        } else {
            self.dataAdd = TempHelper.shared.machineData
            for item in self.dataAdd.images {
                if item.id == self.dataAdd.id {
                    var imageDat = ImageModel()
                    imageDat.id = item.id
                    imageDat.imageString = item.imageString
                    imageDat.name = item.name
                    self.filteredImages.append(imageDat)
                }
            }
            self.codeNumLabel.text = "Code: \(self.dataAdd.code_num)"
            self.filteredImages = self.filteredImages.sorted(by: {$0.name! < $1.name!})
            self.typeMachineTF.text = self.dataAdd.type
            self.nameMachineTF.text = self.dataAdd.name
            self.qrImageView.isHidden = false
            self.qrImageView.image = QRGenerators().generateQRCode(from: "\(self.dataAdd.code_num)")
            self.imageCollectionView.reloadData()
        }
        self.codeNumLabel.isHidden = self.qrImageView.isHidden
    }
    
    @IBAction func saveAction(_ sender: Any) {
        if self.whichShow == .add {
            self.dataAdd.name = nameMachineTF.text ?? ""
            self.dataAdd.type = typeMachineTF.text?.lowercased().trimmingCharacters(in: .whitespaces) ?? ""
            self.viewModel.addMachineData(data: self.dataAdd) {
                //show alert success
                self.navigationController?.popViewController(animated: true)
            }
        } else {
            let updatedData = MachineModelObject()
            updatedData.id = self.dataAdd.id
            updatedData.name = nameMachineTF.text ?? ""
            updatedData.type = typeMachineTF.text?.lowercased().trimmingCharacters(in: .whitespaces) ?? ""
            updatedData.code_num = self.dataAdd.code_num
            updatedData.images = self.dataAdd.images
            self.viewModel.updateMachineData(data: updatedData) {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension AddMachineViewController: addMachineCollDelegate {
    func didDelete(index: Int) {
        if self.whichShow == .edit {
            self.filteredImages[index].id = 0
            self.filteredImages = self.filteredImages.filter({$0.id == self.dataAdd.id})
            self.imageCollectionView.reloadSections(NSIndexSet(index: 1) as IndexSet)
        } else {
            self.dataAdd.images.remove(at: index)
            self.imageCollectionView.reloadData()
        }
    }
    
    func didView(image: UIImage) {
        
    }
    
    
}

extension AddMachineViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 1 {
            if self.whichShow == .edit {
                return self.filteredImages.count
            } else {
                return self.dataAdd.images.count
            }
        } else {
            if self.whichShow == .edit {
                if self.filteredImages.count == 10 {
                    return 0
                } else {
                    return 1
                }
            } else {
                if self.dataAdd.images.count == 10 {
                    return 0
                } else {
                    return 1
                }
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddNewCollectionViewCell.reusableIndentifier, for: indexPath) as! AddNewCollectionViewCell
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AddMachineColl.reusableIndentifier, for: indexPath) as! AddMachineColl
            cell.delegate = self
            if self.whichShow == .edit {
                if self.filteredImages.count > 0 {
                    cell.section = indexPath.section
                    cell.index = indexPath.item
                    cell.data = self.dataAdd.images[indexPath.item]
                }
            } else {
                if self.dataAdd.images.count > 0 {
                    cell.section = indexPath.section
                    cell.index = indexPath.item
                    cell.data = self.dataAdd.images[indexPath.item]
                }
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            // open galery here
            self.didOpenGallery()
        } else {
            if self.whichShow == .edit {
                let imageView = UIImageView(image: DataManager().load(fileName: self.filteredImages[indexPath.row].name!))
                imageView.frame = self.view.frame
                imageView.backgroundColor = UIColor.black.withAlphaComponent(50)
                imageView.contentMode = .scaleAspectFit
                imageView.isUserInteractionEnabled = true

                let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
                imageView.addGestureRecognizer(tap)
                self.view.addSubview(imageView)
            } else {
                
            }
            // open image here
        }
    }
    
    // Use to back from full mode
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }
    
    
    
    private func didOpenGallery() {
        var config = YPImagePickerConfiguration()
        config.library.maxNumberOfItems = 10
        config.library.mediaType = .photo
        config.startOnScreen = .library
        config.screens = [.library]
        config.showsCrop = .none
        config.showsPhotoFilters = false
        config.library.isSquareByDefault = false
        config.library.defaultMultipleSelection = true
        config.library.options = nil
        config.library.skipSelectionsGallery = true
        config.wordings.libraryTitle = "Gallery"
        config.library.preselectedItems = selectedItems
        let imgPicker = YPImagePicker(configuration: config)
        imgPicker.didFinishPicking { [unowned imgPicker] items,cancelled  in
            if cancelled {
                debugPrint("picker was cancelled")
                imgPicker.dismiss(animated: true, completion: nil)
                self.imageCollectionView.reloadData()
                return
            }
            _ = items.map {print("🧀 \($0)")}
            self.selectedItems.append(contentsOf: items)
            let group = DispatchGroup()
            
            group.enter()
            DispatchQueue.main.async {
                for (index, item) in self.selectedItems.enumerated() {
                    switch item {
                    case .photo(let photo):
                        if photo.asset != nil {
                            photo.asset!.getURL(completionHandler: { (url) in
                                if url != nil {
                                    self.dataImg.imageData = photo.image
                                    self.dataImg.name = url!.lastPathComponent
                                    self.dataImg.imageString = url!.absoluteString
                                    DataManager().store(image: photo.image, forKey: url!.lastPathComponent, withStorageType: .userDefaults)
                                    self.appendImages(self.dataImg)
                                    if index == self.selectedItems.count - 1 {
                                        self.selectedItems.removeAll()
                                    }
                                }
                            })
                        }
                    case .video( _):
                        break
                    }
                }
                group.leave()
            }
            
            group.notify(queue: .main) {
                imgPicker.dismiss(animated: true, completion: nil)
                self.imageCollectionView.reloadData()
            }
        }
        present(imgPicker, animated: true, completion: nil)
    }
        
    
    func appendImages(_ image: ImageModel) {
        if self.whichShow == .edit {
            self.filteredImages.append(image)
        } else {
            let imageData = ImageModelObject()
            imageData.name = image.name ?? ""
            imageData.imageString = image.imageString ?? ""
            imageData.imageData = image.imageData
            self.dataAdd.images.append(imageData)
        }
        self.imageCollectionView.reloadData()
    }
}

