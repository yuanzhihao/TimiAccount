//
//  TMDataManager.swift
//  TimiAccount
//
//  Created by Zhihao Yuan on 2017/7/19.
//  Copyright © 2017年 Zhihao Yuan. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

class TMDataManager {
    
    /// singleton
    static let dataManager = TMDataManager()
    
    lazy var categories: [TMCategory] = { () -> [TMCategory] in
        return TMCategory.loadCategoryList()
    }()
    
    lazy var addedCategories: [TMAddedCategory] = { () -> [TMAddedCategory] in
        return TMAddedCategory.loadAddedCategoryList()
    }()
    
    
    /// private init to keep singleton
    private init() {
        self.saveCategoriesFromPlistToDatabase()
        self.configureDefaultBook()
    }
    
    
    /// generate unique ID
    ///
    /// - Returns: unique ID
    func generate64bitString() -> String {
        var data = Array(repeating: Character(" "), count: 64)
        for i in 0..<data.count {
            data[i] = Character(UnicodeScalar(arc4random_uniform(26) + 65)!)
        }
        return String(data)
    }
    
    func countOfBills(bookID: String) -> Int {
        if bookID.isEmpty {
            return 0
        }
        return try! Realm().objects(TMBill.self).filter("book.bookID = %@", bookID).count
    }
    
    func addBill(bill: TMBill) {
        if bill.money.value! <= 0.0 {
            return
        }
        let realm = try! Realm()
        try! realm.write({ [weak self] () -> Void in
            bill.billID = self?.generate64bitString()
            realm.add(bill)
        })
    }
    
    func deleteBill(bill: TMBill) {
        if bill.billID == nil || bill.billID!.isEmpty {
            return
        }
        let realm = try! Realm()
        try! realm.write {
            realm.delete(bill)
        }
    }
    
    func gainAllBills(bookID: String) -> Results<TMBill>? {
        if bookID.isEmpty {
            return nil
        }
        return try! Realm().objects(TMBill.self).filter("book.bookID = %@", bookID)
    }
    
    func gainAllBills(bookID: String, paymentType: PaymentType) -> Results<TMBill>? {
        if bookID.isEmpty {
            return nil
        }
        return try! Realm().objects(TMBill.self).filter("book.bookID = %@ AND isIncome = %li", bookID, paymentType)
    }
    
    func gainAllBills(bookID: String, date: String, categoryTitle: String) -> Results<TMBill>? {
        if bookID.isEmpty || date.isEmpty || categoryTitle.isEmpty {
            return nil
        }
        var results: Results<TMBill>? = nil
        if date == "ALL" {
            let predicate = NSPredicate(format: "book.bookID = %@ AND category.categoryTitle = %@", argumentArray: [bookID, categoryTitle])
            results = try! Realm().objects(TMBill.self).filter(predicate)
        }
        else {
            let predicate = NSPredicate(format: "book.bookID = %@ AND category.categoryTitle = %@ AND date BEGINSWITH %@", argumentArray: [bookID, categoryTitle])
            results = try! Realm().objects(TMBill.self).filter(predicate)
        }
        return results
    }
    
    func gainAllBills(bookID: String, date: String, paymentType: PaymentType) -> Results<TMBill>? {
        if bookID.isEmpty || date.isEmpty {
            return nil
        }
        var predicate: NSPredicate? = nil
        if paymentType == PaymentType.all {
            if date == "ALL" {
                return self.gainAllBills(bookID: bookID)
            }
            else {
                predicate = NSPredicate(format: "book.bookID = %@ AND date BEGINSWITH %@", argumentArray: [bookID, date])
            }
        }
        else {
            if date == "ALL" {
                predicate = NSPredicate(format: "book.bookID = %@ AND isIncome = %li", argumentArray: [bookID, paymentType])
            }
            else {
                predicate = NSPredicate(format: "book.bookID = %@ AND date BEGINSWITH %@ AND isIncome = %li", argumentArray: [bookID, date.substring(to: date.index(date.startIndex, offsetBy: 7)), paymentType])
            }
        }
        return try! Realm().objects(TMBill.self).filter(predicate!)
    }
    
    
    /// get a dictionary that contains date and corresponding bills
    ///
    /// - Parameter bookID: book ID that indicates specific book
    /// - Returns: a dictionary that contains date and corresponding bills
    func gainDateBillMap(bookID: String) -> [String : Results<TMBill>]? {
        if bookID.isEmpty {
            return nil
        }
        let results = self.gainAllBills(bookID: bookID)
        var set = Set<String>()
        for bill in results! {
            set.update(with: bill.date!)
        }
        var dic = Dictionary<String, Results<TMBill>>()
        for date in set {
            let predicate = NSPredicate(format: "date == %@", argumentArray: [date])
            let temp = results!.filter(predicate)
            dic[date] = temp
        }
        return dic
    }
    
    func gainCategoryImageFileName(title: String) -> String? {
        if title.isEmpty {
            return nil
        }
        let results = try! Realm().objects(TMCategory.self).filter("categoryTitle = %@", title)
        let category = results[0]
        return category.categoryImageFileName
    }
    
    
    /// get a dictionary that contains category title and corresponding bills
    ///
    /// - Parameters:
    ///   - bookID: book ID indicates specific book
    ///   - date: date indicates specific time interval
    ///   - paymentType: payment type indicates type of bill
    /// - Returns: a dictionary that contains category title and corresponding bills
    func gainPieChartData(bookID: String, date: String, paymentType: PaymentType) -> [String : TMBill] {
        if date.isEmpty || bookID.isEmpty {
            return [:]
        }
        var titles = Set<String>()
        var results: Results<TMBill>? = nil
        if date == "ALL" {
            if paymentType == PaymentType.all {
                results = self.gainAllBills(bookID: bookID)
            } else {
                results = self.gainAllBills(bookID: bookID, paymentType: paymentType)
            }
        } else {
            results = self.gainAllBills(bookID: bookID, date: date.substring(to: date.index(date.startIndex, offsetBy: 7)), paymentType: paymentType)
        }
        for item in results! {
            titles.update(with: item.category!.categoryTitle!)
        }
        var dic = Dictionary<String, TMBill>()
        for title in titles {
            let bill = TMBill()
            bill.count = self.countOfBills(bookID: bookID, categoryTitle: title, date: date)
            
            dic.updateValue(bill, forKey: title)
        }
        return dic
    }
    
