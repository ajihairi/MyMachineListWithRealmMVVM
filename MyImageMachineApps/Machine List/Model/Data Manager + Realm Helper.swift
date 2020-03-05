//
//  Data Manager + Realm Helper.swift
//  MyImageMachineApps
//
//  Created by Hamzhya Salsatinnov Hairy on 05/03/20.
//  Copyright © 2020 Hamzhya Salsatinnov Hairy. All rights reserved.
//

import Foundation
import UIKit

enum StorageType {
    case userDefaults
    case fileSystem
}

class DataManager {

    var imageFile: String {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path.appending("/images")
    }

    func writeData(data: String) {
        do {
            try data.write(toFile: imageFile, atomically: true, encoding: String.Encoding.utf32)
        } catch let error as NSError {
            print("Write Error: \(error.localizedDescription)")
        }
    }

    func readData() -> String {
        var storeData = ""
        do {
            storeData = try String(contentsOfFile: imageFile)
        }  catch let error as NSError {
            print("Read Error: \(error.localizedDescription)")
        }
        return storeData
  }
    func store(image: UIImage, forKey key: String, withStorageType storageType: StorageType) {
        if let pngRepresentation = image.pngData() {
            switch storageType {
            case .fileSystem:
                if let filePath = filePath(forKey: key) {
                    do  {
                        try pngRepresentation.write(to: filePath,
                                                    options: .atomic)
                    } catch let err {
                        print("Saving file resulted in error: ", err)
                    }
                }
            case .userDefaults:
                UserDefaults.standard.set(pngRepresentation, forKey: key)
            }
        }
    }
    
    func filePath(forKey key: String) -> URL? {
        let fileManager = FileManager.default
        guard let documentURL = fileManager.urls(for: .documentDirectory,
                                                in: FileManager.SearchPathDomainMask.userDomainMask).first else { return nil }
        
        return documentURL.appendingPathComponent(key + ".JPG")
    }
    
    func retrieveImage(forKey key: String, inStorageType storageType: StorageType) -> UIImage? {
        switch storageType {
        case .fileSystem:
            if let filePath = self.filePath(forKey: key),
                let fileData = FileManager.default.contents(atPath: filePath.path),
                let image = UIImage(data: fileData) {
                return image
            }
        case .userDefaults:
            if let imageData = UserDefaults.standard.object(forKey: key) as? Data,
                let image = UIImage(data: imageData) {
                return image
            }
        }
        
        return nil
    }
    
}
