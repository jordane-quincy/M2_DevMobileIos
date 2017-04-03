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
    
    dynamic var name: String = ""
    dynamic var email: String = ""
    let owner = LinkingObjects(fromType: BusinessService.self, property: "subscribers")
    
    override class func primaryKey() -> String? {
        return "email"
    }
    
    convenience public init(_name: String, _email: String) {
        self.init();
        name = _name
        email = _email
    }
}
