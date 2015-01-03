//
//  ALScrollViewVertical.h
//  ALScrollViewVertical
//
//  Created by Alice on 14/12/21.
//  Copyright (c) 2014年 Alice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ALFirstView.h"
#import "ALSecondView.h"
#import "ALThirdView.h"
@interface ALScrollViewVertical : UIScrollView

@property (strong, nonatomic) UIScrollView *scrollView;
/**
 *  all the views on the scrollView
 */
@property (strong, nonatomic) ALFirstView *firstView;
@property (strong, nonatomic) ALFirstView *secondView;
@property (strong, nonatomic) ALFirstView *thirdView;
@property (strong, nonatomic) ALSecondView *fourthView;
@property (strong, nonatomic) ALThirdView *fifthView;

- (instancetype)initWithFrame:(CGRect)frame
         animationImagesArray:(NSArray *)arrayImages;

@end
