//
//  TMActionSheetView.swift
//  TimiAccount
//
//  Created by Zhihao Yuan on 28/08/2017.
//  Copyright © 2017 Zhihao Yuan. All rights reserved.
//

import UIKit

class TMActionSheetView: UIView {
    
    var cancelButtonBlock: (() -> Void)? = nil

    var cameraButtonBlock: (() -> Void)? = nil
    
    var albumButtonBlock: (() -> Void)? = nil
    
    lazy var cameraButton = { () -> UIButton in 
        let button = UIButton()
        button.setTitle("Take a photo", for: UIControlState.normal)
        button.setTitleColor(UIColor.black, for: UIControlState.normal)
        button.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.00)
        button.addTarget(self, action: #selector(clickCameraButton(sender:)), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    lazy var albumButton = { () -> UIButton in 
        let button = UIButton()
        button.setTitle("Album", for: UIControlState.normal)
        button.setTitleColor(UIColor.black, for: UIControlState.normal)
        button.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.00)
        button.addTarget(self, action: #selector(clickAlbumButton(sender:)), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    lazy var cancelButton = { () -> UIButton in 
        let button = UIButton()
        button.setTitle("Cancel", for: UIControlState.normal)
        button.setTitleColor(UIColor.black, for: UIControlState.normal)
        button.backgroundColor = UIColor(red: 0.75, green: 0.76, blue: 0.78, alpha: 1.00)
        button.addTarget(self, action: #selector(clickCancelButton(sender:)), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    func clickCameraButton(sender: UIButton) {
        if self.cameraButtonBlock != nil {
            self.cameraButtonBlock!()
        }
    }
    
    func clickAlbumButton(sender: UIButton) {
        if self.albumButtonBlock != nil {
            self.albumButtonBlock!()
        }
    }
    
    func clickCancelButton(sender: UIButton) {
        if self.cancelButtonBlock != nil {
            self.cancelButtonBlock!()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.cameraButton)
        self.cameraButton.snp.makeConstraints { [weak self] (ConstraintMaker) in
            ConstraintMaker.size.equalTo(CGSize(width: screenSize().width - 50, height: 40))
            ConstraintMaker.centerX.equalTo(self!)
            ConstraintMaker.top.equalTo(self!).offset(10)
        }
        
        self.addSubview(self.albumButton)
        self.albumButton.snp.makeConstraints { [weak self] (ConstraintMaker) in
            ConstraintMaker.size.equalTo(self!.cameraButton)
            ConstraintMaker.centerX.equalTo(self!)
            ConstraintMaker.top.equalTo(self!.cameraButton.snp.bottom).offset(10)
        }
        
        self.addSubview(self.cancelButton)
        self.cancelButton.snp.makeConstraints { [weak self] (ConstraintMaker) in
            ConstraintMaker.size.equalTo(CGSize(width: screenSize().width - 50, height: 35))
            ConstraintMaker.centerX.equalTo(self!)
            ConstraintMaker.top.equalTo(self!.albumButton.snp.bottom).offset(20)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
