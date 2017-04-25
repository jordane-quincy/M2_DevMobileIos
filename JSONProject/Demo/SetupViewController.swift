//
//  SetupViewController.swift
//  Demo
//
//  Created by morgan basset on 03/04/2017.
//  Copyright © 2017 UVHC. All rights reserved.
//

import UIKit

class SetupViewController: UIViewController, UIDocumentMenuDelegate, UIDocumentPickerDelegate, UINavigationControllerDelegate {
    
    var controllerArray = [UIViewController]()
    
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
        
        do {
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
                    self.tabBarController?.selectedIndex = 1
                    let myVC1 = self.tabBarController?.viewControllers![0] as! AccueilViewController
                    DispatchQueue.main.async() {
                        myVC1.createViewFromJson(json: jsonModel)
                    }
                    
                } catch let serializationError {
                    //in case of unsuccessful deserialization
                    print(serializationError)
                }
                
                
                }.resume()
            
        }
        catch let error {
            // Error handling
            print("Error during file reading : \(error)")
        }
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
    
    @IBAction func selectFile(_ sender: Any) {
        // Code pour récupérer file depuis iCloud
        let importMenu = UIDocumentMenuViewController(documentTypes: ["public.text"], in: .import)
        importMenu.delegate = self
        present(importMenu, animated: true, completion: nil)
        
        
        
        // code pour le browser sur le repo de l'app
        //let fileBrowser = FileBrowser();
        //present(fileBrowser, animated: true, completion: nil)
    }

    
    
}
