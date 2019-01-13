//
//  ViewController.swift
//  ATCountingView
//
//  Created by ApesTalk on 2019/1/13.
//  Copyright © 2019年 https://github.com/ApesTalk All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let aView = ATCountingView()
    let bView = ATCountingView()
    let cView = ATCountingView()
    
    let dView = ATCountingView()
    let eView = ATCountingView()
    let fView = ATCountingView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 80, width: self.view.at_w(), height: 50)
        label.text = "1.非循环式，a->b b>a时向上，b<a时向下"
        label.numberOfLines = 2;
        label.textAlignment = NSTextAlignment.center
        self.view.addSubview(label)
        
        let orignX = (self.view.at_w() - 50*3.0)/2.0
        aView.frame = CGRect(x: orignX, y: 150, width: 50, height: 50)
        aView.layer.borderWidth = 1
        aView.layer.borderColor = UIColor.gray.cgColor
        aView.setTextColor(color: UIColor.red)
        aView.number = 9
        self.view.addSubview(aView)
        
        bView.frame = CGRect(x: orignX+50, y: 150, width: 50, height: 50)
        bView.layer.borderWidth = 1
        bView.layer.borderColor = UIColor.gray.cgColor
        bView.setTextColor(color: UIColor.red)
        self.view.addSubview(bView)
        
        cView.frame = CGRect(x: orignX+100, y: 150, width: 50, height: 50)
        cView.layer.borderWidth = 1
        cView.layer.borderColor = UIColor.gray.cgColor
        cView.setTextColor(color: UIColor.red)
        self.view.addSubview(cView)
        
        let label1 = UILabel()
        label1.frame = CGRect(x: 0, y: 250, width: self.view.at_w(), height: 60)
        label1.text = "2.循环式，像一个转盘 a->b 判断a向上还是向下哪种方式能最快的达到b"
        label1.numberOfLines = 2;
        label1.textAlignment = NSTextAlignment.center
        self.view.addSubview(label1)
        
        dView.frame = CGRect(x: orignX, y: 370, width: 50, height: 50)
        dView.layer.borderWidth = 1
        dView.layer.borderColor = UIColor.gray.cgColor
        dView.setTextColor(color: UIColor.red)
        dView.cycle = true;
        dView.setNumber(num: 3)
        self.view.addSubview(dView)
        
        eView.frame = CGRect(x: orignX+50, y: 370, width: 50, height: 50)
        eView.layer.borderWidth = 1
        eView.layer.borderColor = UIColor.gray.cgColor
        eView.setTextColor(color: UIColor.red)
        eView.cycle = true;
        eView.setNumber(num: 2)
        self.view.addSubview(eView)
        
        fView.frame = CGRect(x: orignX+100, y: 370, width: 50, height: 50)
        fView.layer.borderWidth = 1
        fView.layer.borderColor = UIColor.gray.cgColor
        fView.setTextColor(color: UIColor.red)
        fView.cycle = true;
        fView.setNumber(num: 9)
        self.view.addSubview(fView)
        
        
        let orignBtnX = (self.view.at_w() - 80*2 - 20)/2.0
        let startBtn = UIButton()
        startBtn.frame = CGRect(x: orignBtnX, y: 450, width: 80, height: 50)
        startBtn.setTitle("Start", for: UIControlState.normal)
        startBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        startBtn.addTarget(self, action: #selector(start), for: UIControlEvents.touchUpInside)
        self.view.addSubview(startBtn)
        
        let clearBtn = UIButton()
        clearBtn.frame = CGRect(x: orignBtnX+100, y: 450, width: 80, height: 50)
        clearBtn.setTitle("Rest", for: UIControlState.normal)
        clearBtn.setTitleColor(UIColor.black, for: UIControlState.normal)
        clearBtn.addTarget(self, action: #selector(reset), for: UIControlEvents.touchUpInside)
        self.view.addSubview(clearBtn)
    }

    @objc func start() {
        aView.animateToNumber(toNumber: 0, duration: 1);//9->0
        bView.animateToNumber(toNumber: 8, duration: 1);//0->8
        cView.animateToNumber(toNumber: 9, duration: 1);//0->9
        
        dView.animateToNumber(toNumber: 8, duration: 1);//3->8
        eView.animateToNumber(toNumber: 9, duration: 1);//2->9
        fView.animateToNumber(toNumber: 4, duration: 1);//9->4
    }
    
    @objc func reset() {
        aView.animateToNumber(toNumber: 9, duration: 1);
        bView.animateToNumber(toNumber: 0, duration: 1);
        cView.animateToNumber(toNumber: 0, duration: 1);
        
        dView.animateToNumber(toNumber: 3, duration: 1);
        eView.animateToNumber(toNumber: 2, duration: 1);
        fView.animateToNumber(toNumber: 9, duration: 1);
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

