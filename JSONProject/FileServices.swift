//
//  FileServices.swift
//  demoFA_storage_test
//
//  Created by MAC ISTV on 11/04/2017.
//  Copyright © 2017 DeptInfo. All rights reserved.
//

import Foundation
import UIKit

// Class that manage files
class FileServices: UIViewController {
    
    public func createAndMoveFileiCloud (file: String, fileStringified: String, viewController: ResultatViewController) -> URL? {
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let path = dir.appendingPathComponent(file)
            
            //writing the file in the app directory
            do {
                try fileStringified.write(to: path, atomically: false, encoding: String.Encoding.utf8)
            }
            catch {/* error handling here */}
            
            // Move the file in the app directory to iCloud using Document Picker
            
            let importMenu = UIDocumentMenuViewController(url: path, in: UIDocumentPickerMode.moveToService)
            importMenu.delegate = viewController
            viewController.present(importMenu, animated: true, completion: nil)
            
            /*let documentPicker: UIDocumentPickerViewController = UIDocumentPickerViewController(url: path, in: UIDocumentPickerMode.moveToService)
            documentPicker.delegate = viewController
            documentPicker.modalPresentationStyle = UIModalPresentationStyle.fullScreen
            viewController.present(documentPicker, animated: true, completion: nil)*/
            return path
        }
        else {
            return nil
        }
    }
    
    public func createJSONFileFromString(JSONStringified: String, businessServiceTitle: String, viewController: ResultatViewController) -> URL? {
        let now = Date()
        let dateUtils = DateUtils()
        let file = "exportJSON_" + businessServiceTitle + "_" + dateUtils.formatDate(date: now) + ".json"
        return createAndMoveFileiCloud(file: file, fileStringified: JSONStringified, viewController: viewController)
    }
    
    public func createCSVFileFromString(CSVStringified: String, businessServiceTitle: String, viewController: ResultatViewController) -> URL? {
        let now = Date()
        let dateUtils = DateUtils()
        let file = "exportCSV_" + businessServiceTitle + "_" + dateUtils.formatDate(date: now) + ".csv"
        return createAndMoveFileiCloud(file: file, fileStringified: CSVStringified, viewController: viewController)
    }
}
