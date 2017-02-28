//
//  ViewController.swift
//  Demo
//
//  Created by Mathilde Dumont on 24/01/2017.
//  Copyright © 2017 UVHC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //MARK: Properties

    @IBOutlet weak var welcomeLabel: UILabel!
    
    @IBOutlet weak var nameField: UITextField!
    
    @IBOutlet weak var helloLabel: UILabel!
    
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
        
        helloLabel.text = "Bonjoue " + nameField.text! + " !"
        let nameFile = "exampleJSON1"
        let jsonUtils = JSONUtils()
        let jsonObject = jsonUtils.readJson(fileName: nameFile)
        if (jsonObject != nil) {
            let commonFields = jsonObject?["commonFields"] as! NSArray
            let commonFieldsZero = commonFields[0] as! [String: Any]
            print(commonFieldsZero["label"]!)
        }
        else {
            print("erreur lecture json")
        }
    }
    
    
}

