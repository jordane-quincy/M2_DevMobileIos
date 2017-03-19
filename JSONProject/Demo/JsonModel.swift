//
//  JsonModel.swift
//  Demo
//
//  Created by MAC ISTV on 19/03/2017.
//  Copyright © 2017 UVHC. All rights reserved.
//

import Foundation

enum Payment: String {
    case creditCard, bankTransfer
}
struct JsonModel {
    let title: String
    let description: String
    //let commonFields:
    let paymentWays: Set<Payment>
}


enum SerializationError: Error {
    case missing(String)
    case invalid(String, Any)
}
extension JsonModel {
    init?(jsonContent: [String: Any]) throws {
        guard let title = jsonContent["title"] as? String else {
            throw SerializationError.missing("title")
        }
        
        guard let description = jsonContent["description"] as? String else {
            throw SerializationError.missing("description")
        }
        
        // Extract and validate payments
        guard let paymentWaysJSON = jsonContent["paymentWays"] as? [String] else {
            throw SerializationError.missing("meals")
        }
        var paymentWays: Set<Payment> = []
        for paymentString in paymentWaysJSON {
            guard let payment = Payment(rawValue: paymentString) else {
                throw SerializationError.invalid("payment", paymentString)
            }
            paymentWays.insert(payment)
        }

        
        //assignation
        self.title = title
        self.description = description
        self.paymentWays = paymentWays
    }
}
