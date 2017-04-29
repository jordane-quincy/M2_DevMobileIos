//
//  SetupViewController.swift
//  Demo
//
//  Created by morgan basset on 03/04/2017.
//  Copyright © 2017 UVHC. All rights reserved.
//

import UIKit
import RealmSwift

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
        
        
        //let contentDocument = try String(contentsOf: urlDocument)
        //print("The document content : \(contentDocument)")
        
        URLSession.shared.dataTask(with:urlDocument) { (data, response, error) in
            let json = try? JSONSerialization.jsonObject(with: data!, options: [])
            
            do {
                let jsonModel = try JsonModel(jsonContent: json as! [String: Any])
                
                DispatchQueue.main.async() {
                    self.tabBarController?.selectedIndex = 0
                }
                let myVC1 = self.tabBarController?.viewControllers![0] as! AccueilViewController
                // create interface
                myVC1.createViewFromJson(json: jsonModel)
                
                // create the service in dataBase
                let realmServices = RealmServices()
                realmServices.resetlastUsedService()
                let jsonModelInString = String(data: data!, encoding: .utf8)
                let businessService = BusinessService(_title: (jsonModel?.title)!, _serviceDescription: (jsonModel?.description)!, icon: jsonModel?.icon ?? "", jsonModelInString: jsonModelInString!, isLastUsed: true)
                // On vérifie si le service n'existe pas déjà en database
                if (realmServices.serviceFree(title: businessService.title)) {
                    realmServices.createBusinessService(businessService: businessService)
                }
                else {
                    realmServices.setIsLastUsedForService(title: businessService.title)
                }
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
