//
//  DataHandle.m
//  PickPick
//
//  Created by Alice on 14/12/25.
//  Copyright (c) 2014年 Alice. All rights reserved.
//

#import "DataHandle.h"

static  DataHandle *dataHandle = nil;
@implementation DataHandle

+ (DataHandle *)shareInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       
        dataHandle = [[DataHandle alloc] init];
        
    });
    
    return dataHandle;
}



@end
