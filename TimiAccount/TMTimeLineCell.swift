//
//  TMTimeLineCell.swift
//  TimiAccount
//
//  Created by Zhihao Yuan on 2017/7/25.
//  Copyright © 2017年 Zhihao Yuan. All rights reserved.
//

import UIKit

@objc protocol TMTimeLineCellDelegate {
    @objc func didClickCategoryButton(indexPath: IndexPath)
}

let TMMoneyLabelWidth = (Double(screenSize().width) - TMTimeLineButtonWidth) / 2 - 40

let TMCategoryTitleLabelSize = CGSize(width: 30, height: 25)

let TMRemainingWidth = getBlankWidth() + CGFloat(40)

let TMRemarkFont: CGFloat = 10.0

let TMMoneyFont: CGFloat = 14.0

let TMImageWidth = 35

let TMTimeViewWidth: CGFloat = 6

let TMTextFont: CGFloat = 12.0

class TMTimeLineCell: UITableViewCell {
    
    var bill: TMBill? {
        didSet {
            if bill == nil || bill!.empty {
                return
            }
            self.timeLabel.text = bill!.date
            self.moneyLabel.text = String(format: "%.2f", arguments: [bill!.money.value!])
//            self.moneyLabel.text = String(format: "%.2f", arguments: [queryCostDaily(bookID: bill!.book!.bookID!, date: bill!.date!)])
            self.setRemarkIconVisibility(hidden: true)
            self.remarkImageButton.setImage(nil, for: UIControlState.normal)
            if bill!.category!.categoryImage != nil {
                self.categoryImageButton.setImage(bill!.category!.categoryImage!, for: UIControlState.normal)
            }
            //let image = UIImage(data: bill!.remarkIcon!)
            if self.bill!.empty {
                self.categoryImageButton.setImage(nil, for: UIControlState.normal)
                self.setRemarkIconVisibility(hidden: true)
                return
            }
            
            self.moneyLabel.text = String(format: "%.2f", arguments: [bill!.money.value!])
            self.categoryTitleLabel.text = bill!.category!.categoryTitle
            self.remarkLabel.text = bill!.remark
            //self.remarkImageButton.setImage(image, for: UIControlState.normal)
            
            self.bill!.same ? self.setUIControlVisibility(hidden: true) : self.setUIControlVisibility(hidden: false)
        }
    }
    
    weak var cellDelegate: TMTimeLineCellDelegate? = nil
    
    var indexPath: IndexPath? = nil
    
    var isLastBill = false
    
    var isDeleted = false
    
