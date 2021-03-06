import Foundation
import RealmSwift

//Класс таблицы - Дата
class DateObj: Object {
    
    @objc dynamic var year: Int = 0
    @objc dynamic var month: Int = 0
    @objc dynamic var day: Int = 0
    @objc dynamic var hours: Int = 0
    
    static func getDateObject(date: Date) -> DateObj{
        
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
    
}

//Класс таблицы - Авария
class CarObj: Object {
    
    @objc dynamic var owner: DriverObj? = DriverObj()
    @objc dynamic var id: Int = 0
    @objc dynamic var color: String = ""
    @objc dynamic var mark: String = ""
    @objc dynamic var category: Int = 0
    @objc dynamic var techInsp: DateObj? = DateObj()
    
    //Создаем объект машины
    static func getCarObject(car: Car) -> CarObj{
        
        let carObj = CarObj()
        
        carObj.id = car.id
        carObj.mark = car.mark
        carObj.color = car.color
        carObj.category = car.category.rawValue
        carObj.techInsp = DateObj.getDateObject(date: car.techInsp)
        
        return carObj
    }
}

//Класс таблицы - Авария
class AccidentObj: Object {
    
    @objc dynamic var descriptionAc: String = ""
    @objc dynamic var trafficCop: String = ""
    @objc dynamic var trafficCopID: Int = 0
    @objc dynamic var driver: DriverObj? = DriverObj()
    @objc dynamic var car: CarObj? = CarObj()
    @objc dynamic var fine: Int = 0
    @objc dynamic var date: DateObj? = DateObj()
    
    //Создаем объект аварии
    static func getAccidentObject(accident: Accident) -> AccidentObj{
        
        let accidentObj = AccidentObj()
        
        accidentObj.descriptionAc = accident.description
        accidentObj.trafficCopID = accident.trafficCop.id
        accidentObj.fine = accident.fine
        accidentObj.trafficCop = accident.trafficCop.fullName()
        accidentObj.date = DateObj.getDateObject(date: accident.date)
        
        return accidentObj
    }
    
}

// Класс таблицы - Водитель
class DriverObj: Object {
    
    @objc dynamic var luxuryStatus: Bool = true
    @objc dynamic var name: String = ""
    @objc dynamic var surname: String = ""
    @objc dynamic var id: Int = 0
    var category = List<Int>()
    var cars =  List<CarObj>()
    var accidents = List<AccidentObj>()
    
    //Создаем объект водителя
    static func getDriverObject(driver: Driver) -> DriverObj{
        
        let driverObj: DriverObj = DriverObj()
        
        driverObj.name = driver.name
        driverObj.surname = driver.surname
        driverObj.id = driver.id
        driverObj.luxuryStatus = driver.luxuryStatus
        for car in driver.cars {
            let cObj = CarObj.getCarObject(car: car)
            driverObj.cars.append(cObj)
            cObj.owner = driverObj
        }
        for category in driver.category{
            driverObj.category.append(category.rawValue)
        }
        for accident in driver.accidents{
            let aObj = AccidentObj.getAccidentObject(accident: accident)
            for car in driverObj.cars{
                if car.id == accident.carID{
                    aObj.driver = driverObj
                    aObj.car = car
                    driverObj.accidents.append(aObj)
                }
            }
        }
        
        return driverObj
    }
}



// Класс базы данных
class myRealm {
    
    static private let realm = try! Realm()
    
    static func addDriver(driver: Driver) {
        
        let dObj = DriverObj.getDriverObject(driver: driver)
        try! realm.write{
            realm.add(dObj)
            DLog("Created Driver Object: Succses")
        }
    }
    
    static func addCar(car: Car, driverID: Int) {
        for driver in realm.objects(DriverObj.self) {
            let carObj = CarObj.getCarObject(car: car)
            if driver.id == driverID {
                carObj.owner = driver
                try! realm.write{
                    driver.cars.append(carObj)
                    realm.add(carObj)
                    DLog("Created Car Object: Succses")
                }
            }
        }
    }
    
    static func addAccident(driverID: Int, carID: Int, accident: Accident) {
        
        let aObj = AccidentObj.getAccidentObject(accident: accident)
        
        for driver in realm.objects(DriverObj.self) {
            if driver.id == driverID {
                for car in driver.cars{
                    if car.id == accident.carID{
                        
                        aObj.driver = driver
                        aObj.car = car
                        try! realm.write{
                        driver.accidents.append(aObj)
                        realm.add(aObj)
                        DLog("Created Accident Object: Succses")
                        }
                    }
                }
            }
        }
    }
    
    static func removeDriver(driverID: Int){
         for driver in realm.objects(DriverObj.self) {
            if driver.id == driverID {
                try! realm.write {
                realm.delete(driver.cars)
                realm.delete(driver.accidents)
                realm.delete(driver)
                DLog("Removed Driver Object: Succses")
                }
            }
        }
    }
    
    static func removeCar(carID: Int){
        for car in realm.objects(CarObj.self) {
            if car.id == carID {
                try! realm.write {
                    realm.delete(getAccidentsWithID(carID: carID))
                    realm.delete(car)
                    DLog("Removed Car Object: Succses")
                }
            }
        }
    }
    
    static func removeAccident(driverID: Int,carID: Int, date: DateObj){
        print(date.day)
        print(date.month)
        print(date.year)
        for acc in realm.objects(AccidentObj.self) {
            if acc.car!.id == carID && acc.driver!.id == driverID && acc.date!.year == date.year && acc.date!.month == date.month && acc.date!.day == date.day{
                try! realm.write {
                    realm.delete(acc)
                    DLog("Removed Accident Object: Succses")
                }
            }
        }
    }
    
    static func addCategory(driverID: Int, category: Int){
        for driver in realm.objects(DriverObj.self){
            if driver.id == driverID {
                 try! realm.write{
                    if (!driver.category.contains(category)){
                        driver.category.append(category)}
                }
            }
        }
    }
    
    static func removeCategory(driverID: Int, category: Int){
        for driver in realm.objects(DriverObj.self){
            if driver.id == driverID {
                try! realm.write{
                    if let num = driver.category.index(of: category){
                        driver.category.remove(at: num)
                        
                    }
                }
            }
        }
    }
    
    static func changeDriverParam(name: String, surname: String, driverID: Int){
        for driver in realm.objects(DriverObj.self){
            if driver.id == driverID {
                try! realm.write{
                    driver.name = name
                    driver.surname = surname
                }
            }
        }
    }
    
    static func changeCarParamColor(color: String, carID: Int){
        for car in realm.objects(CarObj.self){
            if car.id == carID {
                try! realm.write{
                    car.color = color
                }
            }
        }
    }
    
    static func changeCarParamTechInsp(date: Date, carID: Int){
        for car in realm.objects(CarObj.self){
            if car.id == carID {
                try! realm.write{
                    car.techInsp = DateObj.getDateObject(date: date)
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
    
    static func getCarWithID(carID: Int) -> CarObj? {
        
        for car in realm.objects(CarObj.self) {
            if (car.id == carID) { return car }
        }
        return nil
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


