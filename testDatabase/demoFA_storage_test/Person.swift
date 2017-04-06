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
    
    dynamic var email: String = ""
    var attributes: List<Attribute> = List<Attribute>()
    let owner = LinkingObjects(fromType: BusinessService.self, property: "subscribers")
    
    override class func primaryKey() -> String? {
        return "email"
    }
    
    convenience public init(_email: String) {
        self.init();
        email = _email
    }
    
    convenience public init(_email: String, _attributes: List<Attribute>){
        self.init();
        email = _email
        attributes = _attributes
    }
    
    public func addAttributeToPerson(attribute: Attribute) {
        attributes.append(attribute)
    }
}
