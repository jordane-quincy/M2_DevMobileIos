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
        result = result + "\n\t\"serviceName\" : \"\(businessService.title)\"\n\t\"subscribers\" : ["
        for subscriber in businessService.subscribers {
            result = result + "\n\t\t{"
            for attribute in subscriber.attributes {
                result = result + "\n\t\t\t\"\(attribute.fieldName)\" : \"\(attribute.value)\","
            }
            result = result.substring(to: result.index(before: result.endIndex))
            result = result + "\n\t\t},"
        }
        result = result.substring(to: result.index(before: result.endIndex))
        result = result + "\n\t]"
        result = result + "\n}"
        return result
    }
    
    public func getSubscribersCSV(_businessServiceTitle: String) -> String {
        let realmServices = RealmServices()
        let businessService = realmServices.getBusinessService(_title: _businessServiceTitle) as BusinessService
        
        var header = "sep=,\nserviceName,"
        var result = ""
        
        
        for attribute in (businessService.subscribers.first?.attributes)! {
            header = header + "\(attribute.fieldName),"
        }
        header = header.substring(to: header.index(before: header.endIndex))
        header = header + "\n"
        
        for subscriber in businessService.subscribers {
            result = result + "\(businessService.title),"
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
