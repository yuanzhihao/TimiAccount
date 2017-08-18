//
//  TMTimeLineMenuView.swift
//  TimiAccount
//
//  Created by Zhihao Yuan on 2017/8/1.
//  Copyright © 2017年 Zhihao Yuan. All rights reserved.
//

import UIKit

@objc protocol TMTimeLineMenuViewDelegate {
    func setCellLabelVisibility(hidden: Bool)
    func clickDeleteButton()
    func clickUpdateButton()
}

func defaultButtonFrame(y: Double) -> CGRect {
    return CGRect(x: (Double(screenSize().width) - TMTimeLineButtonWidth) / 2, y: y, width: TMTimeLineButtonWidth, height: TMTimeLineButtonWidth)
}

class TMTimeLineMenuView: UIView {

    weak var timeLineMenuDelegate:TMTimeLineMenuViewDelegate? = nil
    
    var currenImage: UIImage? = nil
    
    var categoryButton: UIButton? = { () -> UIButton in
        var cb = UIButton(frame: defaultButtonFrame(y: -30))
        cb.addTarget(self, action: #selector(clickCategoryButton(sender:)), for: UIControlEvents.touchUpInside)
        return cb
    }()
    
    lazy var deleteButton: UIButton? = { () -> UIButton in
        var db = UIButton(frame: defaultButtonFrame(y: -30))
        db.addTarget(self, action: #selector(clickDeleteButton(sender:)), for: UIControlEvents.touchUpInside)
        db.setImage(UIImage(named: "item_delete"), for: UIControlState.normal)
        return db
    }()
    
    var updateButton: UIButton? = { () -> UIButton in
        var ub = UIButton(frame: defaultButtonFrame(y: -30))
        ub.addTarget(self, action: #selector(clickUpdateButton(sender:)), for: UIControlEvents.touchUpInside)
        ub.setImage(UIImage(named: "item_edit"), for: UIControlState.normal)
        return ub
    }()
    
    var receivedRect: CGRect? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.deleteButton!)
        self.addSubview(self.updateButton!)
        self.addSubview(self.categoryButton!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func clickDeleteButton(sender: UIButton) {
        if self.timeLineMenuDelegate != nil {
            self.timeLineMenuDelegate?.clickDeleteButton()
        }
    }
    
    func clickUpdateButton(sender: UIButton) {
        if self.timeLineMenuDelegate != nil {
            self.timeLineMenuDelegate?.clickUpdateButton()
        }
    }
    
    func clickCategoryButton(sender: UIButton) {
        self.dismiss()
    }
    
    func dismiss() {
        UIView.animate(withDuration: TMAnimationDuration, animations: {
            let rect = self.receivedRect!
            self.deleteButton!.frame = CGRect(x: (Double(screenSize().width) - TMTimeLineButtonWidth) / 2, y: Double(rect.origin.y), width: TMTimeLineButtonWidth, height: TMTimeLineButtonWidth)
            self.updateButton!.frame = CGRect(x: (Double(screenSize().width) - TMTimeLineButtonWidth) / 2, y: Double(rect.origin.y), width: TMTimeLineButtonWidth, height: TMTimeLineButtonWidth)
        }) { (Bool) in
            self.superview!.sendSubview(toBack: self)
            self.categoryButton?.setImage(nil, for: UIControlState.normal)
            self.receivedRect = CGRect.zero
            if self.timeLineMenuDelegate != nil {
                self.timeLineMenuDelegate?.setCellLabelVisibility(hidden: false)
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.dismiss()
    }
    
    func showTimeLineMenuView(rect: CGRect) {
        self.receivedRect = rect
        self.categoryButton!.setImage(self.currenImage, for: UIControlState.normal)
        if self.timeLineMenuDelegate != nil {
            self.timeLineMenuDelegate!.setCellLabelVisibility(hidden: true)
        }
        
        weak var weakSelf = self
        receivedRect!.origin.y += CGFloat(64 - TMTimeLineButtonWidth - 5)
        let rect = defaultButtonFrame(y: Double(receivedRect!.origin.y))
        weakSelf!.deleteButton!.frame = rect
        weakSelf!.updateButton!.frame = rect
        weakSelf!.categoryButton!.frame = rect
        UIView.animate(withDuration: TMAnimationDuration, animations: {
            weakSelf!.deleteButton!.frame = CGRect(x: (screenSize().width - CGFloat(TMTimeLineButtonWidth)) / 2 - getBlankWidth(), y: rect.origin.y, width: CGFloat(TMTimeLineButtonWidth), height: CGFloat(TMTimeLineButtonWidth))
            weakSelf!.updateButton!.frame = CGRect(x: (screenSize().width - CGFloat(TMTimeLineButtonWidth)) / 2 + getBlankWidth(), y: rect.origin.y, width: CGFloat(TMTimeLineButtonWidth), height: CGFloat(TMTimeLineButtonWidth))
            weakSelf!.superview!.bringSubview(toFront: weakSelf!)
        }) { (Bool) in

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
