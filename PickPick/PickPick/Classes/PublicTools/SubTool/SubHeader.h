//
//  SubHeader.h
//  PickPick
//
//  Created by Alice on 14/12/15.
//  Copyright (c) 2014年 Alice. All rights reserved.
//

#ifndef PickPick_SubHeader_h
#define PickPick_SubHeader_h

#define DEBUG 1  // 1- Debug 0-Release

#ifdef DEBUG
#define ADLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define ADLog(...)
#endif

/*!
 *  @author Dylan
 *
 *  @brief  ID AND KEY
 */
#define APPID   @"vmvwrso7stvp5vmzccs0a6zqa37nddpjn8hn30fsq985rbnf"
#define APPKEY  @"yww7pshcw3hs6uciwojxbl3dq085g1oj9uv7bvk4g6ogu5xm"

/// Navigation Height
#define NAVI_BAR_HEIGHT 44.0f

/// Status Bar
#define STATUSBAR_HEIGHT   [[UIApplication sharedApplication] statusBarFrame].size.height

/// System Version
#define IOS_FSystenVersion ([[[UIDevice currentDevice] systemVersion] floatValue])
#define IOS_DSystenVersion ([[[UIDevice currentDevice] systemVersion] doubleValue])
#define IOS_SSystemVersion ([[UIDevice currentDevice] systemVersion])

/// Application Language
#define CURRENTLANGUAGE    ([[NSLocale preferredLanguages] objectAtIndex:0])

/// Screen size
#define SCREEN_HEIGHT [[UIScreen mainScreen] applicationFrame].size.height
#define SCREEN_WIDTH  [[UIScreen mainScreen] applicationFrame].size.width

/// Color
#define RGBCOLOR(r,g,b)    [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
// Main Color
#define ADLIGHT_BLUE_(alp)  RGBACOLOR(86, 150, 220, alp)
#define ADLIGHT_BLUE        RGBCOLOR(86, 150, 220)
#define ADDARK_BLUE_(alp)   RGBACOLOR(55, 91, 130, alp)
#define ADDARK_BLUE         RGBCOLOR(55, 91, 130)

/// Fonts
#define FONT(s) [UIFont systemFontOfSize:s]

/// Image
#define LOCAL_IMG(img)   [UIImage imageNamed:img]

/// UserDefault
#define AD_USERDEFAULT [NSUserDefaults standardUserDefaults]
#define AD_CURRENT_USER @"currentUserName"
#define AD_CURRENT_PASSWORD @"currentPassword"
#define AD_IS_LOGIN @"isLogin"

#define AD_SAVE(OBJC, KEY, VALUE)       [(OBJC) setObject:(VALUE) forKey:(KEY)] // Save Online
#define AD_SAVEL(OBJC, KEY, VALUE)      [(OBJC) setValue:(VALUE) forKey:(KEY)]  // Save Local
#define AD_SAVE_BOLEAN(OBJC,KEY,BOOL)   [(OBJC) setBool:(BOOL) forKey:(KEY)]    // Save BOOL



#define AD_GETW(OBJC, KEY) [(OBJC)  objectForKey:(KEY)] // Online Data
#define AD_GETL(OBJC, KEY) [(OBJC)  valueForKey:(KEY)]  // Local Data

/// String with Class
#define AD_STRINGWITHCLASS(PARM) NSStringFromClass(PARM)
#define AD_CLSSFROMSTRING(PARM)  NSClassFromString(PARM)


// CoreData
#define AD_MISSION_ENTITY_DESC  [NSEntityDescription entityForName:@"Mission" inManagedObjectContext:[[CoreDataManager defaultManager] managedObjectContext]]  // Mission entity description
#define AD_HOST_ENTITY_DESC [NSEntityDescription entityForName:@"Host" inManagedObjectContext:[[CoreDataManager defaultManager] managedObjectContext]]  // Host entity description
#define AD_ManagedObjContext    [CoreDataManager defaultManager] managedObjectContext]   // managed object context 

#import "ADLoginViewController.h"
#import "ADRegistViewController.h"
#import "ADHomePageTableViewController.h"
#import "ADPostMissionViewController.h"
#import "ADNotificationViewController.h"
#import "DataHandle.h"

#import "Host.h"
#import "Mission.h"


// AVOS
#import <AVOSCloud.h>

/**
 *  EeseMob
 */

#import <Availability.h>

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define KNOTIFICATION_LOGINCHANGE @"loginStateChange"

#define CHATVIEWBACKGROUNDCOLOR [UIColor colorWithRed:0.936 green:0.932 blue:0.907 alpha:1]

#import "EaseMobHeaders.h"

#import "WCAlertView.h"
#import "TTGlobalUICommon.h"
#import "UIViewController+HUD.h"
#import "UIViewController+DismissKeyboard.h"
#import "NSString+Valid.h"

#define MR_SHORTHAND
#import "CoreData+MagicalRecord.h"

#import "EaseMob.h"





#endif
