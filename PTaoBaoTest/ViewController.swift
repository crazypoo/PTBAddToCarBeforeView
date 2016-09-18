//
//  ViewController.swift
//  PTaoBaoTest
//
//  Created by 邓杰豪 on 2016/9/3.
//  Copyright © 2016年 邓杰豪. All rights reserved.
//

import UIKit

class ViewController: UIViewController,PTBControlDataSource,PTBControlDelegate {
    var _tbControl:PTBControl?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        _tbControl = PTBControl.init(frame: CGRect( x: 0, y: self.view.frame.size.height-250, width: self.view.frame.size.width, height: 250))
        _tbControl!.backgroundColor = UIColor.clear
        _tbControl!.dataSource = self
        _tbControl!.delegate = self
        _tbControl!._confirmBtn?.backgroundColor = UIColor.red
        _tbControl!._confirmBtn?.setTitleColor(UIColor.white, for: UIControlState())
        _tbControl!._confirmBtn?.setTitle("加到购物车", for: UIControlState())
        _tbControl!._numberControl?.setCurrentValue(1)
        self.view.addSubview(_tbControl!)
        _tbControl!.reloadData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setControl(_ imageView: UIImageView, priceLabel: UILabel, storeLabel: UILabel, chooseLabel: UILabel, numberControl: PNumberChooseControl) {
        imageView.image = UIImage.init(named: "1")
        priceLabel.text = "111111"
        storeLabel.text = "222222"
        chooseLabel.text = "333333"
        numberControl._maxNumber = 99
        numberControl._minNumber = 1
        numberControl.tipLabel?.text = "4444444"

    }

    func uniPriceInControl(_ control: PTBControl) -> NSInteger {
        return 1000
    }

    func closeTBAction() {
        _tbControl?.removeFromSuperview()
    }

    func confirmActionWithHowMuch(_ howMuch: NSString, integer: Int) {

    }
}

