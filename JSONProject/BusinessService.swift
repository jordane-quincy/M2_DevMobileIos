//
//  BusinessService.swift
//  demoFA_storage_test
//
//  Created by DeptInfo on 03/04/2017.
//  Copyright © 2017 DeptInfo. All rights reserved.
//

import UIKit
import RealmSwift

class BusinessService: Object {
    
    dynamic var title: String = ""
    dynamic var serviceDescription: String = ""
    var subscribers: List<Person> = List<Person>()
    dynamic var icon: String = ""
    dynamic var jsonModelInString: String = ""
    dynamic var isLastUsed: Bool = false
    
    override class func primaryKey() -> String? {
        return "title"
    }
    
    convenience public init(_title: String, _serviceDescription: String, icon: String, jsonModelInString: String, isLastUsed: Bool) {
        self.init();
        title = _title
        serviceDescription = _serviceDescription
        self.icon = icon
        self.jsonModelInString = jsonModelInString
        self.isLastUsed = isLastUsed
    }
    
    public func addPersonToService(person: Person) {
        subscribers.append(person)
    }
    
}
