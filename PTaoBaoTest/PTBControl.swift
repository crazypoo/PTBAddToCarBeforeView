//
//  PTBControl.swift
//  PTaoBaoTest
//
//  Created by 邓杰豪 on 2016/9/4.
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

fileprivate func <= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l <= r
  default:
    return !(rhs < lhs)
  }
}


protocol PTBControlDelegate {
    func closeTBAction()
    func confirmActionWithHowMuch(_ howMuch:NSString,integer:Int)
}

protocol PTBControlDataSource {
    func setControl(_ imageView:UIImageView,priceLabel:UILabel,storeLabel:UILabel,chooseLabel:UILabel,numberControl:PNumberChooseControl)
    func uniPriceInControl(_ control:PTBControl)->NSInteger
}

class PTBControl: UIControl {
    var _contentSize:CGSize?
    var _padding:CGFloat?
    var _fontSize:CGFloat?
    var _imageViewSize:CGFloat?
    var _imageView:UIImageView?
    var _closeButton:UIButton?
    var _priceLabel:UILabel?
    var _storeLabel:UILabel?
    var _chooseLabel:UILabel?
    var _confirmBtn:UIButton?
    var _numberControl:PNumberChooseControl?
    var delegate:PTBControlDelegate?
    var dataSource:PTBControlDataSource?
    var _topView:UIView?
    var _bottomView:UIView?
    var _topLineView:UIView?
    var _keyboardView:UIView?
    var _selectView:UIView?
    var _unitPrice:NSInteger?
    var _animateHeight:CGFloat?
    var _numberRect:CGRect?

