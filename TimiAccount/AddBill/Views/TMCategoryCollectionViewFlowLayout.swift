//
//  TMCategoryCollectionViewFlowLayout.swift
//  TimiAccount
//
//  Created by Zhihao Yuan on 28/08/2017.
//  Copyright © 2017 Zhihao Yuan. All rights reserved.
//

import UIKit

class TMCategoryCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override init() {
        super.init()
        self.itemSize = CGSize(width: collectionCellWidth(), height: collectionCellWidth())
        self.minimumInteritemSpacing = 0
//        self.minimumLineSpacing = 10
//        self.scrollDirection = UICollectionViewScrollDirection.horizontal
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
