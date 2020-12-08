//
//  Model_tests.swift
//  ModelTests
//
//  Created by Александр on 03.12.2020.
//  Copyright © 2020 Александр. All rights reserved.
//

import XCTest
@testable import GAI

// Test strategy
class Model_tests: XCTestCase {
    
    func testExample1() {
        
        let test_accident: Accident = Accident(car: .A, carID: 10, driverCat: [.B,.C], driverLS: false, trafficCop: TrafficCop(name: "", surname: "", id: 1), fine: 100, year: 2000, day: 10, month: .April, hours: 0, description: "")
        XCTAssertEqual(test_accident.fine, 1000, "Wrong")
    }
    
    func testExample2() {
        
        let test_accident: Accident = Accident(car: .A, carID: 10, driverCat: [.A,.B,.C], driverLS: false, trafficCop: TrafficCop(name: "", surname: "", id: 1), fine: 100, year: 2000, day: 10, month: .April, hours: 0, description: "")
        XCTAssertEqual(test_accident.fine, 100, "Wrong")
    }
    
    func testExample3() {
        
        let test_accident: Accident = Accident(car: .A, carID: 10, driverCat: [.A,.B,.C], driverLS: true, trafficCop: TrafficCop(name: "", surname: "", id: 1), fine: 100, year: 2000, day: 10, month: .April, hours: 0, description: "")
        XCTAssertEqual(test_accident.fine, 10, "Wrong")
    }
    
    func testExample4() {
        
        let test_accident: Accident = Accident(car: .A, carID: 10, driverCat: [.B,.C], driverLS: true, trafficCop: TrafficCop(name: "", surname: "", id: 1), fine: 100, year: 2000, day: 10, month: .April, hours: 0, description: "")
        XCTAssertEqual(test_accident.fine, 10, "Wrong")
    }
}
