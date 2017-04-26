//
//  AccueilViewController.swift
//  Demo
//
//  Created by morgan basset on 04/04/2017.
//  Copyright © 2017 UVHC. All rights reserved.
//

import UIKit

class AccueilViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UIScrollViewDelegate  {
    
    var pickerData : [(value: String, key: String)] = []
    
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
    
    
    func createViewFromJson(json: JsonModel?){
        print(json as Any)
        
        
        // Setup scrollview
        scrollView = UIScrollView()
        scrollView.delegate = self
        view.addSubview(scrollView)
        containerView = UIView()
        scrollView.addSubview(containerView)
        self.view.addSubview(scrollView)
        
        
        //Init du service
        /*
         TO DO
         CHECK IF SERVICE NOT ALREADY EXIST
         */
        let realmServices = RealmServices()
        
        realmServices.resetDataBase()
        let businessService = BusinessService(_title: (json?.title)!, _serviceDescription: (json?.description)!,_brand: "")
        
        realmServices.createBusinessService(businessService: businessService)
        
        
        
        
        // Setup interface
        
        let title: UILabel = UILabel(frame: CGRect(x: 20, y: 20, width: 350.00, height: 30.00));
        title.text = json?.title
        
        containerView.addSubview(title)
        let description: UILabel = UILabel(frame: CGRect(x: 20, y: 50, width: 350.00, height: 100.00));
                description.numberOfLines = 0
        description.text = json?.description
        containerView.addSubview(description)
        var pX = 170
        for field in (json?.commonFields)! {
            let title: UILabel = UILabel(frame: CGRect(x: 20, y: CGFloat(pX), width: 350.00, height: 30.00));
            title.text = field.label
            containerView.addSubview(title)
            pX += 30
            if(field.input == InputType.date){
                let datepicker: UIDatePicker = UIDatePicker(frame: CGRect(x: 20, y: CGFloat(pX), width: 350.00, height: 100.00));
                
                datepicker.date = Date()
                datepicker.datePickerMode = UIDatePickerMode.date
                containerView.addSubview(datepicker)
                pX += 100
            } else if(field.input == InputType.text){
                let txtField: UITextField = UITextField(frame: CGRect(x: 20, y: CGFloat(pX), width: 350.00, height: 30.00));
                txtField.placeholder = field.params?.placeholder
                containerView.addSubview(txtField)
                pX += 100
            } else if(field.input == InputType.select){
                for choice in (field.params?.choices)! {
                    pickerData.append((choice.label, choice.value))
                }
                let picker: UIPickerView = UIPickerView(frame: CGRect(x: 20, y: CGFloat(pX), width: 350.00, height: 100.00));
                
                
                picker.delegate = self
                picker.dataSource = self
                containerView.addSubview(picker)
                pX += 100
            } else if(field.input == InputType.radio){
                var items : [String] = []
                for choice in (field.params?.choices)! {
                    items.append(choice.value)
                }
                
                let segmentedControl: UISegmentedControl = UISegmentedControl(items: items);
                segmentedControl.frame = CGRect(x: 20, y: CGFloat(pX), width: 350.00, height: 30.00);
                segmentedControl.selectedSegmentIndex = 0
                containerView.addSubview(segmentedControl)
                pX += 30
            }
            
        }
        scrollView.contentSize = CGSize(width: 375, height: pX)

        //self.view.frame.size.height = 10000
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row].value
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
