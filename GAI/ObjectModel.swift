import Foundation
import UIKit

// Базовый класс человека
class Person {
    var name: String
    var surname: String
    var id: Int
    init(name: String, surname: String, id : Int) {
        self.name = name
        self.surname = surname
        self.id = id
    }
    func fullName() -> String {
        return "\(name) \(surname) : \(id)"
    }
}

// Класс водителя
class Driver: Person {
    
    var luxuryStatus: Bool
    var category: [carClass]
    var cars: [Car]
    var accidents: [Accident]
    
    init(category: [carClass], cars: [Car], accidents: [Accident], name: String, surname: String, id: Int, lStatus: Bool) {
        self.category = category
        self.cars = cars
        self.luxuryStatus = lStatus
        self.accidents = accidents
        super.init(name: name, surname: surname, id: id)
    }
    
    func addCategory(category: carClass){
        self.category.append(category)
    }
    
    func addCar(car: Car) {
        self.cars.append(car)
    }
    
    func removeCar(id: Int) {
        for (i, car) in self.cars.enumerated(){
            if car.id == id { car.driver = nil; self.cars.remove(at: i)}
        }
    }
}

//Класс ДПС
class TrafficCop: Person { }

/////////////////////////////////////////////////////////////////

//Паттерн Стратегия для вычисления стратегии штрафа
enum carClass: Int {
    case A
    case B
    case C
    case D
}

protocol CarCategoryFine {
    func fine(driverCategory: [carClass], carCategory: carClass, fineSum: Int) -> Int
}

class diffCategory : CarCategoryFine {
    func fine(driverCategory: [carClass], carCategory: carClass, fineSum: Int) -> Int {
        return  fineSum * 10
    }
}

class friendCategory : CarCategoryFine {
    func fine(driverCategory: [carClass], carCategory: carClass, fineSum: Int) -> Int {
        return  fineSum / 10
    }
}

class Fine {
    
    var carCategoryFine: CarCategoryFine?
    
    func execute(driverCategory: [carClass], carCategory: carClass, fineSum: Int) -> Int{
        guard carCategoryFine != nil else {return fineSum}
        return self.carCategoryFine!.fine(driverCategory: driverCategory, carCategory: carCategory, fineSum: fineSum)
    }
    
    func setCategory(carFine: CarCategoryFine) {
        self.carCategoryFine = carFine
    }
}

//Класс машины
class Car {
    
    var category: carClass
    weak var driver: Driver?
    let id: Int
    var color: String
    let mark: String
    var techInsp: Date
    
    
    init(driver: Driver?, id: Int, category: carClass, color: String, mark: String, year: Int, day: Int, month: Month, hours: Int) {
        self.driver = driver
        self.id = id
        self.color = color
        self.mark = mark
        self.category = category
        self.techInsp = Date(year: year, month: month, day: day, hours: hours)
    }
    
    func newDriver(driver: Driver) {
        self.driver?.removeCar(id: self.id)
        self.driver = driver
        driver.addCar(car: self)
    }
    
    func getTechnicalInspection() -> String {
        return "\(self.techInsp.day) : \(self.techInsp.month.hashValue) : \(self.techInsp.year)"
    }
}
////////////////////////////////////////////////////////
//Класс даты
enum Month: Int{
    case January
    case February
    case March
    case April
    case May
    case June
    case July
    case August
    case September
    case November
    case December
}


class Date {
    var year: Int
    var month: Month
    var day: Int
    var hours: Int?
    
    init(year: Int, month: Month, day: Int) {
        self.day = day
        self.month = month
        self.year = year
    }
    
    init(year: Int, month: Month, day: Int, hours: Int) {
        self.day = day
        self.month = month
        self.year = year
        self.hours = hours
    }
}

////////////////////////////////////////////////////////
//класс инцидента
class Accident{
    
    let trafficCop: TrafficCop
    weak var driver: Driver?
    weak var car: Car?
    let fine: Int
    let date: Date

    
    init(car: Car, driver: Driver, trafficCop: TrafficCop, fine: Int, year: Int, day: Int, month: Month, hours: Int) {
        self.car = car
        self.driver = driver
        self.trafficCop = trafficCop
        let carFine = Fine()
        if (driver.luxuryStatus == true) { carFine.setCategory(carFine: friendCategory()) }
        if (!driver.category.contains(car.category)) { carFine.setCategory(carFine: diffCategory()) }
        self.fine = carFine.execute(driverCategory: driver.category, carCategory: car.category, fineSum: fine)
        self.date = Date(year: year, month: month, day: day, hours: hours)
    }
    
    init(car: Car, trafficCop: TrafficCop, fine: Int, year: Int, day: Int, month: Month, hours: Int) {
        self.car = car
        //self.driver = driver
        self.trafficCop = trafficCop
        self.fine = fine
        self.date = Date(year: year, month: month, day: day, hours: hours)
    }
}