    lazy var categoryImageButton = { () -> UIButton in
        var cb = UIButton()
        cb.addTarget(self, action: #selector(clickCategoryButton(sender:)), for: UIControlEvents.touchUpInside)
        return cb
    }()
    
    lazy var timeView = { () -> UIView in
        var tv = UIView()
        tv.backgroundColor = lineColor()
        tv.layer.cornerRadius = TMTimeViewWidth / 2
        return tv
    }()
    
    lazy var timeLabel = { () -> UILabel in
        var tl = UILabel()
        tl.backgroundColor = UIColor.clear
        tl.textColor = lineColor()
        tl.font = UIFont.systemFont(ofSize: TMTextFont)
        return tl
    }()
    
    lazy var totalMoneyLabel = { () -> UILabel in
        var tml = UILabel()
        tml.backgroundColor = UIColor.clear
        tml.textColor = lineColor()
        tml.font = UIFont.systemFont(ofSize: TMTextFont)
        tml.textAlignment = NSTextAlignment.right
        return tml
    } ()
    
    lazy var lineView = { () -> UIView in
        var lv = UIView()
        lv.backgroundColor = lineColor()
        return lv
    }()
    
    lazy var categoryTitleLabel = { () -> UILabel in
        var cl = UILabel()
        cl.backgroundColor = UIColor.clear
        cl.textColor = UIColor.black
        cl.font = UIFont.systemFont(ofSize: TMMoneyFont)
        cl.textAlignment = NSTextAlignment.right
        self.setContentPriority(label: cl)
        return cl
    }()
    
    lazy var moneyLabel = { () -> UILabel in
        var ml = UILabel()
        ml.backgroundColor = UIColor.clear
        ml.textColor = UIColor.black
        ml.font = UIFont.systemFont(ofSize: TMMoneyFont)
        ml.textAlignment = NSTextAlignment.right
        self.setContentPriority(label: ml)
        return ml
    }()
    
    lazy var remarkLabel = { () -> UILabel in
        var rl = UILabel()
        rl.backgroundColor = UIColor.clear
        rl.textColor = UIColor.black
        rl.font = UIFont.systemFont(ofSize: TMRemarkFont)
        rl.textAlignment = NSTextAlignment.right
        self.setContentPriority(label: rl)
        return rl
    }()
    
    lazy var remarkImageButton = { () -> UIButton in
        var rb = UIButton()
        rb.addTarget(self, action: #selector(clickCategoryButton(sender:)), for: UIControlEvents.touchUpInside)
        return rb
    }()
    
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
        
        weakSelf?.contentView.addSubview((weakSelf?.timeView)!)
        weakSelf?.timeView.snp.makeConstraints({ (ConstraintMaker) in
            ConstraintMaker.size.equalTo(CGSize(width: TMTimeViewWidth, height: TMTimeViewWidth))
            ConstraintMaker.centerX.equalTo((weakSelf?.contentView)!)
            ConstraintMaker.top.equalTo(9)
        })
        
        weakSelf?.contentView.addSubview((weakSelf?.timeLabel)!)
        weakSelf?.timeLabel.snp.makeConstraints({ (ConstraintMaker) in
            ConstraintMaker.centerY.equalTo((weakSelf?.timeView)!)
            ConstraintMaker.right.equalTo((weakSelf?.timeView.snp.left)!).offset(-3)
        })
        
        weakSelf?.contentView.addSubview((weakSelf?.totalMoneyLabel)!)
        weakSelf?.totalMoneyLabel.snp.makeConstraints({ (ConstraintMaker) in
            ConstraintMaker.centerY.equalTo((weakSelf?.timeView)!)
            ConstraintMaker.left.equalTo((weakSelf?.timeView.snp.right)!).offset(3)
        })
        
        weakSelf?.contentView.addSubview((weakSelf?.lineView)!)
        weakSelf?.lineView.frame = CGRect(x: (screenSize().width - 1) / 2, y: 0, width: 1, height: (weakSelf?.contentView.bounds.size.height)!)
        
        weakSelf?.contentView.addSubview((weakSelf?.categoryImageButton)!)
        weakSelf?.categoryImageButton.snp.makeConstraints({ (ConstraintMaker) in
            ConstraintMaker.size.equalTo(CGSize(width: TMTimeLineButtonWidth + 10, height: TMTimeLineButtonWidth + 10))
            ConstraintMaker.centerX.equalTo((weakSelf?.contentView)!)
            ConstraintMaker.bottom.equalTo((weakSelf?.contentView)!)
        })
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !self.isLastBill {
            self.lineView.frame = CGRect(x: (screenSize().width - 1) / 2, y: 0, width: 1, height: self.contentView.bounds.size.height)
        } else {
            self.lineView.frame = CGRect(x: (screenSize().width - 1) / 2, y: 0, width: 1, height: self.contentView.bounds.size.height - 5)
        }
        if self.bill!.empty {
            self.lineView.frame = CGRect(x: (screenSize().width - 1) / 2, y: 0, width: 1, height: 9)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func clickCategoryButton(sender: UIButton) {
        self.cellDelegate?.didClickCategoryButton(indexPath: self.indexPath!)
    }
    
    func setContentPriority(label: UILabel) {
        label.setContentCompressionResistancePriority(UILayoutPriorityRequired, for: UILayoutConstraintAxis.horizontal)
        label.setContentHuggingPriority(UILayoutPriorityRequired, for: UILayoutConstraintAxis.horizontal)
    }
    
    func setLabelInCellVisibility(hidden: Bool) {
        UIView.animate(withDuration: TMAnimationDuration, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: { [weak self] () -> Void in
                self?.categoryTitleLabel.isHidden = hidden
                self?.moneyLabel.isHidden = hidden
                self?.remarkLabel.isHidden = hidden
                if (self?.isDeleted)! {
                    self?.isDeleted = true
                    self?.bill = nil
                    return
                } else {
                    if self?.bill?.remarkIcon != nil {
                        self?.remarkImageButton.isHidden = !(self?.remarkImageButton.isHidden)!
                    }
                }
            }, completion: { (Bool) -> Void in
                
        })
    }
    
    func setRemarkIconVisibility(hidden: Bool) {
        self.remarkImageButton.isHidden = hidden
    }
    
    func setUIControlVisibility(hidden: Bool) {
        self.timeLabel.isHidden = hidden
        self.timeView.isHidden = hidden
        self.moneyLabel.isHidden = hidden
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.bill = nil
        self.categoryImageButton.imageView!.image = nil
        self.categoryTitleLabel.text = nil
        self.moneyLabel.text = nil
        self.remarkLabel.text = nil
        self.isLastBill = false
    }
    
    deinit {
        self.bill = nil
    }
}
