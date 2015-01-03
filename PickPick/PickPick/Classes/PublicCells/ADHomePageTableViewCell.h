//
//  ADHomePageTableViewCell.h
//  PickPick
//
//  Created by Alice on 14/12/19.
//  Copyright (c) 2014年 Alice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADModelHomePage.h"
@interface ADHomePageTableViewCell : UITableViewCell


@property (nonatomic, strong) Mission *model;
@property (nonatomic, strong) ADModelHomePage *modelHome;
@property (nonatomic, strong) ADModelHomePage *modelAccount;

@end
