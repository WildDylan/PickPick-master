//
//  Host.h
//  PickPick
//
//  Created by Alice on 14/12/25.
//  Copyright (c) 2014年 Alice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Mission;

@interface Host : NSManagedObject

@property (nonatomic, retain) NSString * account;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSString * headerImageUrl;
@property (nonatomic, retain) NSSet *missions;
@end

@interface Host (CoreDataGeneratedAccessors)

- (void)addMissionsObject:(Mission *)value;
- (void)removeMissionsObject:(Mission *)value;
- (void)addMissions:(NSSet *)values;
- (void)removeMissions:(NSSet *)values;

@end
