//
//  ResultatPersonDetails.swift
//  Demo
//
//  Created by MAC ISTV on 10/05/2017.
//  Copyright © 2017 UVHC. All rights reserved.
//

import UIKit

class ResultatPersonDetails: UIViewController, UIScrollViewDelegate {

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
    
    // For displaying scrollView
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        containerView.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
    }
    
    func createViewFromAffiliate(){
        // Setup interface
        DispatchQueue.main.async() {
            // Setup scrollview
            self.scrollView = UIScrollView()
           // self.scrollView.delegate = self
            self.view.addSubview(self.scrollView)
            self.containerView = UIView()
            self.scrollView.addSubview(self.containerView)
            
            var posY: Double = 70
            
            for (index, attribute) in ((self.affiliate?.attributes)!).enumerated() {
                if (attribute.value != ""){
                    let label: UILabel = UILabel(frame: CGRect(x: 20, y: posY, width: 335, height: 30.00));
                    //Pour les attributs, affichage "label : value"
                    label.text = attribute.label + " : " + attribute.value
                    self.containerView.addSubview(label)
                    
                    posY += (index < ((self.affiliate?.attributes.count)! - 1) ? 30 : 60)
                }
            }
            
            if (self.affiliate?.serviceOffer != nil) {
                
                if (self.affiliate?.serviceOffer?.title != ""){
                    // Ajout label serviceOffer.title
                    let title: UILabel = UILabel(frame: CGRect(x: 20, y: posY, width: 335, height: 30.00));
                    title.text = "Service souscrit : " + (self.affiliate?.serviceOffer?.title)!
                    self.containerView.addSubview(title)
                    
                    posY += 20
                }
                
                if (self.affiliate?.serviceOffer?.offerDescription != ""){
                    // Ajout description du service
                    let description: UILabel = UILabel(frame: CGRect(x: 20, y: posY, width: 335, height: 100.00));
                    description.numberOfLines = 0
                    description.text = "Description : \n" + (self.affiliate?.serviceOffer?.offerDescription)!
                    self.containerView.addSubview(description)
                    
                    posY += 100
                }
                
                //Ajout du prix de l'offre
                let price: UILabel = UILabel(frame: CGRect(x: 20, y: posY, width: 335, height: 30.00));
                price.text = "Prix de l'offre : " + String((self.affiliate?.serviceOffer?.price)!) + "€"
                self.containerView.addSubview(price)
                
                posY += 50
            }
            
            let numberOfOption = (self.affiliate?.serviceOptions.count)!
            if (numberOfOption > 0) {
                let messageOption: UILabel = UILabel(frame: CGRect(x: 20, y: posY, width: 335, height: 30.00));
                messageOption.text = "Option" + (numberOfOption > 1 ? "s " : " ") + "souscrite" + (numberOfOption > 1 ? "s :" : " :")
                self.containerView.addSubview(messageOption)
                posY += 30
            }
            
            for option in (self.affiliate?.serviceOptions)! {
                
                if (option.title != ""){
                    // Ajout label option.title
                    let title: UILabel = UILabel(frame: CGRect(x: 50, y: posY, width: 305, height: 30.00));
                    title.text = "• Option : " + (option.title)
                    self.containerView.addSubview(title)
                    posY += 20
                }
                
                if (option.optionDescription != ""){
                    // Ajout description de l'option
                    let description: UILabel = UILabel(frame: CGRect(x: 65, y: posY, width: 305, height: 100.00));
                    description.numberOfLines = 0
                    description.text = "Description : \n" + (option.optionDescription)
                    self.containerView.addSubview(description)
                    
                    posY += 100
                }
                
                //Ajout du prix de l'option
                let price: UILabel = UILabel(frame: CGRect(x: 65, y: posY, width: 335, height: 30.00));
                price.text = "Prix de l'option : " + String(option.price) + "€"
                self.containerView.addSubview(price)
                
                posY += 30
            }
            posY += 20
            
            if (self.affiliate?.paymentWay?.label != ""){
                // Ajout label
                let label: UILabel = UILabel(frame: CGRect(x: 20, y: posY, width: 335, height: 30.00));
                label.text = "Moyen de paiement : " + (self.affiliate?.paymentWay?.label)!
                self.containerView.addSubview(label)
                
                posY += 30
            }
            
            for attribute in (self.affiliate?.paymentWay?.paymentAttributes)! {
                if (attribute.value != ""){
                    let label: UILabel = UILabel(frame: CGRect(x: 20, y: posY, width: 335, height: 30.00));
                    //Pour les attributs, affichage "label : value"
                    label.text = attribute.label + " : " + attribute.value
                    self.containerView.addSubview(label)
                    
                    posY += 30
                }
                
            }
            // Set size fo scrollView
            self.scrollView.contentSize = CGSize(width: 350, height: posY + 50)
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
