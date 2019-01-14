//
//  ATColorPanel.swift
//  ATCountingView
//
//  Created by ApesTalk on 2019/1/14.
//  Copyright © 2019年 https://github.com/ApesTalk All rights reserved.
//  颜色面板

import UIKit

class ATColorPanel: UIView {
    let fixWidth: CGFloat = 320.0 //固定宽度

    //show R
    var r0View: ATCountingView?
    var r1View: ATCountingView?
    var r2View: ATCountingView?
    //show G
    var g0View: ATCountingView?
    var g1View: ATCountingView?
    var g2View: ATCountingView?
    //show B
    var b0View: ATCountingView?
    var b1View: ATCountingView?
    var b2View: ATCountingView?
    //show A
    let aLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for v in self.subviews {
            v.setAt_h(at_h: self.at_h())
        }
    }
    
    func configUI() {
        var orignX: CGFloat = 0
        let titles = ["R", "G", "B", "A"]
        for i in 0 ..< titles.count {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 20)
            label.textAlignment = NSTextAlignment.right
            label.frame = CGRect(x: orignX, y: 0, width: 15, height: self.at_h())
            label.text = titles[i]
            self.addSubview(label)
            orignX += 15
            
            if i < titles.count-1 {
                for j in 0...2 {
                    let v = ATCountingView()
                    v.frame = CGRect(x: orignX, y: 0, width: 20, height: self.at_h())
                    v.cycle = true
                    v.setFont(f: UIFont.systemFont(ofSize: 20))
                    self.addSubview(v)
                    orignX += 20
                    if i == 0 {
                        if j == 0 {
                            r0View = v
                        }else if j == 1{
                            r1View = v
                        }else{
                            r2View = v
                        }
                    }else if i == 1 {
                        if j == 0 {
                            g0View = v
                        }else if j == 1{
                            g1View = v
                        }else{
                            g2View = v
                        }
                    }else{
                        if j == 0 {
                            b0View = v
                        }else if j == 1{
                            b1View = v
                        }else{
                            b2View = v
                        }
                    }
                }
            }
            orignX += 15//padding
        }
        
        aLabel.font = UIFont.systemFont(ofSize: 20)
        aLabel.frame = CGRect(x: orignX-15, y: 0, width: 35, height: self.at_h())
        aLabel.text = "0.0"
        self.addSubview(aLabel)
    }
    
    func showColor(color: UIColor) {
        let (r, g, b, a) = self.getRGBAFromColor(color: color)
        let rValue: Int = Int(r*255)
        let rh: Int = rValue/100
        let rt: Int = (rValue-rh*100)/10
        let rd: Int = rValue-rh*100-rt*10
        r0View?.animateToNumber(toNumber: rh, duration: 1)
        r1View?.animateToNumber(toNumber: rt, duration: 1)
        r2View?.animateToNumber(toNumber: rd, duration: 1)
        
        let gValue: Int = Int(g*255)
        let gh: Int = gValue/100
        let gt: Int = (gValue-gh*100)/10
        let gd: Int = gValue-gh*100-gt*10
        g0View?.animateToNumber(toNumber: gh, duration: 1)
        g1View?.animateToNumber(toNumber: gt, duration: 1)
        g2View?.animateToNumber(toNumber: gd, duration: 1)
        
        
        let bValue: Int = Int(b*255)
        let bh: Int = bValue/100
        let bt: Int = (bValue-bh*100)/10
        let bd: Int = bValue-bh*100-bt*10
        b0View?.animateToNumber(toNumber: bh, duration: 1)
        b1View?.animateToNumber(toNumber: bt, duration: 1)
        b2View?.animateToNumber(toNumber: bd, duration: 1)
        
//        aLabel.text = "\(a)"
        aLabel.text = String(format: "%.1f", a)
    }
    
    func getRGBAFromColor(color: UIColor) -> (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 0.0
        color.getRed(&r, green: &g, blue: &b, alpha: &a)
        return (r, g, b, a)
    }
    

}
