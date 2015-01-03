//
//  ADAccountViewController.m
//  Account
//
//  Created by Dylan on 14/12/21.
//  Copyright (c) 2014年 Dylan. All rights reserved.
//
//


#define JUMP_MESSAGE(DES) [NSString stringWithFormat:@"Line: %d, Here For Jump---->%@", __LINE__, DES]
#define	XLog(format,...) NSLog(@"[%s][%d]" format,__func__,__LINE__,##__VA_ARGS__)

#define KINSET_BASEHEADER 160
#define KINSET_HEADER_A 80
#define KINSET_ALERTSIZE 20
#define KINSET_PADDING 0
#define KINSET_PADDING_MIN 5
#define KINSET_TEXTFIELD_PADDING 3
#define KINSET_TEXTFIELD_BUTTON_WIDTH 70
#define KINSET_SEGMENT_PADDING 4

static NSString * const AccountCellIdentifier = @"homePageCell";

#import "ADHomePageTableViewCell.h"
#import "ADAccountViewController.h"
#import "HMSegmentedControl.h"
#import "ADModelHomePage.h"
#import "CWStarRateView.h"
#import "btRippleButtton.h"
#import "RNBlurModalView.h"
#import "ADConfirmPageViewController.h"
#import "SVProgressHUD.h"

@interface ADAccountViewController () <UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

// Basic TableView
@property (nonatomic, strong) UITableView * baseTableView;

// Header. when _isLogin == NO, set default image.
@property (nonatomic, strong) BTRippleButtton * headerImageButton;

// NickName. When EaseMob's NickName is nil, Press button for set nickName.
@property (nonatomic, strong) UIButton * nickNameButton;

// RateStar. UserInteractionEnabled = NO. only for show
@property (nonatomic, strong) CWStarRateView * rateStarView;

// BaseArray.
@property (nonatomic, strong) NSMutableArray * baseDataArray;

//-------------------------Alert-----------------------------
@property (nonatomic, strong) RNBlurModalView * alertView;
@property (nonatomic, strong) UITextField * myNickName;
@property (nonatomic, strong) UIImage *imageGet;

//-------------------------User info-------------------------
@property (nonatomic, strong) UIImage *imageHeader;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *aid;

@property (nonatomic, strong) UIImageView *imageView;

@end

@interface ADAccountViewController ()

@end

@implementation ADAccountViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

#pragma mark - view load / appear
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self showTabBar];
    [self downloadBaseData];
    [self downloadUserInfo];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setRightBarButtonWithString:@"设置"];
    [self layoutMyViews];
    [self selfStyle];
    [self initData];
}

//-------------------------------------------------------------------------------
//------------------------------------ Layout -----------------------------------

- (void)showTabBar {
    
    if (self.tabBarController.tabBar.hidden) {
        [self.tabBarController.tabBar setHidden:NO];
    }else{
        return;
    }
    
    
    
}

- (void)layoutMyViews {
    
    
//    首先判断持久化里有没有用户数据  然后再去设置 Title  Title展示个人昵称
//    [self setTitle:@"个人中心"];
    self.imageHeader = [[UIImage alloc] init];
    self.baseTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _baseTableView.delegate = self;
    _baseTableView.dataSource = self;
    _baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _baseTableView.backgroundColor = ADLIGHT_BLUE;
    [self.view addSubview:_baseTableView];
    [_baseTableView registerNib:[UINib nibWithNibName:@"ADHomePageTableViewCell" bundle:nil] forCellReuseIdentifier:AccountCellIdentifier];
}

- (void)initData {
    self.baseDataArray = [NSMutableArray array];
}

- (void)downloadBaseData {
    
    [self showProgressHUD];
    AVQuery *query = [[AVQuery alloc] initWithClassName:@"Mission"];
    [self downloadBaseDataWithQuery:query];
    
}

- (void)downloadUserInfo {
    AVUser *user = [AVUser currentUser];
    ADLog(@"----account current user %@---",[user objectForKey:@"nickname"]);
    AVFile *getFile =[user objectForKey:@"imageHeader"];
    NSData *getData = [getFile getData];
    UIImage *imageHeader  = [UIImage imageWithData:getData];
    self.aid = user.mobilePhoneNumber;
    self.imageHeader = imageHeader;
    self.userName = [user objectForKey:@"nickname"];
    
}

