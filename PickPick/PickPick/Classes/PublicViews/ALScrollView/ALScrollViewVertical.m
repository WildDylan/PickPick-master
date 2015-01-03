//
//  ALScrollViewVertical.m
//  ALScrollViewVertical
//
//  Created by Alice on 14/12/21.
//  Copyright (c) 2014年 Alice. All rights reserved.
//

#import "ALScrollViewVertical.h"
@interface ALScrollViewVertical ()<UIScrollViewDelegate,UITextFieldDelegate>
{
    CGPoint currentContentOffSet;
}

@property (strong, nonatomic) UITextField *textFieldTitle;
@property (strong, nonatomic) UITextField *textFieldAddress;
@property (strong, nonatomic) UITextField *textFieldrewad;
@property (strong, nonatomic) UITextView *textViewContent;
@property (strong, nonatomic) UIButton *buttonPickLimitTime;

@property (strong, nonatomic) UIImageView *imageWave;

@end

@implementation ALScrollViewVertical


- (instancetype)initWithFrame:(CGRect)frame
              animationImagesArray:(NSArray *)arrayImages {
    
    self = [super initWithFrame:frame];
    if (self) {
        // first
        self.firstView = [[ALFirstView alloc] initWithFrame:frame ImagesArray:arrayImages[0]];
        [_firstView.buttonNextStep addTarget:self action:@selector(clickToNextPage:) forControlEvents:(UIControlEventTouchUpInside)];
        self.firstView.textField.delegate = self;
        [self addSubview:_firstView];
    
        
        // second
        self.secondView = [[ALFirstView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_firstView.frame), CGRectGetMaxY(_firstView.frame), CGRectGetWidth(_firstView.frame), CGRectGetHeight(_firstView.frame)) ImagesArray:arrayImages[1]];
        self.secondView.textField.placeholder = @"地址";
        self.secondView.textField.delegate = self;
        [_secondView.buttonNextStep addTarget:self action:@selector(clickToNextPage:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:_secondView];
        
        
        // third
        self.thirdView = [[ALFirstView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_firstView.frame), CGRectGetMaxY(_secondView.frame), CGRectGetWidth(_firstView.frame), CGRectGetHeight(_firstView.frame)) ImagesArray:arrayImages[2]];
        [_thirdView.buttonNextStep addTarget:self action:@selector(clickToNextPage:) forControlEvents:(UIControlEventTouchUpInside)];
        self.thirdView.textField.delegate = self;
        self.thirdView.textField.placeholder = @"酬金";
        [self addSubview:_thirdView];
        
        // fourth
        self.fourthView = [[ALSecondView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_firstView.frame), CGRectGetMaxY(_thirdView.frame),CGRectGetWidth(_firstView.frame), CGRectGetHeight(_firstView.frame)) ImagesArray:arrayImages[3]];
        [_fourthView.buttonNextStep addTarget:self action:@selector(clickToNextPage:) forControlEvents:(UIControlEventTouchUpInside)];

        [self addSubview:_fourthView];
        
        // fifth
        self.fifthView  = [[ALThirdView alloc] initWithFrame:CGRectMake(CGRectGetMinX(_firstView.frame), CGRectGetMaxY(_fourthView.frame),CGRectGetWidth(_firstView.frame), CGRectGetHeight(_firstView.frame)) ImagesArray:arrayImages[4]];
        [self addSubview:_fifthView];
       
        self.contentSize = CGSizeMake(100, frame.size.height*5);
        [self doSomeConfiguration];
     
    }
    
    
    
    return self;
}

- (void)doSomeConfiguration {
    
    self.delegate = self;
    self.pagingEnabled = YES;
    
    
}

#pragma mark - scrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    
    currentContentOffSet =  scrollView.contentOffset;
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    [self endEditing:YES];
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    
    currentContentOffSet = scrollView.contentOffset;
}

- (void)clickToNextPage:(UIButton *)button {
    
    [self endEditing:YES];
    CGPoint destinationPoint = CGPointMake(0, currentContentOffSet.y + self.frame.size.height);
    [self setContentOffset:destinationPoint animated:YES];
    
}


#pragma mark - 






/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
