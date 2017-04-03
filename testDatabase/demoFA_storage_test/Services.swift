//
//  Services.swift
//  demoFA_storage_test
//
//  Created by DeptInfo on 03/04/2017.
//  Copyright © 2017 DeptInfo. All rights reserved.
//

import Foundation
import RealmSwift

class Services {
    public func addSubscriberToService(title: String, subscriber: Person) {
        let realm = try! Realm()

        let businessService = realm.object(ofType: BusinessService.self, forPrimaryKey: title as AnyObject)
        print(businessService!)
        try! realm.write {
            // Try to add the MediClass Object to the IndiClass Object:
            businessService!.subscribers.append(subscriber)
        }
    }
}