- (void)showProgressHUD {
    
    [SVProgressHUD setBackgroundColor:ADDARK_BLUE];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD show];
    
}

- (void)downloadBaseDataWithQuery:(AVQuery *)query {
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
       
        if (error) {
            
//            ADLog(@"--- error = %@ ---",error);
//            [self.baseDataArray removeAllObjects];
//            [self.baseTableView reloadData];
//            [SVProgressHUD dismiss];
        }else{
            ADLog(@"---- load data %ld ---",(unsigned long)objects.count);
            [self.baseDataArray removeAllObjects];
            if (objects.count) {
                for (AVObject *objc in objects) {
                    
                    ADModelHomePage *model = [[ADModelHomePage alloc] init];
                    AVObject *obj = [objc objectForKey:@"host"];
                    AVUser *getUser = (AVUser *)[obj fetchIfNeeded];
                    [model setValue:getUser forKey:@"host"];
                    [model setValue:[objc objectForKey:@"aid"] forKey:@"aid"];
                    [model setValue:[objc objectForKey:@"status"] forKey:@"status"];
                    [model setValue:[objc objectForKey:@"title"] forKey:@"title"];
                    [model setValue:[objc objectForKey:@"timeLimit"] forKey:@"timeLimit"];
                    [model setValue:[objc objectForKey:@"address"] forKey:@"address"];
                    [model setValue:[objc objectForKey:@"reward"] forKey:@"reward"];
                    [model setValue:[objc objectForKey:@"content"] forKey:@"content"];
                    [model setValue:[objc objectForKey:@"latitude"] forKey:@"latitude"];
                    [model setValue:[objc objectForKey:@"longitude"] forKey:@"longitude"];
                    [model setValue:[objc objectForKey:@"timeStamp"] forKey:@"timeStamp"];
                    [self.baseDataArray addObject:model];
                    
                }
                
            }
            
            [self.baseTableView reloadData];
            [SVProgressHUD dismiss];
        }
        
    }];

}


- (void)selfStyle {
    
    [self.navigationController.navigationBar setBarTintColor:ADLIGHT_BLUE];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setTranslucent:NO];
    _baseTableView.backgroundColor = ADLIGHT_BLUE;
    
}

- (void)setRightBarButtonWithString: (NSString *) string {
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:({
        UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0, 0, 25, 25);
        [button setBackgroundImage:[UIImage imageNamed:@"设置按钮"] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14.];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(settingPress) forControlEvents:UIControlEventTouchUpInside];
        button;
    })];

}

//------------------------------------ Layout -----------------------------------
//-------------------------------------------------------------------------------

#pragma mark - Targets
- (void)settingPress {
    
    
    ADConfirmPageViewController *confirmVC = [[ADConfirmPageViewController alloc] init];
    
    [self.navigationController pushViewController:confirmVC animated:YES];
    
    //TODO: Set. VC
    XLog(@"%@", JUMP_MESSAGE(@"SettingVC"));
}

#pragma mark - tableView delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return [_baseDataArray count];
    if (self.baseDataArray.count) {
        
        [self.view bringSubviewToFront:_baseTableView];
        return self.baseDataArray.count;
        
    }else{
        
        [self.view addSubview:[self setPlaceholderPicture]];
        [self.view bringSubviewToFront:_baseTableView];
        return 0;

    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ADHomePageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AccountCellIdentifier];
    if (!cell) {
        
        [tableView registerNib:[UINib nibWithNibName:@"ADHomePageTableViewCell" bundle:nil] forCellReuseIdentifier:AccountCellIdentifier];
        cell.layer.cornerRadius = 10;
        cell.layer.masksToBounds = YES;
        cell = [tableView dequeueReusableCellWithIdentifier:AccountCellIdentifier];
    }
    
    cell.contentView.backgroundColor = ADLIGHT_BLUE;
    
    if (self.baseDataArray.count) {
        ADLog(@"-----");
        ADModelHomePage *model = self.baseDataArray[indexPath.row];
        cell.modelAccount = model;
    }
    
    
    
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 180;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return KINSET_BASEHEADER;
}

