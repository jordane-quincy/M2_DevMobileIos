//
//  OptionLabel.swift
//  Demo
//
//  Created by MAC ISTV on 12/05/2017.
//  Copyright © 2017 UVHC. All rights reserved.
//

import Foundation
import RealmSwift

class OptionLabel: Object {
    dynamic var label: String = ""
    
    convenience public init(label: String) {
        self.init();
        self.label = label
    }
}
