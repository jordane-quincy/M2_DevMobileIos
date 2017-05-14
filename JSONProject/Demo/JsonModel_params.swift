//
//  JsonModel_params.swift
//  Demo
//
//  Created by MAC ISTV on 26/03/2017.
//  Copyright © 2017 UVHC. All rights reserved.
//

import Foundation

class Choice: Hashable, CustomStringConvertible {
    let value: String
    let label: String
    var selected: Bool = false
    
    init?(jsonContent: [String: Any]) throws {
        guard let value = jsonContent["value"] as? String else {
            throw SerializationError.missing("value")
        }
        guard let label = jsonContent["label"] as? String else {
            throw SerializationError.missing("label")
        }
        let selected = jsonContent["selected"] as? Bool
        
        //assignation
        self.value = value
        self.label = label
        self.selected = selected ?? false
    }
    
    //Hashable
    var hashValue: Int {
        return value.hashValue ^ value.hashValue
    }
    static func == (c1: Choice, c2: Choice) -> Bool {
        return c1.value == c2.value
    }
    
    //toString()
    public var description: String { return "choice(value:'\(value)', label:'\(label)', selected:\(selected) )" }
    
}


class Params: CustomStringConvertible {
    let minLength: Int?
    let maxLenght: Int?
    let placeholder: String?
    
    let choices: Set<Choice>?


    init?(jsonContent: [String: Any], inputType: InputType) throws {
        
        switch inputType {
        case .text:
            var minLength: Int? = nil
            if (jsonContent["minLength"] != nil) {
                minLength = jsonContent["minLength"] as? Int
            }
            var maxLength: Int? = nil
            if (jsonContent["maxLength"] != nil) {
                maxLength = jsonContent["maxLength"] as? Int
            }
            var placeholder = ""
            if (jsonContent["placeholder"] != nil) {
                placeholder = (jsonContent["placeholder"] as? String)!
            }
            
            //assignation
            self.minLength = minLength
            self.maxLenght = maxLength
            self.placeholder = placeholder
            
            self.choices = nil
            
        case .radio, .select, .check:
            // Extract and validate choices
            guard let choicesJsonArray = jsonContent["choices"] as? [[String: Any]] else {
                throw SerializationError.missing("choices")
            }
            //print("choicesJsonArray : \(choicesJsonArray)")//FIXME: pour debug uniquement
            var choices: Set<Choice> = []
            for choicesJsonElement in choicesJsonArray {
                //print("choicesJsonElement : \(choicesJsonElement)")//FIXME: pour debug uniquement
                
                do {
                    guard let choice = try Choice(jsonContent: choicesJsonElement) else {
                        throw SerializationError.invalid("choices", choicesJsonElement)
                    }
                    choices.insert(choice)
                    
                } catch let serializationError {
                    print(serializationError)
                }
                
            }
            
            //assignation
            self.choices = choices
            
            self.minLength = nil
            self.maxLenght = nil
            self.placeholder = nil

        default:
            // special case for .date
            // FIXME: nothing more than initialize to do here because executable line(s) is mandatory
            self.minLength = nil
            self.maxLenght = nil
            self.placeholder = nil
            self.choices = nil
        }
    }
    
    //toString()
    public var description: String { return "Params(minLength:\(minLength), maxLenght:\(maxLenght), placeholder:'\(placeholder)', choices:\(choices) )" }
    
}
