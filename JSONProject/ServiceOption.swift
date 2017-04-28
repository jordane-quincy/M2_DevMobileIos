//
//  ServiceOption.swift
//  Demo
//
//  Created by MAC ISTV on 28/04/2017.
//  Copyright © 2017 UVHC. All rights reserved.
//

import Foundation
import RealmSwift

class ServiceOption: Object {
    
    dynamic var title: String = ""
    dynamic var optionDescription: String = ""
    dynamic var price: Int = 0
    
    let owner = LinkingObjects(fromType: Person.self, property: "serviceOptions")
    
    convenience public init(title: String, optionDescription: String, price: Int) {
        self.init();
        self.title = title
        self.optionDescription = optionDescription
        self.price = price
    }
}
