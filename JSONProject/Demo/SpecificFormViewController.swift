//
//  GeneralFormViewController.swift
//  Demo
//
//  Created by MAC ISTV on 28/04/2017.
//  Copyright © 2017 UVHC. All rights reserved.
//

import UIKit

class SpecificFormViewController: UIViewController, UIPickerViewDelegate, UIScrollViewDelegate  {
    
    
    var scrollView = UIScrollView()
    var containerView = UIView()
    let realmServices = RealmServices()
    var jsonModel: JsonModel? = nil
    var customNavigationController: UINavigationController? = nil
    var indexOfSelectedOffer: Int = -1
    var person: Person? = nil
    var customParent: GeneralFormViewController? = nil
    var choosenOffer: Offer? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set up title of view
        self.title = "Form 2"
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
    
    public func setupCustomParent(customParent: GeneralFormViewController) {
        self.customParent = customParent
    }
    
    public func setIndexOfSelectedOffer(index: Int) {
        self.indexOfSelectedOffer = index
    }
    
    override func willMove(toParentViewController: UIViewController?)
    {
        if (toParentViewController == nil) {
            if (self.person != nil && !(self.person?.isSaved)!) {
                let subViews = self.containerView.subviews
                for view in subViews {
                    var attributeFieldName = ""
                    var attributeLabel = ""
                    var attributeValue = ""
                    if let textField = view as? CustomTextField {
                        attributeFieldName = textField.fieldName
                        attributeLabel = textField.label
                        attributeValue = textField.text ?? ""
                    }
                    if let datePickerField = view as? CustomDatePicker {
                        attributeFieldName = datePickerField.fieldName
                        attributeLabel = datePickerField.label
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd/MM/yyyy"
                        attributeValue = dateFormatter.string(from: datePickerField.date)
                    }
                    if let pickerField = view as? CustomPickerView {
                        attributeFieldName = pickerField.fieldName
                        attributeLabel = pickerField.label
                        attributeValue = pickerField.pickerData[pickerField.selectedRow(inComponent: 0)].value
                    }
                    if let segmentedControlField = view as? CustomSegmentedControl {
                        attributeFieldName = segmentedControlField.fieldName
                        attributeLabel = segmentedControlField.label
                        attributeValue = segmentedControlField.titleForSegment(at: segmentedControlField.selectedSegmentIndex) ?? ""
                    }
                    // Set the attribute only if we have the attribute fieldName and Label
                    // We can have empty attributeValue because the field can be not required
                    if (attributeLabel != "" && attributeFieldName != "") {
                        // On doit vérifier si on n'a pas déjà ce champs, si oui il faut juste le mettre a jour
                        let indexOfAttribute = self.person?.getAttributeIndex(fieldName: attributeFieldName)
                        if (indexOfAttribute! > -1) {
                            self.person?.attributes[indexOfAttribute!].value = attributeValue
                        }
                        else {
                            let attribute = Attribute(_label: attributeLabel, _fieldName: attributeFieldName, _value: attributeValue, isSpecificField: true)
                            self.person?.addAttributeToPerson(_attribute: attribute)
                        }
                    }
                }
                // Setup offer
                self.person?.setupServiceOffer(offer: ServiceOffer(title: (self.choosenOffer?.title)!, offerDescription: (self.choosenOffer?.description)!, price: (self.choosenOffer?.price)!))
                // Pass person to the parent
                self.customParent?.setupPerson(person: self.person!)
                
            }
            // Reset custom parent
            self.customParent = nil
        }
    }
    
