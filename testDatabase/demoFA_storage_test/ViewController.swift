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
    
    
    @IBOutlet weak var name: UITextField!

    @IBOutlet weak var mail: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func save(_ sender: Any) {
        
        let person = Person()
        person.name = self.name.text!
        person.mail = self.mail.text!
        
        
        let realm = try! Realm()
        
        try! realm.write {
            realm.add(person)
            print("\(person)")
        }
        
        let myTest = realm.objects(Person.self)
        
        print("My test name : \(myTest)")
    }

}

