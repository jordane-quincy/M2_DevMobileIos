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
    var customNavigationController: UINavigationController? = nil
    
    @IBOutlet weak var champMdp: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // setup swipe
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        // Do any additional setup after loading the view.
    }
    
    public func setupNavigationController(navigationController: UINavigationController){
        self.customNavigationController = navigationController
    }
    
    // swipe function
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                // GO TO THE LEFT Pannel
                DispatchQueue.main.async() {
                    if (self.tabBarController?.tabBar.items?[2].isEnabled)! {
                        self.tabBarController?.selectedIndex = 2
                    }
                    else {
                        self.tabBarController?.selectedIndex = 0
                    }
                }
            case UISwipeGestureRecognizerDirection.left:
                // GO TO THE RIGHT Pannel
                DispatchQueue.main.async() {
                    self.tabBarController?.selectedIndex = 0
                }
            default:
                break
            }
        }
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
        // GO to System View
        let systemView = InfoSystemViewController(nibName: "InfoSystemViewController", bundle: nil)
        systemView.setupNavigationController(navigationController: self.customNavigationController!)
        
        self.customNavigationController?.pushViewController(systemView, animated: true)
        self.customNavigationController?.setNavigationBarHidden(false, animated: true)
    }

    
    @IBAction func EnabledBarItemMdp(_ sender: Any) {
        
        if(champMdp.text == "1234"){
            self.addTabBarItemResultat()
            // Automatically switch to the import view
            DispatchQueue.main.async() {
                self.tabBarController?.selectedIndex = 2
            }
        }
        
    }
    func addTabBarItemResultat(){
        
        self.tabBarController?.tabBar.items?[1].isEnabled = true
        self.tabBarController?.tabBar.items?[2].isEnabled = true
    }
    
}
