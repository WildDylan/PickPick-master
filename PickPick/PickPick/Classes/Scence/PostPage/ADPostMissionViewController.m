//
//  ADPostMissionViewController.m
//  PickPick
//
//  Created by Alice on 14/12/22.
//  Copyright (c) 2014年 Alice. All rights reserved.
//

#import "ADPostMissionViewController.h"
#import "ALScrollViewVertical.h"
#import "CoreDataManager.h"
#import "ADModelHomePage.h"
#import "ProgressHUD.h"
#import <MapKit/MapKit.h>

@interface ADPostMissionViewController ()
{
    ALScrollViewVertical *scrollView;
}
@property (nonatomic, strong) CLLocationManager *lcocationMnager;
@property (nonatomic, strong) CLGeocoder *geocoder;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) ADModelHomePage *model;

@end

@implementation ADPostMissionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.geocoder = [[CLGeocoder alloc] init];
    [self initSubviews];
    
}

- (void)geocodeAddress:(NSString *)address {
    
    [self.geocoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
       
        CLPlacemark *placemark = placemarks.lastObject;
        
        ADLog(@"-------latitude = %f longitude = %f -----",placemark.location.coordinate.latitude,placemark.location.coordinate.longitude);
        
        if (placemark.location.coordinate.latitude == 0.000000 && placemark.location.coordinate.longitude == 0.000000) {
            
            
            [ProgressHUD showError:@"无效地址" Interaction:YES];
            
        }else{
            
            NSString *latitude = [NSString stringWithFormat:@"%f",placemark.location.coordinate.latitude];
            NSString *longitude = [NSString stringWithFormat:@"%f",placemark.location.coordinate.longitude];
            
            _model.latitude = latitude;
            _model.longitude = longitude;
            ADLog(@"-------- model = %@--------",_model);
            // 数据上传
            [self createMission:_model];
            [self dismissViewControllerAnimated:YES completion:^{
                
                ADLog(@"----model %@----",self.model.timeLimit);
                
            }];
        }
        
    }];
    
    
}

- (void)initSubviews {
    // 背景
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_softText"]];
    imageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:imageView];
    
    // 右上动画
    NSMutableArray *array = [NSMutableArray array];
    for (int i = 1; i < 51; i++) {
    
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"chemical－%d（被拖移）.png",i]];
        
        [array addObject:image];
    }
    
    NSArray *arrayAllImagesArray = @[array,array,array,array,array];
    
    // 初始化scrollView
    scrollView = [[ALScrollViewVertical alloc] initWithFrame:CGRectMake(0,30, self.view.frame.size.width, self.view.frame.size.height) animationImagesArray:arrayAllImagesArray];
    scrollView.scrollEnabled = YES;
    [scrollView.fifthView.buttonNextStep addTarget:self action:@selector(dismissFromCurrentScene) forControlEvents:(UIControlEventTouchUpInside)];
     [self.view addSubview:scrollView];

    // 返回button
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [button setBackgroundImage:[UIImage imageNamed:@"back_white"] forState:(UIControlStateNormal)];
    button.frame = CGRectMake(20, 30, 40, 40);
    [button addTarget:self action:@selector(dismissWithoutDoingAnything) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button];
    
}

- (void)dismissWithoutDoingAnything {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)dismissFromCurrentScene{
    
    NSString *title = scrollView.firstView.textField.text;
    NSString *address = scrollView.secondView.textField.text;
    NSString *reward = scrollView.thirdView.textField.text;
    NSString *content = scrollView.fourthView.textView.text;
    NSString *timeLimit = scrollView.fifthView.buttonTimeLimitList.titleLabel.text;
    NSNumber *timeStamp = [NSNumber numberWithDouble:time(NULL)];
    
    if (title == nil || title.length == 0 || address == nil || address.length == 0 || reward == nil || reward.length == 0 || content == nil || content.length == 0|| [timeLimit isEqualToString:@"时间限制"]) {
        
        [ProgressHUD showError:@"请填写完整信息"];
        
    }else{
        
        self.model = [[ADModelHomePage alloc] init];
        _model.title = title;
        _model.address = address;
        _model.content = content;
        _model.reward = reward;
        _model.timeLimit = timeLimit;
        _model.timeStamp = timeStamp;
        [self geocodeAddress:address];
    
    }
    
}

- (void)createMission:(ADModelHomePage *)mission {
// ----------------------------------------------------------------------------------------------------------------------------------------------------
        AVUser *user = [AVUser currentUser];
        AVObject *objc = [AVObject objectWithClassName:@"Mission"];
        NSString *account = [AD_USERDEFAULT valueForKey:AD_CURRENT_USER];
        CGFloat reward = mission.reward.floatValue;
        NSNumber *rewardNumber = [NSNumber numberWithFloat:reward];
    
        [objc setObject:[user objectForKey:@"nickname"] forKey:@"nickname"];
        [objc setObject:user forKey:@"host"];
        [objc setObject:account forKey:@"aid"];
        [objc setObject:mission.title forKey:@"title"];
        [objc setObject:mission.address forKey:@"address"];
        [objc setObject:mission.content forKey:@"content"];
        [objc setObject:rewardNumber forKey:@"reward"];
        [objc setObject:mission.timeLimit forKey:@"timeLimit"];
        [objc setObject:mission.latitude forKey:@"latitude"];
        [objc setObject:mission.longitude forKey:@"longitude"];
        [objc setObject:@"已发布" forKey:@"status"];
        [objc setObject:mission.timeStamp forKey:@"timeStamp"];
        [objc saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            NSString *msg = nil;
            if (succeeded) {
                 msg=[NSString stringWithFormat:@"创建成功: %@",[objc description]];
                ADLog(@"-----objc creat at %@------",objc.createdAt);
            }else{
                 msg=[NSString stringWithFormat:@"创建失败: %@",[error description]];
                ADLog(@"--error %ld---",(long)error.code);
                
            }
            ADLog(@"--- msg == %@----",msg);
        }];
   
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
