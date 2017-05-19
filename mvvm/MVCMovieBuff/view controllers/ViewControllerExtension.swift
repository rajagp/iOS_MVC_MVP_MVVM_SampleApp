//
//  ViewControllerExtension.swift
//  MovieBuff
//
//  Created by Mac Tester on 11/6/16.
//  Copyright © 2016 Lunaria Software LLC. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD

extension UIViewController {
    func showErrorAlertWithTitle(_ title:String?, message:String) {
        
        let alertController = UIAlertController(title: title ?? "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            
        }
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }

    func showSuccessAlertWithTitle(_ title:String?, message:String) {
        
        let alertController = UIAlertController(title: title ?? "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            self.dismiss(animated: true, completion: {
                
            })
        }
        
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showDataLoadingProgressHUD() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func hideDataLoadingProgressHUD() {
        MBProgressHUD.hide(for: self.view, animated: true)
        UIApplication.shared.isNetworkActivityIndicatorVisible = false

    }
}
