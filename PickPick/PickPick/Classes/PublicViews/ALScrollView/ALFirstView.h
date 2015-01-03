//
//  ALFirstView.h
//  ALScrollViewVertical
//
//  Created by Alice on 14/12/21.
//  Copyright (c) 2014年 Alice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ALFirstView : UIView

/**
 *  click buttonNext switch to next page;
 */
@property (strong, nonatomic) UIButton *buttonNextStep;

/**
 *   get text from this text field if needed
 */

@property (strong, nonatomic) UITextField *textField;

/**
 *  you can custom animation images with this property
 */

@property (strong, nonatomic) NSArray *images;

/**
 *  you can custom logo image with this property
 */

@property (strong, nonatomic) UIImage *logo;

/**
 *  you can custom animation image with this property;
 */
@property (nonatomic, strong) UIImageView *animationImage;


/**
 *  initialize 
 *
 *  @param frame  fram
 *  @param images an array with images
 *
 *  @return self
 */
- (instancetype)initWithFrame:(CGRect)frame ImagesArray:(NSArray *)images;

@end


