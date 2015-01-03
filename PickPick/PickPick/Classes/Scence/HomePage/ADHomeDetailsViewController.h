//
//  ADHomeDetailsViewController.h
//  PickPick
//
//  Created by Alice on 14/12/20.
//  Copyright (c) 2014年 Alice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADModelHomePage.h"
@interface ADHomeDetailsViewController : UIViewController

/**
 *  buttons : chat / Record
 */

@property (strong, nonatomic) IBOutlet UIButton *buttonConnect;

@property (strong, nonatomic) IBOutlet UIButton *buttonRecord;

@property (strong, nonatomic) ADModelHomePage *model;


@end
