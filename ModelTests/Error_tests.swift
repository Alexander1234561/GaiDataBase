//
//  Error_tests.swift
//  ModelTests
//
//  Created by Александр on 03.12.2020.
//  Copyright © 2020 Александр. All rights reserved.
//

import XCTest
@testable import GAI

class Error_tests: XCTestCase {

    func testExample1() {
        
        var str: String?
        
        do {
            try emptyFieldCheck(text: "")
        }
        catch {
            str = error.localizedDescription
        }
          XCTAssertNotNil(str)
    }
    
    func testExample2() {
        
        var str: String?
        
        do {
            try emptyFieldCheck(text: "Hello")
        }
        catch {
            str = error.localizedDescription
        }
        XCTAssertNil(str)
    }
    
    func testExample3() {
        
        var str: String?
        
        do {
            try incorrectFieldCheck(text: "A")
        }
        catch {
            str = error.localizedDescription
        }
        XCTAssertNotNil(str)
    }
    
    func testExample4() {
        
        var str: String?
        
        do {
            try emptyFieldCheck(text: "1")
        }
        catch {
            str = error.localizedDescription
        }
        XCTAssertNil(str)
    }
}
