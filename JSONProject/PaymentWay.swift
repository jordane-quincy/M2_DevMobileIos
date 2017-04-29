//
//  ServiceOption.swift
//  Demo
//
//  Created by MAC ISTV on 28/04/2017.
//  Copyright © 2017 UVHC. All rights reserved.
//

import Foundation
import RealmSwift

class PaymentWay: Object {
    
    dynamic var label: String = ""
    var paymentAttributes: List<PaymentAttribute> = List<PaymentAttribute>()
    
    let owner = LinkingObjects(fromType: Person.self, property: "paymentWay")
    
    convenience public init(label: String) {
        self.init();
        self.label = label
    }
    
    public func addPaymentAttribute (paymentAttribute: PaymentAttribute) {
        self.paymentAttributes.append(paymentAttribute)
    }
}
