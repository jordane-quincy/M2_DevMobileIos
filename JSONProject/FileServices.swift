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
class FileServices: UIViewController, UIDocumentMenuDelegate, UIDocumentPickerDelegate, UINavigationControllerDelegate {
    
    @available(iOS 8.0, *)
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt urlDocument: URL) {
        //print("The Url is : \(urlDocument)")
        
        //let contentDocument = try String(contentsOf: urlDocument)
        //print("The document content : \(contentDocument)")
        
        URLSession.shared.dataTask(with:urlDocument) { (data, response, error) in
            let json = try? JSONSerialization.jsonObject(with: data!, options: [])
            
            //if let dictionary = json as? [String: Any] {
            //    for (key, value) in dictionary {
            //        // access all key / value pairs in dictionary
            //
            //        //print("key : \(key) , value : \(value)")
            //    }
            //}
            
            do {
                let jsonModel = try JsonModel(jsonContent: json as! [String: Any])
                print("jsonModel : \(jsonModel)")
            } catch let serializationError {
                //in case of unsuccessful deserialization
                print(serializationError)
            }
            
            
            }.resume()
        
        
    }
    
    @available(iOS 8.0, *)
    public func documentMenu(_ documentMenu:     UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("we cancelled")
        dismiss(animated: true, completion: nil)
        
    }

    
    public func createJSONFileFromString(JSONStringified: String, businessServiceTitle: String, viewController: ViewController) {
        let now = Date()
        let dateUtils = DateUtils()
        let file = "exportJSON_" + businessServiceTitle + "_" + dateUtils.formatDate(date: now) + ".json"
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
                
                // Move the file in the app directory to iCloud using Document Picker
                let documentPicker: UIDocumentPickerViewController = UIDocumentPickerViewController(url: path, in: UIDocumentPickerMode.moveToService)
                documentPicker.delegate = viewController
                documentPicker.modalPresentationStyle = UIModalPresentationStyle.fullScreen
                viewController.present(documentPicker, animated: true, completion: nil)
            }
            catch {/* error handling here */}
        }
        
    }
}
