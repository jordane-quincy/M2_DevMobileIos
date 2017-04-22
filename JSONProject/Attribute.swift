//
//  Attribute.swift
//  demoFA_storage_test
//
//  Created by DeptInfo on 05/04/2017.
//  Copyright © 2017 DeptInfo. All rights reserved.
//

import Foundation
import RealmSwift

class Attribute: Object {
    
    dynamic var label: String = ""
    dynamic var fieldName: String = ""
    dynamic var value: String = ""

    let owner = LinkingObjects(fromType: Person.self, property: "attributes")
    
    convenience public init(_label: String, _fieldName: String, _value: String) {
        self.init();
        label = _label
        fieldName = _fieldName
        value = _value
    }
}

