//
//  SelectOfferViewController.swift
//  Demo
//
//  Created by MAC ISTV on 28/04/2017.
//  Copyright © 2017 UVHC. All rights reserved.
//

import UIKit

class SelectOfferViewController: UIViewController, UIPickerViewDelegate, UIScrollViewDelegate {

    var scrollView = UIScrollView()
    var containerView = UIView()
    let realmServices = RealmServices()
    var jsonModel: JsonModel? = nil
    var serviceTitle: String = ""
    var customNavigationController: UINavigationController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Choix offres"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        containerView.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Hide the navigation bar
        self.customNavigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.customNavigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    public func setupNavigationController (navigationController: UINavigationController){
        self.customNavigationController = navigationController
    }
    
    func goToGeneralFormView(_ sender: UIButton) {
        let indexOfSelectedOffer = sender.tag
        print(String(indexOfSelectedOffer))
        // Redirect To Next Step
        //let navigationController = UINavigationController(rootViewController: self)
        
        // TODO verifier que la vue n'existe pas deja
        let generalFormView = GeneralFormViewController(nibName: "GeneralFormViewController", bundle: nil)
        generalFormView.setupNavigationController(navigationController: self.customNavigationController!)
        generalFormView.createViewFromJson(json: self.jsonModel)
        generalFormView.setIndexOfSelectedOffer(index: indexOfSelectedOffer)
        self.customNavigationController?.pushViewController(generalFormView, animated: true)
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
            
            // Ajout select offer label
            let title: UILabel = UILabel(frame: CGRect(x: 20, y: 70, width: 350.00, height: 30.00));
            title.text = "Choisissez votre offre parmis les suivantes : "
            self.containerView.addSubview(title)
            
            
            var pX = 120
            var cpt = 1
            for offer in (json?.offers)! {
                print(offer)
                let offerButton = UIButton(frame: CGRect(x: 20, y: CGFloat(pX), width: 350.00, height: 130.00))

                // enable button with multiple lines
                offerButton.titleLabel?.lineBreakMode = .byWordWrapping

                let title = "Offre " +
                    String(cpt) +
                    " : \n" +
                    offer.title +
                    "\n" +
                    offer.description +
                    "\nA partir de " +
                    String(offer.price) +
                    " €"
                offerButton.setTitle(title , for: .normal)
                offerButton.backgroundColor = UIColor.blue
                offerButton.tag = cpt
                // Setup action on the button
                offerButton.addTarget(self, action: #selector(self.goToGeneralFormView(_:)), for: .touchUpInside)
                self.containerView.addSubview(offerButton)
                cpt += 1
                pX += 160
            }
            self.scrollView.contentSize = CGSize(width: 375, height: pX + 100)
        }
        
        // Setup interface
        /*DispatchQueue.main.async() {
            // Reset the view
            self.view.subviews.forEach({ $0.removeFromSuperview() })
            // Setup scrollview
            self.scrollView = UIScrollView()
            self.scrollView.delegate = self
            self.view.addSubview(self.scrollView)
            self.containerView = UIView()
            self.scrollView.addSubview(self.containerView)
            
            // Ajout select offer label
            let title: UILabel = UILabel(frame: CGRect(x: 20, y: 70, width: 350.00, height: 30.00));
            title.text = "Choisissez votre offre parmis les suivantes : "
            self.containerView.addSubview(title)
            
            
            var pX = 120
            var cpt = 1
            /*for offer in (json?.offers)! {
                print(offer)
                let offerButton = UIButton(frame: CGRect(x: 20, y: CGFloat(pX), width: 350.00, height: 130.00))
                
                // enable button with multiple lines
                offerButton.titleLabel?.lineBreakMode = .byWordWrapping
                
                let title = "Offre " +
                    String(cpt) +
                    " : \n" +
                    offer.title +
                    "\n" +
                    offer.description +
                    "\nA partir de " +
                    String(offer.price) +
                    " €"
                offerButton.setTitle(title , for: .normal)
                offerButton.backgroundColor = UIColor.blue
                offerButton.tag = cpt
                // Setup action on the button
                offerButton.addTarget(self, action: #selector(self.goToGeneralFormView(_:)), for: .touchUpInside)

                self.containerView.addSubview(offerButton)
                cpt += 1
                pX += 160
            }*/
            let statButton = UIButton(frame: CGRect(x: 20, y: CGFloat(pX), width: 350.00, height: 30.00))
            statButton.setTitle("Commencer !", for: .normal)
            statButton.addTarget(self, action: #selector(self.goToSelectOfferView(_:)), for: .touchUpInside)
            statButton.backgroundColor = UIColor.blue
            self.containerView.addSubview(statButton)
        }*/
        //self.view.frame.size.height = 10000
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let customPickerView = pickerView as? CustomPickerView
        return customPickerView!.pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let customPickerView = pickerView as? CustomPickerView
        return customPickerView?.pickerData[row].value
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    

    

}
