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
    
    var title: String = ""
    var serviceDescription: String = ""
    var subscribers: List<Person> = List<Person>()
    var brand: String = ""
}
