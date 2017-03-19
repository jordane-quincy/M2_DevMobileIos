//
//  JsonModel.swift
//  Demo
//
//  Created by MAC ISTV on 19/03/2017.
//  Copyright © 2017 UVHC. All rights reserved.
//

import Foundation

struct JsonModel {
    let title: String
    let description: String
    
}

extension JsonModel {
    init?(jsonContent: [String: Any]) {
        guard let title = jsonContent["title"] as? String,
        let description = jsonContent["description"] as? String
        
        else {
                return nil
        }
        
    self.title = title
    self.description = description
    }
}
