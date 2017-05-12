//
//  AideViewController.swift
//  tesst
//
//  Created by morgan basset on 28/02/2017.
//  Copyright © 2017 UVHC. All rights reserved.
//

import UIKit
import LocalAuthentication
import SystemConfiguration

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
        // Automatically switch to the import view
        DispatchQueue.main.async() {
            self.tabBarController?.selectedIndex = 2
        }
        
        
        
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
    
    
    @IBAction func displaySystemInfo(_ sender: UIButton) {
         var sys = System()
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
         print("\tCOMPRESSED:      \(memoryUnit(memoryUsage.compressed))")
        

    }

    
    func addTabBarItemResultat(){
        
        self.tabBarController?.tabBar.items?[1].isEnabled = true
        self.tabBarController?.tabBar.items?[2].isEnabled = true
    }
    
}
