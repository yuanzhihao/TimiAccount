//
//  TMBook.swift
//  TimiAccount
//
//  Created by Zhihao Yuan on 2017/6/30.
//  Copyright © 2017年 Zhihao Yuan. All rights reserved.
//

import RealmSwift
import Foundation
import UIKit

let TBookID = "bookID"

let TBookName = "bookName"

let TBookImageFileName = "bookImageFileName"

let TBookImage = "bookImage"

let TBookImageIndex = "imageIndex"

class TMBook: Object {
    
    dynamic var bookID: String? = nil
    
    dynamic var bookName: String? = nil
    
    let imageIndex = RealmOptional<Int>()
    
    dynamic var bookImageFileName: String? = nil
    
    var bookImage: UIImage? {
        set(image) {
            self.bookImage = image
        }
        get {
            return UIImage(named: self.bookImageFileName!)
        }
    }
    
    override static func ignoredProperties() -> [String] {
        return [TBookImage]
    }
    
    override static func primaryKey() -> String {
        return TBookID
    }
    
    func updateImageIndex(index: Int) {
        if self.imageIndex.value == index {
            return
        }
        let realm = try! Realm()
        try! realm.write({ [weak self] () -> Void in
            realm.create(TMBook.self, value: ["bookID" : (self?.bookID)!, "imageIndex" : RealmOptional<Int>(index)], update: true)
        })
    }
    
    func updateBookName(bookName: String) {
        if self.bookName == bookName {
            return
        }
        let realm = try! Realm()
        try! realm.write({ [weak self] () -> Void in
            realm.create(TMBook.self, value: ["bookID" : (self?.bookID)!, "bookName" : bookName], update: true)
        })
    }
    
    func updateBookImageFileName(bookImageFileName: String) {
        if self.bookImageFileName == bookImageFileName {
            return
        }
        let realm = try! Realm()
        try! realm.write({ [weak self] () -> Void in
            realm.create(TMBook.self, value: ["bookID" : (self?.bookID)!, "bookImageFileName" : bookImageFileName], update: true)
        })
    }
}
