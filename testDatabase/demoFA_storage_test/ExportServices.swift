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
        result = result + "\n\t\"serviceName\" : \"\(_businessServiceTitle)\"\n\t\"subscribers\" : ["
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
<<<<<<< HEAD:testDatabase/demoFA_storage_test/ExportServices.swift
        let realmServices = RealmServices()
        let businessService = realmServices.getBusinessService(_title: _businessServiceTitle)
        
        var result = "sep=;\n"
        for subscriber in businessService.subscribers {
            result = result + "\n"
            for attribute in subscriber.attributes {
                result = result + "\(attribute.value);"
            }
            result = result.substring(to: result.index(before: result.endIndex))
            result = result + "\n"
        }
        return result
=======
        var result = "sep=,\n"
        let realmServices = RealmServices()
        let businessService = realmServices.getBusinessService(_title: _businessServiceTitle)
        
        for subscriber in businessService.subscribers {
            
        }
        
        return result;
>>>>>>> 4c42a4be66bcb4c5b7ae8e6cd7a6c986e35dbc1e:testDatabase/demoFA_storage_test/ExportServices.swift
    }
}