    func next(_ sender: UIButton) {
        // get data from UI for the Person Object
        // Test if all requiredField are completed
        let subViews = self.containerView.subviews
        for view in subViews {
            var attributeFieldName = ""
            var attributeLabel = ""
            var attributeValue = ""
            if let textField = view as? CustomTextField {
                attributeFieldName = textField.fieldName
                attributeLabel = textField.label
                attributeValue = textField.text ?? ""
                if(textField.required == true && attributeValue == ""){
                    print("Champ requis non rempli")
                }
            }
            if let datePickerField = view as? CustomDatePicker {
                attributeFieldName = datePickerField.fieldName
                attributeLabel = datePickerField.label
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                attributeValue = dateFormatter.string(from: datePickerField.date)
            }
            if let pickerField = view as? CustomPickerView {
                attributeFieldName = pickerField.fieldName
                attributeLabel = pickerField.label
                attributeValue = pickerField.pickerData[pickerField.selectedRow(inComponent: 0)].value
            }
            if let segmentedControlField = view as? CustomSegmentedControl {
                attributeFieldName = segmentedControlField.fieldName
                attributeLabel = segmentedControlField.label
                attributeValue = segmentedControlField.titleForSegment(at: segmentedControlField.selectedSegmentIndex) ?? ""
            }
            // Set the attribute only if we have the attribute fieldName and Label
            // We can have empty attributeValue because the field can be not required
            // On doit vérifier si on n'a pas déjà ce champs, si oui il faut vérifier s'il a changé ou non
            if (attributeLabel != "" && attributeFieldName != "") {
                // On doit vérifier si on n'a pas déjà ce champs, si oui il faut juste le mettre a jour
                let indexOfAttribute = self.person?.getAttributeIndex(fieldName: attributeFieldName)
                if (indexOfAttribute! > -1) {
                    self.person?.attributes[indexOfAttribute!].value = attributeValue
                }
                else {
                    let attribute = Attribute(_label: attributeLabel, _fieldName: attributeFieldName, _value: attributeValue, isSpecificField: true)
                    self.person?.addAttributeToPerson(_attribute: attribute)
                }
            }
        }
        // Setup offer
        self.person?.setupServiceOffer(offer: ServiceOffer(title: (self.choosenOffer?.title)!, offerDescription: (self.choosenOffer?.description)!, price: (self.choosenOffer?.price)!))
        // Go to next Screen
        // Redirect To Next Step
        // Check if there is option
        if ((self.choosenOffer?.features.count)! > 0) {
            // Go to select offer view
            let selectOptionView = SelectOptionViewController(nibName: "SelectOptionViewController", bundle: nil)
            
            if (self.person != nil) {
                selectOptionView.setupPerson(person: self.person!)
            }
            selectOptionView.setupNavigationController(navigationController: self.customNavigationController!)
            selectOptionView.setupCustomParent(customParent: self)
            selectOptionView.setupChoosenOffer(choosenOffer: self.choosenOffer!)
            selectOptionView.createViewFromJson(json: self.jsonModel)
            self.customNavigationController?.pushViewController(selectOptionView, animated: true)
        }
        else {
            // Go to recap/payment view
            let paymentView = PaymentViewController(nibName: "PaymentViewController", bundle: nil)
            
            if (self.person != nil) {
                paymentView.setupPerson(person: self.person!)
            }
            paymentView.setupNavigationController(navigationController: self.customNavigationController!)
            paymentView.setupCustomParent1(customParent: self)
            paymentView.createViewFromJson(json: self.jsonModel)
            self.customNavigationController?.pushViewController(paymentView, animated: true)
        }
        
        

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
            message.text = "Informations spécifiques à l'offre :"
            self.containerView.addSubview(message)
            
            var pX = 150
            
            var cpt = 0
            var offerUsed: Offer? = nil
            for offer in (json?.offers)! {
                if (cpt == self.indexOfSelectedOffer) {
                    offerUsed = offer
                    self.choosenOffer = offerUsed
                }
                cpt += 1
            }
            
            for field in (offerUsed?.specificFields)! {
                let title: UILabel = UILabel(frame: CGRect(x: 20, y: CGFloat(pX), width: 350.00, height: 30.00));
                title.text = field.label
                self.containerView.addSubview(title)
                pX += 30
                if(field.input == InputType.date){
                    let datepicker: CustomDatePicker = CustomDatePicker(frame: CGRect(x: 20, y: CGFloat(pX), width: 350.00, height: 100.00));
                    datepicker.fieldName = field.fieldId
                    datepicker.label = field.label
                    
                    // test if we already have the value
                    let attributeValue = self.person?.getAttributeValue(fieldName: field.fieldId)
                    if (attributeValue != nil) {
                        // On a déjà une valeur pour ce champ on le remplidonc directement
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd/MM/yyyy"
                        datepicker.date = dateFormatter.date(from: attributeValue!)!
                    }
                    else {
                        datepicker.date = Date()
                    }
                    
                    datepicker.datePickerMode = UIDatePickerMode.date
                    self.containerView.addSubview(datepicker)
                    pX += 100
                } else if(field.input == InputType.text || field.input == InputType.string){
                    let txtField: CustomTextField = CustomTextField(frame: CGRect(x: 20, y: CGFloat(pX), width: 350.00, height: 30.00));
                    txtField.fieldName = field.fieldId
                    txtField.label = field.label
                    
                    // test if we already have the value
                    let attributeValue = self.person?.getAttributeValue(fieldName: field.fieldId)
                    if (attributeValue != nil) {
                        // On a déjà une valeur pour ce champ on le remplidonc directement
                        txtField.text = attributeValue
                    }
                    else {
                        txtField.placeholder = field.params?.placeholder ?? "Completer"
                    }
                    
                    if(field.required == true){
                        txtField.required = true
                    }
                    
                    self.containerView.addSubview(txtField)
                    pX += 60
                } else if(field.input == InputType.select){
                    // Prepare data for the picker
                    var pickerData : [(value: String, key: String)] = []
                    var cpt = 0
                    let attributeValue = self.person?.getAttributeValue(fieldName: field.fieldId)
                    var alreadySelectedIndex = -1
                    for choice in (field.params?.choices)! {
                        pickerData.append((choice.label, choice.value))
                        if (attributeValue != nil && attributeValue == choice.label) {
                            alreadySelectedIndex = cpt
                        }
                        cpt += 1
                    }
                    // Create the dateSource object
                    let dataSource = CustomPickerViewDataSource()
                    // Set data to the dataSource object
                    dataSource.pickerData = pickerData
                    // Create the picker
                    let picker: CustomPickerView = CustomPickerView(frame: CGRect(x: 20, y: CGFloat(pX), width: 350.00, height: 100.00));
                    picker.fieldName = field.fieldId
                    picker.label = field.label
                    picker.pickerData = pickerData
                    // Set up picker with dataSource object  and pickerViewDelegate (self)
                    picker.delegate = self
                    picker.dataSource = dataSource
                    // test if we already have the value
                    if (alreadySelectedIndex > -1) {
                        // On a déjà une valeur pour ce champ on le remplidonc directement
                        picker.selectRow(alreadySelectedIndex, inComponent: 0, animated: false)
                    }
                    
                    self.containerView.addSubview(picker)
                    pX += 100
                } else if(field.input == InputType.radio){
                    var items : [String] = []
                    var cpt = 0
                    let attributeValue = self.person?.getAttributeValue(fieldName: field.fieldId)
                    var alreadySelectedIndex = -1
                    for choice in (field.params?.choices)! {
                        items.append(choice.label)
                        if (attributeValue != nil && choice.label == attributeValue) {
                            // On a déjà cette valeur
                            alreadySelectedIndex = cpt
                        }
                        cpt += 1
                    }
                    let segmentedControl: CustomSegmentedControl = CustomSegmentedControl(items: items);
                    segmentedControl.fieldName = field.fieldId
                    segmentedControl.label = field.label
                    segmentedControl.frame = CGRect(x: 20, y: CGFloat(pX), width: 350.00, height: 30.00);
                    // test if we already have the value
                    if (alreadySelectedIndex > -1) {
                        // On a déjà une valeur pour ce champ on le remplidonc directement
                        segmentedControl.selectedSegmentIndex = alreadySelectedIndex
                    }
                    else {
                        segmentedControl.selectedSegmentIndex = 0
                    }
                    self.containerView.addSubview(segmentedControl)
                    pX += 30
                }
            }
            pX += 30
            // Ajout du bouton
            let nextButton = UIButton(frame: CGRect(x: 20, y: CGFloat(pX), width: 350.00, height: 30.00))
            nextButton.setTitle("Suivant", for: .normal)
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

