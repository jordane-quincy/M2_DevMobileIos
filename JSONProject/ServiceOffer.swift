//
//  ServiceOption.swift
//  Demo
//
//  Created by MAC ISTV on 28/04/2017.
//  Copyright © 2017 UVHC. All rights reserved.
//

import Foundation
import RealmSwift

class ServiceOffer: Object {
    
    dynamic var title: String = ""
    dynamic var offerDescription: String = ""
    dynamic var price: Int = 0
    
    let owner = LinkingObjects(fromType: Person.self, property: "serviceOffer")
    
    convenience public init(title: String, offerDescription: String, price: Int) {
        self.init();
        self.title = title
        self.offerDescription = offerDescription
        self.price = price
    }
}
