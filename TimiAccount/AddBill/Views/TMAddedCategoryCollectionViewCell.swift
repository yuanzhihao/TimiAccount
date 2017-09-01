//
//  TMAddedCategoryCollectionViewCell.swift
//  TimiAccount
//
//  Created by Zhihao Yuan on 28/08/2017.
//  Copyright © 2017 Zhihao Yuan. All rights reserved.
//

import UIKit

class TMAddedCategoryCollectionViewCell: UICollectionViewCell {
    var iamgeView: UIImageView? = nil
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.iamgeView = UIImageView()
        self.contentView.addSubview(self.iamgeView!)
        self.iamgeView!.snp.makeConstraints { [weak self] (ConstraintMaker) in
            ConstraintMaker.edges.equalTo(self!.contentView)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
