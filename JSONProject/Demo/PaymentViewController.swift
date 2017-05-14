//
//  GeneralFormViewController.swift
//  Demo
//
//  Created by MAC ISTV on 28/04/2017.
//  Copyright © 2017 UVHC. All rights reserved.
//

import UIKit

class PaymentViewController: UIViewController, UIPickerViewDelegate, UIScrollViewDelegate  {
    
    
    var scrollView = UIScrollView()
    var containerView = UIView()
    let realmServices = RealmServices()
    var jsonModel: JsonModel? = nil
    var customNavigationController: UINavigationController? = nil
    var person: Person? = nil
    var customParent1: SpecificFormViewController? = nil
    var customParent2: SelectOptionViewController? = nil
    var pX = 0
    var selectedPaymentWay = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set up title of view
        self.title = "Paiement"
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
    
    public func setupCustomParent1(customParent: SpecificFormViewController) {
        self.customParent1 = customParent
    }
    
    public func setupCustomParent2(customParent: SelectOptionViewController) {
        self.customParent2 = customParent
    }
    
    override func willMove(toParentViewController: UIViewController?)
    {
        if (toParentViewController == nil) {
            if (!(self.person?.isSaved)!) {
                // Reset custom parent
                self.customParent1 = nil
                self.customParent2 = nil
            }
        }
    }
    
