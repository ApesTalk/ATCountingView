
//
//  ATCountView.m
//  Test
//
//  Created by ApesTalk on 2019/1/13.
//  Copyright © 2019年 https://github.com/ApesTalk All rights reserved.
//

#import "ATCountingView.h"

@interface UIView (ATFrameExtension)
@property (nonatomic, assign) CGFloat at_x;
@property (nonatomic, assign) CGFloat at_y;
@property (nonatomic, assign) CGFloat at_w;
@property (nonatomic, assign) CGFloat at_h;
@property (nonatomic, assign) CGSize at_size;
@property (nonatomic, assign) CGPoint at_origin;
@end

@implementation UIView(ATFrameExtension)
- (void)setAt_x:(CGFloat)at_x
{
    CGRect frame = self.frame;
    frame.origin.x = at_x;
    self.frame = frame;
}

- (CGFloat)at_x
{
    return self.frame.origin.x;
}

- (void)setAt_y:(CGFloat)at_y
{
    CGRect frame = self.frame;
    frame.origin.y = at_y;
    self.frame = frame;
}

- (CGFloat)at_y
{
    return self.frame.origin.y;
}

- (void)setAt_w:(CGFloat)at_w
{
    CGRect frame = self.frame;
    frame.size.width = at_w;
    self.frame = frame;
}

- (CGFloat)at_w
{
    return self.frame.size.width;
}

- (void)setAt_h:(CGFloat)at_h
{
    CGRect frame = self.frame;
    frame.size.height = at_h;
    self.frame = frame;
}

- (CGFloat)at_h
{
    return self.frame.size.height;
}

- (void)setAt_size:(CGSize)at_size
{
    CGRect frame = self.frame;
    frame.size = at_size;
    self.frame = frame;
}

- (CGSize)at_size
{
    return self.frame.size;
}

- (void)setAt_origin:(CGPoint)at_origin
{
    CGRect frame = self.frame;
    frame.origin = at_origin;
    self.frame = frame;
}

- (CGPoint)at_origin
{
    return self.frame.origin;
}
@end

@interface ATCountingView () <CAAnimationDelegate>
@property (nonatomic, strong) UILabel *frontLabel;///< current show label
@property (nonatomic, strong) UILabel *backLabel;///< hide or animate label
@end

@implementation ATCountingView
- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        self.clipsToBounds = YES;
        _backLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _backLabel.textAlignment = NSTextAlignmentCenter;
        _backLabel.text = @"0";
        [self addSubview:_backLabel];
        
        _frontLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _frontLabel.textAlignment = NSTextAlignmentCenter;
        _frontLabel.text = @"0";
        [self addSubview:_frontLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    _frontLabel.at_size = self.at_size;
    _backLabel.at_size = self.at_size;
}

- (void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    _frontLabel.textColor = textColor;
    _backLabel.textColor = textColor;
    
}

- (void)setFont:(UIFont *)font{
    _font = font;
    _frontLabel.font = font;
    _backLabel.font = font;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    _textAlignment = textAlignment;
    _frontLabel.textAlignment = textAlignment;
    _backLabel.textAlignment = textAlignment;
}

- (void)setNumber:(NSInteger)number{
    _number = MIN(9, MAX(0, number));
    _frontLabel.text = [NSString stringWithFormat:@"%ld", _number];
    _backLabel.text = [NSString stringWithFormat:@"%ld", _number];
}

- (void)animateFromNumber:(NSInteger)fromNumber toNumber:(NSInteger)toNumber perDuration:(NSTimeInterval)perDuration{
    //考虑到cycle模式下有可能大于9也有可能小于0
    NSInteger f = fromNumber;
    if(f >= 10){
        f = f-10;
    }else if (f < 0) {
        f = f+10;
    }
    _frontLabel.text = [NSString stringWithFormat:@"%ld", f];
    _frontLabel.at_y = 0;
    if(fromNumber < toNumber){
        //increase
        //考虑到cycle模式下有可能大于9
        NSInteger value = fromNumber+1;
        if(value >= 10){
            value = value-10;
        }
        _backLabel.text = [NSString stringWithFormat:@"%ld", value];
        _backLabel.at_y = self.at_h;
        _backLabel.hidden = NO;
        [UIView animateWithDuration:perDuration animations:^{
            _frontLabel.transform = CGAffineTransformTranslate(_frontLabel.transform, 0, -self.at_h);
            _backLabel.transform = CGAffineTransformTranslate(_backLabel.transform, 0, -self.at_h);
        } completion:^(BOOL finished) {
            if(!finished){
                return;
            }
            
            UILabel *tmpLabel = self.frontLabel;
            self.frontLabel = self.backLabel;
            self.backLabel = tmpLabel;
            self.backLabel.hidden = YES;
            _number++;
            if(_number < toNumber){
                [self animateFromNumber:_number toNumber:toNumber perDuration:perDuration];
            }else{
                _number = value;
                if([_delegate respondsToSelector:@selector(animationDidStopForCountView:)]){
                    [_delegate animationDidStopForCountView:self];
                }
            }
        }];
    }else if (fromNumber > toNumber){
        //decrease
        //考虑到cycle模式下有可能小于0
        NSInteger value = fromNumber-1;
        if(value < 0){
            value = value+10;
        }
        _backLabel.text = [NSString stringWithFormat:@"%ld", value];
        _backLabel.at_y = -self.at_h;
        _backLabel.hidden = NO;
        [UIView animateWithDuration:perDuration animations:^{
            _frontLabel.transform = CGAffineTransformTranslate(_frontLabel.transform, 0, self.at_h);
            _backLabel.transform = CGAffineTransformTranslate(_backLabel.transform, 0, self.at_h);
        } completion:^(BOOL finished) {
            if(!finished){
                return;
            }
            
            UILabel *tmpLabel = self.frontLabel;
            self.frontLabel = self.backLabel;
            self.backLabel = tmpLabel;
            self.backLabel.hidden = YES;
            _number--;
            if(_number > toNumber){
                [self animateFromNumber:_number toNumber:toNumber perDuration:perDuration];
            }else{
                _number = value;
                if([_delegate respondsToSelector:@selector(animationDidStopForCountView:)]){
                    [_delegate animationDidStopForCountView:self];
                }
            }
        }];
    }
}

- (void)animateToNumber:(NSUInteger)number duration:(NSTimeInterval)duration{
    [_frontLabel.layer removeAllAnimations];
    [_backLabel.layer removeAllAnimations];

    if([_delegate respondsToSelector:@selector(animationDidStartForCountView:)]){
        [_delegate animationDidStartForCountView:self];
    }
    if (number == _number){
        //no animtion
        if([_delegate respondsToSelector:@selector(animationDidStopForCountView:)]){
            [_delegate animationDidStopForCountView:self];
        }
    }else{
        //判断_number执行加法和减法哪种方式离number更近
        NSInteger realToNumber = number;
        if(self.isCycle){
            if(number > _number){
                NSInteger addTimes = number - _number;
                NSInteger reduceTimes = _number + 10 - number;
                if(addTimes <= reduceTimes){
                    realToNumber = number;
                }else{
                    realToNumber = number - 10;
                }
            }else{
                NSInteger reduceTimes = _number - number;
                NSInteger addTimes = 10 - _number + number;
                if(reduceTimes <= addTimes){
                    realToNumber = number;
                }else{
                    realToNumber = number + 10;
                }
            }
        }
        [self animateFromNumber:_number toNumber:realToNumber perDuration:fabs(duration/(realToNumber-_number))];
    }
}

@end
