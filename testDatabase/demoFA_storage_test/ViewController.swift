//
//  ViewController.swift
//  demoFA_storage_test
//
//  Created by DeptInfo on 03/04/2017.
//  Copyright © 2017 DeptInfo. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var name: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func save(_ sender: Any) {
        
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
        
        print(exportServices.getSubscribersJSON(_businessServiceTitle: "CanalPlay"))
        
        print(exportServices.getSubscribersCSV(_businessServiceTitle: "CanalPlay"))
        
        realmServices.resetService(title: "CanalPlay")
        
        let myTest2 = realm.objects(BusinessService.self)
        
        print("My test after Reset = \(myTest2)")
        
        
    }

}