    func countOfCategories() -> Int {
        return try! Realm().objects(TMCategory.self).count
    }
    
    func deleteCategory(category: TMCategory) {
        if category.categoryTitle!.isEmpty {
            return
        }
        let realm = try! Realm()
        try! realm.write {
            realm.delete(category)
        }
    }
    
    func gainAllCategories() -> Results<TMCategory> {
        return try! Realm().objects(TMCategory.self)
    }
    
    func countOfBills(bookID: String, categoryTitle: String, date: String) -> Int {
        if bookID.isEmpty || categoryTitle.isEmpty || date.isEmpty {
            return 0
        }
        if date == "ALL" {
            let predicate = NSPredicate(format: "book.bookID = %@ AND category.categoryTitle = %@", argumentArray: [bookID, categoryTitle])
            return try! Realm().objects(TMBill.self).filter(predicate).count
        }
        let predicate = NSPredicate(format: "book.bookID = %@ AND category.categoryTitle = %@ AND date BEGINSWITH %@ ", argumentArray: [bookID, categoryTitle, date.substring(to: date.index(date.startIndex, offsetBy: 7))])
        return try! Realm().objects(TMBill.self).filter(predicate).count
    }
    
    func countOfCategories(paymentType: PaymentType) -> Int {
        return try! Realm().objects(TMCategory.self).filter("isIncome = %i", paymentType).count
    }
    
    func gainAllCategories(paymentType: PaymentType) -> Results<TMCategory> {
        return try! Realm().objects(TMCategory.self).filter("isIncome = %i", paymentType)
    }
    
    func addCategory(category: TMCategory) {
        if category.categoryTitle!.isEmpty {
            return
        }
        let realm = try! Realm()
        try! realm.write({ [weak self] () -> Void in
            category.categoryID = self?.generate64bitString()
            realm.add(category)
        })
    }
    
    
    /// check if datebase has records about category, or save categories from plist file
    func saveCategoriesFromPlistToDatabase() {
        if self.countOfCategories() != 0 {
            return
        }
        for category in self.categories {
            self.addCategory(category: category)
        }
    }
    
    func countOfAddedCategories(paymentType: PaymentType) -> Int {
        if paymentType == PaymentType.all {
            return try! Realm().objects(TMAddedCategory.self).count
        }
        return try! Realm().objects(TMAddedCategory.self).filter("isIncome = %i", paymentType).count
    }
    
    func gainAddedCategories(paymentType: PaymentType) -> Results<TMAddedCategory> {
        return try! Realm().objects(TMAddedCategory.self).filter("isIncome = %i", paymentType)
    }
    
    func addAddedCategory(addedCategory: TMAddedCategory) {
        let realm = try! Realm()
        try! realm.write({ [weak self] () -> Void in
            addedCategory.categoryID = self?.generate64bitString()
            realm.add(addedCategory)
        })
    }
    
    func deleteAddedCategory(addedCategory: TMAddedCategory) {
        let realm = try! Realm()
        try! realm.write({
            realm.delete(addedCategory)
        })
    }
    
    func countOfBooks() -> Int {
        return try! Realm().objects(TMBook.self).count
    }
    
    func addBook(book: TMBook) {
        let realm = try! Realm()
        try! realm.write({ [weak self] () -> Void in
            book.bookID = self?.generate64bitString()
            realm.add(book)
        })
    }
    
    func gainAllBooks() -> Results<TMBook> {
        return try! Realm().objects(TMBook.self)
    }
    
    func configureDefaultBook() {
        if self.countOfBooks() != 0 {
            return
        }
        let book = TMBook()
        book.bookName = "Daily Book"
        book.bookImageFileName = "book_cover_0"
        book.imageIndex.value = 0
        self.addBook(book: book)
        self.setSelectedBook()
    }
    
    func setSelectedBook() {
        let userDefaults = UserDefaults.standard
        let book = try! Realm().objects(TMBook.self).first!
        userDefaults.setValue(book.bookID!, forKey: "selectedBookID")
        userDefaults.synchronize()
    }
    
    func gainBook(bookID: String) -> TMBook? {
        if bookID.isEmpty {
            return nil
        }
        return try! Realm().objects(TMBook.self).filter("bookID = %@", bookID).first
    }
    
    func gainBookIndex(bookID: String) -> Int {
        if bookID.isEmpty {
            return -1
        }
        let books = try! Realm().objects(TMBook.self)
        for index in 0..<books.count {
            if books[index].bookID! == bookID {
                return index
            }
        }
        return -1
    }
    
    func deleteBook(bookID: String) {
        if bookID.isEmpty {
            return
        }
        let bills = self.gainAllBills(bookID: bookID)!
        let book = self.gainBook(bookID: bookID)!
        let realm = try! Realm()
        try! realm.write({ 
            realm.delete(bills)
            realm.delete(book)
        })
    }
}
