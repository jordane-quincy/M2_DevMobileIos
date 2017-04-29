//
//  Person.swift
//  demoFA_storage_test
//
//  Created by DeptInfo on 03/04/2017.
//  Copyright © 2017 DeptInfo. All rights reserved.
//

import Foundation
import RealmSwift

class Person: Object {
    dynamic var id: Int = 0
    var attributes: List<Attribute> = List<Attribute>()
    var serviceOptions: List<ServiceOption> = List<ServiceOption>()
    let owner = LinkingObjects(fromType: BusinessService.self, property: "subscribers")
    var serviceOffer: ServiceOffer? = nil
    var paymentWay: PaymentWay? = nil
    
    var isSaved = false
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    public func incrementID() -> Int {
        let realm = try! Realm()
        return (realm.objects(Person.self).max(ofProperty: "id") as Int? ?? 0) + 1
    }
    
    convenience public init(id: Int) {
        self.init();
        self.id = id
    }
    
    public func setupServiceOffer(offer: ServiceOffer) {
        self.serviceOffer = offer
    }
    
    public func setupPaymnetWay(paymentWay: PaymentWay) {
        self.paymentWay = paymentWay
    }
    
    public func changeIsSavePerson() {
        self.isSaved = true
    }
    
    public func addAttributeToPerson(_attribute: Attribute) {
        attributes.append(_attribute)
    }
    
    public func getAttributeValue(fieldName: String) -> String? {
        for attribute in self.attributes {
            if (attribute.fieldName == fieldName && attribute.value != "") {
                return attribute.value
            }
        }
        return nil
    }
    
    public func addServiceOptionToPerson(serviceOption: ServiceOption) {
        self.serviceOptions.append(serviceOption);
    }
    
    public func optionNotAlreadyTaken(serviceOption: ServiceOption) -> Bool {
        for option in self.serviceOptions {
            if (option.title == serviceOption.title) {
                return false
            }
        }
        return true
    }
    
    public func removeAllOptions() {
        self.serviceOptions = List<ServiceOption>()
    }
    
    public func getAttributeIndex(fieldName: String) -> Int {
        var cpt = 0
        for attribute in self.attributes {
            if (attribute.fieldName == fieldName) {
                return cpt
            }
            cpt += 1
        }
        return -1
    }
    
    public func removeAllSpecificFields() {
        var tableOfIndex = Array<Int>()
        var cpt = 0
        for attribute in self.attributes {
            if (attribute.isSpecificField) {
                tableOfIndex.append(cpt)
            }
            cpt += 1
        }
        for index in tableOfIndex {
            self.attributes.remove(at: index)
        }
    }
}
