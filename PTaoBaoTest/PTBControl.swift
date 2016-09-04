//
//  PTBControl.swift
//  PTaoBaoTest
//
//  Created by 邓杰豪 on 2016/9/4.
//  Copyright © 2016年 邓杰豪. All rights reserved.
//

import UIKit

protocol PTBControlDelegate {
    func closeTBAction()
    func confirmActionWithHowMuch(howMuch:NSString,integer:Int)
}

protocol PTBControlDataSource {
    func setControl(imageView:UIImageView,priceLabel:UILabel,storeLabel:UILabel,chooseLabel:UILabel,numberControl:PNumberChooseControl)
    func uniPriceInControl(control:PTBControl)->NSInteger
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

        _keyboardView = UIView.init(frame: CGRectMake(0, 44, _contentSize!.width, 44))
        _keyboardView?.backgroundColor = UIColor.init(red: 209.0/255.0, green: 213.0/255.0, blue: 219.0/255.0, alpha: 1)
        let button = UIButton.init(type: .Custom)
        button.frame = CGRectMake(_contentSize!.width - 60, 0, 60, 44)
        button.titleLabel?.font = UIFont.init(name: "AppleSDGothicNeo-Regular", size: 18)
        button.setTitle("完成", forState: .Normal)
        button.setTitleColor(UIColor.orangeColor(), forState: .Normal)
        button.backgroundColor = UIColor.clearColor()
        _keyboardView?.addSubview(button)

        _topView = UIView.init(frame: CGRectMake(0, 2 * _padding!, _contentSize!.width, _imageViewSize!))
        _topView?.backgroundColor = UIColor.whiteColor()

        _bottomView = UIView.init(frame: CGRectMake(0, _contentSize!.height + 44, _contentSize!.width, _contentSize!.height - _animateHeight!))
        _bottomView?.backgroundColor = UIColor.whiteColor()
        _bottomView?.addSubview(_keyboardView!)

        _topLineView = lineViewWithFrame(CGRectMake(_padding!, _imageViewSize! + _padding! - 1, _contentSize!.width - 2 * _padding!,1), color: UIColor.init(red: 209.0/255.0, green: 213.0/255.0, blue: 219.0/255.0, alpha: 1))

        _imageView = UIImageView.init(frame: CGRectMake(_padding!, 0 ,_imageViewSize!, _imageViewSize!))
        _imageView?.backgroundColor = UIColor.init(red: 209.0/255.0, green: 213.0/255.0, blue: 219.0/255.0, alpha: 1)
        _imageView?.layer.borderColor = UIColor.whiteColor().CGColor
        _imageView?.layer.borderWidth = 2
        _imageView?.layer.masksToBounds = true
        _imageView?.layer.cornerRadius = 4

        _priceLabel = UILabel.init(frame: CGRectMake(_padding! * 2 + _imageViewSize!, _padding! + 5,_contentSize!.width - _imageViewSize! - 3 * _padding!,20))
        _priceLabel?.backgroundColor = UIColor.clearColor()
        _priceLabel?.font = UIFont.init(name: "AppleSDGothicNeo-Regular", size: _fontSize!+1)
        _priceLabel?.text = "购买数量"
        _priceLabel?.textColor = UIColor.orangeColor()

        _storeLabel = UILabel.init(frame: CGRectMake(_padding! * 2 + _imageViewSize!, _padding! + 25, _contentSize!.width - _imageViewSize! - 3 * _padding!,20))
        _storeLabel?.backgroundColor = UIColor.clearColor()
        _storeLabel?.font = UIFont.init(name: "AppleSDGothicNeo-Regular", size: _fontSize!+1)
        _storeLabel?.text = "库存24044件"
        _storeLabel?.textColor = UIColor.blackColor()

        _chooseLabel = UILabel.init(frame: CGRectMake(_padding! * 2 + _imageViewSize!, _padding! + 45, _contentSize!.width - _imageViewSize! - 3 * _padding!,20))
        _chooseLabel?.backgroundColor = UIColor.clearColor()
        _chooseLabel?.font = UIFont.init(name: "AppleSDGothicNeo-Regular", size: _fontSize!+1)
        _chooseLabel?.text = "请选择颜色分类"
        _chooseLabel?.textColor = UIColor.blackColor()

