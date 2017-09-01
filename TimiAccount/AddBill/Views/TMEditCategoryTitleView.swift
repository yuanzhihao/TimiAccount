//
//  TMEditCategoryTitleView.swift
//  TimiAccount
//
//  Created by Zhihao Yuan on 28/08/2017.
//  Copyright © 2017 Zhihao Yuan. All rights reserved.
//

import UIKit

let TMContainerViewWidth: CGFloat = 50

class TMEditCategoryTitleView: UIView {
    var categoryTitle: String {
        get {
            return self.textField.text!
        }
    }
    
    var category: TMCategory? {
        didSet {
            self.categoryImageView.image = self.category!.categoryImage
            self.textField.placeholder = self.category!.categoryTitle
            self.categoryLabel.text = self.category!.categoryTitle
        }
    }
    
    var clickOKButton: (() -> Void)? = nil
    
    lazy var categoryContainerView = { () -> UIView in 
        let cv = UIView()
        cv.backgroundColor = UIColor.white
        cv.layer.cornerRadius = TMContainerViewWidth / 2
        return cv
    }()
    
    lazy var categoryImageView = { () -> UIImageView in 
        let iv = UIImageView()
        iv.contentMode = UIViewContentMode.scaleAspectFill
        return iv
    }()
    
    lazy var categoryLabel = { () -> UILabel in 
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 12.0)
        label.textColor = lineColor()
        return label
    }()
    
    lazy var textField = { () -> UITextField in 
        let tf = UITextField()
        tf.textAlignment = NSTextAlignment.center
        tf.textColor = lineColor()
        return tf
    }()
    
    lazy var lineView = { () -> UIView in 
        let view = UIView()
        view.backgroundColor = lineColor()
        return view
    }()
    
    lazy var cancelButton = { () -> UIButton in 
        let button = UIButton()
        button.setTitle("Cancel", for: UIControlState.normal)
        button.setTitleColor(UIColor.black, for: UIControlState.normal)
        button.addTarget(self, action: #selector(clickCancelButton(sender:)), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    lazy var okButton = { () -> UIButton in 
        let button = UIButton()
        button.setTitle("OK", for: UIControlState.normal)
        button.setTitleColor(UIColor.black, for: UIControlState.normal)
        button.addTarget(self, action: #selector(clickOKButton(sender:)), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 10
        self.addSubview(self.categoryContainerView)
        self.categoryContainerView.addSubview(self.categoryImageView)
        self.addSubview(self.categoryLabel)
        self.addSubview(self.textField)
        self.addSubview(self.lineView)
        self.addSubview(self.cancelButton)
        self.addSubview(self.okButton)
        
        self.categoryContainerView.snp.makeConstraints { [weak self] (ConstraintMaker) in
            ConstraintMaker.centerY.equalTo(self!.snp.top)
            ConstraintMaker.centerX.equalTo(self!)
            ConstraintMaker.size.equalTo(CGSize(width: TMContainerViewWidth, height: TMContainerViewWidth))
        }
        
        self.categoryImageView.image = UIImage(named: "type_big_2")
        self.categoryImageView.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.edges.equalTo(UIEdgeInsetsMake(2, 2, 2, 2))
        }
        
        self.categoryLabel.text = "Clothes"
        self.categoryLabel.snp.makeConstraints { [weak self] (ConstraintMaker) in
            ConstraintMaker.centerX.equalTo(self!)
            ConstraintMaker.top.equalTo(self!).offset(30.5)
        }
        
        self.textField.placeholder = "Clothes"
        self.textField.snp.makeConstraints { [weak self] (ConstraintMaker) in
            ConstraintMaker.size.equalTo(CGSize(width: 100, height: 20))
            ConstraintMaker.center.equalTo(self!)
        }
        
        self.lineView.snp.makeConstraints { [weak self] (ConstraintMaker) in
            ConstraintMaker.size.equalTo(CGSize(width: 100, height: 1))
            ConstraintMaker.top.equalTo(self!.textField.snp.bottom).offset(1)
            ConstraintMaker.centerX.equalTo(self!.textField)
        }
        
        self.cancelButton.snp.makeConstraints { [weak self] (ConstraintMaker) in
            ConstraintMaker.left.equalTo(self!).offset(20)
            ConstraintMaker.bottom.equalTo(self!).offset(-5)
        }
        
        self.okButton.snp.makeConstraints { [weak self] (ConstraintMaker) in
            ConstraintMaker.right.equalTo(self!).offset(-20)
            ConstraintMaker.bottom.equalTo(self!.cancelButton)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func clickCancelButton(sender: UIButton) {
        self.textField.resignFirstResponder()
        self.superview!.superview!.sendSubview(toBack: self.superview!)
        self.superview?.backgroundColor = UIColor.clear
    }
    
    func clickOKButton(sender: UIButton) {
        if self.clickOKButton != nil {
            self.clickOKButton!()
        }
        self.clickCancelButton(sender: sender)
    }
    
    func textFieldBecomeFirstResponder() {
        self.textField.becomeFirstResponder()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
