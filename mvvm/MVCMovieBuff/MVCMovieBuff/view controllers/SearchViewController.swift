//
//  SearchViewController.swift
//  MovieBuff
//
//  Created by Priya Rajagopal on 10/1/16.
//  Copyright © 2016 Lunaria Software LLC. All rights reserved.
//

import Foundation
import UIKit

//MARK: PickerDataSource
enum PickerDataSource {
    
    case yearPicker
    case typePicker
    
    var values:[String] {
        switch self {
        case .yearPicker:
            var _years:[String] = []
            let start = 1975
            var year = start
            while year < 2018 {
                _years.append("\(year)")
                year = year + 1
            }
            return _years
            
        case .typePicker:
            return ["Movie","Series","Episode"]
        }
    }
}


protocol SearchViewControllerProtocol {
    func searchCriteriaSelected(title:String,type:String?,year:String?)
}

class SearchViewController:UIViewController {
    
    var delegate:SearchViewControllerProtocol?
 
    @IBOutlet weak var containerView: UIScrollView!
    
    private var _typeCustomPickerView: CustomPickerView?
    var typeCustomPickerView: CustomPickerView {
        get {
            if _typeCustomPickerView == nil {
                _typeCustomPickerView = CustomPickerView(frame: CGRect(x: 0, y: self.view.frame.height - 256, width: self.view.frame.width, height: 256))
                
                _typeCustomPickerView?.delegate = self
                _typeCustomPickerView?.datasource = self
                
                
            }
            return _typeCustomPickerView!
        }
    }
 
    
    private var _yearCustomPickerView: CustomPickerView?
    
    var yearCustomPickerView: CustomPickerView {
        get {
            if _yearCustomPickerView == nil {
                _yearCustomPickerView = CustomPickerView(frame: CGRect(x: 0, y: self.view.frame.height - 256, width: self.view.frame.width, height: 256))
                
                _yearCustomPickerView?.delegate = self
                _yearCustomPickerView?.datasource = self
                
                
            }
            return _yearCustomPickerView!
        }
    }

    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var typeField: UITextField!
    @IBOutlet weak var yearField: UITextField!
    fileprivate var pickerType:PickerDataSource?
   

 }

extension SearchViewController{
    @IBAction func onApplySearch(_ sender: UIBarButtonItem) {
        if let delegate = delegate {
            delegate.searchCriteriaSelected(title: titleField.text!, type: typeField.text, year: yearField.text)
        }

    }
    
 }

//MARK:UITextFieldDelegate
extension SearchViewController:UITextFieldDelegate{
    public func textFieldDidEndEditing(_ textField: UITextField) {
    
        
    }
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == typeField {
            pickerType = PickerDataSource.typePicker
            self.containerView.addSubview(typeCustomPickerView)
            yearCustomPickerView.removeFromSuperview()
            
        }
        if textField == yearField {
            pickerType = PickerDataSource.yearPicker
            self.containerView.addSubview(yearCustomPickerView)
            typeCustomPickerView.removeFromSuperview()

        }
        
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == titleField {
            let length = (textField.text?.characters.count)! - range.length + string.characters.count
            if length == 0 {
                doneButton.isEnabled = false
            }
            else {
                 doneButton.isEnabled = true
            }
        }
        return true
        
    }
}

extension SearchViewController:CustomPickerViewDelegate {
    func onDismissedWith(selection:String?) {
        typeCustomPickerView.removeFromSuperview()
        yearCustomPickerView.removeFromSuperview()
        
        if pickerType == PickerDataSource.typePicker {
            typeField.text = selection
        }
        if pickerType == PickerDataSource.yearPicker{
            yearField.text = selection
        }     
        
    }
    func onSelectionMade(selection:String?) {
        
        if pickerType == PickerDataSource.typePicker {
              typeField.text = selection
        }
        if pickerType == PickerDataSource.yearPicker{
            yearField.text = selection
         }
    }

}

extension SearchViewController:CustomPickerViewDataSource {
    func values()->[Any]? {
        guard typeField != nil && yearField != nil else {return nil}
        return pickerType?.values
        
    }

}
