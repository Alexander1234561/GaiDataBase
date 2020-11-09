import Foundation
import RealmSwift


class DateObj: Object {
    
    @objc dynamic var year: Int = 0
    @objc dynamic var month: Int = 0
    @objc dynamic var day: Int = 0
    @objc dynamic var hours: Int = 0
    
}

class CarObj: Object {
    
    @objc dynamic var owner: DriverObj? = DriverObj()
    @objc dynamic var id: Int = 0
    @objc dynamic var color: String = ""
    @objc dynamic var mark: String = ""
    @objc dynamic var techInsp: DateObj? = DateObj()
    
}


class AccidentObj: Object {
    
    @objc dynamic var trafficCop: String = ""
    @objc dynamic var driver: DriverObj? = DriverObj()
    @objc dynamic var car: CarObj? = CarObj()
    @objc dynamic var fine: Int = 0
    @objc dynamic var date: DateObj? = DateObj()
    
}

class DriverObj: Object {
    
    @objc dynamic var luxuryStatus: Bool = true
    @objc dynamic var name: String = ""
    @objc dynamic var surname: String = ""
    @objc dynamic var id: Int = 0
    var category = List<Int>()
    var cars =  List<CarObj>()
    var accidents = List<AccidentObj>()
}

//Создаем временной объект
func getDateObject(date: Date) -> DateObj{
        
    let dateObj = DateObj()
    
    if date.hours == nil{
        dateObj.hours = 0
    }
    else {
    dateObj.hours = date.hours!
    }
    dateObj.day = date.day
    dateObj.month = date.month.rawValue
    dateObj.year = date.year
    
    return dateObj
}

//Создаем объект машины
func getCarObject(car: Car) -> CarObj{
    
    let carObj = CarObj()
    
    carObj.id = car.id
    carObj.mark = car.mark
    carObj.color = car.color
    
    carObj.techInsp = getDateObject(date: car.techInsp)
    
    return carObj
}
//Создаем объект аварии
func getAccidentObject(accident: Accident) -> AccidentObj{
    
    let accidentObj = AccidentObj()
    
    //accidentObj.car = getCarObject(car: accident.car!)
    accidentObj.fine = accident.fine
    accidentObj.trafficCop = accident.trafficCop.fullName()
    accidentObj.date = getDateObject(date: accident.date)
    
    return accidentObj
}

//Создаем объект водителя
func getDriverObject(driver: Driver) -> DriverObj{
    
    let driverObj: DriverObj = DriverObj()
    
    driverObj.name = driver.name
    driverObj.surname = driver.surname
    driverObj.id = driver.id
    driverObj.luxuryStatus = driver.luxuryStatus
    for car in driver.cars {
        let cObj = getCarObject(car: car)
        driverObj.cars.append(cObj)
        cObj.owner = driverObj
    }
    for category in driver.category{
        driverObj.category.append(category.rawValue)
    }
    for accident in driver.accidents{
        let aObj = getAccidentObject(accident: accident)
        for car in driverObj.cars{
            if car.id == accident.car!.id{
                aObj.driver = driverObj
                aObj.car = car
                driverObj.accidents.append(aObj)
            }
        }
    }
    
    return driverObj
}

class myRealm {
    
    static private let realm = try! Realm()
    
    static func addDriver(driver: Driver) {
        
        let dObj = getDriverObject(driver: driver)
        try! realm.write{
            realm.add(dObj)
        }
    }
    
    static func addCar(car: Car, driverID: Int) {
        for driver in realm.objects(DriverObj.self) {
            let carObj = getCarObject(car: car)
            if driver.id == driverID {
                carObj.owner = driver
                try! realm.write{
                    driver.cars.append(carObj)
                    realm.add(carObj)
                }
            }
        }
    }
    
    static func addAccident(driverID: Int, carID: Int, accident: Accident) {
        
        let aObj = getAccidentObject(accident: accident)
        
        for driver in realm.objects(DriverObj.self) {
            if driver.id == driverID {
                for car in driver.cars{
                    if car.id == accident.car!.id{
                        
                        aObj.driver = driver
                        aObj.car = car
                        try! realm.write{
                        driver.accidents.append(aObj)
                        realm.add(aObj)
                        }
                    }
                }
            }
        }
    }
    
    static func getDrivers() -> [DriverObj] {
        return Array(realm.objects(DriverObj.self))
    }
    
    static func getCars() -> [CarObj] {
        return Array(realm.objects(CarObj.self))
    }
    
    static func getAccidents() -> [AccidentObj]{
        return Array(realm.objects(AccidentObj.self))
    }
    
    static func getCarsWithID(driverID: Int) -> [CarObj] {
        
        for driver in realm.objects(DriverObj.self) {
            if (driver.id == driverID) { return Array(driver.cars) }
        }
        return []
    }
    
    static func getAccidentsWithID(driverID: Int) -> [AccidentObj] {
        
        for driver in realm.objects(DriverObj.self) {
            if (driver.id == driverID) { return Array(driver.accidents) }
        }
        return []
    }
    
    static func getAccidentsWithID(carID: Int) -> [AccidentObj] {
        
        var acc: [AccidentObj] = []
        
        for accident in realm.objects(AccidentObj.self) {
            if (accident.car!.id == carID) { acc.append(accident) }
        }
        return acc
    }
}

