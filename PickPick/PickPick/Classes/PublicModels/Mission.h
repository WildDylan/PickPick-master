//
//  Mission.h
//  PickPick
//
//  Created by Alice on 14/12/25.
//  Copyright (c) 2014年 Alice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Mission : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * timeLimit;
@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * reward;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * timeStamp;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSManagedObject *host;

@end
