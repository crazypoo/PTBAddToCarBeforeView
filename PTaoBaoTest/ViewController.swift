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

        _tbControl = PTBControl.init(frame: CGRectMake( 0, self.view.frame.size.height-250, self.view.frame.size.width, 250))
        _tbControl!.backgroundColor = UIColor.clearColor()
        _tbControl!.dataSource = self
        _tbControl!.delegate = self
        _tbControl!._confirmBtn?.backgroundColor = UIColor.redColor()
        _tbControl!._confirmBtn?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        _tbControl!._confirmBtn?.setTitle("加到购物车", forState: .Normal)
        _tbControl!._numberControl?.setCurrentValue(1)
        self.view.addSubview(_tbControl!)
        _tbControl!.reloadData()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setControl(imageView: UIImageView, priceLabel: UILabel, storeLabel: UILabel, chooseLabel: UILabel, numberControl: PNumberChooseControl) {
        imageView.image = UIImage.init(named: "1")
        priceLabel.text = "111111"
        storeLabel.text = "222222"
        chooseLabel.text = "333333"
        numberControl._maxNumber = 99
        numberControl._minNumber = 1
        numberControl.tipLabel?.text = "4444444"

    }

    func uniPriceInControl(control: PTBControl) -> NSInteger {
        return 1000
    }

    func closeTBAction() {
        _tbControl?.removeFromSuperview()
    }

    func confirmActionWithHowMuch(howMuch: NSString, integer: Int) {

    }
}

