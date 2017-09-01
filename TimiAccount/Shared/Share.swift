//
//  Share.swift
//  TimiAccount
//
//  Created by Zhihao Yuan on 2017/7/14.
//  Copyright © 2017年 Zhihao Yuan. All rights reserved.
//

import Foundation
import UIKit

let TMHeaderViewHeight = 220

let TMTimeLineButtonWidth = 30.0

let TMAnimationDuration = 0.2

extension String {
    static func getSelectedBookID() -> String {
        return UserDefaults.standard.string(forKey: "selectedBookID")!
    }
    
    static func currentDate() -> String {
        let date = Date()
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "yyyy-MM-dd"
        return dateFormater.string(from: date)
    }
    
    
}

extension Array {
    static func headerBackgroundImageFilesName() -> [String] {
        return ["background1", "background2", "background3", "background4"]
    }
    
    static func bookCoverImageFilesName() -> [String] {
        return ["book_cover_0", "book_cover_1", "book_cover_2", "book_cover_3"]
    }
    
    static func sortArrayByDate(array: [TMBill], ascending: Bool) -> [TMBill] {
        if ascending {
            return array.sorted(by: { (bill1, bill2) -> Bool in
                return bill1.date! <= bill2.date!
            })
        } else {
            return array.sorted(by: { (bill1, bill2) -> Bool in
                return bill1.date! > bill2.date!
            })
        }
    }
}

extension UIButton {
    func getImageRect(contentRect: CGRect) -> CGRect {
        return CGRect(x: (contentRect.size.width - CGFloat(TMTimeLineButtonWidth)) / 2, y: (contentRect.size.height - CGFloat(TMTimeLineButtonWidth)) / 2, width: CGFloat(TMTimeLineButtonWidth), height: CGFloat(TMTimeLineButtonWidth))
    }
}

func lineColor(_ white: CGFloat = 0.800, _ alpha: CGFloat = 1.000) -> UIColor {
    return UIColor(white: white, alpha: alpha)
}

func screenSize() -> CGRect {
    return UIScreen.main.bounds
}

func getBlankWidth() -> CGFloat {
    return (screenSize().width - CGFloat(TMTimeLineButtonWidth)) / 4 + (screenSize().width - CGFloat(TMTimeLineButtonWidth)) / 12
}

func selectedColor() -> UIColor {
    return UIColor(red: 0.907, green: 0.454, blue: 0.000, alpha: 1.000)
}

func collectionCellWidth() -> CGFloat {
    return screenSize().width / 6
}
