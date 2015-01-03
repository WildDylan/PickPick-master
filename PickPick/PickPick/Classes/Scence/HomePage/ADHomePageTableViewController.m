//
//  ADHomePageTableViewController.m
//  PickPick
//
//  Created by Alice on 14/12/17.
//  Copyright (c) 2014年 Alice. All rights reserved.
//

#import "ADHomePageTableViewController.h"
#import "ADBaseTableViewCell.h"
#import "ADHomePageTableViewCell.h"
#import "ADModelHomePage.h"
#import "ADHomeDetailsViewController.h"
#import "ADLoginViewController.h"
#import "MKEntryPanel.h"

@interface ADHomePageTableViewController ()
{
    BOOL _isShow;
}

@property (strong, nonatomic)  UISegmentedControl *segmentedControl; // segment
@property (strong, nonatomic)  NSMutableArray *arrayBaseData; // base data

@end

static NSString *identifier = @"homePageCell";
@implementation ADHomePageTableViewController

#pragma mark - view load / appear
- (void)viewDidLoad {
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.arrayBaseData = [NSMutableArray array];
    
    [self registCell];
    [self adjustSubviews];
    [self addGestureRecognizer];
    [self downloadBaseData];
    [self initSegmentedControl];

}

- (void)viewWillAppear:(BOOL)animated {
    
    
    if (self.tabBarController.tabBar.hidden) {
        
        [self.tabBarController.tabBar setHidden:NO];
        
    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    
    
}


- (void)initSegmentedControl {
    
    
    NSArray *array = @[@"时间",@"距离",@"酬金"];
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:array];
    self.segmentedControl.frame = CGRectMake(80, 5, [UIScreen mainScreen].bounds.size.width - 160, 32);
    self.segmentedControl.tintColor = ADDARK_BLUE;
    [self.segmentedControl addTarget:self action:@selector(downloadDataByTitle:) forControlEvents:(UIControlEventTouchUpInside)];
    _segmentedControl.momentary = YES;
   // [self.tableView setTableHeaderView:self.segmentedControl];
    [self.navigationController.navigationBar addSubview:_segmentedControl];
}

- (void)downloadDataByTitle:(UISegmentedControl *)segmented {
    
    switch (segmented.selectedSegmentIndex) {
        case 0:
            [self refreshDataSortByTime];
            break;
        case 1:
            [self refreshDataSortByDistance];
            break;
        case 2:
            [self refreshDataSortByReward];
            break;
        default:
            break;
    }
    
}

#pragma mark - Data   base data / refresh data sort by...
- (void)downloadBaseData {
    
    
    ADLog(@"down load base data----- ");
    AVQuery *query = [AVQuery queryWithClassName:@"Mission"];
    
    [query setLimit:10];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        ADLog(@"find object in background ");
        if (objects) {
            ADLog(@"%ld",(unsigned long)objects.count);
            [self.arrayBaseData addObjectsFromArray:objects];
            
        }
        
    }];
    
    // 调用小菊花
    
}

- (void)refreshDataSortByTime {
    
    ADLog(@"按发布时间排序");
    
    
}

- (void)refreshDataSortByDistance {
    
    ADLog(@"按距离排序");
    
}

- (void)refreshDataSortByReward {
    
    ADLog(@"按酬金排序");
    
}

#pragma mark - GrestureRecongizer Selector
- (void)addGestureRecognizer {
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchToSearchPage:)];
    [self.tableView addGestureRecognizer:pinch];
    
}



- (void)pinchToSearchPage:(UIPinchGestureRecognizer *)pinch {
    
    if (_isShow == NO) {
        _isShow = YES;
        [MKEntryPanel showPanelWithTitle:@"搜索" inView:self.view onTextEntered:^(NSString *inputString) {
            NSLog(@"%@", inputString); // 在这里可以进行主界面的搜索工作、  （弹出另外一个展示界面是不是会好一点。  搜索之后怎么回到最初界面？ ？ ？ ）
            _isShow = NO;
        } frame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 80) dismissBlock:^{
            _isShow = NO;
        }];
    }
    
}


- (void)adjustSubviews {
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:({
        UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0, 0, 25, 38);
        [button setBackgroundImage:[UIImage imageNamed:@"postBarbtn"] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14.];
        [button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(clickToPostNewMission) forControlEvents:UIControlEventTouchUpInside];
        button;
    })];

}


- (void)clickToPostNewMission {
    
    ADPostMissionViewController *postVC =[ADPostMissionViewController new];
    [self.view.window.rootViewController presentViewController:postVC animated:YES completion:nil];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source
- (void)registCell {
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ADHomePageTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];

}

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
    
   

    ADLog(@"----%ld",self.arrayBaseData.count);
   // Mission *mission = [self.arrayBaseData objectAtIndex:indexPath.section];
    
   // cell.model = self.arrayBaseData[indexPath.section];
    
//    ADModelHomePage *model = [[ADModelHomePage alloc] init];
//    
//    model.userName = @"Alice";
//    model.distance = @"1.34km";
//    model.imageHeaderUrl = @"640*960.png";
//    model.status = @"¥10000";
//    model.title = @"我要吃周黑鸭";
//    model.timeLimit = @"3小时以内";
//    model.address = @"北京体育大学 第三校区305室(海淀区上地)";
    
   // cell.model = model;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 180;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    ADTaskDetailsViewController *taskDetailsVC  = [ADTaskDetailsViewController new];
//    [self.navigationController pushViewController:taskDetailsVC animated:YES];

    ADHomeDetailsViewController *homeVC = [ADHomeDetailsViewController new];
    [self.tabBarController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:homeVC animated:YES];

    
}



- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    
     [UIView animateWithDuration:0.8 animations:^{
        
        [self.navigationController setNavigationBarHidden:YES];
        [self.tabBarController.tabBar setHidden:YES];

    }];
    
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    __weak typeof (self) weakSelf = self;
    
    if (self.tabBarController.tabBar.hidden) {
        
        [UIView animateWithDuration:.8f animations:^{
            
            [weakSelf.tabBarController.tabBar setHidden:NO];
            
        }];

        
    }
    
    if (self.navigationController.navigationBar.hidden) {
        
        [UIView animateWithDuration:.8f animations:^{
            
            [weakSelf.navigationController setNavigationBarHidden:NO];
            
        }];
        
    }
    
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    ADLog(@"完成减速");
    
    __weak typeof (self) weakSelf = self;
    
    [UIView animateWithDuration:.8f animations:^{
        
        [weakSelf.navigationController setNavigationBarHidden:NO];
//        [weakSelf.tabBarController.tabBar setHidden:NO];
        weakSelf.tabBarController.tabBar.hidden = NO;
        
    }];

    
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
