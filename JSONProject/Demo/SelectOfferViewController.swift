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
        // Redirect To Next Step
        //let navigationController = UINavigationController(rootViewController: self)
        
        // TODO verifier que la vue n'existe pas deja
        let generalFormView = GeneralFormViewController(nibName: "GeneralFormViewController", bundle: nil)
        generalFormView.setupNavigationController(navigationController: self.customNavigationController!)
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
            
            
            var pX = 90
            for field in (json?.offers)! {
                /*let title: UILabel = UILabel(frame: CGRect(x: 20, y: CGFloat(pX), width: 350.00, height: 30.00));
                
                title.text = field.label
                self.containerView.addSubview(title)
                pX += 30
                if(field.input == InputType.date){
                    let datepicker: CustomDatePicker = CustomDatePicker(frame: CGRect(x: 20, y: CGFloat(pX), width: 350.00, height: 100.00));
                    datepicker.fieldName = field.fieldId
                    datepicker.label = field.label
                    datepicker.date = Date()
                    datepicker.datePickerMode = UIDatePickerMode.date
                    self.containerView.addSubview(datepicker)
                    pX += 100
                } else if(field.input == InputType.text){
                    let txtField: CustomTextField = CustomTextField(frame: CGRect(x: 20, y: CGFloat(pX), width: 350.00, height: 30.00));
                    txtField.fieldName = field.fieldId
                    txtField.label = field.label
                    txtField.placeholder = field.params?.placeholder
                    self.containerView.addSubview(txtField)
                    pX += 60
                } else if(field.input == InputType.select){
                    // Prepare data for the picker
                    var pickerData : [(value: String, key: String)] = []
                    for choice in (field.params?.choices)! {
                        pickerData.append((choice.label, choice.value))
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
                    self.containerView.addSubview(picker)
                    pX += 100
                } else if(field.input == InputType.radio){
                    var items : [String] = []
                    for choice in (field.params?.choices)! {
                        items.append(choice.value)
                    }
                    
                    let segmentedControl: CustomSegmentedControl = CustomSegmentedControl(items: items);
                    segmentedControl.fieldName = field.fieldId
                    segmentedControl.label = field.label
                    segmentedControl.frame = CGRect(x: 20, y: CGFloat(pX), width: 350.00, height: 30.00);
                    segmentedControl.selectedSegmentIndex = 0
                    self.containerView.addSubview(segmentedControl)
                    pX += 30
                }*/
            }
            pX += 30
            // Ajout du next bouton
            let nextButton = UIButton(frame: CGRect(x: 20, y: CGFloat(pX), width: 350.00, height: 30.00))
            nextButton.setTitle("Suivant", for: .normal)
            nextButton.addTarget(self, action: #selector(self.goToGeneralFormView(_:)), for: .touchUpInside)
            nextButton.backgroundColor = UIColor.blue
            self.containerView.addSubview(nextButton)
            self.scrollView.contentSize = CGSize(width: 375, height: pX + 100)
        }
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
