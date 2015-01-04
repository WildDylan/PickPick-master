//
//  ADHomeDetailsViewController.m
//  PickPick
//
//  Created by Alice on 14/12/20.
//  Copyright (c) 2014年 Alice. All rights reserved.
//

#import "ADHomeDetailsViewController.h"
#import "ChatListViewController.h"
#import "ChatViewController.h"
#import "SVProgressHUD.h"
@interface ADHomeDetailsViewController ()
{
    UINavigationController *chatNC;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIImageView *imageHeader;
@property (strong, nonatomic) IBOutlet UILabel *labelUsername;
@property (strong, nonatomic) IBOutlet UILabel *labelTimeLimit;
@property (strong, nonatomic) IBOutlet UILabel *labelDistance; // 改为地址 address
@property (strong, nonatomic) IBOutlet UILabel *labelReward;
@property (strong, nonatomic) IBOutlet UILabel *labelTitle;
@property (strong, nonatomic) IBOutlet UILabel *labelContent;


@end

@implementation ADHomeDetailsViewController



#pragma mark - connect button & record button


- (IBAction)connectWithPromulgator:(UIButton *)sender {
    
    ADLog(@"与联系人对接");
    // 把详情界面的 nickname == chatter
    NSString *chatter = [self.model.host objectForKey:@"nickname"];
    ChatViewController *chatVC = [[ChatViewController alloc] initWithChatter:chatter isGroup:NO];
    chatNC = [[UINavigationController alloc] initWithRootViewController:chatVC];
    chatNC.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:(UIBarButtonItemStylePlain) target:self action:@selector(back:)];
    [self presentViewController:chatNC animated:YES completion:nil];
    
}

- (void)back:(UIBarButtonItem *)buttonItem {
    
    NSLog(@"---");
    [chatNC dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)playRecording:(UIButton *)sender {

    ADLog(@"播放录音");
    ADLog(@"---接收----%@",self.model.host);
// 判断是否是当前用户自己点自己的任务,如果不是再继续
    AVUser *user = [AVUser currentUser];
    ADLog(@"----current user aid ----%@, ---- mission host aid ---%@",user.mobilePhoneNumber,self.model.aid);
    
    if ([user.mobilePhoneNumber isEqualToString:self.model.aid]) {
    
        [SVProgressHUD setBackgroundColor:ADDARK_BLUE_(0.8)];
        [SVProgressHUD setRingThickness:20];
        [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
        [SVProgressHUD showErrorWithStatus:@"---TEST : 不可以接自己的任务哦---" maskType:4];
        
    }
    
    
    //---------------------------------------------------- 接 收 任 务 ----------------------------------------------
    AVQuery *query = [AVQuery queryWithClassName:@"Mission"];
    [query whereKey:@"aid" equalTo:self.model.aid];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (error) {
            
            ADLog(@"----error = %@----",error);
        }else{
        
            AVObject *obj = objects.lastObject;
            [obj setObject:user.mobilePhoneNumber forKey:@"executant"];
            [obj setObject:@"工作中" forKey:@"status"];
            [obj saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                
                if (error) {
                    ADLog(@"---- save error --- %@ ",error);
                }
                
            }];
        }
        
    }];
    
    AVQuery *pushQuery = [AVInstallation query];
    [pushQuery whereKey:@"owner" equalTo:self.model.host];
    
    // send push notification to query
    AVPush *push = [[AVPush alloc] init];
    [push setQuery:pushQuery];
    [push setMessage:[NSString stringWithFormat:@"' %@ '接受了你的任务",[self.model.host objectForKey:@"nickname"]]];
  //  [push sendPushInBackground];
    [push sendPushInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (error) {
            ADLog(@"--- error ---- %@",error);
        }
        
    }];
    
}


#pragma mark - view load / appear
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
//        
//        self.automaticallyAdjustsScrollViewInsets = NO;
//        
//    };
    [self setHideTabBarAndShowNavigationBar];
    [self adjustSubviews];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.alwaysBounceVertical = YES;
    self.scrollView.alwaysBounceHorizontal = NO;
    self.scrollView.contentSize = CGSizeMake(30, self.view.frame.size.height + 200);
   [self.navigationController.navigationBar setHidden:NO];
    self.tabBarController.tabBar.hidden = YES;
    ADLog(@"---view did appear user aid ---%@",self.model.aid);
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setHideTabBarAndShowNavigationBar];
    
    [self setValueForSubViews];
    ADLog(@"-----view will appear----");
}

- (void)setHideTabBarAndShowNavigationBar {
    
    if (!self.tabBarController.tabBar.hidden) {
        
        [self.tabBarController.tabBar setHidden:YES];
        
    }
    
    if (self.navigationController.navigationBar.hidden) {
        
        [self.navigationController.navigationBar setHidden:NO];
        
    }

    
}

- (void)setValueForSubViews {
    
    _labelUsername.text = [self.model.host objectForKey:@"nickname"];
    _labelTimeLimit.text = self.model.timeLimit;
    _labelDistance.text = self.model.address;
    _labelReward.text = [NSString stringWithFormat:@"¥ %@",self.model.reward];
    _labelTitle.text = self.model.title;
    _labelContent.text = self.model.content;
    AVFile *file = [self.model.host objectForKey:@"imageHeader"];
    NSData *data = [file getData];
    _imageHeader.image = [UIImage imageWithData:data];
    
}

- (void)adjustSubviews {
    
    
  //  self.automaticallyAdjustsScrollViewInsets = YES;
    self.imageHeader.layer.cornerRadius = 10.f;
    self.imageHeader.layer.masksToBounds = YES;
    
    
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
