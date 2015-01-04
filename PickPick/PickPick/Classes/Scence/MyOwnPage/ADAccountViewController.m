//
//  ADAccountViewController.m
//  Account
//
//  Created by Dylan on 14/12/21.
//  Copyright (c) 2014年 Dylan. All rights reserved.
//
//


#define JUMP_MESSAGE(DES) [NSString stringWithFormat:@"Line: %d, Here For Jump---->%@", __LINE__, DES]

#define KINSET_BASEHEADER 140
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
#import "MJRefresh.h"


@interface ADAccountViewController () <UITableViewDelegate, UITableViewDataSource,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    CGFloat contentOfSetBegin;   // get the content of set of base tableview
    CGFloat contentOfSetEnd;
}

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

//-------------------------Base data-------------------------
@property (nonatomic, strong) NSString *fetchWithStatus;



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
    ADLog(@"----will appear ---");
    [self showTabBar];
    [self downloadUserInfo];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    ADLog(@"---- view did load ---");
    [self setRightBarButtonWithString:@"设置"];
    [self selfStyle];
    [self initData];
    [self downloadBaseData];
    [self layoutMyViews];
    [self setupRefresh];
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

#pragma mark - init

- (void)layoutMyViews {
    
    
//    首先判断持久化里有没有用户数据  然后再去设置 Title  Title展示个人昵称
//    [self setTitle:@"个人中心"];
    self.imageHeader = [[UIImage alloc] init];
    self.baseTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _baseTableView.delegate = self;
    _baseTableView.dataSource = self;
    _baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _baseTableView.backgroundColor = ADLIGHT_BLUE;
    
    // 个人信息设置到tableview的tableHeaderView中
    UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), KINSET_BASEHEADER)];
    [bgView setBackgroundColor:ADLIGHT_BLUE];
    [self layoutAtView:bgView];
    [self.baseTableView setTableHeaderView:bgView];
    
    [self.view addSubview:_baseTableView];
    [_baseTableView registerNib:[UINib nibWithNibName:@"ADHomePageTableViewCell" bundle:nil] forCellReuseIdentifier:AccountCellIdentifier];
    
    
    
    
}

- (void)setupRefresh {
    
    [self.baseTableView addHeaderWithTarget:self action:@selector(headerRereshingAction)];
    [self.baseTableView headerBeginRefreshing];

    self.baseTableView.headerPullToRefreshText = @"下拉刷新";
    self.baseTableView.headerReleaseToRefreshText = @"即将开始刷新";
    self.baseTableView.headerRefreshingText = @"正在刷新";
    
    [self.baseTableView addFooterWithTarget:self action:@selector(footerREreshingAction)];
    self.baseTableView.footerPullToRefreshText = @"上拉加载";
    self.baseTableView.footerReleaseToRefreshText = @"即将开始加载";
    self.baseTableView.footerRefreshingText = @"正在加载";
    
}

- (void)initData {
    self.baseDataArray = [NSMutableArray array];
}

- (void)downloadBaseData {
    
    [self showProgressHUD];
    AVQuery *query = [[AVQuery alloc] initWithClassName:@"Mission"];
    self.fetchWithStatus = @"已发布";
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
    
    [self.headerImageButton.imageView setImage:imageHeader];
    [self.nickNameButton setTitle:self.userName forState:(UIControlStateNormal)];
    
}

- (void)showProgressHUD {
    
    [SVProgressHUD setBackgroundColor:ADDARK_BLUE];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD show];
    
}

