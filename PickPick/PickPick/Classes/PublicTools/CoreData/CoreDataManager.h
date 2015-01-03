//
//  CoreDataManager.h
//  CoreData_Practice1
//
//  Created by Alice on 14/12/12.
//  Copyright (c) 2014年 Alice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface CoreDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (CoreDataManager *)defaultManager;

- (void)saveContext;

- (NSURL *)applicationDocumentsDirectory;



@end
