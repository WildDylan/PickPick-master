//
//  DataHandle.h
//  PickPick
//
//  Created by Alice on 14/12/25.
//  Copyright (c) 2014年 Alice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface DataHandle : NSObject

+ (DataHandle *)shareInstance;

@property (nonatomic, strong) NSString *userAccount;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) CLLocation *currentLocation;

//@property (nonatomic, strong)
@property (nonatomic, assign) BOOL isLogin;

@end
