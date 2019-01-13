//
//  ATCountView.h
//  Test
//
//  Created by ApesTalk on 2019/1/13.
//  Copyright © 2019年 https://github.com/ApesTalk All rights reserved.
//  动画展示从0~1的视图

#import <UIKit/UIKit.h>

@class ATCountingView;
@protocol ATCountViewDelegate <NSObject>
- (void)animationDidStartForCountView:(ATCountingView *)countView;
- (void)animationDidStopForCountView:(ATCountingView *)countView;
@end

@interface ATCountingView : UIView
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) NSTextAlignment textAlignment;///< defualt:NSTextAlignmentCenter
@property (nonatomic, assign) NSInteger number;///< defualt 0
@property (nonatomic, assign, getter=isCycle) BOOL cycle;///< 是否循环，默认NO。循环时会自动判断执行加法还是减法距离目标数字近，比如2->9会执行减法动画
@property (nonatomic, weak) id <ATCountViewDelegate> delegate;
- (void)animateToNumber:(NSUInteger)number duration:(NSTimeInterval)duration;
@end
