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
    let owner = LinkingObjects(fromType: BusinessService.self, property: "subscribers")
    
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
}
