//
//  TMCalculatorView.swift
//  TimiAccount
//
//  Created by Zhihao Yuan on 28/08/2017.
//  Copyright © 2017 Zhihao Yuan. All rights reserved.
//

import UIKit

class TMCalculatorView: UIView {
    var passValueBlock: ((String) -> Void)? = nil
    
    var didClickDateButtonBlock: (() -> Void)? = nil
    
    var didClickSaveButtonBlock: (() -> Void)? = nil
    
    var didClickRemarkButtonBlock: (() -> Void)? = nil
    
    @IBOutlet weak var yearLabel: UILabel!
    
    @IBOutlet weak var monthLabelAndDayLabel: UILabel!
    
    var beforePoint: String? = nil
    
    var afterPoint: String? = nil
    
    var currentString: String? = nil
    
    var previousString: String? = nil
    
    var isPointSelected = false
    
    var isPlusOperationSelected = false
    
    var isOperationSelected = false
    
    var isFirstOperation = false
    
    private var container: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.initializeWithPreparation()
    }
    
    func initializeWithPreparation() {
        self.beforePoint = "0"
        self.afterPoint = "00"
        self.currentString = String(format: "%@.%@", self.beforePoint!, self.afterPoint!)
        self.isPointSelected = false
        self.isPlusOperationSelected = false
        self.isOperationSelected = false
        self.previousString = ""
    }
    
    @IBAction func didClickButton(_ sender: UIButton) {
        let text = sender.currentTitle!
        if text == "." {
            self.isPointSelected = true
            return
        } else if text == "AC" {
            self.initializeWithPreparation()
            if self.passValueBlock != nil {
                self.passValueBlock!(self.currentString!)
            }
            return
        } else if text == "+" || text == "-" {
            if text == "+" {
                self.isPlusOperationSelected = true
                let sum = Double(self.previousString!) == nil ? 0 : Double(self.previousString!)! + Double(self.currentString!)!
                self.currentString = String(format: "%.2f", sum)
            } else {
                if Double(self.previousString!) != nil && Double(self.previousString!) != 0 {
                    let difference = Double(self.previousString!)! - Double(self.currentString!)!
                    self.currentString = String(format: "%.2f", difference)
                }
                self.isPlusOperationSelected = false
            }
            if self.passValueBlock != nil {
                self.passValueBlock!(self.currentString!)
            }
            self.previousString = self.currentString
            self.beforePoint = "0"
            self.afterPoint = "00"
            self.isPointSelected = false
            self.isOperationSelected = true
            return
        } else if text == "OK" {
            if self.isOperationSelected {
                if self.isPlusOperationSelected {
                    let sum = Double(self.previousString!)! + Double(self.currentString!)!
                    self.currentString = String(format: "%.2f", sum)
                } else {
                    let difference = Double(self.previousString!)! - Double(self.currentString!)!
                    self.currentString = String(format: "%.2f", difference)
                }
            }
            if self.passValueBlock != nil {
                self.passValueBlock!(self.currentString!)
            }
            if self.didClickSaveButtonBlock != nil {
                self.didClickSaveButtonBlock!()
            }
            self.initializeWithPreparation()
            return
        }
        if self.isPointSelected {
            self.afterPoint = String(format: "%@0", text)
        } else {
            if self.beforePoint == "0" {
                self.beforePoint = text
            } else {
                self.beforePoint = String(format: "%@%@", self.beforePoint!, text)
            }
        }
        self.currentString = String(format: "%@.%@", self.beforePoint!, self.afterPoint!)
        if self.passValueBlock != nil {
            self.passValueBlock!(self.currentString!)
        }
    }
    
    @IBAction func clickDateButton(_ sender: UIButton) {
        if self.didClickDateButtonBlock != nil {
            self.didClickDateButtonBlock!()
        }
    }
    
    @IBAction func clickRemarkButton(_ sender: UIButton) {
        if self.didClickRemarkButtonBlock != nil {
            self.didClickRemarkButtonBlock!()
        }
    }
    
    func setTime(time: String) {
        let currentDate = String.currentDate()
        if time != currentDate {
            let year = time.substring(to: time.index(time.startIndex, offsetBy: 4))
            self.yearLabel.text = year
            self.yearLabel.textColor = selectedColor()
            let month = time.substring(with: time.index(time.startIndex, offsetBy: 5)..<time.index(time.startIndex, offsetBy: 7))
            let day = time.substring(from: time.index(time.startIndex, offsetBy: 8))
            let monthAndDay = String(format: "%@/%@", month, day)
            self.monthLabelAndDayLabel.text = monthAndDay
            self.monthLabelAndDayLabel.textColor = selectedColor()
        } else {
            let year = currentDate.substring(to: currentDate.index(currentDate.startIndex, offsetBy: 4))
            self.yearLabel.text = year
            self.yearLabel.textColor = UIColor(red: 0.69, green: 0.69, blue: 0.69, alpha: 1.00)
            self.monthLabelAndDayLabel.text = "Today"
            self.monthLabelAndDayLabel.textColor = UIColor(red: 0.69, green: 0.69, blue: 0.69, alpha: 1.00)
        }
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
