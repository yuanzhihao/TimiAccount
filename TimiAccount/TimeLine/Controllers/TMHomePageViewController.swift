//
//  TMHomePageViewController.swift
//  TimiAccount
//
//  Created by Zhihao Yuan on 2017/7/25.
//  Copyright © 2017年 Zhihao Yuan. All rights reserved.
//

import UIKit
import RealmSwift

let titleTextFont: CGFloat = 14.0

func titleButtonSize() -> CGSize {
    return CGSize(width: 60, height: 25)
}

let homeReloadNotifiation = "homeReloadData"

let TimeLineCell = "timeLineCell"

let IncomeCell = "incomeCell"

let CostCell = "costCell"

class TMHomePageViewController: TMBaseViewController, UITableViewDelegate, UITableViewDataSource, TMHeaderViewDelegate, TMTimeLineCellDelegate, TMTimeLineMenuViewDelegate, UIViewControllerTransitioningDelegate, TMAddBillViewControllerDelegate {
    
    lazy var tableView: UITableView = { () -> UITableView in
        var tv = UITableView(frame: CGRect(x: CGFloat(0), y: CGFloat(TMHeaderViewHeight), width: screenSize().width, height: screenSize().height - CGFloat(TMHeaderViewHeight)))
        tv.delegate = self
        tv.dataSource = self
        tv.separatorStyle = UITableViewCellSeparatorStyle.none
        tv.backgroundColor = lineColor(0.986, 1.000)
        tv.rowHeight = 64.0
        return tv
    }()
    
    var timeLineMenuView: TMTimeLineMenuView? = nil
    
    var timeLineCell: TMTimeLineCell? = nil
    
    var headerView: TMHeaderView? = nil
    
    var isMenuOpened = false
    
    var dropDownLineView: UIView? = nil
    
    var titleButton: UIButton? = nil
    
    var isTitleButtonOpened = false
    
    var selectedBill: TMBill? = nil
    
    var results: Results<TMBill>? = nil
    
    var bills: [TMBill] = []
    
    var newBookLabel: UILabel? = nil
    
    var token: NotificationToken? = nil
    
    var book: TMBook? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        self.book = TMDataManager.dataManager.gainBook(bookID: String.getSelectedBookID())
        
        self.layoutSubviews()
        
        self.headerView!.calculateMoney()
        
        let realm = try! Realm()
        let r = realm.objects(TMBill.self)
        self.token = r.addNotificationBlock({ [weak self] (changes: RealmCollectionChange) in
            self!.headerView!.calculateMoney()
            self!.loadingPieView()
            self!.getData()
        })
        
