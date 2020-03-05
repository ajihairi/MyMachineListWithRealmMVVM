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


class AddMachineViewController: UIViewController {

    @IBOutlet weak var nameMachineTF: UITextField!
    @IBOutlet weak var typeMachineTF: UITextField!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var saveBtn: BXButton!
    
    var dataAdd = MachineModelObject()
    var dataImageObject = ImageModelObject()
    var dataImg: ImageModel = ImageModel()
    var selectedItems = [YPMediaItem]()
    
    var viewModel = MachineViewModel()
    
    // MARK: - Setting up image picker
    
    // MARK: - CLASS FUNCs
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.register(AddMachineColl.reusableNIB(), forCellWithReuseIdentifier: AddMachineColl.reusableIndentifier)
        imageCollectionView.register(AddNewCollectionViewCell.reusableNIB(), forCellWithReuseIdentifier: AddNewCollectionViewCell.reusableIndentifier)
        setupViewModel()
        imageCollectionView.reloadData()
        
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
    }
    
    @IBAction func saveAction(_ sender: Any) {
        self.dataAdd.name = nameMachineTF.text ?? ""
        self.dataAdd.type = typeMachineTF.text?.lowercased().trimmingCharacters(in: .whitespaces) ?? ""
        self.viewModel.addMachineData(data: self.dataAdd) {
            //show alert success
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}

extension AddMachineViewController: addMachineCollDelegate {
    func didDelete(index: Int) {
        self.dataAdd.images.remove(at: index)
        self.imageCollectionView.reloadData()
    }
    
    func didView(image: UIImage) {
        
    }
    
    
}

extension AddMachineViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 1 {
            return self.dataAdd.images.count
        } else {
            if self.dataAdd.images.count == 10 {
                return 0
            } else {
                return 1
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
            if self.dataAdd.images.count > 0 {
                cell.section = indexPath.section
                cell.index = indexPath.item
                cell.data = self.dataAdd.images[indexPath.item]
            }
            cell.delegate = self
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
            // open image here
        }
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
        let imageData = ImageModelObject()
        imageData.name = image.name ?? ""
        imageData.imageString = image.imageString ?? ""
        imageData.imageData = image.imageData
        self.dataAdd.images.append(imageData)
        print("data list", dataAdd.images)
        self.imageCollectionView.reloadData()
    }
}

extension PHAsset {
    var originalFilename: String? {
        return PHAssetResource.assetResources(for: self).first?.originalFilename
    }
    
    func getURL(completionHandler : @escaping ((_ responseURL : URL?) -> Void)){
        if self.mediaType == .image {
            let options: PHContentEditingInputRequestOptions = PHContentEditingInputRequestOptions()
            options.canHandleAdjustmentData = {(adjustmeta: PHAdjustmentData) -> Bool in
                return true
            }
            self.requestContentEditingInput(with: options, completionHandler: {(contentEditingInput: PHContentEditingInput?, info: [AnyHashable : Any]) -> Void in
                completionHandler(contentEditingInput!.fullSizeImageURL as URL?)
            })
        } else if self.mediaType == .video {
            let options: PHVideoRequestOptions = PHVideoRequestOptions()
            options.version = .original
            PHImageManager.default().requestAVAsset(forVideo: self, options: options, resultHandler: {(asset: AVAsset?, audioMix: AVAudioMix?, info: [AnyHashable : Any]?) -> Void in
                if let urlAsset = asset as? AVURLAsset {
                    let localVideoUrl: URL = urlAsset.url as URL
                    completionHandler(localVideoUrl)
                } else {
                    completionHandler(nil)
                }
            })
        }
    }
}
