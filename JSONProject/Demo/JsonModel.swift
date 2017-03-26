//
//  JsonModel.swift
//  Demo
//
//  Created by MAC ISTV on 19/03/2017.
//  Copyright © 2017 UVHC. All rights reserved.
//

import Foundation

enum FieldType: String {
    case name, date, other
}
enum InputType: String {
    case text, radio, date, select
}
class CommonField: Hashable, CustomStringConvertible {
    let required: Bool
    let fieldType: FieldType
    let fieldId: String
    let label: String
    let input: InputType
    let params: Params
    
    
    init?(jsonContent: [String: Any]) throws {
        guard let required = jsonContent["required"] as? Bool else {
            throw SerializationError.missing("required")
        }
        
        // Extract and validate fieldType
        guard let fieldTypeJson = jsonContent["fieldType"] as? String else {
            throw SerializationError.missing("fieldType")
        }
        guard let fieldType = FieldType(rawValue: fieldTypeJson) else {
            throw SerializationError.invalid("fieldType", fieldTypeJson)
        }
        
        guard let fieldId = jsonContent["fieldId"] as? String else {
            throw SerializationError.missing("fieldId")
        }
        guard let label = jsonContent["label"] as? String else {
            throw SerializationError.missing("label")
        }
        
        // Extract and validate input
        guard let inputJson = jsonContent["input"] as? String else {
            throw SerializationError.missing("input")
        }
        guard let input = InputType(rawValue: inputJson) else {
            throw SerializationError.invalid("input", inputJson)
        }
        
        // Extract and validate input
        guard let paramsJson = jsonContent["params"] as? [String: Any] else {
            throw SerializationError.missing("params")
        }
        guard let params = try Params(jsonContent: paramsJson, inputType: input) else {
            throw SerializationError.invalid("params", paramsJson)
        }
        
        //assignation
        self.required = required
        self.fieldType = fieldType
        self.fieldId = fieldId
        self.label = label
        self.input = input
        self.params = params
    }
    
    //Hashable
    var hashValue: Int {
        return fieldId.hashValue ^ fieldId.hashValue
    }
    static func == (cf1: CommonField, cf2: CommonField) -> Bool {
        return cf1.fieldId == cf2.fieldId
    }
    
    //toString()
    public var description: String { return "commonField(required:\(required), fieldType:\(fieldType), fieldId:\(fieldId), label:\(label), input:\(input), params:\(params) )" }
    
}

enum Payment: String {
    case creditCard, bankTransfer
}
struct JsonModel {
    let title: String
    let description: String
    let commonFields: Set<CommonField>
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
        print("commonFieldsJsonArray : \(commonFieldsJsonArray)")//FIXME: pour debug uniquement
        var commonFields: Set<CommonField> = []
        for commonFieldJsonElement in commonFieldsJsonArray {
            print("commonFieldJsonElement : \(commonFieldJsonElement)")//FIXME: pour debug uniquement
            
            do {
                guard let commonField = try CommonField(jsonContent: commonFieldJsonElement) else {
                    throw SerializationError.invalid("commonField", commonFieldJsonElement)
                }
                commonFields.insert(commonField)
                
            } catch let serializationError {
                print(serializationError)
            }
            
            
        }

        
        //assignation
        self.title = title
        self.description = description
        self.commonFields = commonFields
        self.paymentWays = paymentWays
    }
}
