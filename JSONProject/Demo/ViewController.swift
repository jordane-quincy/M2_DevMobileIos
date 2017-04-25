//
//  ViewController.swift
//  Demo
//
//  Created by Mathilde Dumont on 24/01/2017.
//  Copyright © 2017 UVHC. All rights reserved.
//

import UIKit
import RealmSwift

import Darwin
import Foundation

class ViewController: UIViewController, UIDocumentMenuDelegate, UIDocumentPickerDelegate, UINavigationControllerDelegate {
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

    
    
    @IBAction func selectFile(_ sender: UIButton) {
        // Code pour récupérer file depuis iCloud
        isImportingFile = true
        let importMenu = UIDocumentMenuViewController(documentTypes: ["public.text"], in: .import)
        importMenu.delegate = self
        present(importMenu, animated: true, completion: nil)
        
        
        // code pour le browser sur le repo de l'app
        //let fileBrowser = FileBrowser();
        //present(fileBrowser, animated: true, completion: nil)
    }
    
//    @IBAction func deviceGuru(_ sender: UIButton) {
//        
//        let deviceName = DeviceGuru.hardware()
//        let deviceCode = DeviceGuru.hardwareString()
//        print("\(deviceName) - \(deviceCode)") //Ex: iphone_7_PLUS - iPhone9,2
//    }
    
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
        
        //let fileService = FileServices()
        /*
        print("DEBUT -----  Test save fileJSON in application directory")
        let exportJSONServices = exportServices.getSubscribersJSON(_businessServiceTitle: "CanalPlay")
        path = fileService.createJSONFileFromString(JSONStringified: exportJSONServices, businessServiceTitle: "CanalPlay", viewController: self)
        print("FIN ----- Test save fileJSON in application directory")
        */
        
        
        print("DEBUT -----  Test save fileCSV in application directory")
        //let exportCSVServices = exportServices.getSubscribersCSV(_businessServiceTitle: "CanalPlay")
        //path = fileService.createCSVFileFromString(CSVStringified: exportCSVServices, businessServiceTitle: "CanalPlay", viewController: self)
        print("FIN ----- Test save fileCSV in application directory")
        
        
        let importMenu = UIDocumentMenuViewController(url: path!, in: UIDocumentPickerMode.moveToService)
        importMenu.delegate = self
        self.present(importMenu, animated: true, completion: nil)
        

        
        print(exportServices.getSubscribersJSON(_businessServiceTitle: "CanalPlay"))
        
        
        
        print(exportServices.getSubscribersCSV(_businessServiceTitle: "CanalPlay"))
        
        realmServices.resetService(title: "CanalPlay")
        
        let myTest2 = realm.objects(BusinessService.self)
        
        print("My test after Reset = \(myTest2)")
        print("FIN ---- test realm!!!!")
    }
    
    @IBAction func testDevice(_ sender: UIButton) {
        /*var sys = System()
        let cpuUsage = sys.usageCPU()
        print("\tSYSTEM:          \(Int(cpuUsage.system))%")
        print("\tUSER:            \(Int(cpuUsage.user))%")
        print("\tIDLE:            \(Int(cpuUsage.idle))%")
        print("\tNICE:            \(Int(cpuUsage.nice))%")
        
        
        print("\n-- MEMORY --")
        print("\tPHYSICAL SIZE:   \(System.physicalMemory())GB")
        
        let memoryUsage = System.memoryUsage()
        func memoryUnit(_ value: Double) -> String {
            if value < 1.0 { return String(Int(value * 1000.0))    + "MB" }
            else           { return NSString(format:"%.2f", value) as String + "GB" }
        }
        
        print("\tFREE:            \(memoryUnit(memoryUsage.free))")
        print("\tWIRED:           \(memoryUnit(memoryUsage.wired))")
        print("\tACTIVE:          \(memoryUnit(memoryUsage.active))")
        print("\tINACTIVE:        \(memoryUnit(memoryUsage.inactive))")
        print("\tCOMPRESSED:      \(memoryUnit(memoryUsage.compressed))")*/
    }
}

