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
        print("fin")
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
        for view in self.containerView.subviews {
            if (view.tag == tag) {
                if let textField = view as? CustomTextField {
                    let paymentAttribute = PaymentAttribute(_label: textField.label, _fieldName: textField.fieldName, _value: textField.text!)
                    paymentWay.addPaymentAttribute(paymentAttribute: paymentAttribute)
                }
            }
        }
        self.person?.setupPaymnetWay(paymentWay: paymentWay)
        self.person?.changeIsSavePerson()
        // Save the person in realm database
        realmServices.createPerson(person: self.person!)
        realmServices.addSubscriberToService(title: (self.jsonModel?.title)!, subscriber: self.person!)
        // Go Back to home view
        /*let selectOfferView = self.customNavigationController?.viewControllers[1] as! SelectOfferViewController
        self.customNavigationController?.viewControllers = []
        self.customNavigationController?.pushViewController(selectOfferView.customParent!, animated: true)
        self.customNavigationController?.setNavigationBarHidden(true, animated: true)*/
        //self.customNavigationController?.viewControllers = []
        self.customNavigationController?.popToRootViewController(animated: true)
        
        self.realmServices.createPerson(person: self.person!)
        self.realmServices.addSubscriberToService(title: (self.jsonModel?.title)!, subscriber: self.person!)
            
        
    }
    
    
    func createFormCreditAccount() {
        // Ajout iban
        let ibanLabel = UILabel(frame: CGRect(x: 20, y: CGFloat(self.pX), width: 350, height: 20))
        ibanLabel.text = "IBAN"
        ibanLabel.tag = 1
        self.pX += 20
        self.containerView.addSubview(ibanLabel)
        
        // Ajout ibanField
        let ibanTextField = CustomTextField(frame: CGRect(x: 20, y: CGFloat(self.pX), width: 350, height: 40))
        ibanTextField.fieldName = "iban"
        ibanTextField.placeholder = "Completer"
        ibanTextField.label = "IBAN"
        ibanTextField.tag = 1
        self.pX += 60
        self.containerView.addSubview(ibanTextField)
        
        // Ajout bic
        let bicLabel = UILabel(frame: CGRect(x: 20, y: CGFloat(self.pX), width: 350, height: 20))
        bicLabel.text = "BIC"
        bicLabel.tag = 1
        self.pX += 20
        self.containerView.addSubview(bicLabel)
        
        // Ajout bicField
        let bicTextField = CustomTextField(frame: CGRect(x: 20, y: CGFloat(self.pX), width: 350, height: 40))
        bicTextField.fieldName = "bic"
        bicTextField.placeholder = "Completer"
        bicTextField.label = "BIC"
        bicTextField.tag = 1
        self.pX += 60
        self.containerView.addSubview(bicTextField)
        
        // Add Validation button
        let validationButton = UIButton(frame: CGRect(x: 20, y: CGFloat(pX), width: 350.00, height: 30.00))
        validationButton.setTitle("Valider l'inscription", for: .normal)
        validationButton.addTarget(self, action: #selector(self.validSubscription(_:)), for: .touchUpInside)
        validationButton.tag = 1
        validationButton.backgroundColor = UIColor.blue
        self.pX += 40
        self.containerView.addSubview(validationButton)
    }
    
    func createFormCreditCard() {
        // Ajout cardNumber
        let cardNumberLabel = UILabel(frame: CGRect(x: 20, y: CGFloat(self.pX), width: 350, height: 20))
        cardNumberLabel.text = "Numéro de carte"
        cardNumberLabel.tag = 2
        self.pX += 20
        self.containerView.addSubview(cardNumberLabel)
        
        // Ajout ibanField
        let cardNumberTextField = CustomTextField(frame: CGRect(x: 20, y: CGFloat(self.pX), width: 350, height: 40))
        cardNumberTextField.fieldName = "cardNumber"
        cardNumberTextField.placeholder = "Completer"
        cardNumberTextField.label = "Numéro de carte"
        cardNumberTextField.tag = 2
        self.pX += 60
        self.containerView.addSubview(cardNumberTextField)
        
        // Ajout iban
        let expirtationDateLabel = UILabel(frame: CGRect(x: 20, y: CGFloat(self.pX), width: 350, height: 20))
        expirtationDateLabel.text = "Date d'expiration"
        expirtationDateLabel.tag = 2
        self.pX += 20
        self.containerView.addSubview(expirtationDateLabel)
        
        // Ajout expirtation date
        let expirtationDateTextField = CustomTextField(frame: CGRect(x: 20, y: CGFloat(self.pX), width: 350, height: 40))
        expirtationDateTextField.fieldName = "expirationDate"
        expirtationDateTextField.placeholder = "Completer"
        expirtationDateTextField.label = "Date d'expiration"
        expirtationDateTextField.tag = 2
        self.pX += 60
        self.containerView.addSubview(expirtationDateTextField)
        
        // Ajout crypto
        let cryptoLabel = UILabel(frame: CGRect(x: 20, y: CGFloat(self.pX), width: 350, height: 20))
        cryptoLabel.text = "Cryptogramme"
        cryptoLabel.tag = 2
        self.pX += 20
        self.containerView.addSubview(cryptoLabel)
        
        // Ajout ibanField
        let cryptoTextField = CustomTextField(frame: CGRect(x: 20, y: CGFloat(self.pX), width: 350, height: 40))
        cryptoTextField.fieldName = "crypto"
        cryptoTextField.placeholder = "Completer"
        cryptoTextField.label = "Cryptogramme"
        cryptoTextField.tag = 2
        self.pX += 60
        self.containerView.addSubview(cryptoTextField)
        
        // Ajout owner
        let ownerLabel = UILabel(frame: CGRect(x: 20, y: CGFloat(self.pX), width: 350, height: 20))
        ownerLabel.text = "Propriétaire"
        ownerLabel.tag = 2
        self.pX += 20
        self.containerView.addSubview(ownerLabel)
        
        // Ajout ibanField
        let ownerTextField = CustomTextField(frame: CGRect(x: 20, y: CGFloat(self.pX), width: 350, height: 40))
        ownerTextField.fieldName = "owner"
        ownerTextField.placeholder = "Completer"
        ownerTextField.label = "Propriétaire"
        ownerTextField.tag = 2
        self.pX += 60
        self.containerView.addSubview(ownerTextField)
        // Add Validation button
        let validationButton = UIButton(frame: CGRect(x: 20, y: CGFloat(pX), width: 350.00, height: 30.00))
        validationButton.setTitle("Valider l'inscription", for: .normal)
        validationButton.addTarget(self, action: #selector(self.validSubscription(_:)), for: .touchUpInside)
        validationButton.tag = 2
        validationButton.backgroundColor = UIColor.blue
        self.pX += 40
        self.containerView.addSubview(validationButton)
    }
    
    func createFormPaypal() {
        // Ajout label
        let paypalLabel = UILabel(frame: CGRect(x: 20, y: CGFloat(self.pX), width: 350, height: 20))
        paypalLabel.text = "Numéro de compte paypal"
        paypalLabel.tag = 3
        self.pX += 20
        self.containerView.addSubview(paypalLabel)
        
        // Ajout textField
        let paypalTextField = CustomTextField(frame: CGRect(x: 20, y: CGFloat(self.pX), width: 350, height: 40))
        paypalTextField.fieldName = "paypalAccountNumber"
        paypalTextField.placeholder = "Completer"
        paypalTextField.label = "Numéro de compte paypal"
        paypalTextField.tag = 3
        self.pX += 60
        self.containerView.addSubview(paypalTextField)
        
        // Add Validation button
        let validationButton = UIButton(frame: CGRect(x: 20, y: CGFloat(pX), width: 350.00, height: 30.00))
        validationButton.setTitle("Valider l'inscription", for: .normal)
        validationButton.addTarget(self, action: #selector(self.validSubscription(_:)), for: .touchUpInside)
        validationButton.tag = 3
        validationButton.backgroundColor = UIColor.blue
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
            print("CompteB")
            // Create new form of the new paymentWay
            self.createFormCreditAccount()
            self.scrollView.contentSize = CGSize(width: 375, height: self.pX + 100)
        }
        else if (paymentWay == "Carte Bancaire") {
            // Remove actual form of paymentWay
            self.removeViewWithTag(tag: tagToRemove)
            print("CB")
            // Create new form of the new paymentWay
            self.createFormCreditCard()
            self.scrollView.contentSize = CGSize(width: 375, height: self.pX + 100)
        }
        else if (paymentWay == "Paypal") {
            // Remove actual form of paymentWay
            self.removeViewWithTag(tag: tagToRemove)
            print("paypal")
            // Create new form of the new paymentWay
            self.createFormPaypal()
            self.scrollView.contentSize = CGSize(width: 375, height: self.pX + 100)
        }
        
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
            
            // Ajout recapMessage
            let recapMessage: UILabel = UILabel(frame: CGRect(x: 20, y: 70, width: 350.00, height: 20.00));
            recapMessage.numberOfLines = 0
            recapMessage.text = "Recap :"
            self.containerView.addSubview(recapMessage)
            self.pX = 110
            
            //TODO Display recap of offer choosen and option
            
            // Ajout paymentMessage
            let paymentMessage: UILabel = UILabel(frame: CGRect(x: 20, y: CGFloat(self.pX), width: 350.00, height: 20.00));
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
            items.append("Paypal")
            let segmentedControl: CustomSegmentedControl = CustomSegmentedControl(items: items);
            segmentedControl.label = "Moyen de paiment"
            segmentedControl.frame = CGRect(x: 20, y: CGFloat(self.pX), width: 350.00, height: 30.00);
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
            
            self.scrollView.contentSize = CGSize(width: 375, height: self.pX + 100)
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

