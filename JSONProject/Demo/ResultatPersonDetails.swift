//
//  ResultatPersonDetails.swift
//  Demo
//
//  Created by MAC ISTV on 10/05/2017.
//  Copyright © 2017 UVHC. All rights reserved.
//

import UIKit

class ResultatPersonDetails: UIViewController {

    var customNavigationController: UINavigationController? = nil
    var affiliate: Person? = nil
    
    
    public func setupNavigationController(navigationController: UINavigationController){
        self.customNavigationController = navigationController
    }
    
    public func setupAffiliate(affiliate: Person) {
        self.affiliate = affiliate
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Detail affilié"
        // TODO Créer l'interface en utlisant self.person
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
