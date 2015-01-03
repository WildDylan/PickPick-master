//
//  ALThirdView.m
//  ALScrollViewVertical
//
//  Created by Alice on 14/12/22.
//  Copyright (c) 2014年 Alice. All rights reserved.
//

#import "ALThirdView.h"

@interface ALThirdView ()
{
    UIButton *buttonAnHour;
    UIButton *buttonThreeHour;
    UIButton *buttonOneDay;
    UIButton *buttonThreeDays;
    BOOL isSpread;
    
}

- (void)buttonListControl:(UIButton *)button;


@end
@implementation ALThirdView


- (instancetype)initWithFrame:(CGRect)frame ImagesArray:(NSArray *)images {
    
    self = [super initWithFrame:frame ImagesArray:images];
    if (self) {
        
        
        [self initButtonTimeLimitList];
        [self initTimeLimitList];
        [self adjustSuperSubviews];
        
    }
    
    
    return self;
    
}

/**
 *  make some modify for super view
 */
- (void)adjustSuperSubviews {
    
    [self.textField removeFromSuperview];
    [self.buttonNextStep setBackgroundImage:[UIImage imageNamed:@"done"] forState:(UIControlStateNormal)];
    self.buttonNextStep.frame = CGRectMake(CGRectGetMaxX(_buttonTimeLimitList.frame)+10, CGRectGetMinY(_buttonTimeLimitList.frame), 38, 38);
    
}
/**
 *  initialize button of menu title
 */

