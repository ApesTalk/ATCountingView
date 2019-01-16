# ATCountingView
A counting view which can animate from 0 to 9, you can use it like UILabel. 可以滚动展示数字（0到9）的控件，你可以像UILabel一样使用它。

## Swift实现原理

对于可以滚动展示数字的控件，网上也有其他人的实现，有人的解决思路是利用一个长长的多行的UILabel，每行展示一个数字，展示的动画其实是改变这个UILabel的位置。我的解决思路也很简单，就是利用两个UILabel轮流做位移动画和展示。

第一次尝试使用Swift来写一个简单的demo，有些地方跟Objective-C还是差别比较大，中途走了点弯路，但最终还是一次比较成功的尝试。主要核心实现代码如下，如果有什么问题，欢迎大家提issue，也欢迎大家给个Star表示支持，谢谢！

```Swift
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
```

[OC版本在这里](https://github.com/ApesTalk/ATCountingView/tree/master/OC)


## 用法

```Swift

let countView = CGRect(x: 100, y: 150, width: 50, height: 50)
countView(color: UIColor.red)
countView = 9
//countView = true;
countView.animateToNumber(toNumber: 0, duration: 1);//9->0
```

## 心得收获

纸上得来终觉浅，绝知此事要躬行。通过这个简单的小demo，帮我巩固了Swift的一些基本的知识点，下面通过列出我觉得在本次尝试中遇到的Swift与Objective-C的区别点来总结一下本次的收获和心得体会。

- 1.import
Swift是有模块（Module 比如UIKit，Foundation）的概念。**在Swift中同一个Module中的类，不需要import即可直接使用。** Swift的import不仅可以引入独立的结构体、类、枚举、协议和类型别名，也可以引入在头部定义的方法、常量和变量。

Swift的import语法结构：``import <#kind#> <#module.symbol#>``，其中kind可以是下面这些类型：

|Kind|Description|
|---|---|
|struct|Structure|
|class|Class|
|enum|Enumeration|
|protocol|Protocol|
|typealias|Type Alias|
|func|Function|
|let|Constant|
|var|Variable|


参考：[Swift Import Declarations](https://nshipster.com/import/)

- 2.字符串格式化

```
let a: CGFloat = 0.33
aLabel.text = "\(a)"
aLabel.text = String(format: "%.1f", a)
```

- 3.Swift获取UIColor的R、G、B、A很方便

```
var r: CGFloat = 0.0
var g: CGFloat = 0.0
var b: CGFloat = 0.0
var a: CGFloat = 0.0
color.getRed(&r, green: &g, blue: &b, alpha: &a)
```

- 4.UIView如何移除Block动画

```
v.layer.removeAllAnimations()
同时在completion block中判断动画是否正常结束。
```


## 效果图

![](https://github.com/ApesTalk/ATCountingView/blob/master/counting.gif)
