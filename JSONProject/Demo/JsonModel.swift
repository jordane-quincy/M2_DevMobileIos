//
//  JsonModel.swift
//  Demo
//
//  Created by MAC ISTV on 19/03/2017.
//  Copyright © 2017 UVHC. All rights reserved.
//

import Foundation

enum SerializationError: Error {
    case missing(String)
    case invalid(String, Any)
}
enum Payment: String {
    case creditCard, bankTransfer, paypal
}
struct JsonModel {
    let title: String
    let description: String
    let icon: String
    let commonFields: Set<CommonField>
    let paymentWays: Set<Payment>
    let offers: Set<Offer>
    
    init?(jsonContent: [String: Any]) throws {
        guard let title = jsonContent["title"] as? String else {
            throw SerializationError.missing("title")
        }
        
        guard let description = jsonContent["description"] as? String else {
            throw SerializationError.missing("description")
        }
        
        let icon = jsonContent["icon"] as? String
        
        // Extract and validate payments
        guard let paymentWaysJSON = jsonContent["paymentWays"] as? [String] else {
            throw SerializationError.missing("paymentWays")
        }
        var paymentWays: Set<Payment> = []
        for paymentString in paymentWaysJSON {
            guard let payment = Payment(rawValue: paymentString) else {
                throw SerializationError.invalid("payment", paymentString)
            }
            paymentWays.insert(payment)
        }
        
        // Extract and validate commonFields
        guard let commonFieldsJsonArray = jsonContent["commonFields"] as? [[String: Any]] else {
            throw SerializationError.missing("commonFields")
        }
        //print("commonFieldsJsonArray : \(commonFieldsJsonArray)")//FIXME: pour debug uniquement
        var commonFields: Set<CommonField> = []
        for commonFieldJsonElement in commonFieldsJsonArray {
            //print("commonFieldJsonElement : \(commonFieldJsonElement)")//FIXME: pour debug uniquement
            
            do {
                guard let commonField = try CommonField(jsonContent: commonFieldJsonElement) else {
                    throw SerializationError.invalid("commonField", commonFieldJsonElement)
                }
                commonFields.insert(commonField)
                
            } catch let serializationError {
                print(serializationError)
            }
            
            
        }
        
        // Extract and validate commonFields
        guard let offersJsonArray = jsonContent["offers"] as? [[String: Any]] else {
            throw SerializationError.missing("offers")
        }
        //print("offersJsonArray : \(offersJsonArray)")//FIXME: pour debug uniquement
        var offers: Set<Offer> = []
        for offerJsonElement in offersJsonArray {
            //print("commonFieldJsonElement : \(commonFieldJsonElement)")//FIXME: pour debug uniquement
            
            do {
                guard let offer = try Offer(jsonContent: offerJsonElement) else {
                    throw SerializationError.invalid("offer", offerJsonElement)
                }
                offers.insert(offer)
                
            } catch let serializationError {
                print(serializationError)
            }
            
        }

        
        //assignation
        self.title = title
        self.description = description
        self.icon = icon ?? ""
        self.commonFields = commonFields
        self.paymentWays = paymentWays
        self.offers = offers
    }
}
