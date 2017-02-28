//
//  JSONUtils.swift
//  Demo
//
//  Created by Mathilde Dumont on 28/02/2017.
//  Copyright © 2017 UVHC. All rights reserved.
//

import Foundation

class JSONUtils {
    public func readJson(fileName: String) -> [String: Any]? {
        do {
            if let file = Bundle.main.url(forResource: fileName, withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [String: Any] {
                    // json is a dictionary
                    return object
                } else {
                    return nil
                }
            } else {
                return nil
            }
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
