//
//  TMDetailTableViewController.swift
//  TimiAccount
//
//  Created by Zhihao Yuan on 27/08/2017.
//  Copyright © 2017 Zhihao Yuan. All rights reserved.
//

import UIKit

let cellID = "detailViewCell"

let TMEditBtnTitleColor = UIColor(white: 0.575, alpha: 1.000)

class TMDetailTableViewController: TMBaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var currentIndex: Int = 0
    
    var tableView: UITableView? = nil
    
    lazy var bills = { () -> [TMBill] in 
        var arr: [TMBill] = []
        let results = TMDataManager.dataManager.gainAllBills(bookID: String.getSelectedBookID())
        for bill in results! {
            arr.append(bill)
        }
        return Array<TMBill>.sortArrayByDate(array: arr, ascending: false)
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupNavigationBar()
        self.layoutSubviews()
        self.tableView?.setContentOffset(CGPoint(x: 0, y: currentIndex * Int(screenSize().height)), animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.subviews[0].alpha = 0.0
    }
    
    func setupNavigationBar() {
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        backButton.setImage(UIImage(named: "back_light"), for: UIControlState.normal)
        backButton.addTarget(self, action: #selector(dismissView), for: UIControlEvents.touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    func layoutSubviews() {
        self.tableView = UITableView()
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.showsVerticalScrollIndicator = false
        self.tableView?.isPagingEnabled = true
        self.tableView?.bounces = false
        self.tableView?.separatorStyle = UITableViewCellSeparatorStyle.none
        self.tableView?.rowHeight = screenSize().height
        self.tableView?.register(TMDetailTableViewCell.self, forCellReuseIdentifier: cellID)
        self.view.addSubview(self.tableView!)
        
        self.tableView!.snp.makeConstraints { [weak self] (ConstraintMaker) in
            ConstraintMaker.edges.equalTo(self!.view)
        }
        
        let shareButton = UIButton()
        shareButton.addTarget(self, action: #selector(clickShareButton(sender:)), for: UIControlEvents.touchUpInside)
        shareButton.setBackgroundImage(UIImage(named: "button_edge"), for: UIControlState.normal)
        shareButton.setTitle("Share", for: UIControlState.normal)
        shareButton.setTitleColor(TMEditBtnTitleColor, for: UIControlState.normal)
        self.view.addSubview(shareButton)
        shareButton.snp.makeConstraints { [weak self] (ConstraintMaker) in
            ConstraintMaker.size.equalTo(CGSize(width: 60, height: 60))
            ConstraintMaker.right.bottom.equalTo(self!.view).offset(-10)
        }
        
        let editButton = UIButton()
        editButton.addTarget(self, action: #selector(clickEditButton(sender:)), for: UIControlEvents.touchUpInside)
        editButton.setBackgroundImage(UIImage(named: "button_edge"), for: UIControlState.normal)
        editButton.setTitle("Edit", for: UIControlState.normal)
        editButton.setTitleColor(TMEditBtnTitleColor, for: UIControlState.normal)
        self.view.addSubview(editButton)
        editButton.snp.makeConstraints { (ConstraintMaker) in
            ConstraintMaker.size.equalTo(shareButton)
            ConstraintMaker.right.equalTo(shareButton.snp.left).offset(-30)
            ConstraintMaker.bottom.equalTo(shareButton)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func clickShareButton(sender: UIButton) {
        
    }
    
    func clickEditButton(sender: UIButton) {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bills.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! TMDetailTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.detailBill = self.bills[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.currentIndex = indexPath.row
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
