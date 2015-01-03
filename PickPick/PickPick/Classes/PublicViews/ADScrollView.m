//
//  ADScrollView.m
//  PickPick
//
//  Created by Alice on 14/12/21.
//  Copyright (c) 2014年 Alice. All rights reserved.
//

#import "ADScrollView.h"


@interface ADScrollView ()

@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UITextField *textFieldTitle;
@property (strong, nonatomic) UITextField *textFieldAddress;
@property (strong, nonatomic) UITextField *textFieldrewad;
@property (strong, nonatomic) UITextView *textViewContent;
@property (strong, nonatomic) UIButton *buttonPickLimitTime;

@property (strong, nonatomic) UIImageView *imageWave;

@end

@implementation ADScrollView

- (instancetype)initWithFrame:(CGRect)frame logoImage:(UIImage *)image {
    
    self = [super initWithFrame:frame];
    if (self) {

        self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
        self.textFieldTitle = [[UITextField alloc] initWithFrame:CGRectMake(frame.origin.x - 100, frame.origin.y - 80, 200, 30)];
        self.textFieldTitle.placeholder = @"标题";
        self.textFieldTitle.borderStyle = UITextBorderStyleRoundedRect;
        self.textFieldTitle.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
        
        [self addSubview:_textFieldTitle];
        
        
    }

    return self;
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
