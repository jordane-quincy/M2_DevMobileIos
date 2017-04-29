//
//  Services.swift
//  demoFA_storage_test
//
//  Created by DeptInfo on 03/04/2017.
//  Copyright © 2017 DeptInfo. All rights reserved.
//

import Foundation
import RealmSwift

class RealmServices {
    
    var realm = try! Realm();
    
    public func addSubscriberToService(title: String, subscriber: Person) {
        let businessService = self.realm.object(ofType: BusinessService.self, forPrimaryKey: title as AnyObject)
//        print(businessService!)
        try! self.realm.write {
            // Try to add the MediClass Object to the IndiClass Object:
            businessService!.addPersonToService(person: subscriber)
        }
    }
    
    public func addAttributeToPerson(_email: String, attribute: Attribute) {
        
        let person = self.realm.object(ofType: Person.self, forPrimaryKey: _email as AnyObject)
//        print(person!)
        try! self.realm.write {
            person!.addAttributeToPerson(_attribute: attribute)
        }
    }
    
    public func resetDataBase(){
        
        try! self.realm.write {
            self.realm.deleteAll()
        }
    }
    
    public func resetService(title: String){
        
        let businessService = self.realm.object(ofType: BusinessService.self, forPrimaryKey: title as AnyObject)
        print(businessService!)
        for subcriber in (businessService!.subscribers) {
            deleteSubcriber(id: subcriber.id)
        }
    }
    
    public func createBusinessService(businessService: BusinessService){
        try! self.realm.write {
            self.realm.add(businessService)
//            print("\(businessService)")
        }
    }
    
    public func createPerson(person: Person){
        try! self.realm.write {
            self.realm.add(person)
//            print("\(person)")
        }
    }
    
    public func createAttribute(_attribute: Attribute){
        try! self.realm.write {
            self.realm.add(_attribute)
//            print("\(_attribute)")
        }
    }
    
    public func deleteSubcriber(id: Int){
        let subcriber = self.realm.object(ofType: Person.self, forPrimaryKey: id as AnyObject)
        try! self.realm.write {
            self.realm.delete((subcriber?.attributes)!)
            self.realm.delete(subcriber!)
        }
    }
    
    public func deleteBusinessService(_title: String){
        resetService(title: _title)
        let businessServcice = self.realm.object(ofType: BusinessService.self, forPrimaryKey: _title as AnyObject)
        try! self.realm.write {
            self.realm.delete(businessServcice!)
        }
    }
    
    public func getBusinessServicesArray() -> Array<BusinessService> {
        let results: Results<BusinessService> = self.realm.objects(BusinessService.self)
        let allServices = Array(results)
        return allServices
    }
    
    public func getBusinessService(_title:String) -> BusinessService{
        return self.realm.object(ofType: BusinessService.self, forPrimaryKey: _title as AnyObject)!
    }
    
    public func setIsLastUsedForService(title: String) {
        let businessService = self.getBusinessService(_title: title)
        try! self.realm.write {
            businessService.isLastUsed = true
        }
    }
    
    public func getLastUsedBusinessServices() -> BusinessService? {
        let allServices = self.getBusinessServicesArray()
        for service in allServices {
            if (service.isLastUsed) {
                return service
            }
        }
        return nil;
    }
    
    public func resetlastUsedService() {
        let allServices = self.getBusinessServicesArray()
        for service in allServices {
            if (service.isLastUsed) {
                // reset the "isLastUsed"
                try! self.realm.write {
                    service.isLastUsed = false
                }
            }
        }
    }
    
    public func serviceFree(title: String) -> Bool {
        if (self.realm.object(ofType: BusinessService.self, forPrimaryKey: title as AnyObject) != nil) {
            return false
        }
        else {
            return true
        }
    }
    
}