    override init(frame: CGRect) {
        super.init(frame: frame)
        _contentSize = frame.size
        _padding = 8
        _fontSize = 14
        _imageViewSize = 100
        _animateHeight = 80

        _keyboardView = UIView.init(frame: CGRect(x: 0, y: 44, width: _contentSize!.width, height: 44))
        _keyboardView?.backgroundColor = UIColor.init(red: 209.0/255.0, green: 213.0/255.0, blue: 219.0/255.0, alpha: 1)
        let button = UIButton.init(type: .custom)
        button.frame = CGRect(x: _contentSize!.width - 60, y: 0, width: 60, height: 44)
        button.titleLabel?.font = UIFont.init(name: "AppleSDGothicNeo-Regular", size: 18)
        button.setTitle("完成", for: UIControlState())
        button.setTitleColor(UIColor.orange, for: UIControlState())
        button.backgroundColor = UIColor.clear
        _keyboardView?.addSubview(button)

        _topView = UIView.init(frame: CGRect(x: 0, y: 2 * _padding!, width: _contentSize!.width, height: _imageViewSize!))
        _topView?.backgroundColor = UIColor.white

        _bottomView = UIView.init(frame: CGRect(x: 0, y: _contentSize!.height + 44, width: _contentSize!.width, height: _contentSize!.height - _animateHeight!))
        _bottomView?.backgroundColor = UIColor.white
        _bottomView?.addSubview(_keyboardView!)

        _topLineView = lineViewWithFrame(CGRect(x: _padding!, y: _imageViewSize! + _padding! - 1, width: _contentSize!.width - 2 * _padding!,height: 1), color: UIColor.init(red: 209.0/255.0, green: 213.0/255.0, blue: 219.0/255.0, alpha: 1))

        _imageView = UIImageView.init(frame: CGRect(x: _padding!, y: 0 ,width: _imageViewSize!, height: _imageViewSize!))
        _imageView?.backgroundColor = UIColor.init(red: 209.0/255.0, green: 213.0/255.0, blue: 219.0/255.0, alpha: 1)
        _imageView?.layer.borderColor = UIColor.white.cgColor
        _imageView?.layer.borderWidth = 2
        _imageView?.layer.masksToBounds = true
        _imageView?.layer.cornerRadius = 4

        _priceLabel = UILabel.init(frame: CGRect(x: _padding! * 2 + _imageViewSize!, y: _padding! + 5,width: _contentSize!.width - _imageViewSize! - 3 * _padding!,height: 20))
        _priceLabel?.backgroundColor = UIColor.clear
        _priceLabel?.font = UIFont.init(name: "AppleSDGothicNeo-Regular", size: _fontSize!+1)
        _priceLabel?.text = "购买数量"
        _priceLabel?.textColor = UIColor.orange

        _storeLabel = UILabel.init(frame: CGRect(x: _padding! * 2 + _imageViewSize!, y: _padding! + 25, width: _contentSize!.width - _imageViewSize! - 3 * _padding!,height: 20))
        _storeLabel?.backgroundColor = UIColor.clear
        _storeLabel?.font = UIFont.init(name: "AppleSDGothicNeo-Regular", size: _fontSize!+1)
        _storeLabel?.text = "库存24044件"
        _storeLabel?.textColor = UIColor.black

        _chooseLabel = UILabel.init(frame: CGRect(x: _padding! * 2 + _imageViewSize!, y: _padding! + 45, width: _contentSize!.width - _imageViewSize! - 3 * _padding!,height: 20))
        _chooseLabel?.backgroundColor = UIColor.clear
        _chooseLabel?.font = UIFont.init(name: "AppleSDGothicNeo-Regular", size: _fontSize!+1)
        _chooseLabel?.text = "请选择颜色分类"
        _chooseLabel?.textColor = UIColor.black

        _closeButton = UIButton.init(type: .custom)
        _closeButton?.frame = CGRect(x: _contentSize!.width - 40, y: _padding! * 2 , width: 40, height: 40)
        _closeButton?.backgroundColor = UIColor.init(red: 209.0/255.0, green: 213.0/255.0, blue: 219.0/255.0, alpha: 1)
        _closeButton?.setImage(UIImage.init(named: "error"), for: UIControlState())
        _closeButton?.addTarget(self, action: #selector(self.closeButtonAction(_:)), for: .touchUpInside)

        _numberControl = PNumberChooseControl.init(frame: CGRect(x: _padding!, y: _padding!, width: _contentSize!.width - 2 * _padding!, height: 56))

        _selectView = UIView.init(frame:CGRect( x: 0, y: _imageViewSize! + _padding!, width: _contentSize!.width, height: _contentSize!.height - _imageViewSize! - _padding!))
        _selectView?.backgroundColor = UIColor.white

        _confirmBtn = UIButton.init(type: .custom)
        _confirmBtn?.frame = CGRect(x: 0, y: 0, width: _contentSize!.width, height: 50)
        _confirmBtn?.backgroundColor = UIColor.blue
        _confirmBtn?.titleLabel?.font = UIFont.init(name: "AppleSDGothicNeo-Regular", size: 18)
        _confirmBtn?.addTarget(self, action: #selector(self.confirmAct(_:)), for: .touchUpInside)

        _topView?.addSubview(_priceLabel!)
        _topView?.addSubview(_storeLabel!)
        _topView?.addSubview(_chooseLabel!)

        self.addSubview(_topView!)
        self.addSubview(_topLineView!)
        self.addSubview(_closeButton!)
        self.addSubview(_imageView!)
        self.addSubview(_selectView!)
        self.addSubview(_confirmBtn!)
        self.backgroundColor = UIColor.clear

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func closeButtonAction(_ sender:UIButton)
    {
        if delegate != nil {
            delegate?.closeTBAction()
        }
    }

    func confirmAct(_ sender:UIButton)
    {
        let combined = _unitPrice!*(_numberControl?.currentValue())!
        if delegate != nil {
            delegate?.confirmActionWithHowMuch(String(combined) as NSString, integer: (_numberControl?.currentValue())!)
            delegate?.closeTBAction()
        }
    }

    func configScrollView()
    {
        for subview in _selectView!.subviews {
            subview.removeFromSuperview()
        }
        var size = _selectView?.frame.size
        var rect = _numberControl?.frame
        if (size!.height - rect!.size.height - 2 * _padding! <= _selectView!.bounds.size.height) {
        }
        rect?.origin.y = (size?.height)! + _padding!
        _numberControl?.frame = CGRect(x: 0, y: ((_selectView?.frame.size.height)! - _numberControl!.frame.size.height - _confirmBtn!.frame.size.height)/2, width: _contentSize!.width, height: 50)
        _confirmBtn!.frame = CGRect(x: 0, y: _contentSize!.height-50, width: _contentSize!.width, height: 50);
        size?.height += (_numberControl?.frame.size.height)! + 1 * _padding!
        size?.height += _padding!
        if size?.height <= _selectView?.bounds.size.height {
            size?.height = (_selectView?.bounds.height)!
        }
        _selectView?.addSubview(_numberControl!)
        _numberRect = _numberControl?.frame
    }

    func reloadData()
    {
        configScrollView()
        if dataSource != nil {
            dataSource?.setControl(_imageView!, priceLabel: _priceLabel!, storeLabel: _storeLabel!, chooseLabel: _chooseLabel!, numberControl: _numberControl!)
        }
        _unitPrice = dataSource?.uniPriceInControl(self)
    }

    func setup()
    {
        NotificationCenter.default.addObserver(self, selector: #selector(self.TPKeyboardAvoiding_keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.TPKeyboardAvoiding_keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    func TPKeyboardAvoiding_keyboardWillShow(_ notification:Notification)
    {
        let keyboardRect = self.convert(((((notification as NSNotification).userInfo! as NSDictionary).object(forKey: "UIKeyboardBoundsUserInfoKey") as AnyObject).cgRectValue)!, from: nil)
        if keyboardRect.isEmpty {
            return
        }
        _selectView?.frame = CGRect(x: 0, y: _animateHeight! , width: _contentSize!.width, height: 56 + 2 * _padding!)
        self.addSubview(_bottomView!)
        UIView.animate(withDuration: ((((notification as NSNotification).userInfo! as NSDictionary).object(forKey: UIKeyboardAnimationDurationUserInfoKey) as AnyObject).doubleValue)!, delay: 0, options: .curveEaseIn, animations: {
            self._bottomView?.frame = CGRect(x: 0, y: self._animateHeight! + 56 , width: self._contentSize!.width,  height: self._contentSize!.height)
            self._imageView?.frame = CGRect(x: self._padding!, y: self._padding! , width: self._animateHeight!-2*self._padding!, height: self._animateHeight!-2*self._padding!)
            self._closeButton!.frame = CGRect(x: self._contentSize!.width - 40, y: 0 , width: 40, height: 40)
            self._topView!.frame = CGRect(x: 0, y: 0, width: self._contentSize!.width, height: self._animateHeight!)
            self._priceLabel!.frame = CGRect(x: self._animateHeight!, y: self._padding!,width: self._contentSize!.width - self._animateHeight! - self._padding!,height: 20)
            self._storeLabel!.frame = CGRect(x: self._animateHeight!, y: self._padding! + 20, width: self._contentSize!.width - self._animateHeight! - self._padding!,height: 20)
            self._chooseLabel!.frame = CGRect(x: self._animateHeight!, y: self._padding! + 40, width: self._contentSize!.width - self._animateHeight! - self._padding!,height: 20)
            }) { (finish) in

        }
    }

    func TPKeyboardAvoiding_keyboardWillHide(_ notification:Notification)
    {
        let keyboardRect = self.convert(((((notification as NSNotification).userInfo! as NSDictionary).object(forKey: "UIKeyboardBoundsUserInfoKey") as AnyObject).cgRectValue)!, from: nil)
        if keyboardRect.isEmpty {
            return
        }
        _bottomView?.removeFromSuperview()
        _selectView?.frame = CGRect(x: 0, y: _imageViewSize! + _padding!, width: _contentSize!.width, height: _contentSize!.height - _imageViewSize! - _padding!)
        UIView.animate(withDuration: ((((notification as NSNotification).userInfo! as NSDictionary).object(forKey: UIKeyboardAnimationDurationUserInfoKey) as AnyObject).doubleValue)!, delay: 0, options: .curveEaseOut, animations: { 
            self._imageView!.frame = CGRect(x: self._padding!, y: 0 ,width: self._imageViewSize!, height: self._imageViewSize!)
            self._closeButton!.frame = CGRect(x: self._contentSize!.width - 40, y: self._padding! * 2 , width: 40, height: 40)
            self._topView!.frame = CGRect(x: 0, y: 2 * self._padding!, width: self._contentSize!.width, height: self._imageViewSize!)
            self._priceLabel!.frame = CGRect(x: self._padding! * 2 + self._imageViewSize!,y: self._padding! + 5, width: self._contentSize!.width - self._imageViewSize! - 3 * self._padding!,height: 20)
            self._storeLabel!.frame = CGRect(x: self._padding! * 2 + self._imageViewSize!, y: self._padding! + 25, width: self._contentSize!.width - self._imageViewSize! - 3 * self._padding!,height: 20)
            self._chooseLabel!.frame = CGRect(x: self._padding! * 2 + self._imageViewSize!, y: self._padding! + 45, width: self._contentSize!.width - self._imageViewSize! - 3 * self._padding!,height: 20)
            }) { (finish) in
                self._bottomView!.frame = CGRect(x: 0, y: self._contentSize!.height + 44, width: self._contentSize!.width,height: self._contentSize!.height - self._animateHeight!);
        }
    }

    func lineViewWithFrame(_ frame:CGRect,color:UIColor)->UIView
    {
        let view = UIView.init(frame: frame)
        view.backgroundColor = color
        return view
    }
}
