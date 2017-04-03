//
//  Person.swift
//  demoFA_storage_test
//
//  Created by DeptInfo on 03/04/2017.
//  Copyright © 2017 DeptInfo. All rights reserved.
//

import Foundation
//import RealmSwift

class Person : CustomStringConvertible {
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
    
    func toJsonFile(){
        let props = ["name": self.name, "mail": mail]
        print("props :\(props)");
        
        let filePath = createTestFile("testOutput.json",_contents: Data(capacity: 128))
        
        let output = OutputStream(toFileAtPath: filePath!, append: false)!
        //let output = OutputStream(toMemory: ()) // fonctionne
        
        print("output :\(output)");
        
        output.open();
        print("output opened, hasSpaceAvailable ? \(output.hasSpaceAvailable)");
        
        var error : NSError? = nil;
        
        print("before writeJSONObject");
        let nbBytesWritten = JSONSerialization.writeJSONObject(props, to: output, options: .prettyPrinted, error: &error);
        
        print("nbBytesWritten :\(nbBytesWritten)");
        output.close()
    }
    
    fileprivate func createTestFile(_ path: String,_contents: Data) -> String? {
        let tempDir = NSTemporaryDirectory() + "TestFoundation_Playground_" + NSUUID().uuidString + "/"
        do {
            try FileManager.default.createDirectory(atPath: tempDir, withIntermediateDirectories: false, attributes: nil)
            if FileManager.default.createFile(atPath: tempDir + "/" + path, contents: _contents,
                                              attributes: nil) {
                return tempDir + path
            } else {
                return nil
            }
        } catch _ {
            return nil
        }
    }
}
