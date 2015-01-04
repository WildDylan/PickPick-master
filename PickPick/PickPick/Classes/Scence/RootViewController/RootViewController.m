//
//  RootViewController.m
//  PickPick
//
//  Created by Alice on 14/12/24.
//  Copyright (c) 2014年 Alice. All rights reserved.
//

#import "RootViewController.h"
#import "ChatListViewController.h"
#import "ADAccountViewController.h"
#import "ADHomePageViewController.h"
#import <MapKit/MapKit.h>
#import "ProgressHUD.h"


@interface RootViewController ()<UITabBarControllerDelegate,CLLocationManagerDelegate>
{
    NSString *defaultUserName;
    NSString *defaultUserPassword;
    NSUInteger integer;
}

@property (nonatomic, strong) UITabBarController *tabBC;
@property (nonatomic, strong) CLLocationManager *locationManager;

// 通知中心
@property (nonatomic, strong) UINavigationController *notificationNC;

@end

@implementation RootViewController

#pragma mark - make a judgement for longin

- (void)viewWillAppear:(BOOL)animated {
    
   
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self makeAJudgementForLogin];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubViewControllers];
    [self getUserCurrentLocation];
    [self addNotification];
}

- (void)getUserCurrentLocation {
    
    ADLog(@"get user current location ");
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = 200;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        ADLog(@"ios8 . manager requestWhen in use Authorization ");
        [self.locationManager requestWhenInUseAuthorization];
        
    }
    // 开始定位
    [self updatingUserLocation];
    
}

- (void)updatingUserLocation {
    
    [self.locationManager startUpdatingLocation];
    
}

#pragma mark - 
#pragma mark --- CLLocationManager delegate
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status == kCLAuthorizationStatusDenied || status == kCLAuthorizationStatusNotDetermined || status == kCLAuthorizationStatusRestricted) {
        
        //[ProgressHUD showError:@"获取当前位置失败,请开启定位" Interaction:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取当前位置失败,请开启定位" message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
    
}


- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
   ADLog(@"---- did update locations ----%@",locations.lastObject);
    
    [DataHandle shareInstance].currentLocation = locations.lastObject;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeAddress" object:self userInfo:@{@"currentAddress": locations.lastObject}];
    
}


- (void)makeAJudgementForLogin {
    
    defaultUserName = AD_GETL(AD_USERDEFAULT, AD_CURRENT_USER);
    defaultUserPassword = AD_GETL(AD_USERDEFAULT, AD_CURRENT_PASSWORD);
    ADLog(@" judge login --- defaultUserName %@  --- defaultUserPassword %@",defaultUserName,defaultUserPassword);
    if ([DataHandle shareInstance].isLogin) {
      
        return ;
        
    }else{
        
        if ([AD_USERDEFAULT boolForKey:AD_IS_LOGIN]) {
            
            [AVUser logInWithMobilePhoneNumberInBackground:defaultUserName password:defaultUserPassword block:^(AVUser *user, NSError *error) {
                
                if (!error) {
                    
                    ADLog(@"----login with mobile phont AVUser login succeed info ");
                    EMError *error = nil;
                    [[EaseMob sharedInstance].chatManager logoffWithError:&error];
                    ADLog(@"-------------error----------%@",error);
                    [self loginInBackgroundInEaseMob];
                    
                }else{
                    
                    ADLog(@"judge AVOS login error = %@",error);
                    [self presentLoginViewController];
                }
                
                
            }];
            
            
        }else{
            
            [self presentLoginViewController];
        }

        
    }
   
}

- (void)presentLoginViewController {
    
    ADLog(@"present login view controller ");
    ADLoginViewController *logVC = [[ADLoginViewController alloc] init];
    UINavigationController *logNC = [[UINavigationController alloc] initWithRootViewController:logVC];
    [self presentViewController:logNC animated:NO completion:nil];
    
}

- (void)loginInBackgroundInEaseMob {
    
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:defaultUserName password:defaultUserPassword completion:^(NSDictionary *loginInfo, EMError *error) {
        if (error) {
            
            ADLog(@"judge -- easeMob login error = %@",error);
            [self presentLoginViewController];
            
        }else{
            ADLog(@"judge -- easeMob login succeed");
            [DataHandle shareInstance].isLogin = YES;
        }
        
    } onQueue:dispatch_get_main_queue()];
    
}

- (void)initSubViewControllers {
    
    self.tabBC = [[UITabBarController alloc] init];
    _tabBC.delegate = self;
    _tabBC.tabBar.tintColor = ADDARK_BLUE;
    _tabBC.tabBar.barTintColor = ADLIGHT_BLUE;
    [self.view addSubview:_tabBC.view];
    
    
    // 主页
   // ADHomePageTableViewController *homeTVC = [[ADHomePageTableViewController alloc] initWithStyle:(UITableViewStylePlain)];
    ADHomePageViewController *homeVC = [[ADHomePageViewController alloc] init];
    UINavigationController *homeNC = [[UINavigationController alloc] initWithRootViewController:homeVC];
    homeNC.tabBarItem =  [[UITabBarItem alloc] initWithTitle:@"主页" image:[UIImage imageNamed:@"homeItem"] tag:1100];
    
    
    
    // 聊天界面
    ChatListViewController *chatVC = [ChatListViewController new];
    UINavigationController *conversationNC = [[UINavigationController alloc] initWithRootViewController:chatVC];
    conversationNC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"消息" image:[UIImage imageNamed:@"mail"] tag:1200];
    
    
    
    // 通知
    ADNotificationViewController *notificationVC = [ADNotificationViewController new];
    self.notificationNC = [[UINavigationController alloc] initWithRootViewController:notificationVC];
    _notificationNC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"通知" image:[UIImage imageNamed:@"notificationItem"] tag:1300];
    
    
    // 个人中心
    ADAccountViewController *ownTVC = [ADAccountViewController new];
    UINavigationController *ownNC = [[UINavigationController alloc] initWithRootViewController:ownTVC];
    ownNC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"个人中心" image:[UIImage imageNamed:@"ownItem"] tag:1400];
    
    NSArray *tabBarItems = @[homeNC,conversationNC,_notificationNC,ownNC];
    [_tabBC setViewControllers:tabBarItems];

    // 初始化badge标记数据
    integer = 0;
    
}

- (void)addNotification {
    
    ADLog(@"---addNotification badge %ld---",(unsigned long)integer);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showOnTheBadge) name:@"receivedNotification" object:nil];
    
}


- (void)showOnTheBadge {
    ADLog(@"-----badge%lu----",(unsigned long)integer);
//    integer++;
    integer +=1;
    ADLog(@"---%lu-----",(unsigned long)integer);
    _notificationNC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%lu",(unsigned long)integer];
    
}

#pragma mark - TabBar delegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    viewController.tabBarItem.badgeValue = nil;
    integer = 0;
    ADLog(@"---integer = %li---",(unsigned long)integer);
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
