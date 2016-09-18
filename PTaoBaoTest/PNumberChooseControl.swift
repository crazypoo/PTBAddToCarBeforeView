//
//  PNumberChooseControl.swift
//  PTaoBaoTest
//
//  Created by 邓杰豪 on 2016/9/3.
//  Copyright © 2016年 邓杰豪. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}

fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}


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

        tipLabel = UILabel.init(frame: CGRect(x: _padding!, y: _padding!, width: 120, height: _contentSize!.height - 2 * _padding!))
        tipLabel?.backgroundColor = UIColor.clear
        tipLabel?.font = UIFont.init(name: "AppleSDGothicNeo-Regular", size: _fontSize! - 3)
        tipLabel?.text = "购买数量"
        self.addSubview(tipLabel!)

        decreaseButton = UIButton.init(type: .custom)
        decreaseButton?.frame = CGRect(x: _contentSize!.width - 130 , y: _padding!, width: 40, height: 40)
        decreaseButton?.titleLabel?.font = UIFont.boldSystemFont(ofSize: _fontSize!)
        decreaseButton?.setTitle("-", for: UIControlState())
        decreaseButton?.setTitleColor(UIColor.black, for: UIControlState())
        decreaseButton?.setTitleColor(UIColor.lightGray, for: .highlighted)
        decreaseButton?.setTitleColor(UIColor.lightGray, for: .selected)
        decreaseButton?.setTitleColor(UIColor.lightGray, for: .disabled)
        decreaseButton?.layer.borderWidth = 1
        decreaseButton?.layer.borderColor = UIColor.init(red: 209.0/255.0, green: 213.0/255.0, blue: 219.0/255.0, alpha: 1).cgColor
        decreaseButton?.addTarget(self, action: #selector(self.decreaseButtonAction(_:)), for: .touchUpInside)
        self.addSubview(decreaseButton!)

        textField = UITextField.init(frame: CGRect(x: _contentSize!.width - 90 - 1, y: _padding!, width: 50, height: 40))
        textField?.font = UIFont.init(name: "AppleSDGothicNeo-Regular", size: _fontSize!)
        textField?.backgroundColor = UIColor.clear
        textField?.textAlignment = .center
        textField?.layer.borderWidth = 1
        textField?.delegate = self
        textField?.text = "1"
        textField?.keyboardType = .numberPad
        textField?.layer.borderColor = UIColor.init(red: 209.0/255.0, green: 213.0/255.0, blue: 219.0/255.0, alpha: 1).cgColor
        textField?.isEnabled = false
        self.addSubview(textField!)

        increaseButton = UIButton.init(type: .custom)
        increaseButton?.frame = CGRect(x: _contentSize!.width - 40 - 2, y: _padding!, width: 40, height: 40)
        increaseButton?.titleLabel?.font = UIFont.boldSystemFont(ofSize: _fontSize!)
        increaseButton?.setTitle("+", for: UIControlState())
        increaseButton?.setTitleColor(UIColor.black, for: UIControlState())
        increaseButton?.setTitleColor(UIColor.lightGray, for: .highlighted)
        increaseButton?.setTitleColor(UIColor.lightGray, for: .selected)
        increaseButton?.setTitleColor(UIColor.lightGray, for: .disabled)
        increaseButton?.layer.borderWidth = 1
        increaseButton?.layer.borderColor = UIColor.init(red: 209.0/255.0, green: 213.0/255.0, blue: 219.0/255.0, alpha: 1).cgColor
        increaseButton?.addTarget(self, action: #selector(self.increaseButtonAction(_:)), for: .touchUpInside)
        self.addSubview(increaseButton!)

        _minNumber = 1
        _maxNumber = 100000
        self.backgroundColor = UIColor.clear
    }

    func enableButtonWithValue(_ currentNumber:NSInteger)
    {
        increaseButton?.isEnabled = (currentNumber < _maxNumber)
        decreaseButton?.isEnabled = (currentNumber > _minNumber)
    }

    func setMaxNumber(_ maxNumber:NSInteger)
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

    func setMinNumber(_ minNumber:NSInteger)
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

    func decreaseButtonAction(_ sender:UIButton)
    {
        let currentNumber = Int((textField?.text!)!)
        let b = currentNumber! - 1
        if b >= _minNumber {
            _currnetValue = b
        }
        enableButtonWithValue(b)
    }

    func increaseButtonAction(_ sender:UIButton)
    {
        let currentNumber = Int((textField?.text!)!)
        var b = currentNumber! + 1
        if b <= _maxNumber {
            _currnetValue = b
        }
        else
        {
            b = _maxNumber!
        }
        enableButtonWithValue(b)
    }

    func setCurrentValue(_ currentValue:NSInteger)
    {
        var result = currentValue
        if (result > _maxNumber || result < _minNumber) {
            result = _minNumber!
        }
        textField?.text = String(result)
    }

    func inputTextField(_ text:UITextField) -> UITextField {
        return textField!
    }

    func leftTipLabel(_ label:UILabel)->UILabel
    {
        return tipLabel!
    }

    func currentValue()->NSInteger
    {
        let currentNumber = Int((textField?.text!)!)
        return currentNumber!
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == nil {
            _currnetValue = _minNumber
            enableButtonWithValue(_currnetValue!)
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let result = NSMutableString()
        result.setString(textField.text!)
        result.replaceCharacters(in: range, with: string)
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
