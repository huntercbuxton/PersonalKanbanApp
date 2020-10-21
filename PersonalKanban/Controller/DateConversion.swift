//
//  DateConversion.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/20/20.
//

import Foundation
import CoreData

struct DateConversion {

//    func setDate<T: NSManagedObject>(object: T, key: String, date: Date) {
//        object.setValue(date.format(), forKey: key)
//    }
//
//

    static func format(_ newDate: Date, format: String = "dd-MM-yyyy hh-mm-ss") -> Date {
        return newDate.format()
    }

    static func toString(date: Date, format: String = "dd-MM-yyyy hh-mm-ss") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
}


extension Date {

     func format(format: String = "dd-MM-yyyy hh-mm-ss") -> Date {
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = format
         let dateString = dateFormatter.string(from: self)
         print("dateString: \(dateString)")
         if let newDate = dateFormatter.date(from: dateString) {
             return newDate
         } else {
             return self
         }
     }
}
