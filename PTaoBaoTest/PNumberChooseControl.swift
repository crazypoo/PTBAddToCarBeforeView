//
//  PNumberChooseControl.swift
//  PTaoBaoTest
//
//  Created by 邓杰豪 on 2016/9/3.
//  Copyright © 2016年 邓杰豪. All rights reserved.
//

import UIKit

class PNumberChooseControl: UIControl,UITextFieldDelegate {

    var _minNumber:NSInteger?
    var _maxNumber:NSInteger?
    var _currnetValue:NSInteger?
    var inputTextField:UITextField?
    var leftTipLabel:UILabel?
    var tipLabel:UILabel?
    var decreaseButton:UIButton?
    var increaseButton:UIButton?
    var textField:UITextField?
    var _contentSize:CGSize?
    var _padding:CGFloat?
    var _fontSize:CGFloat?

    override init(frame: CGRect) {
        super.init(frame: frame)
        _contentSize = frame.size
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func commonInit()
    {
        _padding = 8.0
        _fontSize = 20.0

        tipLabel = UILabel.init(frame: CGRectMake(_padding!, _padding!, 120, _contentSize!.height - 2 * _padding!))
        tipLabel?.backgroundColor = UIColor.clearColor()
        tipLabel?.font = UIFont.init(name: "AppleSDGothicNeo-Regular", size: _fontSize! - 3)
        tipLabel?.text = "购买数量"
        self.addSubview(tipLabel!)

        decreaseButton = UIButton.init(type: .Custom)
        decreaseButton?.frame = CGRectMake(_contentSize!.width - 130 , _padding!, 40, 40)
        decreaseButton?.titleLabel?.font = UIFont.boldSystemFontOfSize(_fontSize!)
        decreaseButton?.setTitle("-", forState: .Normal)
        decreaseButton?.setTitleColor(UIColor.blackColor(), forState: .Normal)
        decreaseButton?.setTitleColor(UIColor.lightGrayColor(), forState: .Highlighted)
        decreaseButton?.setTitleColor(UIColor.lightGrayColor(), forState: .Selected)
        decreaseButton?.setTitleColor(UIColor.lightGrayColor(), forState: .Disabled)
        decreaseButton?.layer.borderWidth = 1
        decreaseButton?.layer.borderColor = UIColor.init(red: 209.0/255.0, green: 213.0/255.0, blue: 219.0/255.0, alpha: 1).CGColor
        decreaseButton?.addTarget(self, action: #selector(self.decreaseButtonAction(_:)), forControlEvents: .TouchUpInside)
        self.addSubview(decreaseButton!)

        textField = UITextField.init(frame: CGRectMake(_contentSize!.width - 90 - 1, _padding!, 50, 40))
        textField?.font = UIFont.init(name: "AppleSDGothicNeo-Regular", size: _fontSize!)
        textField?.backgroundColor = UIColor.clearColor()
        textField?.textAlignment = .Center
        textField?.layer.borderWidth = 1
        textField?.delegate = self
        textField?.text = "1"
        textField?.keyboardType = .NumberPad
        textField?.layer.borderColor = UIColor.init(red: 209.0/255.0, green: 213.0/255.0, blue: 219.0/255.0, alpha: 1).CGColor
        textField?.enabled = false
        self.addSubview(textField!)

        increaseButton = UIButton.init(type: .Custom)
        increaseButton?.frame = CGRectMake(_contentSize!.width - 40 - 2, _padding!, 40, 40)
        increaseButton?.titleLabel?.font = UIFont.boldSystemFontOfSize(_fontSize!)
        increaseButton?.setTitle("+", forState: .Normal)
        increaseButton?.setTitleColor(UIColor.blackColor(), forState: .Normal)
        increaseButton?.setTitleColor(UIColor.lightGrayColor(), forState: .Highlighted)
        increaseButton?.setTitleColor(UIColor.lightGrayColor(), forState: .Selected)
        increaseButton?.setTitleColor(UIColor.lightGrayColor(), forState: .Disabled)
        increaseButton?.layer.borderWidth = 1
        increaseButton?.layer.borderColor = UIColor.init(red: 209.0/255.0, green: 213.0/255.0, blue: 219.0/255.0, alpha: 1).CGColor
        increaseButton?.addTarget(self, action: #selector(self.increaseButtonAction(_:)), forControlEvents: .TouchUpInside)
        self.addSubview(increaseButton!)

        _minNumber = 1
        _maxNumber = 100000
        self.backgroundColor = UIColor.clearColor()
    }

    func enableButtonWithValue(currentNumber:NSInteger)
    {
        increaseButton?.enabled = (currentNumber < _maxNumber)
        decreaseButton?.enabled = (currentNumber > _minNumber)
    }

    func setMaxNumber(maxNumber:NSInteger)
    {
        _maxNumber = maxNumber
        let currentNumber = Int((textField?.text!)!)
        if currentNumber > _maxNumber
        {
            _currnetValue = currentNumber
            _maxNumber = currentNumber

        }
        enableButtonWithValue(currentNumber!)
    }

    func setMinNumber(minNumber:NSInteger)
    {
        _minNumber = minNumber
        let currentNumber = Int((textField?.text!)!)
        if currentNumber > _minNumber
        {
            _currnetValue = currentNumber
            _minNumber = currentNumber

        }
        enableButtonWithValue(currentNumber!)

    }

    func decreaseButtonAction(sender:UIButton)
    {
        let currentNumber = Int((textField?.text!)!)
        currentNumber! - 1
        if currentNumber >= _minNumber {
            _currnetValue = currentNumber
        }
        enableButtonWithValue(currentNumber!)
    }

    func increaseButtonAction(sender:UIButton)
    {
        var currentNumber = Int((textField?.text!)!)
        currentNumber! + 1
        if currentNumber <= _maxNumber {
            _currnetValue = currentNumber
        }
        else
        {
            currentNumber = _maxNumber
        }
        enableButtonWithValue(currentNumber!)
    }

    func setCurrentValue(currentValue:NSInteger)
    {
        var result = currentValue
        if (result > _maxNumber || result < _minNumber) {
            result = _minNumber!
        }
        textField?.text = String(result)
    }

    func inputTextField(text:UITextField) -> UITextField {
        return textField!
    }

    func leftTipLabel(label:UILabel)->UILabel
    {
        return tipLabel!
    }

    func currentValue()->NSInteger
    {
        let currentNumber = Int((textField?.text!)!)
        return currentNumber!
    }

    func textFieldDidEndEditing(textField: UITextField) {
        if textField.text == nil {
            _currnetValue = _minNumber
            enableButtonWithValue(_currnetValue!)
        }
    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let result = NSMutableString()
        result.setString(textField.text!)
        result.replaceCharactersInRange(range, withString: string)
        if result.length == 0 {
            return true
        }
        let currentNumber = Int(result as String)
        if currentNumber <= _maxNumber && currentNumber >= _minNumber {
            enableButtonWithValue(currentNumber!)
            return true
        }
        return false
    }
}