- (void)initButtonTimeLimitList {
    
    self.buttonTimeLimitList = [UIButton buttonWithType:(UIButtonTypeSystem)];
    _buttonTimeLimitList.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
    _buttonTimeLimitList.frame = CGRectMake(80,CGRectGetMaxY(self.animationImage.frame)-10,self.frame.size.width-160,40);
    _buttonTimeLimitList.tag = 4100;
    [_buttonTimeLimitList setTitle:@"时间限制" forState:(UIControlStateNormal)];
    [_buttonTimeLimitList setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    [_buttonTimeLimitList addTarget:self action:@selector(buttonListControl:) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:_buttonTimeLimitList];
    [self bringSubviewToFront:_buttonTimeLimitList];

}
/**
 *  initialize time limit list
 */

- (void)initTimeLimitList {
    
    NSArray *array = @[@"一小时之内",@"三小时之内",@"今天之内",@"三天之内"];
    
    for (int i = 0; i < 4; i++) {
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
        button.frame = CGRectMake(CGRectGetMinX(_buttonTimeLimitList.frame),CGRectGetMinY(_buttonTimeLimitList.frame),CGRectGetWidth(_buttonTimeLimitList.frame),CGRectGetHeight(_buttonTimeLimitList.frame));
        [button setTitle:array[i] forState:(UIControlStateNormal)];
        button.tag = 4000 + i * 10;
        button.layer.borderColor =  [UIColor whiteColor].CGColor;
        button.layer.borderWidth = .8f;
        [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
        button.alpha = 0;
        [button addTarget:self action:@selector(getWhichOneWeChoose:) forControlEvents:(UIControlEventTouchUpInside)];
        button.userInteractionEnabled = NO;
        [self addSubview:button];
     }
    
    
}


- (void)buttonListControl:(UIButton *)button {
    
    if (isSpread) {
        
        
        [self recoverList:button];
        isSpread = NO;
        
    }else {
        
        
        [self spreadList:button];
        
        isSpread = YES;
    }
    
}

- (void)spreadList:(UIButton *)button {
    
    [UIView animateWithDuration:.2 animations:^{
        
        buttonAnHour = (UIButton *)[self viewWithTag:4000];
        buttonAnHour.userInteractionEnabled = YES;
        buttonAnHour.alpha = 1;
        buttonAnHour.frame = CGRectMake(CGRectGetMinX(_buttonTimeLimitList.frame), CGRectGetMaxY(_buttonTimeLimitList.frame)+ 2.0, CGRectGetWidth(_buttonTimeLimitList.frame), CGRectGetHeight(_buttonTimeLimitList.frame));
        
        buttonThreeHour = (UIButton *)[self viewWithTag:4010];
        buttonThreeHour.alpha = 1;
        buttonThreeHour.userInteractionEnabled = YES;
        buttonThreeHour.frame = CGRectMake(CGRectGetMinX(_buttonTimeLimitList.frame), CGRectGetMaxY(buttonAnHour.frame)+3, CGRectGetWidth(_buttonTimeLimitList.frame), CGRectGetHeight(_buttonTimeLimitList.frame));
        
        buttonOneDay = (UIButton *)[self viewWithTag:4020];
        buttonOneDay.alpha = 1;
        buttonOneDay.userInteractionEnabled = YES;
        buttonOneDay.frame = CGRectMake(CGRectGetMinX(_buttonTimeLimitList.frame), CGRectGetMaxY(buttonThreeHour.frame)+4, CGRectGetWidth(_buttonTimeLimitList.frame), CGRectGetHeight(_buttonTimeLimitList.frame));
        
        buttonThreeDays = (UIButton *)[self viewWithTag:4030];
        buttonThreeDays.alpha = 1;
        buttonThreeDays.userInteractionEnabled = YES;
        buttonThreeDays.frame = CGRectMake(CGRectGetMinX(_buttonTimeLimitList.frame), CGRectGetMaxY(buttonOneDay.frame)+6, CGRectGetWidth(_buttonTimeLimitList.frame), CGRectGetHeight(_buttonTimeLimitList.frame));
        
    } completion:^(BOOL finished) {
    
        buttonAnHour = (UIButton *)[self viewWithTag:4000];
        buttonAnHour.userInteractionEnabled = YES;
        buttonAnHour.alpha = 1;
        buttonAnHour.frame = CGRectMake(CGRectGetMinX(_buttonTimeLimitList.frame), CGRectGetMaxY(_buttonTimeLimitList.frame), CGRectGetWidth(_buttonTimeLimitList.frame), CGRectGetHeight(_buttonTimeLimitList.frame));
        
        buttonThreeHour = (UIButton *)[self viewWithTag:4010];
        buttonThreeHour.alpha = 1;
        buttonThreeHour.userInteractionEnabled = YES;
        buttonThreeHour.frame = CGRectMake(CGRectGetMinX(_buttonTimeLimitList.frame), CGRectGetMaxY(buttonAnHour.frame), CGRectGetWidth(_buttonTimeLimitList.frame), CGRectGetHeight(_buttonTimeLimitList.frame));
        
        buttonOneDay = (UIButton *)[self viewWithTag:4020];
        buttonOneDay.alpha = 1;
        buttonOneDay.userInteractionEnabled = YES;
        buttonOneDay.frame = CGRectMake(CGRectGetMinX(_buttonTimeLimitList.frame), CGRectGetMaxY(buttonThreeHour.frame), CGRectGetWidth(_buttonTimeLimitList.frame), CGRectGetHeight(_buttonTimeLimitList.frame));
        
        buttonThreeDays = (UIButton *)[self viewWithTag:4030];
        buttonThreeDays.alpha = 1;
        buttonThreeDays.userInteractionEnabled = YES;
        buttonThreeDays.frame = CGRectMake(CGRectGetMinX(_buttonTimeLimitList.frame), CGRectGetMaxY(buttonOneDay.frame), CGRectGetWidth(_buttonTimeLimitList.frame), CGRectGetHeight(_buttonTimeLimitList.frame));
        
        
    }];

    
}


- (void)recoverList:(UIButton *)button {
    
    [UIView animateWithDuration:.2 animations:^{
        
        buttonAnHour = (UIButton *)[self viewWithTag:4000];
        buttonAnHour.userInteractionEnabled = NO;
        buttonAnHour.frame = CGRectMake(CGRectGetMinX(_buttonTimeLimitList.frame), CGRectGetMinY(_buttonTimeLimitList.frame), CGRectGetWidth(_buttonTimeLimitList.frame), CGRectGetHeight(_buttonTimeLimitList.frame));
        buttonAnHour.alpha = 0;
        
        buttonThreeHour = (UIButton *)[self viewWithTag:4010];
        buttonThreeHour.userInteractionEnabled = NO;
        buttonThreeHour.frame = CGRectMake(CGRectGetMinX(_buttonTimeLimitList.frame), CGRectGetMinY(buttonAnHour.frame), CGRectGetWidth(_buttonTimeLimitList.frame), CGRectGetHeight(_buttonTimeLimitList.frame));
        buttonThreeHour.alpha = 0;

        buttonOneDay = (UIButton *)[self viewWithTag:4020];
        buttonOneDay.userInteractionEnabled = YES;
        buttonOneDay.frame = CGRectMake(CGRectGetMinX(_buttonTimeLimitList.frame), CGRectGetMinY(buttonThreeHour.frame), CGRectGetWidth(_buttonTimeLimitList.frame), CGRectGetHeight(_buttonTimeLimitList.frame));
        buttonOneDay.alpha = 0;

        buttonThreeDays = (UIButton *)[self viewWithTag:4030];
        buttonThreeDays.userInteractionEnabled = NO;
        buttonThreeDays.frame = CGRectMake(CGRectGetMinX(_buttonTimeLimitList.frame), CGRectGetMinY(buttonOneDay.frame), CGRectGetWidth(_buttonTimeLimitList.frame), CGRectGetHeight(_buttonTimeLimitList.frame));
        buttonThreeDays.alpha = 0;

    }];
    
    
    
}

- (void)getWhichOneWeChoose:(UIButton *)button {
    
    NSString *title = button.titleLabel.text;
    [self.buttonTimeLimitList setTitle:title forState:(UIControlStateNormal)];
    [self recoverList:button];
    isSpread = NO;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
