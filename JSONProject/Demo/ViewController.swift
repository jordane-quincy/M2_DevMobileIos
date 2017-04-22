//
//  ViewController.swift
//  Demo
//
//  Created by Mathilde Dumont on 24/01/2017.
//  Copyright © 2017 UVHC. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UIDocumentMenuDelegate, UIDocumentPickerDelegate, UINavigationControllerDelegate {
    //MARK: Properties

    @IBOutlet weak var welcomeLabel: UILabel!
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var helloLabel: UILabel!
    
    @IBOutlet weak var fileName: UITextField!
    
    @IBOutlet weak var name: UITextField!
    
    
    @IBOutlet weak var email: UITextField!
    
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
        
        
        let person = PersonTest(name: "jordane", mail: "john@doe.com");
        
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
    
    @IBAction func testRealm(_ sender: UIButton) {
        print("DEBUT ------ test realm!!!!")
        let realmServices = RealmServices()
        let exportServices = ExportServices()
        let realm = try! Realm()
        
        realmServices.resetDataBase()
        
        //Init du service
        let businessService = BusinessService(_title: "CanalPlay", _serviceDescription: "Service de vidéo à la demande",_brand: "Canal Satellite")
        
        //Ajout d'une personne
        let person = Person(_email: email.text!)
        
        //Ajout d'un attribut à la personne
        let attribute = Attribute(_label: "Nom", _fieldName: "name", _value: name.text!)
        
        //Ajout d'un attribut à la personne
        let attribute2 = Attribute(_label: "Email", _fieldName: "email", _value: email.text!)
        
        realmServices.createBusinessService(businessService: businessService)
        realmServices.addSubscriberToService(title: businessService.title, subscriber: person)
        realmServices.addAttributeToPerson(_email: person.email, attribute: attribute)
        realmServices.addAttributeToPerson(_email: person.email, attribute: attribute2)
        
        
        
        
        let myTest = realm.objects(Person.self)
        
        print("My test name : \(myTest)")
        
        
        print("DEBUT -----  Test save file in application directory")
        let exportJSONServices = exportServices.getSubscribersJSON(_businessServiceTitle: "CanalPlay")
        let fileService = FileServices()
        fileService.createJSONFileFromString(JSONStringified: exportJSONServices, businessServiceTitle: "CanalPlay", viewController: self)
        print("FIN ----- Test save file in application directory")
 
        
        print(exportServices.getSubscribersJSON(_businessServiceTitle: "CanalPlay"))
        
        
        
        print(exportServices.getSubscribersCSV(_businessServiceTitle: "CanalPlay"))
        
        realmServices.resetService(title: "CanalPlay")
        
        let myTest2 = realm.objects(BusinessService.self)
        
        print("My test after Reset = \(myTest2)")
        print("FIN ---- test realm!!!!")
    }
    
}