//-----------------------------------------------------------------------------
//------------------------------------Header-----------------------------------
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        
        UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), KINSET_BASEHEADER)];
        [bgView setBackgroundColor:ADLIGHT_BLUE];
        [self layoutAtView:bgView];
        return bgView;
    }
    return nil;
}

- (void)layoutAtView: (UIView *)bgView {
    
    ADLog(@"--------------------------------------------------------------------------------------");
    // Layout Header View
    self.headerImageButton = [[BTRippleButtton alloc] initWithImage:self.imageHeader andFrame:CGRectMake(CGRectGetWidth(self.view.frame) / 2. - KINSET_HEADER_A / 2., KINSET_PADDING, KINSET_HEADER_A, KINSET_HEADER_A) onCompletion:^(BOOL success) {
       
        if (success) {
                ADLog(@"-----------------------------------------------------------------------------------------");
            //TODO:  首先判断 是否登录/ 如果没有登录->JUMO LOGIN / 如果登录->打开ImagePicker进行头像选取
            
            
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            picker.allowsEditing = YES;
            [self.view.window.rootViewController presentViewController:picker animated:YES completion:nil];
        
        }
    }];
    [_headerImageButton setRippeEffectEnabled:YES];
    [_headerImageButton setRippleEffectWithColor:[UIColor colorWithRed:0.989 green:1.000 blue:0.767 alpha:1.000]];
    [bgView addSubview:_headerImageButton];
    
    // Layout NickName View
    self.nickNameButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _nickNameButton.frame = CGRectMake(0, CGRectGetMaxY(_headerImageButton.frame) + KINSET_PADDING_MIN, CGRectGetWidth(self.view.frame), 25);
    [_nickNameButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_nickNameButton setTitle:self.userName forState:UIControlStateNormal];
    _nickNameButton.titleLabel.font = [UIFont systemFontOfSize:16.];
    [_nickNameButton addTarget:self action:@selector(changeNickName:) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:_nickNameButton];
    
    // Layout Segment Control
    // Segmented control with scrolling
    HMSegmentedControl *segmentedControl1 = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"已发布", @"工作中", @"已完成"]];
    segmentedControl1.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    segmentedControl1.frame = CGRectMake(2 * KINSET_SEGMENT_PADDING, CGRectGetMaxY(_nickNameButton.frame) + KINSET_PADDING_MIN, CGRectGetWidth(self.view.frame) - 4 * KINSET_SEGMENT_PADDING, 40);
    segmentedControl1.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    segmentedControl1.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    segmentedControl1.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentedControl1.layer.masksToBounds = YES;
    segmentedControl1.layer.cornerRadius = 3;
    [segmentedControl1 addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [bgView addSubview:segmentedControl1];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    ADLog(@"----------------------------------------------------------------------------------------------");
    
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    AVUser *user = [AVUser currentUser];
    NSData *imageData;
    if (UIImagePNGRepresentation(image) == nil) {
        
        imageData = UIImageJPEGRepresentation(image, 0.5);
        AVFile *file = [AVFile fileWithName:[NSString stringWithFormat:@"%@.jpg",user.mobilePhoneNumber] data:imageData];
        [user setObject:file forKey:@"imageHeader"];
        
    }else{
        
        imageData = UIImagePNGRepresentation(image);
        AVFile *file = [AVFile fileWithName:[NSString stringWithFormat:@"%@.png",user.mobilePhoneNumber] data:imageData];
        [user setObject:file forKey:@"imageHeader"];
    }
    
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
        if (error) {
            
            ADLog(@"----error = %@---",error);
        
        }
        
        if (succeeded) {
            
            ADLog(@"-----save succeed----");
        }
        
    }];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (UIImageView *)setPlaceholderPicture {
    
    if (self.imageView == nil) {
        
        self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_placeholder"]];
        _imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 100);
        return _imageView;
    }
    return _imageView;
}

