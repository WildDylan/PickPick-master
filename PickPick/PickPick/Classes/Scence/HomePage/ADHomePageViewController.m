//
//  ADHomePageViewController.m
//  PickPick
//
//  Created by Alice on 14/12/25.
//  Copyright (c) 2014年 Alice. All rights reserved.
//

#import "ADHomePageViewController.h"
#import "ADBaseTableViewCell.h"
#import "ADHomePageTableViewCell.h"
#import "ADModelHomePage.h"
#import "ADHomeDetailsViewController.h"
#import "ADLoginViewController.h"
#import "MKEntryPanel.h"
#import "SVProgressHUD.h"
#import "MJRefresh.h"


@interface ADHomePageViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    BOOL _isShow;
    CGFloat contentOfSetBegin;
    CGFloat contentOfSetEnd;
}
@property (nonatomic, strong) UIButton *buttonNavLeft;
@property (nonatomic, strong) UISegmentedControl *segmentedControl; // segment
@property (nonatomic, strong) NSMutableArray *arrayBaseData; // base data
@property (nonatomic, strong) UITableView *tableView; // basic tableView
@property (nonatomic, strong) NSString *sortBy;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, strong) NSString *currentCity;
@end

static NSString *identifier = @"homePageCell";
@implementation ADHomePageViewController

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - view load / appear
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.arrayBaseData = [NSMutableArray array];
    [self adjustSubviews];
    [self setAVQueryForDownloadData];
    [self initTableView];
    [self setupRefresh];
    [self initSegmentedControl];
    //[self registNotification];
    
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];

    [self showTabBarIfNeeded];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self registNotification];

}

// ---------------------------------------------------------------------------------------------------------------------
- (void)initTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"ADHomePageTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
    [self.view addSubview:self.tableView];
    [self addGestureRecognizer];
}

- (void)showTabBarIfNeeded {
    
    if (self.tabBarController.tabBar.hidden) {
        
        [self.tabBarController.tabBar setHidden:NO];
        
    }
    
    // show segment
    if (self.segmentedControl.alpha < 1.0f) {
        ADLog(@"---- segmenetedControl alpha ----");
        self.segmentedControl.alpha = 1.0f;
    }
}

- (void)setAVQueryForDownloadData {
    
    AVQuery *query = [AVQuery queryWithClassName:@"Mission"];
    [self downloadBaseData:query];
    
}

- (void)setupRefresh {
    
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self.tableView headerBeginRefreshing];
    self.tableView.headerPullToRefreshText = @"下拉刷新";
    self.tableView.headerReleaseToRefreshText = @"即将开始刷新";
    self.tableView.headerRefreshingText = @"正在刷新";
    
    [self.tableView addFooterWithTarget:self action:@selector(footerREreshing)];
    self.tableView.footerPullToRefreshText = @"上拉加载";
    self.tableView.footerReleaseToRefreshText = @"即将开始加载";
    self.tableView.footerRefreshingText = @"正在加载";
    
}

- (void)endHandleTouches {
    
    if (self.tableView.headerRefreshing || self.tableView.footerRefreshing) {
        
        self.tableView.userInteractionEnabled = NO;
        
    }else{
        
        self.tableView.userInteractionEnabled = YES;
    }
    
}

- (void)adjustSubviews {
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:({
        UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0, 0, 20, 22);
        [button setBackgroundImage:[UIImage imageNamed:@"postBarbtn"] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14.];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickToPostNewMission) forControlEvents:UIControlEventTouchUpInside];
        button;
    })];
    
//    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
//        
//        self.automaticallyAdjustsScrollViewInsets = NO;
//        
//    };
//
}

- (void)registNotification {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setNavigationTitle:) name:@"changeAddress" object:nil];
    
}

- (void)setNavigationTitle:(NSNotification *)notification {
    
    CLLocation *location = [notification.userInfo objectForKey:@"currentAddress"];
    self.geocoder = [[CLGeocoder alloc] init];
   
    ADLog(@"-------notification observer %@----",self.geocoder);
    if (self.geocoder) {
        
        [_geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
            
           self.currentCity = [[placemarks.lastObject addressDictionary] objectForKey:@"City"];
            [self clickShowCurrentLocation];
        }];

    }
    
}

- (void)headerRereshing {
    
    AVQuery *query = [AVQuery queryWithClassName:@"Mission"];
    if ([self.sortBy isEqualToString:@"时间"]) {
        
        [query orderByDescending:@"timeStamp"];
        
    }else if([self.sortBy isEqualToString:@"酬金"]) {
        
        [query orderByDescending:@"reward"];
        
    }
    
    [self downloadBaseData:query];
    [self.tableView headerEndRefreshing];
    [self.navigationController.navigationBar setHidden:NO];
    [self.tabBarController.tabBar setHidden:NO];
    
}

