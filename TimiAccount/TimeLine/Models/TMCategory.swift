//
//  TMCategory.swift
//  TimiAccount
//
//  Created by Zhihao Yuan on 2017/6/30.
//  Copyright © 2017年 Zhihao Yuan. All rights reserved.
//

import RealmSwift
import Foundation
import UIKit

let TCategoryID = "categoryID"

let TCategoryTitle = "categoryTitle"

let TCategoryImage = "categoryImage"

let TCategoryImageFileName = "categoryImageFileName"

let TCategoryPercent = "percent"

let TCategoryIncome = "isIncome"

class TMCategory: Object {
    
    dynamic var categoryID: String? = nil
    
    dynamic var categoryImageFileName: String? = nil
    
    dynamic var categoryTitle: String? = nil
    
    var percent = 0.0
    
    let isIncome = RealmOptional<Bool>()
    
    var categoryImage: UIImage? {
        get {
            return UIImage(named: self.categoryImageFileName!)
        }
    }
    
    override static func ignoredProperties() -> [String] {
        return [TCategoryImage, TCategoryPercent]
    }
    
    override static func primaryKey() -> String {
        return TCategoryID
    }
    
    required init(dic: [String : Any]) {
        super.init()
        self.setValuesForKeys(dic)
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        fatalError("init(realm:schema:) has not been implemented")
    }
    
    required init(value: Any, schema: RLMSchema) {
        fatalError("init(value:schema:) has not been implemented")
    }
    
    required init() {
        super.init()
    }
    
    static func loadCategoryList() -> [TMCategory] {
        let path = Bundle.main.path(forResource: "category", ofType: "plist")
        let dicArray = NSArray(contentsOfFile: path!)
        var categories = Array<TMCategory>()
        if let dicArray = dicArray {
            for item in dicArray {
                let category = TMCategory(dic: item as! [String : Any])
                categories.append(category)
            }
        }
        return categories
    }
    
    func modifyCategoryTitle(categoryTitle: String) {
        if self.categoryTitle == categoryTitle {
            return
        }
        let realm = try! Realm()
        try! realm.write({ [weak self] () -> Void in
            realm.create(TMCategory.self, value: ["categoryID" : (self?.categoryID)!, "categoryTitle" : (self?.categoryTitle)!], update: true)
        })
    }
}
