//
//  ViewController.swift
//  Demo
//
//  Created by Mathilde Dumont on 24/01/2017.
//  Copyright © 2017 UVHC. All rights reserved.
//

import UIKit
import FileBrowser

class ViewController: UIViewController, UIDocumentMenuDelegate, UIDocumentPickerDelegate, UINavigationControllerDelegate {
    //MARK: Properties

    @IBOutlet weak var welcomeLabel: UILabel!
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var helloLabel: UILabel!
    
    @IBOutlet weak var fileName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Actions
    
    @IBAction func sayHello(_ sender: UIButton) {
        
        helloLabel.text = "Bonjour " + nameField.text! + " !"
//        let nameFile = "exampleJSON1"
//        let jsonUtils = JSONUtils()
//        let jsonObject = jsonUtils.readJson(fileName: nameFile)
//        if (jsonObject != nil) {
//            let commonFields = jsonObject?["commonFields"] as! NSArray
//            let commonFieldsZero = commonFields[0] as! [String: Any]
//            print(commonFieldsZero["label"]!)
//        }
//        else {
//            print("erreur lecture json")
//        }
        
        
        let person = Person(name: "jordane", mail: "john@doe.com");
        
        print("person : \(person)");
        
        let json = person.toJson();
        print(json);
        
        person.toJsonFile(pathJsonFile: "testOutput.json");
    }
    
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
    
    
    @IBAction func selectFile(_ sender: UIButton) {
        // Code pour récupérer file depuis iCloud
        let importMenu = UIDocumentMenuViewController(documentTypes: ["public.text"], in: .import)
        importMenu.delegate = self
        present(importMenu, animated: true, completion: nil)
        
        
        
        // code pour le browser sur le repo de l'app
        //let fileBrowser = FileBrowser();
        //present(fileBrowser, animated: true, completion: nil)
    }
    
    
}

