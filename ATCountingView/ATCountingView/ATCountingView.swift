//
//  ATCountingView.swift
//  ATCountingView
//
//  Created by ApesTalk on 2019/1/13.
//  Copyright © 2019年 https://github.com/ApesTalk All rights reserved.
//

import UIKit

protocol ATCountViewProtocol: class {
    func animationDidStartForCountView(view:ATCountingView)
    func animationDidStopForCountView(view:ATCountingView)
}

class ATCountingView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.clipsToBounds = true
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var textColor = UIColor.black
    var font = UIFont.systemFont(ofSize: 17)
    var textAlignment = NSTextAlignment.center
    var number: Int = 0
    var cycle = false // 是否循环，默认false。循环时会自动判断执行加法还是减法距离目标数字近，比如2->9会执行减法动画
    weak var delegate: ATCountViewProtocol?
    
    private var frontLabel = UILabel()
    private var backLabel = UILabel()
    
    func configUI() {
        frontLabel.textAlignment = NSTextAlignment.center
        frontLabel.text = "0"
        self.addSubview(frontLabel)
        
        backLabel.textAlignment = NSTextAlignment.center
        backLabel.text = "0"
        self.addSubview(backLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        frontLabel.setAt_size(at_size: self.at_size())
        backLabel.setAt_size(at_size: self.at_size())
    }
    
    func setTextColor(color: UIColor) {
        textColor = color
        frontLabel.textColor = textColor
        backLabel.textColor = textColor
    }
    
    func setFont(f: UIFont) {
        font = f
        frontLabel.font = font
        backLabel.font = font
    }
    
    func setTextAlignment(alignment: NSTextAlignment) {
        textAlignment = alignment
        frontLabel.textAlignment = textAlignment
        backLabel.textAlignment = textAlignment
    }
    
    func setNumber(num: Int) {
        number = min(9, max(0, num))
        frontLabel.text = String(num)
        backLabel.text = String(num)
    }
    
    private func animateFromNumber(fromNumber: Int, toNumber: Int, perDuration: TimeInterval){
        //考虑到cycle模式下有可能大于9也有可能小于0
        var f = fromNumber
        if f >= 10{
            f = f-10
        }else if f < 0 {
            f = f+10
        }
        frontLabel.text = String(f)
        frontLabel.setAt_y(at_y: 0)
        if fromNumber < toNumber {
            //increase
            //考虑到cycle模式下有可能大于9
            var value = fromNumber+1
            if value >= 10{
                value = value-10
            }
            backLabel.text = String(value)
            backLabel.setAt_y(at_y: self.at_h())
            backLabel.alpha = 1
            UIView.animate(withDuration: perDuration, animations: {
                self.frontLabel.transform = self.frontLabel.transform.translatedBy(x: 0, y: -self.at_h())
                self.backLabel.transform = self.backLabel.transform.translatedBy(x: 0, y: -self.at_h())
            }) { (finished) in
                let tmpLabel = self.frontLabel
                self.frontLabel = self.backLabel
                self.backLabel = tmpLabel
                self.backLabel.alpha = 0
                self.number = self.number+1
                if self.number < toNumber {
                    self.animateFromNumber(fromNumber: self.number, toNumber: toNumber, perDuration: perDuration)
                }else{
                    self.number = value
                    self.delegate?.animationDidStopForCountView(view: self)
                }
            }
        }else{
            //decrease
            //考虑到cycle模式下有可能小于0
            var value = fromNumber-1
            if value < 0 {
                value = value+10
            }
            backLabel.text = String(value)
            backLabel.setAt_y(at_y: -self.at_h())
            backLabel.alpha = 1
            UIView.animate(withDuration: perDuration, animations: {
                self.frontLabel.transform = self.frontLabel.transform.translatedBy(x: 0, y: self.at_h())
                self.backLabel.transform = self.backLabel.transform.translatedBy(x: 0, y: self.at_h())
            }) { (finished) in
                let tmpLabel = self.frontLabel
                self.frontLabel = self.backLabel
                self.backLabel = tmpLabel
                self.backLabel.alpha = 0
                self.number = self.number-1
                if self.number > toNumber {
                    self.animateFromNumber(fromNumber: self.number, toNumber: toNumber, perDuration: perDuration)
                }else{
                    self.number = value
                    self.delegate?.animationDidStopForCountView(view: self)
                }
            }
        }
    }
    
    func animateToNumber(toNumber: Int, duration: TimeInterval) {
        frontLabel.layer.removeAllAnimations()
        backLabel.layer.removeAllAnimations()
        self.delegate?.animationDidStartForCountView(view: self)
   
        if (toNumber == self.number){
            //no animtion
            self.delegate?.animationDidStopForCountView(view: self)
        }else{
            //判断_number执行加法和减法哪种方式离number更近
            var realToNumber = toNumber
            if self.cycle {
                if toNumber > self.number {
                    let addTimes = toNumber - self.number
                    let reduceTimes = self.number + 10 - toNumber
                    if addTimes <= reduceTimes {
                        realToNumber = toNumber
                    }else{
                        realToNumber = toNumber - 10
                    }
                }else{
                    let reduceTimes = self.number - toNumber
                    let addTimes = 10 - self.number + toNumber
                    if reduceTimes <= addTimes {
                        realToNumber = toNumber
                    }else{
                        realToNumber = toNumber + 10
                    }
                }
            }
            let count: Double = Double(realToNumber-self.number)
            let pertimes: Double = Double(fabs(duration/count))
            self.animateFromNumber(fromNumber: self.number, toNumber: realToNumber, perDuration: pertimes)
        }
    }

}
