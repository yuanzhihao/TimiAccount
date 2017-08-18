//
//  TMTimeLineCell.swift
//  TimiAccount
//
//  Created by Zhihao Yuan on 2017/7/25.
//  Copyright © 2017年 Zhihao Yuan. All rights reserved.
//

import UIKit



class TMTimeLineIncomeCell: TMTimeLineCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        weak var weakSelf = self
        
        weakSelf?.contentView.addSubview((weakSelf?.categoryTitleLabel)!)
        weakSelf?.categoryTitleLabel.snp.makeConstraints({ (ConstraintMaker) in
            ConstraintMaker.trailing.equalTo((weakSelf?.categoryImageButton.snp.leading)!).offset(-5)
            ConstraintMaker.centerY.equalTo((weakSelf?.categoryImageButton)!)
        })
        
        weakSelf?.contentView.addSubview((weakSelf?.moneyLabel)!)
        weakSelf?.moneyLabel.snp.makeConstraints({ (ConstraintMaker) in
            ConstraintMaker.trailing.equalTo((weakSelf?.categoryTitleLabel.snp.leading)!).offset(-3)
            ConstraintMaker.top.equalTo((weakSelf?.categoryTitleLabel)!)
        })
        
        weakSelf?.contentView.addSubview((weakSelf?.remarkLabel)!)
        weakSelf?.remarkLabel.snp.makeConstraints({ (ConstraintMaker) in
            ConstraintMaker.top.equalTo((weakSelf?.categoryTitleLabel.snp.bottom)!)
            ConstraintMaker.right.equalTo((weakSelf?.categoryTitleLabel)!)
            ConstraintMaker.left.equalTo(weakSelf!)
        })
        
        weakSelf?.contentView.addSubview((weakSelf?.remarkImageButton)!)
        weakSelf?.remarkImageButton.snp.makeConstraints({ (ConstraintMaker) in
            ConstraintMaker.size.equalTo(CGSize(width: TMImageWidth, height: TMImageWidth))
            ConstraintMaker.right.equalTo((weakSelf?.categoryImageButton.snp.left)!).offset(-5)
            ConstraintMaker.centerY.equalTo((weakSelf?.categoryImageButton)!)
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
