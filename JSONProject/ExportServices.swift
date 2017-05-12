//
//  ExportServices.swift
//  demoFA_storage_test
//
//  Created by DeptInfo on 06/04/2017.
//  Copyright © 2017 DeptInfo. All rights reserved.
//

import Foundation

class ExportServices {
    
    public func getSubscribersJSON(_businessServiceTitle: String) -> String{
        let realmServices = RealmServices()
        let businessService = realmServices.getBusinessService(_title: _businessServiceTitle)
        
        var result = "{"
        
        if (businessService.title == ""){
            result = result + "\n\t\"serviceName\" : \"Non Renseigné\","
        } else {
            result = result + "\n\t\"serviceName\" : \"\(businessService.title)\","
        }
        
        if (businessService.serviceDescription == ""){
            result = result + "\n\t\"serviceDescription\" : \"Non Renseigné\","
        } else {
            result = result + "\n\t\"serviceDescription\" : \"\(businessService.serviceDescription)\","
        }
        
        if (businessService.icon == ""){
            result = result + "\n\t\"icon\" : \"Non rensiegné\","
        } else {
            result = result + "\n\t\"icon\" : \"\(businessService.icon)\","
        }
        
        result = result + "\n\t\"subscribers\" : ["
        
        for (index, subscriber) in businessService.subscribers.enumerated() {
            
            result = result + "\n\t\t{"
            
            if (subscriber.serviceOffer == nil) {
                result = result + "\n\t\t\t\"serviceOffer\" : \"Non Renseigné\","
            } else{
                result = result + "\n\t\t\t\"serviceOffer\" : {"
                
                if (subscriber.serviceOffer?.title == ""){
                    result = result + "\n\t\t\t\t\"title\" : \"Non Renseigné\","
                } else {
                    result = result + "\n\t\t\t\t\"title\" : \"\((subscriber.serviceOffer?.title)!)\","
                }
                
                if (subscriber.serviceOffer?.offerDescription == ""){
                    result = result + "\n\t\t\t\t\"offerDescription\" : \"Non Renseigné\","
                } else {
                    result = result + "\n\t\t\t\t\"offerDescription\" : \"\((subscriber.serviceOffer?.offerDescription)!)\","
                }
                
                //price égal à zero si non reseigné (valeur par défaut)
                let offerPrice = String((subscriber.serviceOffer?.price)!)
                result = result + "\n\t\t\t\t\"price\" : \(offerPrice)\n\t\t\t},"
            }
            
            result = result + "\n\t\t\t\"serviceOption(s)\" : ["
            
            for (indexOption, option) in subscriber.serviceOptions.enumerated() {
                
                result = result + "\n\t\t\t\t{"
                
                if (option.title == ""){
                    result = result + "\n\t\t\t\t\t\"title\" : \"Non Renseigné)\","
                } else {
                    result = result + "\n\t\t\t\t\t\"title\" : \"\(option.title)\","
                }
                
                if (option.optionDescription == ""){
                    result = result + "\n\t\t\t\t\t\"optionDescritpion\" : \"Non Renseigné\","
                } else {
                    result = result + "\n\t\t\t\t\t\"optionDescritpion\" : \"\(option.optionDescription)\","
                }
                
                //price égal à zero si non reseigné (valeur par défaut)
                result = result + "\n\t\t\t\t\t\"price\" : \(option.price)"
                
                result = result + "\n\t\t\t\t}" + (indexOption < (subscriber.serviceOptions.count - 1) ? "," : "")
            }
            result = result + "\n\t\t\t],"
            
            for attribute in subscriber.attributes {
                if (attribute.value == ""){
                    result = result + "\n\t\t\t\"\(attribute.fieldName)\" : \"Non Renseigné\","
                } else {
                    result = result + "\n\t\t\t\"\(attribute.fieldName)\" : \"\(attribute.value)\","
                }
            }
            
            result = result + "\n\t\t\t\"paymentWay\" : {"
            
            if (subscriber.paymentWay?.label == ""){
                result = result + "\n\t\t\t\t\"label\" : \"Non Renseigné\","
            } else {
                result = result + "\n\t\t\t\t\"label\" : \"\((subscriber.paymentWay?.label)!)\","
            }
            
            for (indexAttribute, attribute) in (subscriber.paymentWay?.paymentAttributes)!.enumerated() {
                if (attribute.value == ""){
                    result = result + "\n\t\t\t\t\"\(attribute.fieldName)\" : \"Non Renseigné\"" + (indexAttribute < ((subscriber.paymentWay?.paymentAttributes.count)! - 1) ? "," : "")
                } else {
                    result = result + "\n\t\t\t\t\"\(attribute.fieldName)\" : \"\(attribute.value)\"" + (indexAttribute < ((subscriber.paymentWay?.paymentAttributes.count)! - 1) ? "," : "")
                }
            
            }
            result = result + "\n\t\t\t}"
            result = result + "\n\t\t}" + (index < (businessService.subscribers.count - 1) ? "," : "")
        }
        result = result + "\n\t]"
        result = result + "\n}"
        return result
    }
    
    public  func getSubscribersCSV(_businessServiceTitle: String) -> String {
        let realmServices = RealmServices()
        let businessService = realmServices.getBusinessService(_title: _businessServiceTitle) as BusinessService
        
        var header = "sep=,\nserviceName,serviceDescription,icon,"
        var result = ""
        
        
        for attribute in (businessService.subscribers.first?.attributes)! {
            header += "\(attribute.fieldName),"
        }
        
        for option in businessService.listOfOptions {
            header += "\(option.label),"
        }
        
        
        header += "paymentWay\n"
        
        for subscriber in businessService.subscribers {
            result = result + "\(businessService.title),\(businessService.serviceDescription),\(businessService.icon),"
            for attribute in subscriber.attributes {
                result = result + "\(attribute.value),"
            }
            
            var find = false
            
            for option in businessService.listOfOptions {
                for optionSubcriber in subscriber.serviceOptions {
                    if (optionSubcriber.title == option.label){
                        find = true
                    }
                }
                if (find) {
                    result += "subscribed,"
                } else {
                    result += "not subscribed,"
                }
            }
            result += "\((subscriber.paymentWay?.label)!)\n"
        }
        
        result = header + result
        
        return result
    }
    
}
