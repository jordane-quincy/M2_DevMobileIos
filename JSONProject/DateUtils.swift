//
//  DateUtils.swift
//  Demo
//
//  Created by MAC ISTV on 22/04/2017.
//  Copyright © 2017 UVHC. All rights reserved.
//

import Foundation

class DateUtils {
    
    public func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy-hh'h'-mm'min'"
        return dateFormatter.string(from: date)
    }
}
