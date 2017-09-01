//
//  TMCategoryCollectionViewCell.swift
//  TimiAccount
//
//  Created by Zhihao Yuan on 28/08/2017.
//  Copyright © 2017 Zhihao Yuan. All rights reserved.
//

import UIKit

class TMCategoryCollectionViewCell: UICollectionViewCell {
    lazy var categoryImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = UIViewContentMode.scaleAspectFill
        return iv
    }()
    
    var category: TMCategory? {
        set(c) {
            self.categoryImageView.image = c?.categoryImage
            self.categoryTitleLabel.text = c?.categoryTitle
        }
        get {
            return nil
        }
    }
    
    lazy var categoryTitleLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 8.0)
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.categoryImageView)
        self.categoryImageView.snp.makeConstraints { [weak self] (ConstraintMaker) in
            ConstraintMaker.size.equalTo(CGSize(width: collectionCellWidth() - 20, height: collectionCellWidth() - 20))
            ConstraintMaker.centerX.equalTo(self!)
            ConstraintMaker.top.equalTo(self!).offset(5)
        }
        
        self.contentView.addSubview(self.categoryTitleLabel)
        self.categoryTitleLabel.snp.makeConstraints { [weak self] (ConstraintMaker) in
            ConstraintMaker.height.equalTo(20)
            ConstraintMaker.top.equalTo(self!.categoryImageView.snp.bottom).offset(5)
            ConstraintMaker.centerX.equalTo(self!)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.category = nil
        self.categoryImageView.image = nil
        self.categoryTitleLabel.text = nil
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
