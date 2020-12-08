//
//  Exceptions.swift
//  GAI
//
//  Created by Александр on 30.11.2020.
//  Copyright © 2020 Александр. All rights reserved.
//

import Foundation

public enum MyError: Error {
    case emptyField
    case incorrectField
}

extension MyError: LocalizedError {
    
    public var errorDescription: String? {
        switch self {
        case .emptyField:
            return NSLocalizedString("Empty Field", comment: "My error")
        case .incorrectField:
            return NSLocalizedString("Incorrect Field", comment: "My error")
        }
    }
}

func emptyFieldCheck(text: String?) throws {
    if (text == nil) || (text == ""){
        throw MyError.emptyField
    }
}

func incorrectFieldCheck(text: String) throws {
    if (Int(text) == nil){
        throw MyError.incorrectField
    }
}
    
func incorrectDriverID(id: Int) -> Bool{
    for driver in myRealm.getDrivers(){
        if (driver.id == id){
            return false
        }
    }
    return true
}

func incorrectCarID(id: Int) -> Bool{
    for car in myRealm.getCars(){
        if (car.id == id){
            return false
        }
    }
    return true
}