    func validSubscription(_ sender: UIButton) {
        // get data from UI for the Person Object
        // Test if all requiredField are completed
        let paymentWay = PaymentWay(label: self.selectedPaymentWay)
        var tag = -1
        if (self.selectedPaymentWay == "Compte Bancaire") {
            tag = 1
        }
        if (self.selectedPaymentWay == "Carte Bancaire") {
            tag = 2
        }
        if (self.selectedPaymentWay == "Paypal") {
            tag = 3
        }
        var champManquant: Bool = false
        for view in self.containerView.subviews {
            if (view.tag == tag) {
                if let textField = view as? CustomTextField {
                    if(textField.required == true && textField.text == ""){
                        print("Champ requis non rempli")
                        champManquant = true
                    }
                    let paymentAttribute = PaymentAttribute(_label: textField.label, _fieldName: textField.fieldName, _value: textField.text!)
                    paymentWay.addPaymentAttribute(paymentAttribute: paymentAttribute)
                }
            }
        }
        
        // test if they are empty required field
        if(champManquant){
            let alert = UIAlertController(title: "", message: "Veuillez remplir tous les champs requis (champs avec une étoile)", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Fermer", style: UIAlertActionStyle.default, handler: { action in
                switch action.style{
                case .default:
                    print("default")
                    
                case .cancel:
                    print("cancel")
                    
                case .destructive:
                    print("destructive")
                }
            }))
            self.present(alert, animated: true, completion: nil)
        } else {
            self.person?.setupPaymentWay(paymentWay: paymentWay)
            self.person?.changeIsSavePerson()
            // Save the person in realm database
            realmServices.createPerson(person: self.person!)
            realmServices.addSubscriberToService(title: (self.jsonModel?.title)!, subscriber: self.person!)
            // Go Back to home view
            self.customNavigationController?.popToRootViewController(animated: true)
        }
    }
    
    
    func createFormCreditAccount() {
        // Ajout iban
        let ibanLabel = UILabel(frame: CGRect(x: 20, y: CGFloat(self.pX), width: 335, height: 20))
        ibanLabel.text = "IBAN*"
        ibanLabel.tag = 1
        self.pX += 20
        self.containerView.addSubview(ibanLabel)
        
        // Ajout ibanField
        let ibanTextField = CustomTextField(frame: CGRect(x: 20, y: CGFloat(self.pX), width: 335, height: 40))
        ibanTextField.required = true
        ibanTextField.fieldName = "iban"
        ibanTextField.placeholder = "Completer"
        ibanTextField.label = "IBAN"
        ibanTextField.tag = 1
        self.pX += 60
        self.containerView.addSubview(ibanTextField)
        
        // Ajout bic
        let bicLabel = UILabel(frame: CGRect(x: 20, y: CGFloat(self.pX), width: 335, height: 20))
        bicLabel.text = "BIC*"
        bicLabel.tag = 1
        self.pX += 20
        self.containerView.addSubview(bicLabel)
        
        // Ajout bicField
        let bicTextField = CustomTextField(frame: CGRect(x: 20, y: CGFloat(self.pX), width: 335, height: 40))
        bicTextField.required = true
        bicTextField.fieldName = "bic"
        bicTextField.placeholder = "Completer"
        bicTextField.label = "BIC"
        bicTextField.tag = 1
        self.pX += 60
        self.containerView.addSubview(bicTextField)
        
        // Add Validation button
        let validationButton = UIButton(frame: CGRect(x: 25, y: CGFloat(pX), width: 335, height: 30.00))
        validationButton.setTitle("Valider l'inscription", for: .normal)
        validationButton.addTarget(self, action: #selector(self.validSubscription(_:)), for: .touchUpInside)
        validationButton.tag = 1
        validationButton.setTitleColor(UIView().tintColor, for: .normal)
        validationButton.backgroundColor = UIColor.clear
        validationButton.titleLabel?.textAlignment = .center
        validationButton.titleLabel?.numberOfLines = 0
        self.pX += 40
        self.containerView.addSubview(validationButton)
    }
    
    func createFormCreditCard() {
        // Ajout cardNumber
        let cardNumberLabel = UILabel(frame: CGRect(x: 20, y: CGFloat(self.pX), width: 335, height: 20))
        cardNumberLabel.text = "Numéro de carte*"
        cardNumberLabel.tag = 2
        self.pX += 20
        self.containerView.addSubview(cardNumberLabel)
        
        // Ajout ibanField
        let cardNumberTextField = CustomTextField(frame: CGRect(x: 20, y: CGFloat(self.pX), width: 335, height: 40))
        cardNumberTextField.fieldName = "cardNumber"
        cardNumberTextField.required = true
        cardNumberTextField.placeholder = "Completer"
        cardNumberTextField.label = "Numéro de carte"
        cardNumberTextField.tag = 2
        self.pX += 60
        self.containerView.addSubview(cardNumberTextField)
        
        // Ajout iban
        let expirtationDateLabel = UILabel(frame: CGRect(x: 20, y: CGFloat(self.pX), width: 335, height: 20))
        expirtationDateLabel.text = "Date d'expiration*"
        expirtationDateLabel.tag = 2
        self.pX += 20
        self.containerView.addSubview(expirtationDateLabel)
        
        // Ajout expirtation date
        let expirtationDateTextField = CustomTextField(frame: CGRect(x: 20, y: CGFloat(self.pX), width: 335, height: 40))
        expirtationDateTextField.required = true
        expirtationDateTextField.fieldName = "expirationDate"
        expirtationDateTextField.placeholder = "Completer"
        expirtationDateTextField.label = "Date d'expiration"
        expirtationDateTextField.tag = 2
        self.pX += 60
        self.containerView.addSubview(expirtationDateTextField)
        
        // Ajout crypto
        let cryptoLabel = UILabel(frame: CGRect(x: 20, y: CGFloat(self.pX), width: 335, height: 20))
        cryptoLabel.text = "Cryptogramme*"
        cryptoLabel.tag = 2
        self.pX += 20
        self.containerView.addSubview(cryptoLabel)
        
        // Ajout ibanField
        let cryptoTextField = CustomTextField(frame: CGRect(x: 20, y: CGFloat(self.pX), width: 335, height: 40))
        cryptoTextField.required = true
        cryptoTextField.fieldName = "crypto"
        cryptoTextField.placeholder = "Completer"
        cryptoTextField.label = "Cryptogramme"
        cryptoTextField.tag = 2
        self.pX += 60
        self.containerView.addSubview(cryptoTextField)
        
        // Ajout owner
        let ownerLabel = UILabel(frame: CGRect(x: 20, y: CGFloat(self.pX), width: 335, height: 20))
        ownerLabel.text = "Propriétaire*"
        ownerLabel.tag = 2
        self.pX += 20
        self.containerView.addSubview(ownerLabel)
        
        // Ajout ibanField
        let ownerTextField = CustomTextField(frame: CGRect(x: 20, y: CGFloat(self.pX), width: 335, height: 40))
        ownerTextField.required = true
        ownerTextField.fieldName = "owner"
        ownerTextField.placeholder = "Completer"
        ownerTextField.label = "Propriétaire"
        ownerTextField.tag = 2
        self.pX += 60
        self.containerView.addSubview(ownerTextField)
        // Add Validation button
        let validationButton = UIButton(frame: CGRect(x: 25, y: CGFloat(pX), width: 335, height: 30.00))
        validationButton.setTitle("Valider l'inscription", for: .normal)
        validationButton.addTarget(self, action: #selector(self.validSubscription(_:)), for: .touchUpInside)
        validationButton.tag = 2
        validationButton.setTitleColor(UIView().tintColor, for: .normal)
        validationButton.backgroundColor = UIColor.clear
        validationButton.titleLabel?.textAlignment = .center
        validationButton.titleLabel?.numberOfLines = 0

        self.pX += 40
        self.containerView.addSubview(validationButton)
    }
    
    func createFormPaypal() {
        // Ajout label
        let paypalLabel = UILabel(frame: CGRect(x: 20, y: CGFloat(self.pX), width: 335, height: 20))
        paypalLabel.text = "Numéro de compte paypal*"
        paypalLabel.tag = 3
        self.pX += 20
        self.containerView.addSubview(paypalLabel)
        
        // Ajout textField
        let paypalTextField = CustomTextField(frame: CGRect(x: 20, y: CGFloat(self.pX), width: 335, height: 40))
        paypalTextField.required = true
        paypalTextField.fieldName = "paypalAccountNumber"
        paypalTextField.placeholder = "Completer"
        paypalTextField.label = "Numéro de compte paypal"
        paypalTextField.tag = 3
        self.pX += 60
        self.containerView.addSubview(paypalTextField)
        
        // Add Validation button
        let validationButton = UIButton(frame: CGRect(x: 25, y: CGFloat(pX), width: 335, height: 30.00))
        validationButton.setTitle("Valider l'inscription", for: .normal)
        validationButton.addTarget(self, action: #selector(self.validSubscription(_:)), for: .touchUpInside)
        validationButton.tag = 3
        validationButton.setTitleColor(UIView().tintColor, for: .normal)
        validationButton.backgroundColor = UIColor.clear
        validationButton.titleLabel?.textAlignment = .center
        validationButton.titleLabel?.numberOfLines = 0

        self.pX += 40
        self.containerView.addSubview(validationButton)
        self.containerView.addSubview(validationButton)
    }
    
    func removeViewWithTag(tag: Int) {
        for view in self.containerView.subviews {
            if (view.tag == tag) {
                view.removeFromSuperview()
            }
        }
        if (tag == 1) {
            self.pX -= 200
        }
        if (tag == 2) {
            self.pX -= 360
        }
        if (tag == 3) {
            self.pX -= 120
        }
    }
    
    func changePaymentWay(_ sender: CustomSegmentedControl) {
        var tagToRemove = -1
        if (self.selectedPaymentWay == "Compte Bancaire") {
            tagToRemove = 1
        }
        if (self.selectedPaymentWay == "Carte Bancaire") {
            tagToRemove = 2
        }
        if (self.selectedPaymentWay == "Paypal") {
            tagToRemove = 3
        }
        let paymentWay = sender.titleForSegment(at: sender.selectedSegmentIndex)
        self.selectedPaymentWay = paymentWay!
        if (paymentWay == "Compte Bancaire") {
            // Remove actual form of paymentWay
            self.removeViewWithTag(tag: tagToRemove)
            // Create new form of the new paymentWay
            self.createFormCreditAccount()
            self.scrollView.contentSize = CGSize(width: 350, height: self.pX + 100)
        }
        else if (paymentWay == "Carte Bancaire") {
            // Remove actual form of paymentWay
            self.removeViewWithTag(tag: tagToRemove)
            // Create new form of the new paymentWay
            self.createFormCreditCard()
            self.scrollView.contentSize = CGSize(width: 350, height: self.pX + 100)
        }
        else if (paymentWay == "Paypal") {
            // Remove actual form of paymentWay
            self.removeViewWithTag(tag: tagToRemove)
            // Create new form of the new paymentWay
            self.createFormPaypal()
            self.scrollView.contentSize = CGSize(width: 350, height: self.pX + 100)
        }
        
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
            
            // Ajout recapMessage
            let recapMessage: UILabel = UILabel(frame: CGRect(x: 20, y: 70, width: 335, height: 20.00));
            recapMessage.numberOfLines = 0
            recapMessage.text = "Recapitulatif abonnement :"
            self.containerView.addSubview(recapMessage)
            self.pX = 110
            
            //TODO Display recap of offer choosen and option
            // prepare total price
            var totalPrice = 0
            // affichage offre choisi
            let offerMessage: UILabel = UILabel(frame: CGRect(x: 20, y: CGFloat(self.pX), width: 335, height: 20.00));
            offerMessage.numberOfLines = 0
            offerMessage.text = "Offre choisie :"
            self.containerView.addSubview(offerMessage)
            self.pX += 20
            let offerChoosen: UILabel = UILabel(frame: CGRect(x: 20, y: CGFloat(self.pX), width: 335, height: 20.00));
            offerChoosen.numberOfLines = 0
            offerChoosen.text = " • " + (self.person?.serviceOffer?.title)! + "(" + String((self.person?.serviceOffer?.price)!) + "€)"
            totalPrice += (self.person?.serviceOffer?.price)!
            self.pX += 20
            self.containerView.addSubview(offerChoosen)
            // affichage option s'il y en a
            let numberOfOptions = (self.person?.serviceOptions.count)!
            if (numberOfOptions > 0) {
                self.pX += 20
                let optionLabel: UILabel = UILabel(frame: CGRect(x: 20, y: CGFloat(self.pX), width: 335, height: 20.00));
                optionLabel.numberOfLines = 0
                optionLabel.text = "Option" + (numberOfOptions > 1 ? "s " : " ") + "choisie" + (numberOfOptions > 1 ? "s" : "")
                self.pX += 20
                self.containerView.addSubview(optionLabel)
                // Parcours des options
                for option in (self.person?.serviceOptions)! {
                    let optionChoosen: UILabel = UILabel(frame: CGRect(x: 20, y: CGFloat(self.pX), width: 335, height: 20.00));
                    optionChoosen.numberOfLines = 0
                    optionChoosen.text = " • " + option.title + "(" + String(option.price) + "€)"
                    totalPrice += option.price
                    self.pX += 20
                    self.containerView.addSubview(optionChoosen)
                }

            }
            // affichage total price
            self.pX += 10
            let totalPriceLabel: UILabel = UILabel(frame: CGRect(x: 20, y: CGFloat(self.pX), width: 335, height: 20.00));
            totalPriceLabel.numberOfLines = 0
            totalPriceLabel.text = "Prix total à payer : " + String(totalPrice) + "€"
            self.pX += 20
            self.containerView.addSubview(totalPriceLabel)
            

            //Afficher depuis l'objet person (serviceoffer) le titre de l'option, le prix et prix total
            
            // Ajout paymentMessage
            let paymentMessage: UILabel = UILabel(frame: CGRect(x: 20, y: CGFloat(self.pX), width: 335, height: 20.00));
            paymentMessage.numberOfLines = 0
            paymentMessage.text = "Paiement :"
            self.containerView.addSubview(paymentMessage)
            self.pX += 40
            
            // Choix moyen de paiement
            var items : [String] = []
            var cpt = 0
            for paymentWay in (json?.paymentWays)! {
                if (paymentWay == Payment.bankTransfer) {
                    items.append("Compte Bancaire")
                    if (cpt == 0) {
                        self.selectedPaymentWay = "Compte Bancaire"
                    }
                }
                else if (paymentWay == Payment.creditCard) {
                    items.append("Carte Bancaire")
                    if (cpt == 0) {
                        self.selectedPaymentWay = "Carte Bancaire"
                    }
                }
                else if (paymentWay == Payment.paypal) {
                    items.append("Paypal")
                    if (cpt == 0) {
                        self.selectedPaymentWay = "Paypal"
                    }
                }
                cpt += 1
            }
            let segmentedControl: CustomSegmentedControl = CustomSegmentedControl(items: items);
            segmentedControl.label = "Moyen de paiment"
            segmentedControl.frame = CGRect(x: 20, y: CGFloat(self.pX), width: 335, height: 30.00);
            segmentedControl.selectedSegmentIndex = 0
            segmentedControl.addTarget(self, action: #selector(self.changePaymentWay(_:)), for: .valueChanged)
            
            self.containerView.addSubview(segmentedControl)
            self.pX += 50
            
            if (items[0] == "Compte Bancaire") {
                self.createFormCreditAccount()
            }
            else if (items[0] == "Carte Bancaire") {
                self.createFormCreditCard()
            }
            else if (items[0] == "Paypal") {
                self.createFormPaypal()
            }
            
            self.scrollView.contentSize = CGSize(width: 350, height: self.pX + 100)
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
    
}

