//
//  AideViewController.swift
//  tesst
//
//  Created by morgan basset on 28/02/2017.
//  Copyright © 2017 UVHC. All rights reserved.
//

import UIKit
import LocalAuthentication

class AideViewController: UIViewController {
    
    var controllerArray = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func AfficherMenuAdmin(_ sender: Any) {
        
        self.addTabBarItemResultat()
        
        
        /*let authenticationContext = LAContext()
        
        authenticationContext.evaluatePolicy(
            .deviceOwnerAuthenticationWithBiometrics,
            localizedReason: "Veuillez-vous identifier",
            reply: { (success, error) -> Void in
                if(success) {
                    self.addTabBarItemResultat()
                    print("success")
                } else {
                    print("erreur")
                }
        })*/
    }

    
    func addTabBarItemResultat(){
        
        self.tabBarController?.tabBar.items?[1].isEnabled = true
        self.tabBarController?.tabBar.items?[2].isEnabled = true
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
