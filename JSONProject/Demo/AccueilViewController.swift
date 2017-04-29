//
//  AccueilViewController.swift
//  Demo
//
//  Created by morgan basset on 04/04/2017.
//  Copyright © 2017 UVHC. All rights reserved.
//

import UIKit

class AccueilViewController: UIViewController, UIScrollViewDelegate  {

    
    var scrollView = UIScrollView()
    var containerView = UIView()
    let realmServices = RealmServices()
    var jsonModel: JsonModel? = nil
    var customNavigationController: UINavigationController? = nil
    var person: Person? = nil
    
    
    public func setupNavigationController(navigationController: UINavigationController){
        self.customNavigationController = navigationController
    }
    
    public func setupPerson(person: Person?) {
        self.person = person
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        containerView.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
    }
    
    func goToSelectOfferView(_ sender: UIButton) {
        // Redirect To Next Step
        //let navigationController = UINavigationController(rootViewController: self)
        
        // TODO verifier que la vue n'existe pas deja
        let selectOfferView = SelectOfferViewController(nibName: "SelectOfferViewController", bundle: nil)
        selectOfferView.setupNavigationController(navigationController: self.customNavigationController!)
        selectOfferView.setupCustomParent(customParent: self)
        selectOfferView.createViewFromJson(json: self.jsonModel)
        self.customNavigationController?.title = self.jsonModel?.title
        self.customNavigationController?.pushViewController(selectOfferView, animated: true)
        self.customNavigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    func createViewFromJson(json: JsonModel?){
        print(json as Any)
        self.jsonModel = json
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
            title.text = "Bonjour bienvenue sur le service : " + (json?.title)!
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

            // Ajout du bouton commencer
            let statButton = UIButton(frame: CGRect(x: 20, y: 230, width: 350.00, height: 30.00))
            statButton.setTitle("Commencer !", for: .normal)
            statButton.addTarget(self, action: #selector(self.goToSelectOfferView(_:)), for: .touchUpInside)
            statButton.backgroundColor = UIColor.blue
            self.containerView.addSubview(statButton)
            
            // Set size fo scrollView
            self.scrollView.contentSize = CGSize(width: 375, height: 250)
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
