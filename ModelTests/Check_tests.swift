//
//  Check_tests.swift
//  ModelTests
//
//  Created by Александр on 03.12.2020.
//  Copyright © 2020 Александр. All rights reserved.
//

import XCTest
@testable import GAI

class Check_tests: XCTestCase {

    func testExample1() {
        
        let a = changeDate(date: "10:10:2000")
        XCTAssertNotNil(a)
    }
    
    func testExample2() {
        let a = changeDate(date: "30:01:2002")
        XCTAssertNotNil(a)
    }
    
    func testExample3() {
        let a = changeDate(date: "01:12:2000")
        XCTAssertNotNil(a)
    }
    
    func testExample4() {
        let a = changeDate(date: "00:12:2000")
        XCTAssertNil(a)
    }
    
    func testExample5() {
        let a = changeDate(date: "0:12:2000")
        XCTAssertNil(a)
    }
    
    func testExample6() {
        let a = changeDate(date: "01:2:2000")
        XCTAssertNil(a)
    }
    
    func testExample7() {
        let a = changeDate(date: "01:02:200")
        XCTAssertNil(a)
    }
    
    func testExample8() {
        let a = changeDate(date: "01:02-2000")
        XCTAssertNil(a)
    }
    
    func testExample9() {
        let a = changeDate(date: "01-02:2000")
        XCTAssertNil(a)
    }
    
    func testExample10() {
        let a = changeDate(date: "01022000")
        XCTAssertNil(a)
    }
}
