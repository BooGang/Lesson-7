//
//  main.swift
//  Lesson 7
//
//  Created by Air on 28.03.2021.
//

import Foundation

struct Product {
    let name: String
}

struct Item {
    var price: Int
    var count: Int
    var product: Product
}

class DataBase {
    var inventory = [
    "BMW X6": Item(price: 6000000, count: 3, product: Product(name: "BMW X6")),
    "BMW X5": Item(price: 5500000, count: 7, product: Product(name: "BMW X5")),
    "BMW X3": Item(price: 3500000, count: 10, product: Product(name: "BMW X3")),
    "BMW M5": Item(price: 400000, count: 0, product: Product(name: "BMW M5"))
    ]
    var rubDeposite = 0
    
    func data(itemName name: String) -> Product? {
        
        guard let item = inventory[name] else { return nil }
        guard rubDeposite >= item.price else { return nil }
        guard item.count > 0 else { return nil }
        
        rubDeposite -= item.price
        
        var newItem = item
        newItem.count -= 1
        inventory[name] = newItem
        
       return item.product
    }
}

let database = DataBase()
database.rubDeposite = 5000000
//database.data(itemName: "BMW X6")
//database.data(itemName: "BMW X5")
//database.data(itemName: "BMW X3")
//database.data(itemName: "BMW X7")


enum DataBaseError: Error {
    case emptySelection
    case outOfStocks
    case insufficientFunds(rubNeeded: Int)
    
    var localizedDecription: String {
        switch self {
        case .emptySelection:
            return "Нет в ассортименте"
        case .outOfStocks:
            return "Нет в наличии"
        case .insufficientFunds(rubNeeded: let rubNeeded):
            return "Не хватает \(rubNeeded) рублей "
        }
        
    }
}

extension DataBase {
    func dataBaseError(itemNamed name: String) -> (product: Product?, error: DataBaseError?){
        guard let item = inventory[name] else {
            return (product: nil, error:.emptySelection)
        }
        guard rubDeposite >= item.price else {
            return (product: nil, error:.insufficientFunds(rubNeeded: item.price - rubDeposite))
        }
        guard item.count > 0 else {
            return (product: nil, error:.outOfStocks)
        }
        
        rubDeposite -= item.price
        
        var newItem = item
        newItem.count -= 1
        inventory[name] = newItem
        
        return (product: item.product, error: nil)
    }
}

let sale1 = database.dataBaseError(itemNamed: "BMW X6")
if let product = sale1.product {
    print("Вы купили \(product.name)")
} else if let error = sale1.error {
    print("Произошла ошибка: \(error.localizedDecription)")
}

let sale2 = database.dataBaseError(itemNamed: "BMW X5")
if let product = sale2.product {
    print("Вы купили \(product.name)")
} else if let error = sale2.error {
    print("Произошла ошибка: \(error.localizedDecription)")
}

let sale3 = database.dataBaseError(itemNamed: "BMW X3")
if let product = sale3.product {
    print("Вы купили \(product.name)")
} else if let error = sale3.error {
    print("Произошла ошибка: \(error.localizedDecription)")
}

let sale4 = database.dataBaseError(itemNamed: "BMW X7")
let sale5 = database.dataBaseError(itemNamed: "BMW M5")



extension DataBase {
    func dataBaseThrowError(itemNamed name: String) throws -> Product {
        guard let item = inventory[name] else {
            throw DataBaseError.emptySelection
        }
        guard rubDeposite >= item.price else {
            throw DataBaseError.insufficientFunds(rubNeeded: item.price - rubDeposite)
        }
        guard item.count > 0 else {
            throw DataBaseError.outOfStocks
        }
        rubDeposite -= item.price
        
        var newItem = item
        newItem.count -= 1
        inventory[name] = newItem
        
        return item.product
    }
}

do {
    let product = try database.dataBaseThrowError(itemNamed: "BMW M5")
    print("Вы купили \(product.name)")
} catch DataBaseError.emptySelection {
    print("Такого товара нет в магазине!")
} catch DataBaseError.insufficientFunds(rubNeeded: let rubNeeded) {
    print("Не хаватает \(rubNeeded) рублей")
} catch DataBaseError.outOfStocks {
    print("Товара нет в наличии. Ждём поступления.")
} catch {
    print(error.localizedDescription)
}

do {

    let product1 = try database.dataBaseThrowError(itemNamed: "BMW X7")
    print("Вы купили \(product1.name)")
} catch DataBaseError.emptySelection {
    print("Такого товара нет в магазине!")
} catch DataBaseError.insufficientFunds(rubNeeded: let rubNeeded) {
    print("Не хаватает \(rubNeeded) рублей")
} catch DataBaseError.outOfStocks {
    print("Товара нет в наличии. Ждём поступления.")
} catch {
    print(error.localizedDescription)
}
//изменения



