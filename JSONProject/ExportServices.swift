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
        result = result + "\n\t\"serviceName\" : \"\(businessService.title)\",\n\t\"serviceDescription\" : \"\(businessService.serviceDescription)\",\n\t\"icon\" : \"\(businessService.icon)\",\n\t\"subscribers\" : ["
        for subscriber in businessService.subscribers {
            
            result = result + "\n\t\t{\n\t\t\t\"serviceOffer\" : {\n\t\t\t\t\"title\" : \"\(subscriber.serviceOffer?.title)\",\n\t\t\t\t\"serviceDescription\" : \"\(subscriber.serviceOffer?.offerDescription)\",\n\t\t\t\t\"price\" : \(subscriber.serviceOffer?.price)\n\t\t\t},\n\t\t\t\"serviceOption(s)\" : ["
            
            for option in subscriber.serviceOptions {
                result = result + "\n\t\t\t\t{\n\t\t\t\t\t\"title\" : \"\(option.title)\",\n\t\t\t\t\t\"optionDescritpion\" : \"\(option.optionDescription)\",\n\t\t\t\t\t\"price\" : \(option.price)\n\t\t\t\t},"
            }
            result = result.substring(to: result.index(before: result.endIndex))
            result = result + "\n\t\t\t],"
            
            for attribute in subscriber.attributes {
                result = result + "\n\t\t\t\"\(attribute.fieldName)\" : \"\(attribute.value)\","
            }
            
            result = result + "\n\t\t\t\"paymentWay\" : {\n\t\t\t\t \"label\" : \"\(subscriber.paymentWay?.label)\","
            for attribute in (subscriber.paymentWay?.paymentAttributes)! {
                result = result + "\n\t\t\t\t\"\(attribute.fieldName)\" : \"\(attribute.value)\","
            }
            
            result = result.substring(to: result.index(before: result.endIndex))
            result = result + "\n\t\t\t},"
        }
        result = result.substring(to: result.index(before: result.endIndex))
        result = result + "\n\t]"
        result = result + "\n}"
        return result
    }
    
    public  func getSubscribersCSV(_businessServiceTitle: String) -> String {
        let realmServices = RealmServices()
        let businessService = realmServices.getBusinessService(_title: _businessServiceTitle) as BusinessService
        
        var header = "sep=,\nserviceName,serviceDescription,brand,"
        var result = ""
        
        
        for attribute in (businessService.subscribers.first?.attributes)! {
            header = header + "\(attribute.fieldName),"
        }
        header = header.substring(to: header.index(before: header.endIndex))
        header = header + "\n"
        
        for subscriber in businessService.subscribers {
            result = result + "\(businessService.title),\(businessService.serviceDescription),\(businessService.icon),"
            for attribute in subscriber.attributes {
                result = result + "\(attribute.value),"
            }
            result = result.substring(to: result.index(before: result.endIndex))
            result = result + "\n"
        }
        
        result = header + result
        
        return result
    }
    
}
