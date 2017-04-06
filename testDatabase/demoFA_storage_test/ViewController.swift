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
        let realm = try! Realm()
        
        realmServices.resetDataBase()
        
        //Init du service
        let businessService = BusinessService(_title: "Le titre", _serviceDescription: "Description du service", _brand: "La marque")
        
        realmServices.createBusinessService(businessService: businessService)
        
        
        //Ajout d'une personne
        let person = Person(_email: email.text!)
       
        realmServices.createPerson(person: person)
        
        //Ajout d'un attribut à la personne
        let attribute = Attribute(_label: "Le label", _fieldName: "Nom du champ", _value: name.text!)
        
        //realmServices.createAttribute(_attribute: attribute)
        
        //Ajout d'un attribut à la personne
        let attribute2 = Attribute(_label: "Le label 2", _fieldName: "Nom du champ 2", _value: email.text!)
        
        //realmServices.createAttribute(_attribute: attribute2)
        
        realmServices.addSubscriberToService(title: "Le titre", subscriber: person)
        realmServices.addAttributeToPerson(email: person.email, attribute: attribute)
        realmServices.addAttributeToPerson(email: person.email, attribute: attribute2)
        
        //businessService.addPersonToService(person: person)
        
        
        
        
        let myTest = realm.objects(Person.self)
        
        print("My test name : \(myTest)")
        
        realmServices.resetService(title: "Le titre")
        
        let myTest2 = realm.objects(BusinessService.self)
        
        print("My test after Reset = \(myTest2)")
        
        
    }

}

