//
//  CustomPickerView.swift
//  MovieBuff
//
//  Created by Mac Tester on 11/17/16.
//  Copyright © 2016 Lunaria Software LLC. All rights reserved.
//

import UIKit

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

protocol CustomPickerViewDelegate :NSObjectProtocol {
    func onDismissedWith(selection:String?)
    func onSelectionMade(selection:String?)
}
protocol CustomPickerViewDataSource :NSObjectProtocol {
    func pickerDataType()->PickerDataSource?
}

@IBDesignable  class CustomPickerView: UIView {
   /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    @IBOutlet weak var thePickerView: UIPickerView!
    weak var delegate:CustomPickerViewDelegate?
    weak var datasource:CustomPickerViewDataSource?
    
    fileprivate var selection:String?
    
    var view: UIView!
    
    func setUp() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CustomPickerView", bundle: bundle)
        view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        view.frame = bounds
        addSubview(view)
        self.setupConstraintsForContentView()
        self.thePickerView.delegate = self
        self.thePickerView.dataSource = self
    }
    
    
    
    override init(frame: CGRect) {
         super.init(frame: frame)
         setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setUp()
    }
    
    override func awakeFromNib() {
        print(#function)
        super.awakeFromNib()

       
    }
    
    private func setupConstraintsForContentView() {
        let xConstraint = NSLayoutConstraint.init(item: self, attribute:.centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1.0, constant: 0)
        
        let yConstraint = NSLayoutConstraint.init(item: self, attribute:.centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1.0, constant: 0)
        
        
        let widthConstraint = NSLayoutConstraint.init(item: self, attribute:.width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1.0, constant: 0)
        
        let heightConstraint = NSLayoutConstraint.init(item: self, attribute:.height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 1.0, constant: 0)
        
        self.addConstraints([xConstraint,yConstraint,widthConstraint,heightConstraint])
        
    }
    
    @IBAction func onDoneTapped(_ sender: UIButton) {
        self.delegate?.onDismissedWith(selection: selection)
    }
    
    @IBAction func onCancelTapped(_ sender: UIButton) {
          self.delegate?.onDismissedWith(selection: nil)
    }

    
}

//MARK : UIPickerViewDelegate

extension CustomPickerView :UIPickerViewDelegate{
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.datasource?.pickerDataType()?.values[row]
       
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selection = self.datasource?.pickerDataType()?.values[row]
        self.delegate?.onSelectionMade(selection: selection)
       
    }
}


// MARK:UIPickerViewDataSource

extension CustomPickerView :UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        guard self.datasource?.pickerDataType() != nil else {return 0}
         return 1
        
    }
    
    
    // returns the # of rows in each component..
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.datasource?.pickerDataType()?.values.count ?? 0
       
    }
    
    
    
}
