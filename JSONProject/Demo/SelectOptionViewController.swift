//
//  GeneralFormViewController.swift
//  Demo
//
//  Created by MAC ISTV on 28/04/2017.
//  Copyright © 2017 UVHC. All rights reserved.
//

import UIKit

class SelectOptionViewController: UIViewController, UIPickerViewDelegate, UIScrollViewDelegate  {
    
    
    var scrollView = UIScrollView()
    var containerView = UIView()
    let realmServices = RealmServices()
    var jsonModel: JsonModel? = nil
    var customNavigationController: UINavigationController? = nil
    var person: Person? = nil
    var customParent: SpecificFormViewController? = nil
    var choosenOffer: Offer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set up title of view
        self.title = "Options"
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        containerView.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
    }
    
    public func setupNavigationController (navigationController: UINavigationController){
        self.customNavigationController = navigationController
    }
    
    public func setupPerson(person: Person) {
        self.person = person
    }
    
    public func setupCustomParent(customParent: SpecificFormViewController) {
        self.customParent = customParent
    }
    
    public func setupChoosenOffer(choosenOffer: Offer) {
        self.choosenOffer = choosenOffer
    }
    
    override func willMove(toParentViewController: UIViewController?)
    {
        if (toParentViewController == nil) {
            if (!(self.person?.isSaved)!) {
                // remove all options
                self.person?.removeAllOptions()
                // Pass person to the parent
                self.customParent?.setupPerson(person: self.person!)
                // Reset custom parent
                self.customParent = nil
            }
        }
    }
    
    func next(_ sender: UIButton) {
        // get data from UI for the Person Object
        // Test if all requiredField are completed
        let subViews = self.containerView.subviews
        for view in subViews {
            if let optionSwitchButton = view as? UISwitch {
                if (optionSwitchButton.isOn) {
                    var cpt = 0
                    var serviceOptionChoosen: ServiceOption? = nil
                    for option in (self.choosenOffer?.features)! {
                        if (cpt == optionSwitchButton.tag) {
                            serviceOptionChoosen = ServiceOption(title: option.title, optionDescription: option.description, price: option.price)
                        }
                        cpt += 1
                    }
                    // Check if the option is not in the serviceOption of the person
                    if (self.person?.optionNotAlreadyTaken(serviceOption: serviceOptionChoosen!))! {
                        self.person?.addServiceOptionToPerson(serviceOption: serviceOptionChoosen!)
                    }
                }
            }
        }
        
        // Go to next Screen
        // Redirect To Next Step
        let paymentView = PaymentViewController(nibName: "PaymentViewController", bundle: nil)
        
        if (self.person != nil) {
            paymentView.setupPerson(person: self.person!)
        }
        paymentView.setupNavigationController(navigationController: self.customNavigationController!)
        paymentView.setupCustomParent2(customParent: self)
        paymentView.createViewFromJson(json: self.jsonModel)
        self.customNavigationController?.pushViewController(paymentView, animated: true)
        
        
        // Save the person in realm database
        //realmServices.createPerson(person: self.person!)
        //realmServices.addSubscriberToService(title: (self.jsonModel?.title)!, subscriber: self.person!)
    }
    
    
    func createViewFromJson(json: JsonModel?){
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
            
            // Ajout message
            let message: UILabel = UILabel(frame: CGRect(x: 20, y: 50, width: 350.00, height: 100.00));
            message.numberOfLines = 0
            message.text = "Vous pouvez choisir des options :"
            self.containerView.addSubview(message)
            
            var pX = 150
            var cpt = 1
            for offer in (self.choosenOffer?.features)! {
                // Ajout bouton switch
                let switchButton = UISwitch(frame: CGRect(x: 10, y: CGFloat(pX), width: 350, height: 20))
                switchButton.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
                switchButton.tag = cpt - 1
                self.containerView.addSubview(switchButton)
                // Display title
                let optionTitle = UILabel(frame: CGRect(x: 60, y: CGFloat(pX) + 5 , width: 350, height: 20))
                optionTitle.numberOfLines = 0
                optionTitle.text = "Option " + String(cpt) + " : " + offer.title
                self.containerView.addSubview(optionTitle)
                pX += 30
                // Display description
                let optionDesc = UILabel(frame: CGRect(x: 20, y: CGFloat(pX), width: 350, height: 70))
                optionDesc.numberOfLines = 0
                optionDesc.lineBreakMode = .byWordWrapping
                optionDesc.text = "Description de l'offre : \n" + offer.description
                self.containerView.addSubview(optionDesc)
                pX += 80
                // Display price
                let optionPrice = UILabel(frame: CGRect(x: 20, y: CGFloat(pX), width: 350, height: 20))
                optionPrice.text = "Prix : " + String(offer.price)
                self.containerView.addSubview(optionPrice)
                pX += 50
                cpt += 1
            }
            pX += 30
            // Ajout du bouton
            let nextButton = UIButton(frame: CGRect(x: 20, y: CGFloat(pX), width: 350.00, height: 30.00))
            nextButton.setTitle("Paiement", for: .normal)
            nextButton.addTarget(self, action: #selector(self.next(_:)), for: .touchUpInside)
            nextButton.backgroundColor = UIColor.blue
            
            self.containerView.addSubview(nextButton)
            self.scrollView.contentSize = CGSize(width: 375, height: pX + 100)
        }
        //self.view.frame.size.height = 10000
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