- (void)downloadBaseDataWithQuery:(AVQuery *)query {
    
    ADLog(@"----- down load base data ----- ");
    query.limit = 4;
    //    [query orderByDescending:@"timeStamp"];
    //    query.cachePolicy = kAVCachePolicyCacheThenNetwork;
    NSMutableArray *array = [NSMutableArray array];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (error) {
            ADLog(@"--- error = %@ ---", error);
            [SVProgressHUD dismiss];
            
        }else{
            ADLog(@"---------------------- %ld",(unsigned long)objects.count);
            for (AVObject *objc in objects) {
                
                ADModelHomePage *model = [[ADModelHomePage alloc] init];
                AVObject *obj = [objc objectForKey:@"host"];
                AVUser *user = (AVUser *)[obj fetchIfNeeded];
                [model setValue:user forKey:@"host"];
                [model setValue:[objc objectForKey:@"aid"] forKey:@"aid"];
                [model setValue:[objc objectForKey:@"title"] forKey:@"title"];
                [model setValue:[objc objectForKey:@"timeLimit"] forKey:@"timeLimit"];
                [model setValue:[objc objectForKey:@"address"] forKey:@"address"];
                [model setValue:[objc objectForKey:@"reward"] forKey:@"reward"];
                [model setValue:[objc objectForKey:@"content"] forKey:@"content"];
                [model setValue:[objc objectForKey:@"latitude"] forKey:@"latitude"];
                [model setValue:[objc objectForKey:@"longitude"] forKey:@"longitude"];
                [model setValue:[objc objectForKey:@"timeStamp"] forKey:@"timeStamp"];
                [model setValue:[objc objectForKey:@"status"] forKey:@"status"];
                [array addObject:model];
                
            }

            [self.baseDataArray removeAllObjects];
            [self.baseDataArray setArray:array];
            [self.baseTableView reloadData];
            [SVProgressHUD dismiss];
            [self.baseTableView setScrollsToTop:YES];
            
        }
        
    }];

}


- (void)downloadDataForFootRefresh:(AVQuery *)query {
    
    NSInteger skipNum = self.baseDataArray.count;
    ADLog(@"---- skipNum %ld ----",(long)skipNum);
    query.limit = 4;
    query.skip = skipNum;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (error) {
            ADLog(@"--- error = %@ ---", error);
            [SVProgressHUD dismiss];
            
        }else{
            
            //            [self.arrayBaseData removeAllObjects];
            for (AVObject *objc in objects) {
                
                ADModelHomePage *model = [[ADModelHomePage alloc] init];
                AVObject *obj = [objc objectForKey:@"host"];
                AVUser *user = (AVUser *)[obj fetchIfNeeded];
                
                [model setValue:user forKey:@"host"];
                [model setValue:[objc objectForKey:@"aid"] forKey:@"aid"];
                [model setValue:[objc objectForKey:@"title"] forKey:@"title"];
                [model setValue:[objc objectForKey:@"timeLimit"] forKey:@"timeLimit"];
                [model setValue:[objc objectForKey:@"address"] forKey:@"address"];
                [model setValue:[objc objectForKey:@"reward"] forKey:@"reward"];
                [model setValue:[objc objectForKey:@"content"] forKey:@"content"];
                [model setValue:[objc objectForKey:@"latitude"] forKey:@"latitude"];
                [model setValue:[objc objectForKey:@"longitude"] forKey:@"longitude"];
                [model setValue:[objc objectForKey:@"timeStamp"] forKey:@"timeStamp"];
                [model setValue:[objc objectForKey:@"status"] forKey:@"status"];
                [self.baseDataArray addObject:model];
                
            }
            
            @try {
                ADLog(@"---%ld--",(unsigned long)self.baseDataArray.count);
                [self.baseTableView reloadData];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.baseDataArray.count - 1 inSection:0];
                [self.baseTableView scrollToRowAtIndexPath:indexPath atScrollPosition:(UITableViewScrollPositionTop) animated:YES];
                [SVProgressHUD dismiss];
            }
            @catch (NSException *exception) {
                ADLog(@"----exception---- %@",exception);
            }
            
            @finally {
                
            }
            
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

#pragma mark - Action
- (void)headerRereshingAction {
    
    AVQuery *query = [AVQuery queryWithClassName:@"Mission"];
    [query whereKey:@"aid" equalTo:self.aid];
    
    if ([self.fetchWithStatus isEqualToString:@"已发布"]) {
        
        [query whereKey:@"status" equalTo:@"已发布"];
        
        
    }else if ([self.fetchWithStatus isEqualToString:@"工作中"]) {
        
        [query whereKey:@"status" equalTo:@"工作中"];
        
        
    }else if ([self.fetchWithStatus isEqualToString:@"已完成"]) {
        
        [query whereKey:@"status" equalTo:@"已完成"];
        
    }
    
    [self downloadBaseDataWithQuery:query];
    [self.baseTableView headerEndRefreshing];
    
}

- (void)footerREreshingAction {
    
    // 下拉加载,根据标识语句判断,加载新数据
    AVQuery *query = [AVQuery queryWithClassName:@"Mission"];
    if ([self.fetchWithStatus isEqualToString:@"已发布"]) {
        
        [query whereKey:@"status" equalTo:@"已发布"];

        
    }else if ([self.fetchWithStatus isEqualToString:@"工作中"]) {
        
        [query whereKey:@"status" equalTo:@"工作中"];

        
    }else if ([self.fetchWithStatus isEqualToString:@"已完成"]) {
        
        [query whereKey:@"status" equalTo:@"已完成"];

    }
    
    [self downloadDataForFootRefresh:query];
    [self.baseTableView footerEndRefreshing];
}

//------------------------------------ Layout -----------------------------------
//-------------------------------------------------------------------------------

#pragma mark - Targets
- (void)settingPress {
    
    
    ADConfirmPageViewController *confirmVC = [[ADConfirmPageViewController alloc] init];
    
    [self.navigationController pushViewController:confirmVC animated:YES];
    
    //TODO: Set. VC
    ADLog(@"%@", JUMP_MESSAGE(@"SettingVC"));
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
        ADModelHomePage *model = self.baseDataArray[indexPath.row];
        cell.modelAccount = model;
    }
    
    
    
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 170;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return KINSET_BASEHEADER;
//}

//-----------------------------------------------------------------------------
//------------------------------------Header-----------------------------------
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    if (section == 0) {
//        
//        UIView * bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), KINSET_BASEHEADER)];
//        [bgView setBackgroundColor:ADLIGHT_BLUE];
//        [self layoutAtView:bgView];
//        return bgView;
//    }
//    return nil;
//}



- (void)layoutAtView: (UIView *)bgView {
    
    ADLog(@"--------------------------------------------------------------------------------------%@",self.userName);
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
    // 图片转data, 判断,
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
    
    // 设置新更改的头像
    self.headerImageButton.imageView.image = image;
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
            self.fetchWithStatus = @"已发布";
            [self selectedPostedMissions];
            
        }
            break;
        case 1:
        {
        
        // 工作中
            self.fetchWithStatus = @"工作中";
            [self selectedWorking];
            
        }
            break;
        case 2:
        {
        // 已完成
            self.fetchWithStatus = @"已完成";
            [self selectedFinished];
        }
            break;
            
        default:
        {
            ADLog(@"segment error!");
        }
            break;
    }
}


