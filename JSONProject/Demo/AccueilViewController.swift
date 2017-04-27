//
//  AccueilViewController.swift
//  Demo
//
//  Created by morgan basset on 04/04/2017.
//  Copyright © 2017 UVHC. All rights reserved.
//

import UIKit

class AccueilViewController: UIViewController, UIPickerViewDelegate, UIScrollViewDelegate  {
    
    
    var scrollView = UIScrollView()
    var containerView = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.frame = view.bounds
        containerView.frame = CGRect(x: 0, y: 0, width: scrollView.contentSize.width, height: scrollView.contentSize.height)
    }
    
    func savePerson(_ sender: UIButton) {
        print("bouton good")
        // On récupère les informations de la personne
        let subViews = self.containerView.subviews

        for view in subViews {
            if let textField = view as? CustomTextField {
                print(textField.label)
                print(textField.fieldName)
                print(textField.text ?? "")
            }
            if let datePickerField = view as? CustomDatePicker {
                print(datePickerField.label)
                print(datePickerField.fieldName)
                print(datePickerField.date)
            }
            if let pickerField = view as? CustomPickerView {
                print(pickerField.label)
                print(pickerField.fieldName)
                print(pickerField.pickerData[pickerField.selectedRow(inComponent: 0)])
                
            }
            if let segmentedControlField = view as? CustomSegmentedControl {
                print(segmentedControlField.label)
                print(segmentedControlField.fieldName)
                print(segmentedControlField.titleForSegment(at: segmentedControlField.selectedSegmentIndex) ?? "")
            }
        }
    }
    
    
    func createViewFromJson(json: JsonModel?){
        print(json as Any)
        
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
            
            let title: UILabel = UILabel(frame: CGRect(x: 20, y: 20, width: 350.00, height: 30.00));
            title.text = json?.title
        
            self.containerView.addSubview(title)
            let description: UILabel = UILabel(frame: CGRect(x: 20, y: 50, width: 350.00, height: 100.00));
                description.numberOfLines = 0
            description.text = json?.description
            self.containerView.addSubview(description)
            var pX = 140
            for field in (json?.commonFields)! {
                let title: UILabel = UILabel(frame: CGRect(x: 20, y: CGFloat(pX), width: 350.00, height: 30.00));
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
                }
            }
            pX += 30
            // Ajout du bouton
            let saveButton = UIButton(frame: CGRect(x: 20, y: CGFloat(pX), width: 350.00, height: 30.00))
            saveButton.setTitle("title", for: .normal)
            saveButton.addTarget(self, action: #selector(self.savePerson(_:)), for: .touchUpInside)
            saveButton.backgroundColor = UIColor.blue
            
            self.containerView.addSubview(saveButton)
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