- (void)footerREreshing {
    [self endHandleTouches];
    AVQuery *query = [AVQuery queryWithClassName:@"Mission"];
    if ([self.sortBy isEqualToString:@"时间"]) {
        ADLog(@"--- 时间 ---");
        [query orderByDescending:@"timeStamp"];
    
    }else if([self.sortBy isEqualToString:@"酬金"]) {
        ADLog(@"--- 酬金 ---");
        
        [query orderByDescending:@"reward"];
        
    }
    
    
    [self downloadForAdding:query];
    self.tableView.userInteractionEnabled = YES;
    [self.tableView footerEndRefreshing];
}

- (void)clickShowCurrentLocation {
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:({
       UIButton *button =  [UIButton buttonWithType:(UIButtonTypeSystem)];
        button.frame = CGRectMake(0, 0, 100, 40);
        [button setTitle:self.currentCity forState:(UIControlStateNormal)];
        [button setTitleColor:ADDARK_BLUE forState:(UIControlStateNormal)];
        button.titleLabel.numberOfLines = 0;

        [button addTarget:self action:@selector(test) forControlEvents:(UIControlEventTouchUpInside)];
        button;
    })];
    ADLog(@"-----self current city ----- %@",self.currentCity);
    
}

- (void)test {
    
    [self clickShowCurrentLocation];
    
}

- (void)clickToPostNewMission {
    
    ADPostMissionViewController *postVC =[ADPostMissionViewController new];
    [self.view.window.rootViewController presentViewController:postVC animated:YES completion:nil];
    
}

- (void)initSegmentedControl {
    
    NSArray *array = @[@"时间",@"酬金"];
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:array];
    self.segmentedControl.frame = CGRectMake(140, 5, [UIScreen mainScreen].bounds.size.width - 200, 32);
    self.segmentedControl.tintColor = ADDARK_BLUE;
    [self.segmentedControl addTarget:self action:@selector(downloadDataByTitle:) forControlEvents:(UIControlEventValueChanged)];
    _segmentedControl.momentary = YES;
    // [self.tableView setTableHeaderView:self.segmentedControl];
    [self.navigationController.navigationBar addSubview:_segmentedControl];

}


- (void)showSVProgressHUD {
    
    [SVProgressHUD setBackgroundColor:ADDARK_BLUE];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD show];
    
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - GrestureRecongizer Selector
- (void)addGestureRecognizer {
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchToSearchPage:)];
    [self.tableView addGestureRecognizer:pinch];
    
}



- (void)pinchToSearchPage:(UIPinchGestureRecognizer *)pinch {
    
    if (_isShow == NO) {
        _isShow = YES;
        [self.navigationController.navigationBar setHidden:YES];
        [MKEntryPanel showPanelWithTitle:@"搜索" inView:self.view onTextEntered:^(NSString *inputString) {
            NSLog(@"%@", inputString); // 在这里可以进行主界面的搜索工作、  （弹出另外一个展示界面是不是会好一点。  搜索之后怎么回到最初界面？ ？ ？ ）
            
            _isShow = NO;
        } frame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 80) dismissBlock:^{
            [self.navigationController.navigationBar setHidden:NO];
            [self showTabBarIfNeeded];
            _isShow = NO;
        }];
    }
    
}

// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - Data   base data / refresh data sort by...
- (void)downloadBaseData:(AVQuery *)query {
    
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
                [array addObject:model];
                
            }

            ADLog(@"----原来的 %ld----",(unsigned long)self.arrayBaseData.count);
            [self.arrayBaseData removeAllObjects];
            [self.arrayBaseData setArray:array];
            ADLog(@"--- 重载的array count %ld ----",(unsigned long)self.arrayBaseData.count);
            ADModelHomePage *model = self.arrayBaseData[0];
            ADLog(@"---- 首条数据信息 ----%@",[model aid]);
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
            [self.tableView setScrollsToTop:YES];

        }
        
    }];

}



- (void)downloadForAdding:(AVQuery *)query {
    
    //[quey setCachePolicy:kAVCachePolicyCacheThenNetwork];
    [self downloadData:query];
    [self.tableView footerEndRefreshing];
    
}

- (void)downloadDataByTitle:(UISegmentedControl *)segmented {
    ADLog(@"---点击segmented %ld ---",(long)segmented.selectedSegmentIndex);
    switch (segmented.selectedSegmentIndex) {
        case 0:
            [self refreshDataSortByTime];
            break;
        case 1:
            [self refreshDataSortByReward];
            break;
    }
    
}


- (void)refreshDataSortByTime {
    self.sortBy = @"时间";
    AVQuery *query = [AVQuery queryWithClassName:@"Mission"];
   // query.cachePolicy = kAVCachePolicyCacheThenNetwork;
    [query orderByDescending:@"timeStamp"];
    [self downloadBaseData:query];
    
}


    
- (NSArray *)downloadData:(AVQuery *)query {
   
    NSInteger skipNum = self.arrayBaseData.count;
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
                [self.arrayBaseData addObject:model];
                
            }
            
            @try {
                ADLog(@"---%ld--",(unsigned long)self.arrayBaseData.count);
                [self.tableView reloadData];
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:self.arrayBaseData.count -1 ];
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:(UITableViewScrollPositionTop) animated:YES];
                [SVProgressHUD dismiss];
            }
            @catch (NSException *exception) {
                ADLog(@"----exception---- %@",exception);
            }
            @finally {
                
                
                
            }
            
            
        }
        
    }];
    NSArray *array = [NSArray arrayWithArray:self.arrayBaseData];
    return array;
}




