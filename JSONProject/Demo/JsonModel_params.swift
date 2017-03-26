//
//  JsonModel_params.swift
//  Demo
//
//  Created by MAC ISTV on 26/03/2017.
//  Copyright © 2017 UVHC. All rights reserved.
//

import Foundation

class Params: CustomStringConvertible {
    let minLength: Int
    let maxLenght: Int
    let placeholder: String


    init?(jsonContent: [String: Any], inputType: InputType) throws {
        
        switch inputType {
        case .text:
            guard let minLength = jsonContent["minLength"] as? Int else {
                throw SerializationError.missing("minLength")
            }
            guard let maxLenght = jsonContent["maxLenght"] as? Int else {
                throw SerializationError.missing("maxLenght")
            }
            guard let placeholder = jsonContent["placeholder"] as? String else {
                throw SerializationError.missing("placeholder")
            }
            
            //assignation
            self.minLength = minLength
            self.maxLenght = maxLenght
            self.placeholder = placeholder
            
        default:
            // Input type not supported
            throw SerializationError.invalid("inputType", inputType)
        }
    }
    
    //toString()
    public var description: String { return "Params(minLength:\(minLength), maxLenght:\(maxLenght), placeholder:\(placeholder) )" }
    
}
