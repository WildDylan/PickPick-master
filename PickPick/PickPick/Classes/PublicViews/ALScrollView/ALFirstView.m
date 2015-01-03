//
//  ALFirstView.m
//  ALScrollViewVertical
//
//  Created by Alice on 14/12/21.
//  Copyright (c) 2014年 Alice. All rights reserved.
//

#import "ALFirstView.h"

///// Color
//#define RGBCOLOR(r,g,b)    [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
//#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
//#define HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
//// Main Color
//#define ADLIGHT_BLUE_(alp)  RGBACOLOR(86, 150, 220, alp)
//#define ADLIGHT_BLUE        RGBCOLOR(86, 150, 220)
//#define ADDARK_BLUE_(alp)   RGBACOLOR(55, 91, 130, alp)
//#define ADDARK_BLUE         RGBCOLOR(55, 91, 130)

@interface ALFirstView ()
{
@private
    
    UIImageView *_imageLogo;
    
}


@end

@implementation ALFirstView



- (instancetype)initWithFrame:(CGRect)frame ImagesArray:(NSArray *)images{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        NSLog(@"init first view");
        [self initImages:images];
        [self initLogoImage];
        [self initTextField];
        
        
    }
    
    return self;
    
}

- (void)initImages:(NSArray *)images {
    
    
    self.animationImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 120, 40, 80, 80)];
    self.animationImage.animationImages = images;
    self.animationImage.animationDuration = 5;
    self.animationImage.animationRepeatCount = -1;
    [self.animationImage startAnimating];
   [self addSubview:_animationImage];
    
}

- (void)initLogoImage {
    
    _imageLogo = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(_animationImage.frame)/2)-20, (CGRectGetHeight(_animationImage.frame)/2)-10, 40, 30)];
    
    _imageLogo.image = [UIImage imageNamed:@"logoFirstView"];
   // [self.animationImage addSubview:_imageLogo];
    
}

- (void)initTextField {
    
//    self.textField = [[UITextField alloc] initWithFrame:CGRectMake( self.frame.origin.x - 80, self.frame.origin.y - 100, 160, 30)];
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(60,CGRectGetMaxY(_animationImage.frame)+30,self.frame.size.width-120,60)];
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.textField.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
    self.textField.layer.borderColor  = [UIColor whiteColor].CGColor;
    self.textField.placeholder = @"标题";
    self.textField.font = FONT(19);
    self.textField.textColor = [UIColor whiteColor];
    [self addSubview:_textField];
    
    // buttonNextStep
    self.buttonNextStep = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.buttonNextStep.frame = CGRectMake(CGRectGetMaxX(_textField.frame)+10, CGRectGetMinY(_textField.frame)+15, 30, 30);
    [self.buttonNextStep setBackgroundImage:[UIImage imageNamed:@"arrowDown"] forState:(UIControlStateNormal)];
    [self addSubview:_buttonNextStep];
    
    
    
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
