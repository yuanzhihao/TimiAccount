//
//  TMBill.swift
//  TimiAccount
//
//  Created by Zhihao Yuan on 2017/6/30.
//  Copyright © 2017年 Zhihao Yuan. All rights reserved.
//

import RealmSwift
import Foundation

let TBillPrimaryKey = "billID"

let TBillDate = "date"

let TBillRemark = "remark"

let TBillIncome = "isIncome"

let TBillMoney = "money"

let TBillRemarkIcon = "remarkIcon"

let TBillCount = "count"

let TBillSame = "same"

let TBillSimilar = "similar"

let TBillEmpty = "empty"

class TMBill: Object {
    
    @objc dynamic var billID: String? = nil
    
    @objc dynamic var date: String? = nil
    
    @objc dynamic var remark: String? = nil
    
    @objc dynamic var remarkIcon: Data? = nil
    
    let isIncome = RealmOptional<Int>()
    
    let money = RealmOptional<Double>()
    
    @objc dynamic var category: TMCategory? = nil
    
    @objc dynamic var book: TMBook? = nil
    
    var same = false
    
    var similar = false
    
    var empty = false
    
    var count = 0
    
    override var description: String {
        get {
            return self.billID! + self.date! + self.remark! + self.isIncome.value!.description + self.money.value!.description + self.category!.description + self.category!.percent.description + self.book!.description
        }
    }
    
    override static func primaryKey() -> String {
        return TBillPrimaryKey
    }
    
    override static func ignoredProperties() -> [String] {
        return [TBillCount, TBillSame, TBillSimilar, TBillEmpty]
    }
    
    override static func indexedProperties() -> [String] {
        return [TBillDate]
    }
    
    required init() {
        super.init()
        self.category = TMCategory()
        self.book = TMBook()
    }
    
    required init(value: Any, schema: RLMSchema) {
        fatalError("init(value:schema:) has not been implemented")
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    func updateDate(date: String) {
        if self.date == date {
            return
        }
        let realm = try! Realm()
        try! realm.write({ [weak self] () -> Void in
            realm.create(TMBill.self, value: ["billID" : (self?.billID)!, "date" : date], update: true)
        })
    }
    
    func updateRemark(remark: String) {
        if self.remark == remark {
            return
        }
        let realm = try! Realm()
        try! realm.write({ [weak self] () -> Void in
            realm.create(TMBill.self, value: ["billID" : (self?.billID)!, "remark" : remark], update: true)
        })
    }
    
    func updateRemarkIcon(remarkIcon: Data) {
        if self.remarkIcon == remarkIcon {
            return
        }
        let realm = try! Realm()
        try! realm.write({ [weak self] () -> Void in
            realm.create(TMBill.self, value: ["billID" : (self?.billID)!, "remarkIcon" : remarkIcon], update: true)
        })
    }
    
    func updateIncome(isIncome: Int) {
        if self.isIncome.value! == isIncome {
            return
        }
        let realm = try! Realm()
        try! realm.write({ [weak self] () -> Void in
            realm.create(TMBill.self, value: ["billID" : (self?.billID)!, "isIncome" : isIncome], update: true)
        })
    }
    
    func updateMoney(money: Double) {
        if self.money.value! == money {
            return
        }
        let realm = try! Realm()
        try! realm.write({ [weak self] () -> Void in
            realm.create(TMBill.self, value: ["billID" : (self?.billID)!, "money" : money], update: true)
        })
    }
    
    func updateCategory(category: TMCategory) {
        if self.category!.categoryID! == category.categoryID! {
            return
        }
        let realm = try! Realm()
        try! realm.write({ [weak self] () -> Void in
            realm.create(TMBill.self, value: ["billID" : (self?.billID)!, "category" : category], update: true)
        })
    }
}
