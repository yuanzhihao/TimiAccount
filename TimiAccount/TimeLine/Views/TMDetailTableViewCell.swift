//
//  TMDetailTableViewCell.swift
//  TimiAccount
//
//  Created by Zhihao Yuan on 27/08/2017.
//  Copyright © 2017 Zhihao Yuan. All rights reserved.
//

import UIKit

let TMDetailViewTimePointWidth: CGFloat = 10

let TMDetailViewCategoryImageViewWidth: CGFloat = 20

let TMDetailViewContainerViewHeight: CGFloat = 75

class TMDetailTableViewCell: UITableViewCell {
    var detailBill: TMBill? {
        didSet {
            if detailBill == nil {
                return
            }
            
            self.remarkLabel.removeFromSuperview()
            
            let temp = detailBill!.date
            self.timeLabel.text = String(format: "%@", temp![temp!.index(temp!.startIndex, offsetBy: 8)..<temp!.index(temp!.startIndex, offsetBy: 10)])
            self.categoryImageView.image = detailBill!.category!.categoryImage
            self.categoryAndMoneyLabel.text = String(format: "%@ %.2f", detailBill!.category!.categoryTitle!,detailBill!.money.value!)
            
            if detailBill!.remarkIcon != nil && !detailBill!.remark!.isEmpty {
                self.contentView.addSubview(self.remarkLabel)
                self.remarkLabel.numberOfLines = 2
                self.remarkLabel.textAlignment = NSTextAlignment.center
                self.updateTimePointAndContainerViewConstraints()
                self.updatePictureImageViewConstraints(exist: true)
                self.updateRemarkLabelConstraints(onBottom: true)
                self.pictureImageView.image = UIImage(data: detailBill!.remarkIcon!)
                self.remarkLabel.text = detailBill!.remark
                return
            } else if detailBill!.remarkIcon != nil {
                self.pictureImageView.image = UIImage(data: detailBill!.remarkIcon!)
                self.updateTimePointAndContainerViewConstraints()
                self.updatePictureImageViewConstraints(exist: true)
                return
            } else if detailBill!.remark != nil && !detailBill!.remark!.isEmpty {
                self.containerForRemarkLabel.addSubview(self.remarkLabel)
                self.remarkLabel.isVerticalForm = true
                self.remarkLabel.textVerticalAlignment = YYTextVerticalAlignment.center
                self.updateTimePointAndContainerViewConstraints()
                self.updatePictureImageViewConstraints(exist: false)
                self.updateRemarkLabelConstraints(onBottom: false)
                self.remarkLabel.text = detailBill!.remark
                return
            } else {
                self.originTimePointAndContainerViewContraints()
                self.updatePictureImageViewConstraints(exist: false)
                self.containerForRemarkLabel.snp.remakeConstraints({ (ConstraintMaker) in
                    ConstraintMaker.width.equalTo(0)
                })
            }
        }
    }
    
    lazy var lineView: UIView = {
        let view = UIView()
        view.backgroundColor = lineColor()
        return view
    }()

