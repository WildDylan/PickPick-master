//
//  ALSecondView.m
//  ALScrollViewVertical
//
//  Created by Alice on 14/12/22.
//  Copyright (c) 2014年 Alice. All rights reserved.
//

#import "ALSecondView.h"

@interface ALSecondView ()<UITextViewDelegate>
{
    UILabel *labelPlaceholder;
}

@end

@implementation ALSecondView


- (instancetype)initWithFrame:(CGRect)frame ImagesArray:(NSArray *)images {
    self = [super initWithFrame:frame ImagesArray:images];
    if (self) {
        
        [self.textField removeFromSuperview];
        self.textView = [[UITextView alloc] initWithFrame:CGRectMake(60,CGRectGetMaxY(self.animationImage.frame)+40,self.frame.size.width-120,120)];
        self.textView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
        self.textView.layer.cornerRadius  = 4.5;
        self.textView.font = FONT(19);
        self.textView.textColor = [UIColor whiteColor];
        self.textView.delegate  = self;
        [self addSubview:self.textView];
        
        [self initPlaceholderLabel];
        
        
    }
    
    return self;
}

- (void)initPlaceholderLabel {
    
    labelPlaceholder  = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMidX(_textView.frame) - 40, CGRectGetMidY(_textView.frame)-10, 80, 20)];
    labelPlaceholder.text = @"任务内容";
    labelPlaceholder.textColor = ADDARK_BLUE;
    [self addSubview:labelPlaceholder];

}


#pragma mark - textView delegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
   
    labelPlaceholder.alpha = 0;

}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if (self.textView.text == nil || self.textView.text.length == 0) {

        labelPlaceholder.alpha = 1;
    }
    
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
