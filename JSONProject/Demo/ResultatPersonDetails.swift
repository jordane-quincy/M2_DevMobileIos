//
//  ResultatPersonDetails.swift
//  Demo
//
//  Created by MAC ISTV on 10/05/2017.
//  Copyright © 2017 UVHC. All rights reserved.
//

import UIKit

class ResultatPersonDetails: UIViewController {

    var scrollView = UIScrollView()
    var containerView = UIView()
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
        self.title = "Détails"
        // TODO Créer l'interface en utlisant self.person
    }
    
    func createViewFromAffiliate(){
        // Setup interface
        DispatchQueue.main.async() {
            // Reset the view
            self.view.subviews.forEach({ $0.removeFromSuperview() })
            // Setup scrollview
            self.scrollView = UIScrollView()
            self.scrollView.delegate = self
            self.view.addSubview(self.scrollView)
            self.containerView = UIView()
            self.scrollView.addSubview(self.containerView)
            
            
            // Ajout titre service
            let title: UILabel = UILabel(frame: CGRect(x: 20, y: 20, width: 350.00, height: 30.00));
            title.text = "Nom : " + (json?.title)!
            self.containerView.addSubview(title)
            
            
            // Ajout description du service
            let description: UILabel = UILabel(frame: CGRect(x: 20, y: 50, width: 400.00, height: 100.00));
            description.numberOfLines = 0
            description.text = "Voici la description de ce service : \n" + (json?.description)!
            self.containerView.addSubview(description)
            
            // Start message
            let startMessage: UILabel = UILabel(frame: CGRect(x: 20, y: 130, width: 350.00, height: 100.00))
            startMessage.numberOfLines = 0
            startMessage.text = "Pour vous inscrire à ce service cliquez sur \"Commencer\""
            self.containerView.addSubview(startMessage)
            
            // Set size fo scrollView
            self.scrollView.contentSize = CGSize(width: 375, height: 250)
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
