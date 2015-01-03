//
//  ADNotificationViewController.m
//  PickPick
//
//  Created by Alice on 14/12/24.
//  Copyright (c) 2014年 Alice. All rights reserved.
//

static NSString * const NotificationCellIdentifier = @"homePageCell";

#import "ADNotificationViewController.h"
#import "ADHomePageTableViewCell.h"
#import "ADHomeDetailsViewController.h"
@interface ADNotificationViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *baseTableView;
@property (nonatomic, strong) NSMutableArray *baseDataArray;
@end

@implementation ADNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initTableView];
    [self selfStyle];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.tabBarController.tabBar.hidden) {
        
        [self.tabBarController.tabBar setHidden:NO];
    }
    
}

- (void)initTableView {
    
    self.baseTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _baseTableView.delegate = self;
    _baseTableView.dataSource = self;
    _baseTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _baseTableView.backgroundColor = ADLIGHT_BLUE;
    [self.view addSubview:_baseTableView];
    
    [_baseTableView registerNib:[UINib nibWithNibName:@"ADHomePageTableViewCell" bundle:nil] forCellReuseIdentifier:NotificationCellIdentifier];

}

- (void)selfStyle {
    
    [self.navigationController.navigationBar setBarTintColor:ADLIGHT_BLUE];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: ADLIGHT_BLUE}];
    [self.navigationController.navigationBar setTranslucent:NO];
    self.navigationController.title = @"通知中心";
    self.view.backgroundColor = ADLIGHT_BLUE;
    _baseTableView.backgroundColor = ADLIGHT_BLUE;
    
}

#pragma mark -
#pragma mark - UITabelView dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 180;
}

#pragma mark - UITableView delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ADHomePageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NotificationCellIdentifier];
    if (!cell) {

        cell = [[ADHomePageTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:NotificationCellIdentifier];
        cell.backgroundColor = ADLIGHT_BLUE;
        cell.contentView.backgroundColor = ADLIGHT_BLUE;
        
    }
    
//    ADModelHomePage *model = [[ADModelHomePage alloc] init];
//    model.userName = @"Alice";
//    model.distance = @"199409007";
//    model.status = @" take care ";
//    model.timeLimit = @"1小时之内";
//    model.address = @"my lovely , super Dylan , i miss you..";
//    model.title = @"Dylan";
//    cell.model = model;
    return cell;
}

#pragma mark - UITabelView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ADHomeDetailsViewController *detailsVC = [ADHomeDetailsViewController new];
    
    // prepare for segue , do something before that here
//    ADModelHomePage *model = [[ADModelHomePage alloc] init];
//    model.userName = @"Alice";
//    model.distance = @"199409007";
//    model.status = @"Let's make a wish for our future ";
//    model.timeLimit = @"forever";
//    model.address = @"love you .. ";
//    detailsVC.model = model;
    [self.navigationController pushViewController:detailsVC animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

    
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