- (void)segmentedControlChangedValue: (HMSegmentedControl *)segment {
    ADLog(@"%ld", (long)[segment selectedSegmentIndex])
    //TODO:  根据选择不同的index 来让TableView展示不同的数据
    switch (segment.selectedSegmentIndex) {
        case 0:
        {
        
        // 已发布
            [self postedMissions];
            
        }
            break;
        case 1:
        {
        
        // 工作中
            [self working];
            
        }
            break;
        case 2:
        {
        // 已完成
            [self finished];
        }
            break;
            
        default:
        {
            XLog(@"segment error!");
        }
            break;
    }
}

- (void)postedMissions {
    ADLog(@"---已发布--");
    AVQuery *query = [AVQuery queryWithClassName:@"Missions"];
    [query whereKey:@"aid" equalTo:self.aid];
    [query whereKey:@"status" equalTo:@"已发布"];
    [self downloadBaseDataWithQuery:query];
    
}

- (void)working {
    ADLog(@"---工作中---");
    AVQuery *query = [AVQuery queryWithClassName:@"Missions"];
    [query whereKey:@"aid" equalTo:self.aid];
    [query whereKey:@"status" equalTo:@"工作中"];
    [self downloadBaseDataWithQuery:query];
}

- (void)finished {
    ADLog(@"---已完成---");
    AVQuery *query = [AVQuery queryWithClassName:@"Missions"];
    [query whereKey:@"aid" equalTo:self.aid];
    [query whereKey:@"status" equalTo:@"已完成"];
    [self downloadBaseDataWithQuery:query];
    
}

- (void)changeNickName: (UIButton *)button {
    
    // Set new nickName.
    [self.alertView show], [_myNickName resignFirstResponder];
    
}

// Lazy Load
- (RNBlurModalView *)alertView {
    if (!_alertView) {
        _alertView = [[RNBlurModalView alloc] initWithView:[self setNickName]];
        [_alertView hideCloseButton:YES];
        UITapGestureRecognizer * tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissAlertView)];
        [_alertView addGestureRecognizer:tapGes];
    }
    
    return _alertView;
}



- (UIView *)setNickName {
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame) - KINSET_ALERTSIZE, 40)];
    
    // Layout TextField
    self.myNickName = [[UITextField alloc] initWithFrame:CGRectMake(KINSET_TEXTFIELD_PADDING, KINSET_TEXTFIELD_PADDING, CGRectGetWidth(bgView.frame) - KINSET_TEXTFIELD_BUTTON_WIDTH - 3 * KINSET_TEXTFIELD_PADDING, CGRectGetHeight(bgView.frame) - 2 * KINSET_TEXTFIELD_PADDING)];
    _myNickName.borderStyle = UITextBorderStyleNone;
    [_myNickName setBackgroundColor:ADDARK_BLUE_(0.5)];
    _myNickName.layer.masksToBounds = YES;
    _myNickName.layer.cornerRadius = 5;
    _myNickName.placeholder = @"输入新的昵称";
    [bgView addSubview:_myNickName];
    
    // Layout Confirm Button
    UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(CGRectGetMaxX(_myNickName.frame) + KINSET_TEXTFIELD_PADDING, KINSET_TEXTFIELD_PADDING, KINSET_TEXTFIELD_BUTTON_WIDTH, CGRectGetHeight(_myNickName.frame));
    [button setTitle:@"确认" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:ADDARK_BLUE];
    button.layer.masksToBounds = YES;
    [button addTarget:self action:@selector(changeNow) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 5;
    [bgView addSubview:button];
    
    return bgView;
}

- (void)changeNow {
    
    ADLog(@"%@", _myNickName.text);
    //TODO:  在这里 更改新的昵称/在ChatDemo里边 有设置昵称的方法
    AVUser *user = [AVUser currentUser];
    [user setObject:_myNickName.text forKey:@"nickname"];
    [user save];
    [_nickNameButton setTitle:_myNickName.text forState:(UIControlStateNormal)];
    [self dismissAlertView];
    
}

- (void)dismissAlertView {
    [self.alertView hide];
    
}
//------------------------------------Header-----------------------------------
//-----------------------------------------------------------------------------




























- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
