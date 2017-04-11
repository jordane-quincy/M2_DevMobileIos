//
//  FileServices.swift
//  demoFA_storage_test
//
//  Created by MAC ISTV on 11/04/2017.
//  Copyright © 2017 DeptInfo. All rights reserved.
//

import Foundation

// Class that manage files
class FileServices {
    
    
    public func createJSONFileFromString(JSONStringify: String) {
        let file = "exportJSON.json"
        //let data = JSONStringify.data(using: .utf8)!
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            
            let path = dir.appendingPathComponent(file)
            
            //writing
            do {
                try JSONStringify.write(to: path, atomically: false, encoding: String.Encoding.utf8)
            }
            catch {/* error handling here */}
            
            //reading
            do {
                let text2 = try String(contentsOf: path, encoding: String.Encoding.utf8)
            }
            catch {/* error handling here */}
        }
        
    }
}
