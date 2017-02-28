//
//  jsonDeTest.swift
//  Demo
//
//  Created by Mathilde Dumont on 07/02/2017.
//  Copyright © 2017 UVHC. All rights reserved.
//

import Foundation

enum ParsingError: Error {
    case missingData(String)
}

struct StructTest {
    //declaration des champs
    let champUn:String
    
    //TODO: comprendre pourquoi un ? apres init
    init?(json:[String: Any]) throws {
        
        // parse champUn
        guard let champUn = json["champUnDuJson"] as? String else {
            throw ParsingError.missingData("champUnDuJson")
        }
        
        self.champUn = champUn
    }
}
