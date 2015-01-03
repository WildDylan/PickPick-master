//
//  ADModelHomePage.h
//  PickPick
//
//  Created by Alice on 14/12/19.
//  Copyright (c) 2014年 Alice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADModelHomePage : NSObject


@property (nonatomic, strong) AVUser *host;
@property (nonatomic, strong) AVUser *executant;
@property (nonatomic, strong) NSString *aid;

@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *imageHeaderUrl;
@property (nonatomic, strong) UIImage *imageHeader;


@property (nonatomic, strong) NSString *status;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *timeLimit;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *reward;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSNumber *distance;
@property (nonatomic, strong) NSNumber *timeStamp;

@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;

@end
