//
//  TMRemarkViewController.swift
//  TimiAccount
//
//  Created by Zhihao Yuan on 30/08/2017.
//  Copyright © 2017 Zhihao Yuan. All rights reserved.
//

import UIKit

let maxCharacters = 50

class TMRemarkViewController: TMBaseViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var bill: TMBill? = nil
    
    var passValueBlock: ((String?, Data?) -> Void)? = nil
    
    var timeLabel: UILabel? = nil
    
    var contentTextView: UITextView? = nil
    
    var accessoryView: UIView? = nil
    
    var cameraButton: UIButton? = nil
    
    var limitLabel: UILabel? = nil
    
    var actionSheetView: TMActionSheetView? = nil
    
    var isActionSheetDisplayed: Bool = false
    
    lazy var imagePicker: UIImagePickerController = {
        let ip = UIImagePickerController()
        ip.delegate = self
        return ip
    }()
    
    var remark: String? = nil
    
    var iconData: Data? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        self.setupNavigationBar()
        self.layoutSubviews()
        self.registerNotification()
        self.handleActionSheetEvent()
        self.isActionSheetDisplayed = false
        self.contentTextView?.text = self.bill?.remark
        self.remark = self.bill?.remark
        self.iconData = self.bill?.remarkIcon
        if self.bill?.remarkIcon != nil {
            self.cameraButton?.setImage(UIImage(data: self.bill!.remarkIcon!), for: UIControlState.normal)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.contentTextView?.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func setupNavigationBar() {
        let cancelButton = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        cancelButton.setImage(UIImage(named: "btn_item_close"), for: UIControlState.normal)
        cancelButton.addTarget(self, action: #selector(clickCameraButton(sender:)), for: UIControlEvents.touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: cancelButton)
        self.title = "Remark"
        
        let completeButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 30))
        completeButton.setTitle("Complete", for: UIControlState.normal)
        completeButton.titleLabel?.font = UIFont.systemFont(ofSize: 15.0)
        completeButton.setTitleColor(lineColor(), for: UIControlState.normal)
        completeButton.addTarget(self, action: #selector(clickCompleteButton(sender:)), for: UIControlEvents.touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: completeButton)
    }
    
    func layoutSubviews() {
        self.timeLabel = {
            let label = UILabel()
            self.view.addSubview(label)
            label.snp.makeConstraints({ [weak self] (ConstraintMaker) in
                ConstraintMaker.size.equalTo(CGSize(width: screenSize().width, height: 30))
                ConstraintMaker.left.equalTo(self!.view).offset(10)
                ConstraintMaker.top.equalTo(self!.getMaxYOfNavigationBar())
            })
            label.font = UIFont.systemFont(ofSize: 14.0)
            label.textColor = UIColor(white: 0.800, alpha: 1.000)
            label.text = self.bill?.date
            return label
        }()
        
        self.contentTextView = {
            let tv = UITextView()
            self.view.addSubview(tv)
            tv.snp.makeConstraints({ [weak self] (ConstraintMaker) in
                ConstraintMaker.size.equalTo(CGSize(width: screenSize().width, height: 300))
                ConstraintMaker.left.equalTo(self!.timeLabel!.snp.left)
                ConstraintMaker.top.equalTo(self!.timeLabel!.snp.bottom)
            })
            tv.delegate = self
            tv.font = UIFont.systemFont(ofSize: 20.0)
            return tv
        }()
        
        self.accessoryView = {
            let view = UIView()
            self.view.addSubview(view)
            view.snp.makeConstraints({ [weak self] (ConstraintMaker) in
                ConstraintMaker.size.equalTo(CGSize(width: screenSize().width, height: 50))
                ConstraintMaker.left.bottom.equalTo(self!.view)
            })
            return view
        }()
        
        self.cameraButton = {
            let button = UIButton()
            self.accessoryView?.addSubview(button)
            button.snp.makeConstraints({ [weak self] (ConstraintMaker) in
                ConstraintMaker.size.equalTo(CGSize(width: 40, height: 40))
                ConstraintMaker.left.equalTo(self!.timeLabel!)
                ConstraintMaker.bottom.equalTo(self!.accessoryView!).offset(-10)
            })
            button.setBackgroundImage(UIImage(named: "btn_camera"), for: UIControlState.normal)
            button.addTarget(self, action: #selector(clickCameraButton(sender:)), for: UIControlEvents.touchUpInside)
            return button
        }()
        
        self.limitLabel = {
            let label = UILabel()
            self.accessoryView?.addSubview(label)
            label.snp.makeConstraints({ [weak self] (ConstraintMaker) in
                ConstraintMaker.size.equalTo(CGSize(width: 60, height: 30))
                ConstraintMaker.right.equalTo(self!.accessoryView!).offset(-20)
                ConstraintMaker.bottom.equalTo(self!.accessoryView!).offset(-10)
            })
            label.textColor = lineColor()
            label.text = "0/50"
            return label
        }()
        
        self.actionSheetView = {
            let view = TMActionSheetView()
            self.view.addSubview(view)
            view.snp.makeConstraints({ [weak self] (ConstraintMaker) in
                ConstraintMaker.size.equalTo(CGSize(width: screenSize().width, height: 0))
                ConstraintMaker.left.bottom.right.equalTo(self!.view)
            })
            view.backgroundColor = UIColor(red: 0.93, green: 0.93, blue: 0.93, alpha: 1.00)
            return view
        }()
    }
    
    func handleActionSheetEvent() {
        self.actionSheetView?.cancelButtonBlock = { [weak self] in
            self?.actionSheetView?.snp.updateConstraints({ (ConstraintMaker) in
                ConstraintMaker.size.equalTo(CGSize(width: screenSize().width, height: 0))
            })
            self?.view.layoutIfNeeded()
            self?.contentTextView?.becomeFirstResponder()
            self?.view.backgroundColor = UIColor.white
            self?.contentTextView?.backgroundColor = UIColor.white
            self?.isActionSheetDisplayed = false
        }
        
        self.actionSheetView?.albumButtonBlock = { [weak self] in
            self?.loadPhotos()
        }
        
        self.actionSheetView?.cameraButtonBlock = { [weak self] in
            self?.useCamera()
        }
    }
    
    func useCamera() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            self.imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureMode.photo
            self.imagePicker.showsCameraControls = true
            self.imagePicker.cameraDevice = UIImagePickerControllerCameraDevice.rear
            self.imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashMode.auto
            self.present(self.imagePicker, animated: true, completion: nil)
        } else {
            self.showSVProgressHUD(text: "Camera Unavaliable!")
        }
    }
    
    func loadPhotos() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            self.imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            self.present(self.imagePicker, animated: true, completion: nil)
        }
    }
    
    func clickCameraButton(sender: UIButton) {
        self.view.endEditing(true)
        UIView.animate(withDuration: 0.5, animations: {
            self.actionSheetView?.snp.updateConstraints({ (ConstraintMaker) in
                ConstraintMaker.size.equalTo(CGSize(width: screenSize().width, height: 180))
            })
            self.view.layoutIfNeeded()
        }) { (Bool) in
            self.view.backgroundColor = UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 1.00)
            self.contentTextView?.backgroundColor = UIColor(red: 0.87, green: 0.87, blue: 0.87, alpha: 1.00)
            self.isActionSheetDisplayed = true
        }
    }
    
    func clickCancelButton(sender: UIButton) {
        if self.contentTextView!.text.characters.count > maxCharacters {
            self.showSVProgressHUD(text: "Exceed max word limitation!")
            return
        }
        self.dismiss(animated: true) { [weak self] in
            if self?.passValueBlock != nil {
                self?.passValueBlock!(self!.remark, self!.iconData)
            }
        }
    }
    
    func clickCompleteButton(sender: UIButton) {
        self.clickCancelButton(sender: sender)
    }
    
    func keyboardWillShow(notification: Notification) {
        let rect = notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! CGRect
        let keyboardY = rect.origin.y
        let cameraButtonY = self.accessoryView?.frame.maxY
        let delta = cameraButtonY! - keyboardY
        UIView.animate(withDuration: notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! TimeInterval) { 
            self.accessoryView?.snp.updateConstraints({ [weak self] (ConstraintMaker) in
                ConstraintMaker.bottom.equalTo(self!.view).offset(-delta)
            })
            self.view.layoutIfNeeded()
        }
    }
    
    func keyboardWillHide() {
        self.accessoryView?.snp.updateConstraints({ [weak self] (ConstraintMaker) in
            ConstraintMaker.bottom.equalTo(self!.view)
            self?.view.layoutIfNeeded()
        })
    }
    
    func textViewDidChange(_ textView: UITextView) {
        self.remark = textView.text
        self.limitLabel?.text = String(format: "%lu/%lu", textView.text.characters.count, maxCharacters)
        if textView.text.characters.count > maxCharacters {
            self.limitLabel?.textColor = UIColor.red
        } else {
            self.limitLabel?.textColor = lineColor()
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if self.isActionSheetDisplayed {
            self.isActionSheetDisplayed = false
            self.actionSheetView!.snp.updateConstraints({ (ConstraintMaker) in
                ConstraintMaker.size.equalTo(CGSize(width: screenSize().width, height: 0))
            })
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.white
            self.contentTextView?.backgroundColor = UIColor.white
        }
        return true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.cameraButton?.setBackgroundImage(info[UIImagePickerControllerOriginalImage] as! UIImage, for: UIControlState.normal)
        let data = UIImageJPEGRepresentation(info[UIImagePickerControllerOriginalImage] as! UIImage, 0.8)
        self.iconData = data
        self.dismiss(animated: true, completion: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func getMaxYOfNavigationBar() -> CGFloat {
        return (self.navigationController?.navigationBar.frame.maxY)! + UIApplication.shared.statusBarFrame.maxY
    }
}
