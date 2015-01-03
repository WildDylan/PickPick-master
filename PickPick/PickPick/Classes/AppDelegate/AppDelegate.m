//
//  AppDelegate.m
//  PickPick
//
//  Created by Alice on 14/12/14.
//  Copyright (c) 2014年 Alice. All rights reserved.
//

#import "AppDelegate.h"
#import <AVOSCloud.h>
#import "ADLoginViewController.h"
#import "ChatViewController.h"
#import "ChatListViewController.h"
#import "ADAccountViewController.h"

#import "RootViewController.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"

@interface AppDelegate ()
{
    NSString *defaultUserName;
    NSString *defaultUserPassword;
}

@property (nonatomic, strong) UITabBarController *tabBC;
@end
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    // AVOS Config
    [AVOSCloud setApplicationId:APPID clientKey:APPKEY];
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    RootViewController *rootVC = [[RootViewController alloc] init];
    self.window.rootViewController = rootVC;
    
    [self.window makeKeyAndVisible];
    
    // 搜集用户通过通知打开应用的数据
    [self statitsticsOfOpenningAppWhenReceivedNotification:application launchPotions:launchOptions];
    
    /**
     *  chat
     */
    [[EaseMob sharedInstance] registerSDKWithAppKey:@"dylanmac#imoney" apnsCertName:@"dev"];
    // 需要在注册sdk后写上该方法
    [[EaseMob sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    // 开启消息送达通知
    [[EaseMob sharedInstance].chatManager enableDeliveryNotification];
    
    // 注册推送
    [self registerRemoteNotification];
    
    [self style];
    
    
    return YES;
}

- (void)registerRemoteNotification
{
#if !TARGET_IPHONE_SIMULATOR
    UIApplication *application = [UIApplication sharedApplication];
    
    //iOS8 注册APNS
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }else{
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound |
        UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
#endif
}


#pragma mark - tabBar delegate

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    viewController.tabBarItem.badgeValue = nil;
    
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    ADLog(@"-------deviceToken----user--%@,---%@", deviceToken,[AVUser currentUser]);
    
    // AVOS
    AVInstallation *currentInstallation = [AVInstallation currentInstallation];
    [currentInstallation setObject:[AVUser currentUser] forKey:@"owner"];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
    
    // EaseMob方法调用
    [[EaseMob sharedInstance] application:app didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];

}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    ADLog(@"%@", error);
    
    // EaseMob
    [[EaseMob sharedInstance] application:application didFailToRegisterForRemoteNotificationsWithError:error];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"注册推送失败"
message:error.description delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
    
    
}

#pragma mark - Receive Notifications / User info
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    ADLog(@"----user Info %@---",userInfo);
    // post notification when received badge
    [self countAndShowOnTheBadge];
    [[EaseMob sharedInstance].deviceManager asyncPlayNewMessageSound];
    [[EaseMob sharedInstance].deviceManager asyncPlayVibration];
    [[EaseMob sharedInstance] application:application didReceiveRemoteNotification:userInfo];
    
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    ADLog(@"-----received local notification ------");
    [[EaseMob sharedInstance] application:application didReceiveLocalNotification:notification];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
    [[EaseMob sharedInstance] applicationWillResignActive:application];
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    [[EaseMob sharedInstance] applicationDidEnterBackground:application];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    [[EaseMob sharedInstance] applicationWillEnterForeground:application];
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // badge value
    if ([UIApplication sharedApplication].applicationIconBadgeNumber != 0) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
    
    [[EaseMob sharedInstance] applicationDidBecomeActive:application];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    [[EaseMob sharedInstance] applicationWillTerminate:application];
    
}

- (void)statitsticsOfOpenningAppWhenReceivedNotification:(UIApplication *)application launchPotions:(NSDictionary *)launchOptions{
    
    if (application.applicationState != UIApplicationStateBackground) {
        // Track an app open here if we launch with a push, unless
        // "content_available" was used to trigger a background push (introduced
        // in iOS 7). In that case, we skip tracking here to avoid double
        // counting the app-open.
        BOOL preBackgroundPush = ![application respondsToSelector:@selector(backgroundRefreshStatus)];
        BOOL oldPushHandlerOnly = ![self respondsToSelector:@selector(application:didReceiveRemoteNotification:fetchCompletionHandler:)];
        BOOL noPushPayload = ![launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (preBackgroundPush || oldPushHandlerOnly || noPushPayload) {
            [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
            ADLog(@"----- count badge -----");
        }
        
    }
    
}

- (void)countAndShowOnTheBadge {
    ADLog(@"---show on the badge ---");
    [[NSNotificationCenter defaultCenter] postNotificationName:@"receivedNotification" object:self];
    
}


- (void)style {
    
    [[UINavigationBar appearance] setTintColor:ADDARK_BLUE];
    [[UINavigationBar appearance] setBarTintColor:ADLIGHT_BLUE];
    
    
}

#pragma clang diagnostic pop


@end