- (void)selectedPostedMissions {
  
    ADLog(@"--- 已发布 --");
    AVQuery *query = [AVQuery queryWithClassName:@"Mission"];
    [query whereKey:@"aid" equalTo:self.aid];
    [query addDescendingOrder:@"timeStamp"];
    [self downloadBaseDataWithQuery:query];
    
}


- (void)selectedWorking {

    ADLog(@"--- 工作中 ---");
    AVQuery *query = [AVQuery queryWithClassName:@"Mission"];
    [query whereKey:@"aid" equalTo:self.aid];
    [query whereKey:@"status" equalTo:@"工作中"];
    [query addAscendingOrder:@"timeStamp"];
    [self downloadBaseDataWithQuery:query];

}


- (void)selectedFinished {
    ADLog(@"--- 已完成 ---");
    AVQuery *query = [AVQuery queryWithClassName:@"Mission"];
    [query whereKey:@"aid" equalTo:self.aid];
    [query whereKey:@"status" equalTo:@"已完成"];
    [query addDescendingOrder:@"timeStamp"];
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


#pragma mark - ScrollView delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    contentOfSetBegin = scrollView.contentOffset.y;
    
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat contentOfSet = scrollView.contentOffset.y;
    if (contentOfSetBegin < contentOfSet) {
        
        [UIView animateWithDuration:0.8 animations:^{
            
            //            [self.navigationController setNavigationBarHidden:YES];
            [self.tabBarController.tabBar setHidden:YES];
            
        }];
        
        
    } else {
        
        [UIView animateWithDuration:0.8 animations:^{
            
            //            [self.navigationController setNavigationBarHidden:NO];
            [self.tabBarController.tabBar setHidden:NO];
            
        }];
        
        
    }
    
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    ADLog(@"-----did end decelerating ---- %f",scrollView.contentOffset.y);
    if (scrollView.contentOffset.y <= 10) {
        
        [UIView animateWithDuration:0.8 animations:^{
            
            [self.navigationController setNavigationBarHidden:NO];
            [self.tabBarController.tabBar setHidden:NO];
            
        }];
        
        
    }
    
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
