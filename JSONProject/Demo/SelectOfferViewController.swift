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
    var person: Person? = nil
    var customParent: AccueilViewController? = nil
    var indexOfPreviousSelectedOffer = -1
    
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
    
    override func willMove(toParentViewController: UIViewController?)
    {
        if (toParentViewController == nil) {
            // Hide the navigation bar
            self.customNavigationController?.setNavigationBarHidden(true, animated: true)
            // Pass the person object to the parent
            self.customParent?.setupPerson(person: self.person!)
            // reset customParent
            self.customParent = nil
        }
    }
    
    public func setupNavigationController (navigationController: UINavigationController){
        self.customNavigationController = navigationController
    }
    
    public func setupIndexOfPreviousSelectedOffer(index: Int) {
        self.indexOfPreviousSelectedOffer = index
    }
    
    public func setupPerson(person: Person) {
        self.person = person
    }
    
    public func setupCustomParent(customParent: AccueilViewController) {
        self.customParent = customParent
    }
    
    func goToGeneralFormView(_ sender: UIButton) {
        let indexOfSelectedOffer = sender.tag
        print(String(indexOfSelectedOffer))
        
        // Redirect To Next Step
        let generalFormView = GeneralFormViewController(nibName: "GeneralFormViewController", bundle: nil)
        
        if (self.person != nil) {
            if (self.indexOfPreviousSelectedOffer > -1 && indexOfSelectedOffer != self.indexOfPreviousSelectedOffer) {
                self.person?.removeAllSpecificFields()
            }
            generalFormView.setupPerson(person: self.person!)
        }
        generalFormView.setupNavigationController(navigationController: self.customNavigationController!)
        generalFormView.setIndexOfSelectedOffer(index: indexOfSelectedOffer)
        generalFormView.setupCustomParent(customParent: self)
        generalFormView.createViewFromJson(json: self.jsonModel)
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
                offerButton.tag = cpt - 1
                // Setup action on the button
                offerButton.addTarget(self, action: #selector(self.goToGeneralFormView(_:)), for: .touchUpInside)
                self.containerView.addSubview(offerButton)
                cpt += 1
                pX += 160
            }
            self.scrollView.contentSize = CGSize(width: 375, height: pX + 100)
        }
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
