//
//  TMHeaderView.swift
//  TimiAccount
//
//  Created by Zhihao Yuan on 2017/7/2.
//  Copyright © 2017年 Zhihao Yuan. All rights reserved.
//

import UIKit
import SnapKit

let kBtnWidth = 40
let kCircleWidth = 100

@objc protocol TMHeaderViewDelegate {
    @objc optional func didClickCreateButton()
}

class TMHeaderView: UIView {
    
    var headerViewDelegate: TMHeaderViewDelegate? = nil
    
    lazy var backgroundImageView = { () -> UIImageView in
        let imageView = UIImageView(image: (UIImage(named: "background")))
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    lazy var pieView = { () -> TMPieView in
        let pieView = TMPieView()
        pieView.backgroundColor = UIColor.clear
        pieView.layer.cornerRadius = CGFloat(kCircleWidth / 2)
        pieView.lineWidth = 2
        return pieView
    }()
    
    var incomeLabel = { () -> UILabel in
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = lineColor()
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.text = "Income"
        return label
    }()
    
    var incomeMoneyLabel = { () -> UILabel in
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = lineColor()
        label.font = UIFont.systemFont(ofSize: 18.0)
        return label
    }()
    
    var costLabel = { () -> UILabel in
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = lineColor()
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.text = "Cost"
        return label
    }()
    
    var costMoneyLabel = { () -> UILabel in
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = lineColor()
        label.font = UIFont.systemFont(ofSize: 18.0)
        label.textAlignment = NSTextAlignment.right
        return label
    }()
    
    var timeLineView = { () -> UIView in
        let view = UIView()
        view.backgroundColor = lineColor()
        return view
    }()
    
    lazy var createButton = { () -> UIButton in
        let button = UIButton()
        button.addTarget(self, action: #selector(clickCreateButton(sender:)), for: UIControlEvents.touchUpInside)
        button.setImage(UIImage(named: "circle_btn"), for: UIControlState.normal)
        button.backgroundColor = UIColor.white
        button.layer.cornerRadius = CGFloat((kCircleWidth - 60) / 2)
        button.layer.masksToBounds = true
        return button
    }()
    
    func clickCreateButton(sender: UIButton) {
        if self.headerViewDelegate != nil {
            self.headerViewDelegate!.didClickCreateButton?()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.backgroundImageView)
        self.backgroundImageView.snp.makeConstraints { [weak self] (ConstraintMaker) in
            ConstraintMaker.height.equalTo(155)
            ConstraintMaker.width.equalTo(screenSize().width)
            ConstraintMaker.left.top.right.equalTo(self!)
        }
        
        self.backgroundImageView.addSubview(self.pieView)
        self.pieView.snp.makeConstraints { [weak self] (ConstraintMaker) in
            ConstraintMaker.size.equalTo(CGSize(width: kCircleWidth, height: kCircleWidth))
            ConstraintMaker.centerX.equalTo((self?.backgroundImageView)!)
            ConstraintMaker.centerY.equalTo((self?.backgroundImageView.snp.bottom)!)
        }
        
        self.backgroundImageView.addSubview(self.createButton)
        self.createButton.snp.makeConstraints { [weak self] (ConstraintMaker) in
            ConstraintMaker.edges.equalTo((self?.pieView)!).inset(UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30))
        }
        
        self.addSubview(self.incomeLabel)
        self.incomeLabel.snp.makeConstraints { [weak self] (ConstraintMaker) in
            ConstraintMaker.top.equalTo((self?.backgroundImageView.snp.bottom)!).offset(10)
            ConstraintMaker.left.equalTo(self!).offset(20)
        }
        
        self.addSubview(self.incomeMoneyLabel)
        self.incomeMoneyLabel.snp.makeConstraints { [weak self] (ConstraintMaker) in
            ConstraintMaker.top.equalTo((self?.incomeLabel)!).offset(20)
            ConstraintMaker.left.equalTo((self?.incomeLabel)!)
        }
        
        self.addSubview(self.costLabel)
        self.costLabel.snp.makeConstraints { [weak self] (ConstraintMaker) in
            ConstraintMaker.top.equalTo((self?.incomeLabel)!)
            ConstraintMaker.right.equalTo(self!).offset(-20)
        }
        
        self.addSubview(self.costMoneyLabel)
        self.costMoneyLabel.snp.makeConstraints { [weak self] (ConstraintMaker) in
            ConstraintMaker.top.equalTo((self?.costLabel)!).offset(20)
            ConstraintMaker.right.equalTo((self?.costLabel)!)
        }
        
        self.addSubview(self.timeLineView)
        self.timeLineView.snp.makeConstraints { [weak self] (ConstraintMaker) in
            ConstraintMaker.size.equalTo(CGSize(width: 1, height: 20))
            ConstraintMaker.centerX.equalTo(self!)
            ConstraintMaker.top.equalTo((self?.pieView.snp.bottom)!)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func calculateMoney() {
        self.incomeMoneyLabel.text = String(format: "%.2f", query(bookID: String.getSelectedBookID(), paymentType: PaymentType.income))
        self.costMoneyLabel.text = String(format: "%.2f", query(bookID: String.getSelectedBookID(), paymentType: PaymentType.cost))
        let array = Array<Any>.headerBackgroundImageFilesName()
        let headerBackgroundImageFileName = array[Int(arc4random()) % array.count]
        self.backgroundImageView.image = UIImage(named: headerBackgroundImageFileName)
    }
    
    func loadPieView(sections: [Double], colors: [UIColor]) {
        self.pieView.sections = sections
        self.pieView.sectionColors = colors
        self.pieView.setNeedsDisplay()
    }
    
    func animation(time: TimeInterval, angle: CGFloat) {
        UIView.animate(withDuration: time, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
            self.createButton.transform = self.createButton.transform.rotated(by: angle / 500)
        }, completion: { (Bool) -> Void in
            UIView.animate(withDuration: time / 2, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
                self.createButton.transform = CGAffineTransform.identity
            }, completion: { (Bool) -> Void in
                
            })
        })
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
