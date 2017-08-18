//
//  TMBaseViewController.swift
//  TimiAccount
//
//  Created by Zhihao Yuan on 2017/7/25.
//  Copyright © 2017年 Zhihao Yuan. All rights reserved.
//

import UIKit
import SnapKit


class TMBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.automaticallyAdjustsScrollViewInsets = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showNetworkIndicator() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func hideNetworkIndicator() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
    func prompt(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let alertAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.cancel, handler: nil)
        alertController.addAction(alertAction)
        self.present(alertController, animated: true, completion: nil)
    }

    func promptError(error: Error?) -> Bool {
        if error != nil {
            self.prompt(message: String(format: "%@", [error!]))
            return true
        }
        return false
    }
    
    func filterError(error: Error?) -> Bool {
        return self.promptError(error: error) == false
    }
    
    func runInMainQueue(block: @escaping () -> Void) {
        let queue = DispatchQueue.main
        queue.async(execute: block)
    }
    
    func runInGlobalQueue(block: @escaping () -> Void) {
        let queue = DispatchQueue.global()
        queue.async(execute: block)
    }
    
    func runAfter(seconds: Double, block: @escaping () -> Void) {
        let queue = DispatchQueue.main
        queue.asyncAfter(deadline: DispatchTime.now() + (seconds * Double(NSEC_PER_SEC)), execute: block)
    }
    
    func showSVProgressHUD(text: String) {
        SVProgressHUD.setMinimumDismissTimeInterval(0.5)
        SVProgressHUD.show(withStatus: text)
        SVProgressHUD.setFont(UIFont.systemFont(ofSize: 18))
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.gradient)
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
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
