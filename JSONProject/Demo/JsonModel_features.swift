//
//  JsonModel.swift
//  Demo
//
//  Created by MAC ISTV on 19/03/2017.
//  Copyright © 2017 UVHC. All rights reserved.
//

import Foundation

class Feature: Hashable, CustomStringConvertible {
    let price: Int
    let title: String
    let description: String
    
    init?(jsonContent: [String: Any]) throws {
        guard let price = jsonContent["price"] as? Int else {
            throw SerializationError.missing("price")
        }
        guard let title = jsonContent["title"] as? String else {
            throw SerializationError.missing("title")
        }
        guard let description = jsonContent["description"] as? String else {
            throw SerializationError.missing("description")
        }
        
        
        //assignation
        self.price = price
        self.title = title
        self.description = description
    }
    
    //Hashable
    var hashValue: Int {
        return title.hashValue ^ title.hashValue
    }
    static func == (f1: Feature, f2: Feature) -> Bool {
        return f1.title == f2.title
    }
    
    //toString()
    //public var description: String { return "Feature(price:\(price), title:'\(title)', description:'\(description)' )" }
    
}
