//
//  TMAddedCategory.swift
//  TimiAccount
//
//  Created by Zhihao Yuan on 2017/7/19.
//  Copyright © 2017年 Zhihao Yuan. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

class TMAddedCategory: Object {
    dynamic var categoryID: String? = nil
    
    dynamic var categoryImageFileName: String? = nil
    
    let isIncome = RealmOptional<Bool>()
    
    var image: UIImage? {
        get {
            return UIImage(named: self.categoryImageFileName!)
        }
    }
    
    override static func ignoredProperties() -> [String] {
        return ["image"]
    }
    
    override static func primaryKey() -> String {
        return "categoryID"
    }
    
    convenience init(dic: [String : Any]) {
        self.init()
        self.setValuesForKeys(dic)
    }
    
    static func addedCategory(dic: [String : Any]) -> TMAddedCategory {
        return TMAddedCategory(dic: dic)
    }
    
    static func loadAddedCategoryList() -> [TMAddedCategory] {
        let path = Bundle.main.path(forResource: "addedCategory", ofType: "plist")
        let dicArray = NSArray(contentsOfFile: path!)
        var categories = Array<TMAddedCategory>()
        if let dicArray = dicArray {
            for item in dicArray {
                let category = TMAddedCategory(dic: item as! [String : Any])
                categories.append(category)
            }
        }
        return categories
    }
}
