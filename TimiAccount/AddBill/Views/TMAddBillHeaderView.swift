//
//  TMAddBillHeaderView.swift
//  TimiAccount
//
//  Created by Zhihao Yuan on 28/08/2017.
//  Copyright © 2017 Zhihao Yuan. All rights reserved.
//

import UIKit

class TMAddBillHeaderView: UIView {
    var clickCategoryTitleLabel: (() -> Void)? = nil
    
    lazy var categoryImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = UIViewContentMode.scaleAspectFill
        iv.image = UIImage(named: "type_big_2")
        return iv
    }()
    
    lazy var categoryTitleButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(clickCategoryTitleButton(sender:)), for: UIControlEvents.touchUpInside)
        button.tintColor = UIColor.white
        button.titleLabel!.font = UIFont.systemFont(ofSize: 17)
        button.setTitle("Restaurant", for: UIControlState.normal)
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        return button
    }()
    
    lazy var moneyLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 20.0)
        label.tintColor = UIColor.white
        label.textAlignment = NSTextAlignment.right
        label.text = "$ 0.00"
        return label
    }()
    
    var backgroundColorLayer: CAShapeLayer? = nil
    
    var previousSelectedColor: UIColor? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(self.categoryImageView)
        self.categoryImageView.snp.makeConstraints { [weak self] (ConstraintMaker) in
            ConstraintMaker.size.equalTo(CGSize(width: 48.5, height: 48.5))
            ConstraintMaker.centerY.equalTo(self!)
            ConstraintMaker.left.equalTo(self!).offset(10)
        }
        
        self.addSubview(self.categoryTitleButton)
        self.categoryTitleButton.snp.makeConstraints { [weak self] (ConstraintMaker) in
            ConstraintMaker.left.equalTo(self!.categoryImageView.snp.right).offset(5)
            ConstraintMaker.centerY.equalTo(self!)
        }
        
        self.addSubview(self.moneyLabel)
        self.moneyLabel.snp.makeConstraints { [weak self] (ConstraintMaker) in
            ConstraintMaker.centerY.equalTo(self!)
            ConstraintMaker.right.equalTo(-10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        path.move(to: self.bounds.origin)
        path.addLine(to: CGPoint(x: self.bounds.origin.x, y: self.bounds.size.height))
        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = UIColor.clear.cgColor
        self.layer.addSublayer(layer)
        self.backgroundColorLayer = layer
    }
    
    func clickCategoryTitleButton(sender: UIButton) {
        if self.clickCategoryTitleLabel != nil {
            self.clickCategoryTitleLabel!()
        }
    }
    
    func setCategoryImageAndTitle(imageFileName: String, title: String) {
        self.categoryImageView.image = UIImage(named: imageFileName)
        self.categoryTitleButton.setTitle(title, for: UIControlState.normal)
    }
    
    func updateMoney(money: String) {
        if self.moneyLabel.text!.characters.count > 13 {
            if money == "0.00" {
                self.moneyLabel.text = String(format: "$ %@", money)
            }
            return
        }
        self.moneyLabel.text = String(format: "$ %@", money)
    }
    
    func animateOnBackgroundColorLayer(color: UIColor) {
        if color == self.previousSelectedColor {
            return
        }
        self.backgroundColor = self.previousSelectedColor
        
        let animation = CABasicAnimation(keyPath: "lineWidth")
        animation.fromValue = 0.0
        animation.toValue = self.bounds.size.width * 2
        animation.duration = 0.3
        self.backgroundColorLayer?.fillColor = color.cgColor
        self.backgroundColorLayer?.strokeColor = color.cgColor
        
        self.previousSelectedColor = color
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        self.backgroundColorLayer?.add(animation, forKey: "backgroundColorAnimation")
        
        self.bringSubview(toFront: self.categoryImageView)
        self.bringSubview(toFront: self.moneyLabel)
        self.bringSubview(toFront: self.categoryTitleButton)
    }
    
    func animateShake() {
        UIView.animate(withDuration: 5.0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.moneyLabel.snp.updateConstraints({ (ConstraintMaker) in
                ConstraintMaker.right.equalTo(-20)
            })
        }) { (Bool) in
            UIView.animate(withDuration: 5.0, animations: {
                self.moneyLabel.snp.updateConstraints({ (ConstraintMaker) in
                    ConstraintMaker.right.equalTo(-10)
                })
            })
        }
        UIView.animate(withDuration: 5.0, delay: 10.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.moneyLabel.snp.updateConstraints({ (ConstraintMaker) in
                ConstraintMaker.right.equalTo(-20)
            })
        }) { (Bool) in
            UIView.animate(withDuration: 5.0, animations: {
                self.moneyLabel.snp.updateConstraints({ (ConstraintMaker) in
                    ConstraintMaker.right.equalTo(-10)
                })
            })
        }
    }
    
    deinit {
        self.backgroundColorLayer?.removeAllAnimations()
        self.moneyLabel.layer.removeAllAnimations()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
