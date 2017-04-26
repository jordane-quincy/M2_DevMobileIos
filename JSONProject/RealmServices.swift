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
    
    var realm = try! Realm()
    
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
            deleteSubcriber(_email: subcriber.email)
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
    
    public func deleteSubcriber(_email: String){
        let subcriber = self.realm.object(ofType: Person.self, forPrimaryKey: _email as AnyObject)
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
    
}
