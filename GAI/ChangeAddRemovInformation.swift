//
//  ChangeAddRemovInformation.swift
//  GAI
//
//  Created by Александр on 28.11.2020.
//  Copyright © 2020 Александр. All rights reserved.
//

import Foundation

func changeInt(intInformation: String) -> Bool {
    return Int(intInformation) != (nil) ? true : false
}

func changeDate(date: String) -> Date? {
    var y: Int = 0
    var d: Int = 0
    var m: Int = 0
    guard date.count == 10 else { return nil }
    guard ((date[String.Index(encodedOffset: 2)] == ":") && (date[String.Index(encodedOffset: 5)] == ":")) else { return nil }
    if let day = Int(date[String.Index(encodedOffset: 0)..<String.Index(encodedOffset: 2)]) {
        guard day > 0 && day <= 31 else {return nil}
        d = day
    } else {return  nil}
    if let month = Int(date[String.Index(encodedOffset: 3)..<String.Index(encodedOffset: 5)]) {
        guard month > 0 && month <= 12 else {return nil}
        m = month
    } else {return  nil}
    if let year = Int(date[String.Index(encodedOffset: 6)..<String.Index(encodedOffset: 10)]) {
        guard year > 0 else {return nil}
        y = year
    } else {return  nil}
    let date = Date(year: y, month: Month(rawValue: m - 1)!, day: d)
    return date
}