    lazy var timePointView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.red
        view.layer.cornerRadius = TMDetailViewTimePointWidth / 2
        return view
    }()
    
    lazy var container: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    var categoryImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = UIViewContentMode.scaleAspectFill
        iv.layer.cornerRadius = TMDetailViewCategoryImageViewWidth / 2
        return iv
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = lineColor()
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textAlignment = NSTextAlignment.right
        return label
    }()
    
    lazy var categoryAndMoneyLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 14.0)
        return label
    }()
    
    lazy var logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "launch_title")
        iv.contentMode = UIViewContentMode.scaleAspectFill
        return iv
    }()
    
    lazy var remarkLabel: YYLabel = {
        let label = YYLabel()
        label.backgroundColor = UIColor.white
        label.textColor = UIColor(white: 0.232, alpha: 1.000)
        label.numberOfLines = 3
        return label
    }()
    
    lazy var pictureImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = UIColor.white
        iv.contentMode = UIViewContentMode.scaleAspectFit
        iv.layer.borderWidth = 1.0
        iv.layer.borderColor = UIColor(white: 0.689, alpha: 1.000).cgColor
        return iv
    }()
    
    lazy var containerForRemarkLabel: UIView = {
        let view = UIView()
        return view
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(self.lineView)
        self.contentView.addSubview(self.timePointView)
        self.contentView.addSubview(self.timeLabel)
        self.contentView.addSubview(self.container)
        self.container.addSubview(self.categoryImageView)
        self.container.addSubview(self.categoryAndMoneyLabel)
        self.contentView.addSubview(self.logoImageView)
        self.contentView.addSubview(self.pictureImageView)
        self.contentView.addSubview(self.containerForRemarkLabel)
        self.containerForRemarkLabel.backgroundColor = UIColor.white
        
        self.lineView.snp.makeConstraints { [weak self] (ConstraintMaker) in
            ConstraintMaker.size.equalTo(CGSize(width: 1.5, height: screenSize().height))
            ConstraintMaker.centerX.equalTo(self!.contentView)
            ConstraintMaker.top.equalTo(self!.contentView)
        }
        
        self.container.backgroundColor = UIColor.white
        self.container.snp.makeConstraints { [weak self] (ConstraintMaker) in
            ConstraintMaker.size.equalTo(CGSize(width: screenSize().width, height: TMDetailViewContainerViewHeight))
            ConstraintMaker.center.equalTo(self!.contentView).priorityLow()
        }
        
        self.categoryImageView.image = UIImage(named: "type_big_1006")
        self.categoryImageView.snp.makeConstraints { [weak self] (ConstraintMaker) in
            ConstraintMaker.size.equalTo(CGSize(width: 40, height: 40))
            ConstraintMaker.centerX.equalTo(self!.container)
            ConstraintMaker.top.equalTo(self!.container).offset(5).priorityLow()
        }
        
        self.categoryAndMoneyLabel.text = "Restaurant 4558.00"
        self.categoryAndMoneyLabel.snp.makeConstraints { [weak self] (ConstraintMaker) in
            ConstraintMaker.centerX.equalTo(self!.container).priorityLow()
            ConstraintMaker.bottom.equalTo(self!.container).offset(-5)
        }
        
        self.timePointView.backgroundColor = lineColor()
        self.timePointView.snp.makeConstraints { [weak self] (ConstraintMaker) in
            ConstraintMaker.size.equalTo(CGSize(width: TMDetailViewTimePointWidth, height: TMDetailViewTimePointWidth))
            ConstraintMaker.centerX.equalTo(self!.contentView)
            ConstraintMaker.centerY.equalTo(self!.container.snp.top).offset(-15).priorityLow()
        }
        
        self.timeLabel.text = "31"
        self.timeLabel.snp.makeConstraints { [weak self] (ConstraintMaker) in
            ConstraintMaker.centerY.equalTo(self!.timePointView).priorityLow()
            ConstraintMaker.right.equalTo(self!.timePointView.snp.left).offset(-10)
        }
        
        self.logoImageView.snp.makeConstraints { [weak self] (ConstraintMaker) in
            ConstraintMaker.size.equalTo(CGSize(width: 88, height: 16))
            ConstraintMaker.left.equalTo(self!.contentView).offset(10)
            ConstraintMaker.bottom.equalTo(self!.contentView).offset(-10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func updateTimePointAndContainerViewConstraints() {
        self.timePointView.snp.remakeConstraints { [weak self] (ConstraintMaker) in
            ConstraintMaker.size.equalTo(CGSize(width: TMDetailViewTimePointWidth, height: TMDetailViewTimePointWidth))
            ConstraintMaker.centerX.equalTo(self!.contentView)
            ConstraintMaker.top.equalTo(self!.contentView).offset(50)
        }
        self.container.snp.remakeConstraints { [weak self] (ConstraintMaker) in
            ConstraintMaker.size.equalTo(CGSize(width: screenSize().width, height: TMDetailViewContainerViewHeight))
            ConstraintMaker.centerX.equalTo(self!.contentView)
            ConstraintMaker.top.equalTo(self!.timePointView.snp.bottom).offset(15)
        }
    }
    
    func updatePictureImageViewConstraints(exist: Bool) {
        if exist {
            self.pictureImageView.snp.remakeConstraints({ [weak self] (ConstraintMaker) in
                ConstraintMaker.width.equalTo(250)
                ConstraintMaker.bottom.equalTo(self!.contentView).offset(-150)
                ConstraintMaker.centerX.equalTo(self!.contentView)
                ConstraintMaker.top.equalTo(self!.container.snp.bottom)
            })
        } else {
            self.pictureImageView.snp.remakeConstraints({ (ConstraintMaker) in
                ConstraintMaker.width.equalTo(0)
            })
        }
    }
    
    func updateRemarkLabelConstraints(onBottom: Bool) {
        if onBottom {
            self.remarkLabel.snp.remakeConstraints({ [weak self] (ConstraintMaker) in
                ConstraintMaker.top.equalTo(self!.pictureImageView.snp.bottom)
                ConstraintMaker.size.equalTo(CGSize(width: screenSize().width - 50, height: 65))
                ConstraintMaker.centerX.equalTo(self!.contentView)
            })
            self.containerForRemarkLabel.snp.remakeConstraints({ (ConstraintMaker) in
                ConstraintMaker.width.equalTo(0)
            })
        } else {
            self.containerForRemarkLabel.snp.remakeConstraints({ [weak self] (ConstraintMaker) in
                ConstraintMaker.width.equalTo(screenSize().width)
                ConstraintMaker.top.equalTo(self!.container.snp.bottom)
                ConstraintMaker.bottom.equalTo(self!).offset(-100)
            })
            self.remarkLabel.snp.remakeConstraints({ [weak self] (ConstraintMaker) in
                ConstraintMaker.width.equalTo(screenSize().width)
                ConstraintMaker.height.equalTo(250)
                ConstraintMaker.center.equalTo(self!.containerForRemarkLabel)
            })
        }
    }
    
    func originTimePointAndContainerViewContraints() {
        self.container.snp.remakeConstraints { [weak self] (ConstraintMaker) in
            ConstraintMaker.size.equalTo(CGSize(width: screenSize().width, height: TMDetailViewContainerViewHeight))
            ConstraintMaker.center.equalTo(self!.contentView)
        }
        self.timePointView.snp.remakeConstraints { [weak self] (ConstraintMaker) in
            ConstraintMaker.size.equalTo(CGSize(width: TMDetailViewTimePointWidth, height: TMDetailViewTimePointWidth))
            ConstraintMaker.centerX.equalTo(self!.contentView)
            ConstraintMaker.centerY.equalTo(self!.container.snp.top).offset(-15).priorityLow()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.detailBill = nil
    }
}
