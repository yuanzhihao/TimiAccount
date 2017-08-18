//
//  TMStatistics.swift
//  TimiAccount
//
//  Created by Zhihao Yuan on 2017/7/15.
//  Copyright © 2017年 Zhihao Yuan. All rights reserved.
//

import Foundation
import RealmSwift

enum PaymentType: Int {
    case cost = 0
    case income = 1
    case all = 2
}

func query(paymentType: PaymentType) -> Double {
    let predicate = NSPredicate(format: "isIncome = %i", [paymentType])
    let results = try! Realm().objects(TMBill.self).filter(predicate)
    let money: Double = results.sum(ofProperty: "money")
    return money
}

func query(bookID: String, paymentType: PaymentType) -> Double {
    if bookID.isEmpty {
        return 0.0
    }
    let predicate = NSPredicate(format: "book.bookID = %@ AND isIncome = %i", bookID, paymentType.rawValue)
    let results = try! Realm().objects(TMBill.self).filter(predicate)
    let money: Double = results.sum(ofProperty: "money")
    return money
}

func queryBalance() -> Double {
    let incomeResults = try! Realm().objects(TMBill.self).filter("isIncome = 1")
    let costResults = try! Realm().objects(TMBill.self).filter("isIncome = 0")
    let income: Double = incomeResults.sum(ofProperty: "money")
    let cost: Double = costResults.sum(ofProperty: "money")
    return income - cost
}

func queryBalance(bookID: String) -> Double {
    if bookID.isEmpty {
        return 0.0
    }
    let incomeResults = try! Realm().objects(TMBill.self).filter("book.bookID = %@ AND isIncome = 1", bookID)
    let costResults = try! Realm().objects(TMBill.self).filter("book.bookID = %@ AND isIncome = 0", bookID)
    let income: Double = incomeResults.sum(ofProperty: "money")
    let cost: Double = costResults.sum(ofProperty: "money")
    return income - cost
}

func queryMonthly(bookID: String, date: String, paymentType: PaymentType) -> Double {
    if date.isEmpty || bookID.isEmpty {
        return 0.0
    }
    let s = date.substring(to: date.index(date.startIndex, offsetBy: 7))
    let predicate = NSPredicate(format: "books.booksID = %@ AND dateStr contains %@ AND isIncome = %li", bookID, s, paymentType as! CVarArg)
    let results = try! Realm().objects(TMBill.self).filter(predicate)
    let amount: Double = results.sum(ofProperty: "money")
    return amount
}

func queryCostDaily(bookID: String, date: String) -> Double {
    if date.isEmpty || bookID.isEmpty {
        return 0.0
    }
    let predicate = NSPredicate(format: "book.bookID = %@ AND date = %@ AND isIncome = 0", bookID, date)
    let results = try! Realm().objects(TMBill.self).filter(predicate)
    let cost: Double = results.sum(ofProperty: "money")
    return cost
}

func query(bookID: String, category: String, date: String) -> Double {
    if bookID.isEmpty || category.isEmpty || date.isEmpty {
        return 0.0
    }
    if date == "ALL" {
        let results = try! Realm().objects(TMBill.self).filter("book.bookID = %@ AND category.categoryTitle = %@", bookID, category)
        let amount: Double = results.sum(ofProperty: "money")
        return amount
    }
    let results = try! Realm().objects(TMBill.self).filter("book.bookID = %@ AND category.categoryTitle = %@ AND dateStr BEGINSWITH %@", bookID, category, date.substring(to: date.index(date.startIndex, offsetBy: 7)))
    let amount: Double = results.sum(ofProperty: "money")
    return amount
}

func calculatePercent(bookID: String, date: String, category: String, paymentType: PaymentType) -> Double {
    if category.isEmpty || date.isEmpty || bookID.isEmpty {
        return 0.0
    }
    let money: Double = TMDataManager.dataManager.gainAllBills(bookID: bookID, date: date, categoryTitle: category)!.sum(ofProperty: "money")
    let results = TMDataManager.dataManager.gainAllBills(bookID: bookID, date: date, paymentType: paymentType)
    let totalMoney: Double = results!.sum(ofProperty: "money")
    return money / totalMoney * 100
}