- (void)refreshDataSortByDistance {
    
    ADLog(@"按距离排序");
    [self showSVProgressHUD];
    CLLocation *currentLocation = [DataHandle shareInstance].currentLocation;
    AVQuery *query = [AVQuery queryWithClassName:@"Mission"];
    query.limit = 10;
    NSMutableArray *array = [NSMutableArray array];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (error) {
            
            [SVProgressHUD dismiss];
            
        }else{
            
            for (AVObject *objc in objects) {
                
                ADModelHomePage *model = [[ADModelHomePage alloc] init];
                double longitude = [[objc objectForKey:@"longitude"] doubleValue];
                double latitude = [[objc objectForKey:@"latitude"] doubleValue];
                CLLocation *destinationLocation = [[CLLocation alloc] initWithLatitude:latitude longitude:longitude];
                CGFloat distance = [currentLocation distanceFromLocation:destinationLocation];
                NSNumber *distanceID = [NSNumber numberWithDouble:distance];
                [model setValue:distanceID forKey:@"distance"];
                AVObject *obj = [objc objectForKey:@"host"];
                AVUser *getUser = (AVUser *)[obj fetchIfNeeded];
                [model setValue:getUser forKey:@"host"];
                [model setValue:[objc objectForKey:@"aid"] forKey:@"aid"];
                [model setValue:[objc objectForKey:@"title"] forKey:@"title"];
                [model setValue:[objc objectForKey:@"timeLimit"] forKey:@"timeLimit"];
                [model setValue:[objc objectForKey:@"address"] forKey:@"address"];
                [model setValue:[objc objectForKey:@"reward"] forKey:@"reward"];
                [model setValue:[objc objectForKey:@"content"] forKey:@"content"];
                [model setValue:[objc objectForKey:@"latitude"] forKey:@"latitude"];
                [model setValue:[objc objectForKey:@"longitude"] forKey:@"longitude"];
                [model setValue:[objc objectForKey:@"timeStamp"] forKey:@"timeStamp"];
                [array addObject:model];
                
            }
        }
        
    }];

    [self.arrayBaseData removeAllObjects];
    [self.arrayBaseData setArray:array];
    [self sortDataBaseArrayByDistance];
    
}


- (void)sortDataBaseArrayByDistance {
    
    if (self.arrayBaseData.count) {
        
        NSSortDescriptor *descriptor_distance = [NSSortDescriptor sortDescriptorWithKey:@"distance" ascending:YES];
        NSSortDescriptor *descriptor_timeStamp = [NSSortDescriptor sortDescriptorWithKey:@"timeStamp" ascending:YES];
        NSArray *arrayDes = @[descriptor_distance,descriptor_timeStamp];
        NSArray *temp = [self.arrayBaseData sortedArrayUsingDescriptors:arrayDes];
        [self.arrayBaseData removeAllObjects];
        [self.arrayBaseData setArray:temp];
        [SVProgressHUD dismiss];
        [self.tableView reloadData];
    }
    
}


- (void)refreshDataSortByReward {
    
    ADLog(@"按酬金排序");
    self.sortBy = @"酬金";
    [self showSVProgressHUD];
    
    AVQuery *querry = [AVQuery queryWithClassName:@"Mission"];
    [querry orderByDescending:@"reward"];
    [self downloadBaseData:querry];
    
}


// ---------------------------------------------------------------------------------------------------------------------
#pragma mark - tableView dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    if (self.arrayBaseData.count) {
        return self.arrayBaseData.count;
    }else{
        return 1;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ADHomePageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        
        [tableView registerNib:[UINib nibWithNibName:@"ADHomePageTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
        cell.layer.cornerRadius = 10;
        cell.layer.masksToBounds = YES;
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
    }
    
    if (self.arrayBaseData.count) {
        
        ADModelHomePage *model = self.arrayBaseData[indexPath.section];
     
        cell.modelHome = model;
        
    }
    
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 180;
}

//--------------------------------------------------------------------------------------------------------------------------
#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.arrayBaseData.count) {
        ADHomeDetailsViewController *homeVC = [[ADHomeDetailsViewController alloc] init];
        ADModelHomePage *model = self.arrayBaseData[indexPath.section];
        homeVC.model = model;
        ADLog(@"--homeVC model %@ model %@--",homeVC.model.aid,model.aid);
        [self.tabBarController setHidesBottomBarWhenPushed:YES];
        self.segmentedControl.alpha =0; // 详情界面隐藏
        [self.navigationController pushViewController:homeVC animated:YES];

    }
    
}

#pragma mark - scrollView delegate

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
