//
//  JsonModel.swift
//  Demo
//
//  Created by MAC ISTV on 19/03/2017.
//  Copyright © 2017 UVHC. All rights reserved.
//

import Foundation

enum FieldType: String {
    case name, date, phone, email, other
}
enum InputType: String {
    case text, radio, date, select, string, check
}
class Field: Hashable, CustomStringConvertible {
    let fieldType: FieldType
    let fieldId: String
    let label: String
    let input: InputType
    
    init?(jsonContent: [String: Any]) throws {
        
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
        
        
        //assignation
        self.fieldType = fieldType
        self.fieldId = fieldId
        self.label = label
        self.input = input
    }
    
    //Hashable
    var hashValue: Int {
        return fieldId.hashValue ^ fieldId.hashValue
    }
    static func == (cf1: Field, cf2: Field) -> Bool {
        return cf1.fieldId == cf2.fieldId
    }
    
    //toString()
    public var description: String { return "commonField(fieldType:\(fieldType), fieldId:\(fieldId), label:\(label), input:\(input) )" }
    
}

class CommonField: Field {
    var required: Bool?
    var params: Params?

    override init?(jsonContent: [String: Any]) throws {
        // We must set a value before call parent method (and reassing the real value after (so we use of "var" instead of "let"))
        self.required = false;
        self.params = nil;
        
        // parent method
        try super.init(jsonContent: jsonContent)
        
        let required = jsonContent["required"] as? Bool
        //assignation
        self.required = required
        
        if(InputType.date == self.input){
            // c'est ça aussi de ne pas mettre de champ params pour les dates... (ex : pour la V2 :mettre le format de la date en params)
            self.params = nil
        }else{
            // Extract and validate input
            if let paramsJson = jsonContent["params"] as? [String: Any] {
                guard let params = try Params(jsonContent: paramsJson, inputType: self.input) else {
                    throw SerializationError.invalid("params", paramsJson)
                }
                self.params = params
            }
        }
        
        
        
    }
    
    //toString()
    override public var description: String { return super.description + ", required:\(required), params:\(params)" }
}

class SpecificField: Field {
    
}

