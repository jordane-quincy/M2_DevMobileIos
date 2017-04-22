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
    
    
    public func createJSONFileFromString(JSONStringified: String) {
        let file = "exportJSON.json"
        //let data = JSONStringify.data(using: .utf8)!
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let path = dir.appendingPathComponent(file)
            
            //writing the file in the app directory
            do {
                try JSONStringified.write(to: path, atomically: false, encoding: String.Encoding.utf8)
            }
            catch {/* error handling here */}
            
            //reading
            do {
                let text2 = try String(contentsOf: path, encoding: String.Encoding.utf8)
                print(text2);
                
                // Trying to move the file in the app directory to iCloud using Document Picker
                let documentPicker: UIDocumentPickerViewController = UIDocumentPickerViewController(url: path, in: UIDocumentPickerMode.moveToService)
                
                documentPicker.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                self.present(documentPicker, animated: true, completion: nil)
            }
            catch {/* error handling here */}
        }
        
    }
}