        let panGestureRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(clickMenuButton(sender:)))
        panGestureRecognizer.edges = UIRectEdge.left
        self.view.addGestureRecognizer(panGestureRecognizer)
        
        self.registerNotification()
    }
    
    func layoutSubviews() {
        self.timeLineMenuView = TMTimeLineMenuView(frame: self.view.frame)
        self.timeLineMenuView!.timeLineMenuDelegate = self
        self.view.addSubview(self.timeLineMenuView!)
        
        self.dropDownLineView = UIView(frame: CGRect(x: (screenSize().width - 1) / 2, y: 0, width: 1, height: 0))
        self.dropDownLineView!.backgroundColor = lineColor()
        self.tableView.addSubview(self.dropDownLineView!)
        self.tableView.sendSubview(toBack: self.dropDownLineView!)
        
        self.headerView = TMHeaderView(frame: CGRect(x: 0, y: 0, width: Int(screenSize().width), height: TMHeaderViewHeight))
        
        self.headerView!.backgroundColor = lineColor(0.986, 1.000)
        self.headerView!.headerViewDelegate = self
        self.view.addSubview(self.headerView!)
        
        let menuButton = UIButton()
        menuButton.setImage(UIImage(named: "btn_menu"), for: UIControlState.normal)
        menuButton.addTarget(self, action: #selector(clickMenuButton(sender:)), for: UIControlEvents.touchUpInside)
        self.headerView!.addSubview(menuButton)
        menuButton.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.size.equalTo(CGSize(width: 40, height: 40))
            ConstraintMaker.left.equalTo(10)
            ConstraintMaker.top.equalTo(25)
        }
        
        self.titleButton = UIButton()
        self.titleButton!.backgroundColor = UIColor(white: 0.278, alpha: 0.500)
        self.titleButton!.layer.cornerRadius = titleButtonSize().height / 2
        self.titleButton!.alpha = 0.7
        self.titleButton!.layer.borderWidth = 1.5
        self.titleButton!.layer.borderColor = UIColor.white.cgColor
        self.titleButton!.titleLabel!.font = UIFont.systemFont(ofSize: titleTextFont)
        self.titleButton!.setTitle(self.book!.bookName!, for: UIControlState.normal)
        self.titleButton!.tintColor = UIColor.white
        self.titleButton!.addTarget(self, action: #selector(clickTitleButton(sender:)), for: UIControlEvents.touchUpInside)
        self.headerView!.addSubview(self.titleButton!)
        self.titleButton!.snp.makeConstraints { [weak self] (ConstraintMaker) in
            ConstraintMaker.size.equalTo(self!.getTitleButtonSize(title: self!.book!.bookName!))
            ConstraintMaker.centerX.equalTo(self!.headerView!)
            ConstraintMaker.centerY.equalTo(menuButton)
        }
        
        let cameraButton = UIButton()
        cameraButton.setImage(UIImage(named: "btn_camera"), for: UIControlState.normal)
        cameraButton.addTarget(self, action: #selector(clickCameraButton(sender:)), for: UIControlEvents.touchUpInside)
        self.headerView!.addSubview(cameraButton)
        cameraButton.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.size.equalTo(menuButton)
            ConstraintMaker.centerY.equalTo(menuButton)
            ConstraintMaker.right.equalTo(-10)
        }
        
        self.view.addSubview(self.tableView)

        
        self.tableView.showsVerticalScrollIndicator = false
        
        self.newBookLabel = UILabel()
        self.newBookLabel!.text = "New Book"
        self.newBookLabel!.textColor = lineColor()
        self.newBookLabel!.font = UIFont.systemFont(ofSize: 20.0)
        self.tableView.addSubview(self.newBookLabel!)
        self.newBookLabel!.snp.makeConstraints { [weak self] (ConstraintMaker) in
            ConstraintMaker.centerX.equalTo(self!.view)
            ConstraintMaker.top.equalTo(self!.tableView).offset(30)
        }
        self.tableView.sendSubview(toBack: self.newBookLabel!)
    }
    
    func clickCameraButton(sender: UIButton) {
        
    }
    
    func clickTitleButton(sender: UIButton) {
        UIView.animate(withDuration: 0.3, delay: 0.2, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.titleButton!.backgroundColor = UIColor(red: 1.000, green: 0.812, blue: 0.124, alpha: 1.000)
        }) { (Bool) in
            UIView.animate(withDuration: 0.3, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                self.titleButton!.backgroundColor = UIColor(white: 0.278, alpha: 0.500)
            }, completion: { (Bool) in
                
            })
        }
        var title: String? = nil
        if !self.isTitleButtonOpened {
            self.isTitleButtonOpened = true
            title = String(format: "Blance: %.2f", queryBalance(bookID: String.getSelectedBookID()))
            let width = getTitleButtonSize(title: title!).width
            self.titleButton!.snp.updateConstraints({ (ConstraintMaker) in
                ConstraintMaker.width.equalTo(width)
            })
        } else {
            self.isTitleButtonOpened = false
            let width = getTitleButtonSize(title: self.book!.bookName!)
            self.titleButton!.snp.updateConstraints({ (ConstraintMaker) in
                ConstraintMaker.width.equalTo(width)
            })
            title = self.book!.bookName
        }
        self.titleButton!.setTitle(title, for: UIControlState.normal)
    }
    
    func clickMenuButton(sender: UIButton) {
        
    }
    
    func loadingPieView() {
        let dic = TMDataManager.dataManager.gainPieChartData(bookID: String.getSelectedBookID(), date: "ALL", paymentType: PaymentType.all)
        let arr = dic.values
        var sections: [Double] = []
        var sectionColors: [UIColor] = []
        self.runInGlobalQueue { [weak self] () -> Void in
            for bill in arr {
                sections.append(bill.money.value!)
                let imageColor = CCColorCube()
                let colors = imageColor.extractColors(from: bill.category!.categoryImage!, flags: CCAvoidBlack.rawValue, count: 1)
                sectionColors.append(colors!.first! as! UIColor)
            }
            if sections.isEmpty {
                sections.append(100)
                sectionColors.append(lineColor())
            }
            self!.runInMainQueue {
                self!.headerView!.loadPieView(sections: sections, colors: sectionColors)
            }
        }
    }
    
    func getData() {
        self.bills.removeAll()
        self.results = TMDataManager.dataManager.gainAllBills(bookID: String.getSelectedBookID())
        if self.results!.isEmpty {
            self.tableView.bringSubview(toFront: self.newBookLabel!)
            let bill = TMBill()
            bill.date = String.currentDate()
            bill.empty = true
            self.bills.append(bill)
            self.tableView.reloadData()
            return
        }
        self.tableView.sendSubview(toBack: self.newBookLabel!)
        var array = [TMBill]()
        for bill in self.results! {
            array.append(bill)
        }
        let receive = Array<Any>.sortArrayByDate(array: array, ascending: false)
        var previous: String? = nil
        for (index, value) in receive.enumerated() {
            if index == 0 {
                self.bills.append(value)
                previous = value.date
            } else {
                var bill = TMBill()
                if previous! == value.date! {
                    bill = value
                    bill.same = true
                    self.bills.append(bill)
                } else {
                    self.bills.append(value)
                }
                previous = value.date
            }
        }
        self.tableView.reloadData()
    }
    
    func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(changeBook), name: NSNotification.Name(rawValue: homeReloadNotifiation), object: nil)
    }
    
    func changeBook() {
        self.getData()
        self.loadingPieView()
        self.headerView!.calculateMoney()
        self.book = TMDataManager.dataManager.gainBook(bookID: String.getSelectedBookID())
        titleButton!.setTitle(self.book!.bookName!, for: UIControlState.normal)
        let width = self.getTitleButtonSize(title: self.book!.bookName!).width
        self.titleButton!.snp.updateConstraints { (ConstraintMaker) in
            ConstraintMaker.width.equalTo(width)
        }
    }
    
    func getTitleButtonSize(title: String) -> CGSize {
        let temp = title as NSString
        let width = temp.size(attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: titleTextFont)]).width + 20
        return CGSize(width: width, height: 25)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bills.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: TMTimeLineCell? = nil
        if !self.bills[indexPath.row].empty && self.bills[indexPath.row].isIncome.value! == PaymentType.income.rawValue {
            cell = tableView.dequeueReusableCell(withIdentifier: IncomeCell) as! TMTimeLineCell?
            if cell == nil {
                cell = TMTimeLineIncomeCell(style: UITableViewCellStyle.default, reuseIdentifier: IncomeCell)
            }
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: CostCell) as! TMTimeLineCell?
            if cell == nil {
                cell = TMTimeLineCostCell(style: UITableViewCellStyle.default, reuseIdentifier: CostCell)
            }
        }
        cell!.backgroundColor = lineColor(0.986, 1.000)
        cell!.selectionStyle = UITableViewCellSelectionStyle.none
        cell!.indexPath = indexPath
        cell!.cellDelegate = self
        if indexPath.row == self.bills.count - 1 {
            cell?.isLastBill = true
        }
        cell!.bill = self.bills[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bill = self.bills[indexPath.row]
        if bill.empty {
            return
        }
        let detailVC = TMDetailTableViewController()
        detailVC.currentIndex = indexPath.row
        
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
    func didClickCategoryButton(indexPath: IndexPath) {
        self.selectedBill = self.bills[indexPath.row]
        if self.selectedBill!.empty {
            return
        }
        self.isMenuOpened = true
        self.timeLineCell = self.tableView.cellForRow(at: indexPath) as! TMTimeLineCell?
        let rect = self.tableView.rectForRow(at: indexPath)
        let rectInSuperView = self.tableView.convert(rect, to: self.tableView.superview)
        self.timeLineMenuView!.currenImage = self.timeLineCell!.categoryImageButton.currentImage
        self.timeLineMenuView!.showTimeLineMenuView(rect: rectInSuperView)
    }
    
    func setCellLabelVisibility(hidden: Bool) {
        self.timeLineCell?.setLabelInCellVisibility(hidden: hidden)
    }
    
    func clickDeleteButton() {
        
    }
    
    func clickUpdateButton() {
        
    }
    
    func didClickCreateButton() {
        let addBillVC = TMAddBillViewController()
        addBillVC.addBillDelegate = self
        let navi = UINavigationController(rootViewController: addBillVC)
        self.present(navi, animated: true, completion: nil)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.panGestureRecognizer.translation(in: self.tableView).y
        
        if y > 0 {
            self.dropDownLineView!.frame = CGRect(x: (screenSize().width - 1) / 2, y: -y, width: 1, height: y)
            self.tableView.bringSubview(toFront: self.dropDownLineView!)
            self.headerView!.animation(time: 1.0, angle: y)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if self.isMenuOpened {
            self.isMenuOpened = false
            self.timeLineMenuView?.dismiss()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let contentOffsetY = scrollView.contentOffset.y
        if contentOffsetY < -60 {
            self.didClickCreateButton()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func clickDismissButton(viewController: TMAddBillViewController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    deinit {
        self.token!.stop()
        NotificationCenter.default.removeObserver(self)
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
