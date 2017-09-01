//
//  TMAddBillViewController.swift
//  TimiAccount
//
//  Created by Zhihao Yuan on 28/08/2017.
//  Copyright © 2017 Zhihao Yuan. All rights reserved.
//

import UIKit

protocol TMAddBillViewControllerDelegate: class {
    func clickDismissButton(viewController: TMAddBillViewController)
}

let collectionCellIdentifier = "categoryCell"

class TMAddBillViewController: TMBaseViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    weak var addBillDelegate: TMAddBillViewControllerDelegate? = nil
    
    var bill: TMBill? = nil
    
    var update: Bool = false
    
    var headerView: TMAddBillHeaderView? = nil
    
    lazy var expenditureCategoryCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: screenSize().width, height: (collectionCellWidth() + 10) * 4), collectionViewLayout: TMCategoryCollectionViewFlowLayout())
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = UIColor.white
        return cv
    }()
    
    lazy var expenditureCategoryCollectionView2: UICollectionView = {
        let cv = UICollectionView(frame: CGRect(x: screenSize().width, y: 0, width: screenSize().width, height: (collectionCellWidth() + 10) * 4), collectionViewLayout: TMCategoryCollectionViewFlowLayout())
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = UIColor.white
        return cv
    }()
    
    lazy var incomeCategoryCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: self.collectionFrame(), collectionViewLayout: TMCategoryCollectionViewFlowLayout())
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = UIColor.white
        return cv
    }()
    
    lazy var expenditureCategoryScrollView: UIScrollView = {
        let sv = UIScrollView(frame: self.collectionFrame())
        sv.contentSize = CGSize(width: self.collectionFrame().size.width * 2, height: self.collectionFrame().size.height)
        sv.delegate = self
        sv.addSubview(self.expenditureCategoryCollectionView)
        sv.addSubview(self.expenditureCategoryCollectionView2)
        return sv
    }()
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl(frame: self.pageControlFrame())
        pc.numberOfPages = 2
        pc.isUserInteractionEnabled = false
        pc.pageIndicatorTintColor = UIColor(white: 0.829, alpha: 1.000)
        pc.currentPageIndicatorTintColor = selectedColor()
        return pc
    }()
    
    var titleView: UIView? = nil
    
    var clapboard: UIView? = nil
    
    lazy var incomeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Income", for: UIControlState.normal)
        button.setTitleColor(UIColor.black, for: UIControlState.normal)
        button.setTitleColor(selectedColor(), for: UIControlState.selected)
        button.addTarget(self, action: #selector(clickIncomeButton(sender:)), for: UIControlEvents.touchUpInside)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 15.0)
        return button
    }()
    
    lazy var expenditureButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cost", for: UIControlState.normal)
        button.setTitleColor(UIColor.black, for: UIControlState.normal)
        button.setTitleColor(selectedColor(), for: UIControlState.selected)
        button.addTarget(self, action: #selector(clickExpenditureButton(sender:)), for: UIControlEvents.touchUpInside)
        button.titleLabel!.font = UIFont.systemFont(ofSize: 15.0)
        return button
    }()
    
    var lastExpenditureCategories: [TMCategory] = []
    
    lazy var selectedCategoryImageView: UIImageView = {
        let iv = UIImageView(frame: CGRect(x: 0, y: -30, width: collectionCellWidth() - 20, height: collectionCellWidth() - 20))
        iv.layer.cornerRadius = (collectionCellWidth() - 20) / 2
        iv.contentMode = UIViewContentMode.scaleAspectFill
        return iv
    }()
    
    lazy var calculatorView: TMCalculatorView = {
        let view = Bundle.main.loadNibNamed("TMCalculatorView", owner: nil, options: nil)?.last as! TMCalculatorView
        view.frame = CGRect(x: 0, y: self.pageControl.frame.maxY, width: screenSize().width, height: screenSize().height - self.pageControl.frame.maxY)
        return view
    }()
    
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.backgroundColor = UIColor(white: 0.800, alpha: 0.800)
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.setDate(Date(), animated: true)
        datePicker.addTarget(self, action: #selector(scrollDate(sender:)), for: UIControlEvents.valueChanged)
        return datePicker
    }()
    
    var categoryTitleView: TMEditCategoryTitleView? = nil
    
    var editCategoryContainerView: UIView? = nil
    
    var time: String? = nil
    
    var remark: String? = nil
    
    var iconData: Data? = nil
    
    var selectedCategory: TMCategory? = nil
    
    var isIncome: Int = 0
    
    var money: Double = 0.0
    
    var hidden: Bool = true
    
    lazy var animator: UIDynamicAnimator = {
        return UIDynamicAnimator(referenceView: self.view)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        self.setupNavigationBar()
        self.layoutSubviews()
        self.register()
        self.expenditureCategoryScrollView.isPagingEnabled = true
        self.expenditureCategoryScrollView.showsHorizontalScrollIndicator = false
        self.expenditureButton.isSelected = true
        if !self.update {
            self.setupBill()
        } else {
            self.setupUpdateBill()
            if self.bill!.isIncome.value! == PaymentType.income.rawValue {
                self.updateBillToIncome(sender: self.incomeButton)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.subviews[0].alpha = 0.0
        
        self.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadData() {
        let results = TMDataManager.dataManager.gainAllCategories(paymentType: PaymentType.cost)
        var arr: [TMCategory] = []
        for category in results {
            arr.append(category)
        }
        self.lastExpenditureCategories = Array<TMCategory>(arr.suffix(from: 24))
        self.incomeCategoryCollectionView.reloadData()
        self.expenditureCategoryCollectionView2.reloadData()
    }
    
    func setupUpdateBill() {
        self.headerView?.setCategoryImageAndTitle(imageFileName: (self.bill?.category?.categoryImageFileName)!, title: (self.bill?.category?.categoryTitle)!)
        let imageColor = CCColorCube()
        let colors = imageColor.extractColors(from: self.bill?.category?.categoryImage, flags: CCAvoidBlack.rawValue, count: 1)
        self.headerView?.backgroundColor = colors?.first as? UIColor
        self.headerView?.updateMoney(money: String(format: "%@.00", String((self.bill?.money.value)!)))
        self.money = (self.bill?.money.value)!
        self.time = self.bill?.date
        self.remark = self.bill?.remark
        self.iconData = self.bill?.remarkIcon
        self.selectedCategory = self.bill?.category
        self.calculatorView.setTime(time: (self.bill?.date)!)
        
        self.headerView?.animateOnBackgroundColorLayer(color: colors?.first as! UIColor)
    }
    
    func setupBill() {
        self.bill = TMBill()
        self.bill?.date = String.currentDate()
        self.bill?.isIncome.value = PaymentType.cost.rawValue
        self.selectedCategory = TMDataManager.dataManager.gainAllCategories(paymentType: PaymentType.cost).first
        self.headerView?.setCategoryImageAndTitle(imageFileName: (self.selectedCategory?.categoryImageFileName)!, title: (self.selectedCategory?.categoryTitle)!)
        self.headerView?.animateOnBackgroundColorLayer(color: UIColor(red: 0.485, green: 0.686, blue: 0.667, alpha: 1.000))
        self.headerView?.backgroundColor = UIColor(red: 0.485, green: 0.686, blue: 0.667, alpha: 1.000)
    }
    
    func updateBillToIncome(sender: UIButton) {
        self.isIncome = PaymentType.income.rawValue
        sender.isSelected = true
        self.expenditureButton.isSelected = false
        self.view.bringSubview(toFront: self.incomeCategoryCollectionView)
        self.view.bringSubview(toFront: self.headerView!)
        self.view.sendSubview(toBack: self.expenditureCategoryScrollView)
        
        self.headerView?.setCategoryImageAndTitle(imageFileName: (self.bill?.category?.categoryImageFileName)!, title: (self.bill?.category?.categoryTitle)!)
        
        let imageColor = CCColorCube()
        let colors = imageColor.extractColors(from: self.bill?.category?.categoryImage, flags: CCAvoidBlack.rawValue, count: 1)
        self.headerView?.animateOnBackgroundColorLayer(color: colors?.first as! UIColor)
        self.pageControl.numberOfPages = 1
        self.incomeCategoryCollectionView.reloadData()
    }
    
    func layoutSubviews() {
        self.headerView = TMAddBillHeaderView(frame: self.headerViewFrame())
        self.view.addSubview(self.headerView!)
        
        self.view.addSubview(self.selectedCategoryImageView)
        self.view.sendSubview(toBack: self.selectedCategoryImageView)
        
        self.view.addSubview(self.incomeCategoryCollectionView)
        self.view.sendSubview(toBack: self.incomeCategoryCollectionView)
        
        self.clapboard = UIView(frame: collectionFrame())
        self.clapboard?.backgroundColor = UIColor.white
        self.view.addSubview(self.clapboard!)
        
        self.view.bringSubview(toFront: self.headerView!)
        
        self.view.addSubview(self.expenditureCategoryScrollView)
        
        self.view.addSubview(self.pageControl)
        
        self.editCategoryContainerView = UIView(frame: self.view.bounds)
        self.view.addSubview(self.editCategoryContainerView!)
        
        let editView = TMEditCategoryTitleView(frame: CGRect(x: 37.5, y: 166, width: 300, height: 140))
        self.categoryTitleView = editView
        self.editCategoryContainerView?.addSubview(editView)
        self.view.sendSubview(toBack: self.editCategoryContainerView!)
        
        self.headerView?.clickCategoryTitleLabel = { [weak self] in
            self!.categoryTitleView?.category = self!.selectedCategory
            self!.editCategoryContainerView?.backgroundColor = UIColor(white: 0.750, alpha: 0.3)
            self!.view.bringSubview(toFront: self!.editCategoryContainerView!)
            self?.categoryTitleView?.becomeFirstResponder()
        }
        
        self.categoryTitleView?.clickOKButton = { [weak self] in
            if (self?.categoryTitleView?.categoryTitle.isEmpty)! {
                self!.showSVProgressHUD(text: "Wrong category title!")
            } else {
                self!.selectedCategory?.modifyCategoryTitle(categoryTitle: (self!.categoryTitleView?.categoryTitle)!)
                self!.headerView?.setCategoryImageAndTitle(imageFileName: (self!.selectedCategory?.categoryImageFileName!)!, title: (self!.selectedCategory?.categoryTitle)!)
                self?.incomeCategoryCollectionView.reloadData()
                self?.expenditureCategoryCollectionView.reloadData()
                self?.expenditureCategoryCollectionView2.reloadData()
            }
        }
        
        self.calculatorView.passValueBlock = { [weak self] s in
            self!.headerView!.updateMoney(money: s)
            if !self!.update {
                self!.bill!.money.value = Double(s)
            } else {
                if Double(s)! > 0.0 {
                    self!.money = Double(s)!
                }
            }
        }
        
        self.calculatorView.didClickSaveButtonBlock = { [weak self] in
            if !self!.update {
                if self!.bill!.money.value! <= 0.0 {
                    self!.showSVProgressHUD(text: "Please input valid amount!")
                    self?.headerView?.animateShake()
                } else {
                    self!.bill!.category = self!.selectedCategory
                    let bookID = String.getSelectedBookID()
                    let book = TMDataManager.dataManager.gainBook(bookID: bookID)
                    self!.bill!.book = book
                    TMDataManager.dataManager.addBill(bill: (self?.bill)!)
                    self!.dismissView()
                }
            } else {
                if self!.money <= 0.0 {
                    self!.showSVProgressHUD(text: "Please input valid amount!")
                    self?.headerView?.animateShake()
                } else {
                    self?.updateBill()
                    self?.dismissView()
                }
            }
        }
        
        self.calculatorView.didClickDateButtonBlock = { [weak self] in
            if self!.hidden {
                self!.hidden = false
                self?.datePicker.isHidden = false
                self?.view.bringSubview(toFront: self!.datePicker)
            } else {
                self!.hidden = true
                self?.datePicker.isHidden = true
            }
        }
        
        self.calculatorView.didClickRemarkButtonBlock = { [weak self] in
            self!.runInMainQueue {
                let remarkVC = TMRemarkViewController()
                remarkVC.passValueBlock = { (remark, data) in
                    if self!.update {
                        self?.remark = remark
                        self?.iconData = data
                    } else {
                        self?.bill?.remark = remark
                        self?.bill?.remarkIcon = data
                    }
                }
                remarkVC.bill = self?.bill
                let navigation = UINavigationController(rootViewController: remarkVC)
                self?.present(navigation, animated: true, completion: nil)
            }
        }
        
        self.view.addSubview(self.calculatorView)
        
        self.view.addSubview(datePicker)
        datePicker.snp.makeConstraints({ [weak self] (ConstraintMaker) in
            ConstraintMaker.left.equalTo((self?.calculatorView)!)
            ConstraintMaker.width.equalTo((self?.calculatorView)!)
            ConstraintMaker.bottom.equalTo((self?.calculatorView.snp.top)!).offset(-5)
            ConstraintMaker.height.equalTo((self?.expenditureCategoryScrollView)!)
        })
        self.datePicker.isHidden = true
    }
    
    func updateBill() {
        self.bill?.updateIncome(isIncome: self.isIncome)
        self.bill?.updateMoney(money: self.money)
        self.bill?.updateDate(date: self.time!)
        self.bill?.updateRemark(remark: self.remark!)
        self.bill?.updateCategory(category: self.selectedCategory!)
        self.bill?.updateRemarkIcon(remarkIcon: self.iconData!)
    }
    
    func register() {
        self.incomeCategoryCollectionView.register(TMCategoryCollectionViewCell.self, forCellWithReuseIdentifier: collectionCellIdentifier)
        self.expenditureCategoryCollectionView.register(TMCategoryCollectionViewCell.self, forCellWithReuseIdentifier: collectionCellIdentifier)
        self.expenditureCategoryCollectionView2.register(TMCategoryCollectionViewCell.self, forCellWithReuseIdentifier: collectionCellIdentifier)
    }
    
    func setupNavigationBar() {
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        self.titleView = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
        
        self.incomeButton.frame = CGRect(x: 0, y: 0, width: self.titleView!.bounds.size.width / 2, height: self.titleView!.bounds.size.height)
        
        self.titleView?.addSubview(incomeButton)
        
        self.expenditureButton.frame = CGRect(x: self.titleView!.bounds.size.width / 2, y: 0, width: self.titleView!.bounds.size.width / 2, height: self.titleView!.bounds.size.height)
        
        self.titleView?.addSubview(expenditureButton)
        
        self.navigationItem.titleView = self.titleView!
        
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        backButton.setImage(UIImage(named: "btn_item_close"), for: UIControlState.normal)
        backButton.addTarget(self, action: #selector(dismissView), for: UIControlEvents.touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    func getMaxYOfNavigationBar() -> CGFloat {
        return (self.navigationController?.navigationBar.frame.maxY)! + UIApplication.shared.statusBarFrame.maxY
    }
    
    func headerViewFrame() -> CGRect {
        return CGRect(x: 0, y: getMaxYOfNavigationBar(), width: screenSize().width, height: 60)
    }
    
    func collectionFrame() -> CGRect {
        return CGRect(x: 0, y: getMaxYOfNavigationBar() + headerViewFrame().size.height, width: screenSize().width, height: collectionCellWidth() * 4 + 40)
    }
    
    func pageControlFrame() -> CGRect {
        return CGRect(x: 0, y: getMaxYOfNavigationBar() + headerViewFrame().size.height + collectionFrame().size.height, width: screenSize().width, height: 30)
    }
    
    func headerCategoryImageCenter() -> CGPoint {
        return CGPoint(x: 30, y: (headerViewFrame().size.height - 48.5) / 2 + getMaxYOfNavigationBar())
    }
    
    func clickExpenditureButton(sender: UIButton) {
        print(self.view.subviews)
        
        let firstExpenditureCategory = TMDataManager.dataManager.gainAllCategories(paymentType: PaymentType.cost).first
        self.selectedCategory = firstExpenditureCategory
        if !self.update {
            self.bill!.isIncome.value = PaymentType.cost.rawValue
        } else {
            self.isIncome = PaymentType.cost.rawValue
        }
        sender.isSelected = true
        self.incomeButton.isSelected = false
        
        self.view.bringSubview(toFront: self.expenditureCategoryScrollView)
        self.view.bringSubview(toFront: self.headerView!)
        self.view.sendSubview(toBack: self.incomeCategoryCollectionView)
        
        self.headerView?.setCategoryImageAndTitle(imageFileName: firstExpenditureCategory!.categoryImageFileName!, title: firstExpenditureCategory!.categoryTitle!)
        
        let imageColor = CCColorCube()
        let colors = imageColor.extractColors(from: firstExpenditureCategory?.categoryImage!, flags: CCAvoidBlack.rawValue, count: 1)
        
        self.headerView?.animateOnBackgroundColorLayer(color: colors?.first as! UIColor)
        self.pageControl.numberOfPages = 2
        self.expenditureCategoryCollectionView.reloadData()
        self.expenditureCategoryCollectionView2.reloadData()
    }
    
    func clickIncomeButton(sender: UIButton) {
        let firstIncomeCategory = TMDataManager.dataManager.gainAllCategories(paymentType: PaymentType.income).first
        self.selectedCategory = firstIncomeCategory
        if !self.update {
            self.bill!.isIncome.value = PaymentType.income.rawValue
        } else {
            self.isIncome = PaymentType.income.rawValue
        }
        sender.isSelected = true
        self.expenditureButton.isSelected = false
        
        self.view.bringSubview(toFront: self.incomeCategoryCollectionView)
        self.view.bringSubview(toFront: self.headerView!)
        self.view.sendSubview(toBack: self.expenditureCategoryScrollView)
        
        self.headerView?.setCategoryImageAndTitle(imageFileName: firstIncomeCategory!.categoryImageFileName!, title: firstIncomeCategory!.categoryTitle!)
        
        let imageColor = CCColorCube()
        let colors = imageColor.extractColors(from: firstIncomeCategory?.categoryImage!, flags: CCAvoidBlack.rawValue, count: 1)
        
        self.headerView?.animateOnBackgroundColorLayer(color: colors?.first as! UIColor)
        self.pageControl.numberOfPages = 1
        self.incomeCategoryCollectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.incomeCategoryCollectionView {
            return TMDataManager.dataManager.countOfCategories(paymentType: PaymentType.income) + 1
        } else if collectionView == self.expenditureCategoryCollectionView {
            return 24
        } else {
            return lastExpenditureCategories.count + 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCellIdentifier, for: indexPath) as! TMCategoryCollectionViewCell
        if collectionView == self.incomeCategoryCollectionView {
            if indexPath.row == TMDataManager.dataManager.countOfCategories(paymentType: PaymentType.income) {
                let category = TMCategory()
                category.categoryImageFileName = "type_add"
                category.categoryTitle = "Edit"
                cell.category = category
            } else {
                cell.category = TMDataManager.dataManager.gainAllCategories(paymentType: PaymentType.income)[indexPath.row]
            }
        } else if collectionView == self.expenditureCategoryCollectionView {
            cell.category = TMDataManager.dataManager.gainAllCategories(paymentType: PaymentType.cost)[indexPath.row]
        } else {
            if indexPath.row == self.lastExpenditureCategories.count {
                let category = TMCategory()
                category.categoryImageFileName = "type_add"
                category.categoryTitle = "Edit"
                cell.category = category
            } else {
                cell.category = self.lastExpenditureCategories[indexPath.row]
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var cell: TMCategoryCollectionViewCell? = nil
        var category: TMCategory? = nil
        
        if collectionView == self.incomeCategoryCollectionView {
            if indexPath.row == TMDataManager.dataManager.countOfCategories(paymentType: PaymentType.income) {
                NSLog("Add Category")
                return
            }
            cell = collectionView.cellForItem(at: indexPath) as? TMCategoryCollectionViewCell
            category = TMDataManager.dataManager.gainAllCategories(paymentType: PaymentType.income)[indexPath.row]
        } else if collectionView == self.expenditureCategoryCollectionView {
            cell = collectionView.cellForItem(at: indexPath) as? TMCategoryCollectionViewCell
            category = TMDataManager.dataManager.gainAllCategories(paymentType: PaymentType.cost)[indexPath.row]
        } else {
            if indexPath.row == self.lastExpenditureCategories.count {
                NSLog("Add Category")
                return
            }
            cell = collectionView.cellForItem(at: indexPath) as? TMCategoryCollectionViewCell
            category = self.lastExpenditureCategories[indexPath.row]
        }
        
        self.animateOnCell(cell: cell!)
        self.selectedCategory = category
        self.headerView?.setCategoryImageAndTitle(imageFileName: category!.categoryImageFileName!, title: category!.categoryTitle!)
        
        let imageColor = CCColorCube()
        let colors = imageColor.extractColors(from: category!.categoryImage!, flags: CCAvoidBlack.rawValue, count: 1)
        self.headerView?.animateOnBackgroundColorLayer(color: colors?.first as! UIColor)
    }
    
    func animateOnCell(cell: TMCategoryCollectionViewCell) {
        self.selectedCategoryImageView.image = cell.categoryImageView.image
        var center = cell.center
        let y = cell.frame.maxY
        center.y = getMaxYOfNavigationBar() + y + 10
        self.selectedCategoryImageView.center = center
        animator.removeAllBehaviors()
        let behavior = UIAttachmentBehavior(item: self.selectedCategoryImageView, attachedToAnchor: headerCategoryImageCenter())
        animator.addBehavior(behavior)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let point = scrollView.contentOffset
        let index = round(point.x / scrollView.frame.size.width)
        self.pageControl.currentPage = Int(index)
    }
    
    func dismissView() {
        if self.addBillDelegate != nil {
            self.addBillDelegate!.clickDismissButton(viewController: self)
        }
    }
    
    func scrollDate(sender: UIDatePicker) {
        let date = sender.date
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let temp = formatter.string(from: date)
        if self.update {
            self.time = temp
        } else {
            self.bill!.date = temp
        }
        self.calculatorView.setTime(time: temp)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
