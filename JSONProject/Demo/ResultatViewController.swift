//
//  ResultatViewController.swift
//  Demo
//
//  Created by morgan basset on 24/04/2017.
//  Copyright © 2017 UVHC. All rights reserved.
//

import UIKit
import RealmSwift

import Darwin
import Foundation

class ResultatViewController: UIViewController, UIDocumentMenuDelegate, UIDocumentPickerDelegate, UINavigationControllerDelegate {

    //MARK: Properties
    
    @IBOutlet weak var welcomeLabel: UILabel!
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var helloLabel: UILabel!
    
    @IBOutlet weak var fileName: UITextField!
    
    @IBOutlet weak var name: UITextField!
    
    
    @IBOutlet weak var email: UITextField!
    var path : URL? = nil
    
    var isImportingFile = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @available(iOS 8.0, *)
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt urlDocument: URL) {
        //print("The Url is : \(urlDocument)")
        
        //let contentDocument = try String(contentsOf: urlDocument)
        //print("The document content : \(contentDocument)")
        if (isImportingFile) {
            isImportingFile = false
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
    }
    
    @available(iOS 8.0, *)
    public func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("we cancelled document picker")
        isImportingFile = false
        // We have to delete the file from the local repo if it exists
        // path is different of nil if we are creating a file
        // If we cancel the document picker during the selection of a file
        // We have to do nothing and so path will be equal to nil
        if (path != nil) {
            do {
                _ = try String(contentsOf: path!, encoding: String.Encoding.utf8)
                do {
                    try FileManager.default.removeItem(at: path!)
                    path = nil;
                } catch {
                    print("error deleting file at path : " + (path?.absoluteString)!)
                }
            }
            catch {
                path = nil
            }
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func documentMenuWasCancelled(_ documentMenu: UIDocumentMenuViewController) {
        print("we cancelled document menu")
        isImportingFile = false
        // We have to delete the file from the local repo if it exists
        // path is different of nil if we are creating a file
        // If we cancel the document picker during the selection of a file
        // We have to do nothing and so path will be equal to nil
        if (path != nil) {
            do {
                _ = try String(contentsOf: path!, encoding: String.Encoding.utf8)
                do {
                    try FileManager.default.removeItem(at: path!)
                    path = nil;
                } catch {
                    print("error deleting file at path : " + (path?.absoluteString)!)
                }
            }
            catch {
                path = nil
            }
        }
    }
    

    // Button action
    
    @IBAction func sayHello(_ sender: UIButton) {
        helloLabel.text = "Bonjour " + nameField.text! + " !"
        let person = PersonTest(name: "jordane", mail: "john@doe.com");
        
        print("person : \(person)");
        
        let json = person.toJson();
        print(json);
        
        person.toJsonFile(pathJsonFile: "testOutput.json");
        
    }
}
