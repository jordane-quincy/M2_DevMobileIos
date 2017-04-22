//
//  Person.swift
//  demoFA_storage_test
//
//  Created by DeptInfo on 03/04/2017.
//  Copyright © 2017 DeptInfo. All rights reserved.
//

import Foundation
//import RealmSwift

class PersonTest : CustomStringConvertible {
    dynamic var name: String = ""
    dynamic var mail: String = ""
    
    init(name: String, mail: String) {
        self.name = name
        self.mail = mail
    }
    
    //toString()
    public var description: String { return "person(name:\(name), mail:\(mail) )" }
    
    func toJson() -> String {
        let props = ["name": self.name, "mail": mail]
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: props,
                                                      options: .prettyPrinted)
            return String(data: jsonData, encoding: String.Encoding.utf8)!
        } catch let error {
            print("Error in toJson() : \(error)")
            return "";
        }
    }
    
    func toJsonFile(pathJsonFile : String){
        
        let jsonFileSuccessfullyCreated = FileManager.default.createFile(atPath: pathJsonFile, contents: nil, attributes: nil);
        if(jsonFileSuccessfullyCreated){
            
            let props = ["name": self.name, "mail": mail]
            print("props :\(props)");
            
            let output = OutputStream(toFileAtPath: pathJsonFile, append: false)!
            
            output.open();
            print("output opened, hasSpaceAvailable ? \(output.hasSpaceAvailable)");
            
            var error : NSError? = nil;
            
            let nbBytesWritten = JSONSerialization.writeJSONObject(props, to: output, options: .prettyPrinted, error: &error);
            
            print("nbBytesWritten :\(nbBytesWritten)");
            output.close();
        }
    }
}
