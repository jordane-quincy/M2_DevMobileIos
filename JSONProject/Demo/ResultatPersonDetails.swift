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
        createViewFromAffiliate()
    }
    
    func createViewFromAffiliate(){
        // Setup interface
        DispatchQueue.main.async() {
            // Reset the view
            self.view.subviews.forEach({ $0.removeFromSuperview() })
            // Setup scrollview
            self.scrollView = UIScrollView()
           // self.scrollView.delegate = self
            self.view.addSubview(self.scrollView)
            self.containerView = UIView()
            self.scrollView.addSubview(self.containerView)
            
            var posY: Double = 20
            
            for attribute in (self.affiliate?.attributes)! {
                if (attribute.value != ""){
                    let label: UILabel = UILabel(frame: CGRect(x: 20, y: posY, width: 350.00, height: 30.00));
                    //Pour les attributs, affichage "label : value"
                    label.text = attribute.label + " : " + attribute.value
                    self.containerView.addSubview(label)
                    
                    posY += 30
                }
            }
            
            if (self.affiliate?.serviceOffer != nil) {
                
                if (self.affiliate?.serviceOffer?.title != ""){
                    // Ajout label serviceOffer.title
                    let title: UILabel = UILabel(frame: CGRect(x: 20, y: posY, width: 350.00, height: 30.00));
                    title.text = "Service souscrit : " + (self.affiliate?.serviceOffer?.title)!
                    self.containerView.addSubview(title)
                    
                    posY += 30
                }
                
                if (self.affiliate?.serviceOffer?.offerDescription != ""){
                    // Ajout description du service
                    let description: UILabel = UILabel(frame: CGRect(x: 20, y: posY, width: 400.00, height: 100.00));
                    description.numberOfLines = 0
                    description.text = "Description : \n" + (self.affiliate?.serviceOffer?.offerDescription)!
                    self.containerView.addSubview(description)
                    
                    posY += 50
                }
                
                //Ajout du prix de l'offre
                let price: UILabel = UILabel(frame: CGRect(x: 20, y: posY, width: 350.00, height: 30.00));
                price.text = "Prix de l'offre : " + String((self.affiliate?.serviceOffer?.price)!)
                self.containerView.addSubview(price)
                
                posY += 30
            }
            
            
            for option in (self.affiliate?.serviceOptions)! {
                
                if (option.title != ""){
                    // Ajout label option.title
                    let title: UILabel = UILabel(frame: CGRect(x: 20, y: posY, width: 350.00, height: 30.00));
                    title.text = "Option : " + (option.title)
                    self.containerView.addSubview(title)
                    
                    posY += 30
                }
                
                if (option.optionDescription != ""){
                    // Ajout description de l'option
                    let description: UILabel = UILabel(frame: CGRect(x: 20, y: posY, width: 400.00, height: 100.00));
                    description.numberOfLines = 0
                    description.text = "Description : \n" + (option.optionDescription)
                    self.containerView.addSubview(description)
                    
                    posY += 50
                }
                
                //Ajout du prix de l'option
                let price: UILabel = UILabel(frame: CGRect(x: 20, y: posY, width: 350.00, height: 30.00));
                price.text = "Prix de l'option : " + String(option.price)
                self.containerView.addSubview(price)
                
                posY += 30
            }
            
            if (self.affiliate?.paymentWay?.label != ""){
                // Ajout label
                let label: UILabel = UILabel(frame: CGRect(x: 20, y: posY, width: 350.00, height: 30.00));
                label.text = "Moyen de paiement : " + (self.affiliate?.paymentWay?.label)!
                self.containerView.addSubview(label)
                
                posY += 30
            }
            
            for attribute in (self.affiliate?.paymentWay?.paymentAttributes)! {
                if (attribute.value != ""){
                    let label: UILabel = UILabel(frame: CGRect(x: 20, y: posY, width: 350.00, height: 30.00));
                    //Pour les attributs, affichage "label : value"
                    label.text = attribute.label + " : " + attribute.value
                    self.containerView.addSubview(label)
                    
                    posY += 30
                }
                
            }
            
            
            
            // Set size fo scrollView
            self.scrollView.contentSize = CGSize(width: 375, height: 250)
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
