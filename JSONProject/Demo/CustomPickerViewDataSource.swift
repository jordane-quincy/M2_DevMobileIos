//
//  CustomPickerViewDataSource.swift
//  Demo
//
//  Created by MAC ISTV on 27/04/2017.
//  Copyright © 2017 UVHC. All rights reserved.
//

import Foundation
import UIKit

class CustomPickerViewDataSource : NSObject, UIPickerViewDataSource, UIPickerViewDelegate{
    var pickerData : [(value: String, key: String)] = []
    
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
}