        _closeButton = UIButton.init(type: .Custom)
        _closeButton?.frame = CGRectMake(_contentSize!.width - 40, _padding! * 2 , 40, 40)
        _closeButton?.backgroundColor = UIColor.init(red: 209.0/255.0, green: 213.0/255.0, blue: 219.0/255.0, alpha: 1)
        _closeButton?.setImage(UIImage.init(named: "error"), forState: .Normal)
        _closeButton?.addTarget(self, action: #selector(self.closeButtonAction(_:)), forControlEvents: .TouchUpInside)

        _numberControl = PNumberChooseControl.init(frame: CGRectMake(_padding!, _padding!, _contentSize!.width - 2 * _padding!, 56))

        _selectView = UIView.init(frame:CGRectMake( 0, _imageViewSize! + _padding!, _contentSize!.width, _contentSize!.height - _imageViewSize! - _padding!))
        _selectView?.backgroundColor = UIColor.whiteColor()

        _confirmBtn = UIButton.init(type: .Custom)
        _confirmBtn?.frame = CGRectMake(0, 0, _contentSize!.width, 50)
        _confirmBtn?.backgroundColor = UIColor.blueColor()
        _confirmBtn?.titleLabel?.font = UIFont.init(name: "AppleSDGothicNeo-Regular", size: 18)
        _confirmBtn?.addTarget(self, action: #selector(self.confirmAct(_:)), forControlEvents: .TouchUpInside)

        _topView?.addSubview(_priceLabel!)
        _topView?.addSubview(_storeLabel!)
        _topView?.addSubview(_chooseLabel!)

        self.addSubview(_topView!)
        self.addSubview(_topLineView!)
        self.addSubview(_closeButton!)
        self.addSubview(_imageView!)
        self.addSubview(_selectView!)
        self.addSubview(_confirmBtn!)
        self.backgroundColor = UIColor.clearColor()

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func closeButtonAction(sender:UIButton)
    {
        if delegate != nil {
            delegate?.closeTBAction()
        }
    }

    func confirmAct(sender:UIButton)
    {
        let combined = _unitPrice!*(_numberControl?.currentValue())!
        if delegate != nil {
            delegate?.confirmActionWithHowMuch(String(combined), integer: (_numberControl?.currentValue())!)
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
        _numberControl?.frame = CGRectMake(0, ((_selectView?.frame.size.height)! - _numberControl!.frame.size.height - _confirmBtn!.frame.size.height)/2, _contentSize!.width, 50)
        _confirmBtn!.frame = CGRectMake(0, _contentSize!.height-50, _contentSize!.width, 50);
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.TPKeyboardAvoiding_keyboardWillShow(_:)), name: UIKeyboardWillChangeFrameNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.TPKeyboardAvoiding_keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }

    func TPKeyboardAvoiding_keyboardWillShow(notification:NSNotification)
    {
        let keyboardRect = self.convertRect(((notification.userInfo! as NSDictionary).objectForKey("UIKeyboardBoundsUserInfoKey")?.CGRectValue())!, fromView: nil)
        if CGRectIsEmpty(keyboardRect) {
            return
        }
        _selectView?.frame = CGRectMake(0, _animateHeight! , _contentSize!.width, 56 + 2 * _padding!)
        self.addSubview(_bottomView!)
        UIView.animateWithDuration(((notification.userInfo! as NSDictionary).objectForKey(UIKeyboardAnimationDurationUserInfoKey)?.doubleValue)!, delay: 0, options: .CurveEaseIn, animations: {
            self._bottomView?.frame = CGRectMake(0, self._animateHeight! + 56 , self._contentSize!.width,  self._contentSize!.height)
            self._imageView?.frame = CGRectMake(self._padding!, self._padding! , self._animateHeight!-2*self._padding!, self._animateHeight!-2*self._padding!)
            self._closeButton!.frame = CGRectMake(self._contentSize!.width - 40, 0 , 40, 40)
            self._topView!.frame = CGRectMake(0, 0, self._contentSize!.width, self._animateHeight!)
            self._priceLabel!.frame = CGRectMake(self._animateHeight!, self._padding!,self._contentSize!.width - self._animateHeight! - self._padding!,20)
            self._storeLabel!.frame = CGRectMake(self._animateHeight!, self._padding! + 20, self._contentSize!.width - self._animateHeight! - self._padding!,20)
            self._chooseLabel!.frame = CGRectMake(self._animateHeight!, self._padding! + 40, self._contentSize!.width - self._animateHeight! - self._padding!,20)
            }) { (finish) in

        }
    }

    func TPKeyboardAvoiding_keyboardWillHide(notification:NSNotification)
    {
        let keyboardRect = self.convertRect(((notification.userInfo! as NSDictionary).objectForKey("UIKeyboardBoundsUserInfoKey")?.CGRectValue())!, fromView: nil)
        if CGRectIsEmpty(keyboardRect) {
            return
        }
        _bottomView?.removeFromSuperview()
        _selectView?.frame = CGRectMake(0, _imageViewSize! + _padding!, _contentSize!.width, _contentSize!.height - _imageViewSize! - _padding!)
        UIView.animateWithDuration(((notification.userInfo! as NSDictionary).objectForKey(UIKeyboardAnimationDurationUserInfoKey)?.doubleValue)!, delay: 0, options: .CurveEaseOut, animations: { 
            self._imageView!.frame = CGRectMake(self._padding!, 0 ,self._imageViewSize!, self._imageViewSize!)
            self._closeButton!.frame = CGRectMake(self._contentSize!.width - 40, self._padding! * 2 , 40, 40)
            self._topView!.frame = CGRectMake(0, 2 * self._padding!, self._contentSize!.width, self._imageViewSize!)
            self._priceLabel!.frame = CGRectMake(self._padding! * 2 + self._imageViewSize!,self._padding! + 5, self._contentSize!.width - self._imageViewSize! - 3 * self._padding!,20)
            self._storeLabel!.frame = CGRectMake(self._padding! * 2 + self._imageViewSize!, self._padding! + 25, self._contentSize!.width - self._imageViewSize! - 3 * self._padding!,20)
            self._chooseLabel!.frame = CGRectMake(self._padding! * 2 + self._imageViewSize!, self._padding! + 45, self._contentSize!.width - self._imageViewSize! - 3 * self._padding!,20)
            }) { (finish) in
                self._bottomView!.frame = CGRectMake(0, self._contentSize!.height + 44, self._contentSize!.width,self._contentSize!.height - self._animateHeight!);
        }
    }

    func lineViewWithFrame(frame:CGRect,color:UIColor)->UIView
    {
        let view = UIView.init(frame: frame)
        view.backgroundColor = color
        return view
    }
}
