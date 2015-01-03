//
//  ADConfirmPageViewController.m
//  PickPick
//
//  Created by Alice on 14/12/22.
//  Copyright (c) 2014年 Alice. All rights reserved.
//

#import "ADConfirmPageViewController.h"
#import "ProgressHUD.h"
static NSString *identifier = @"confirmPageCell";

@interface ADConfirmPageViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tabelView;
@property (nonatomic, strong) NSArray *arrayAboutUser;
@property (nonatomic, strong) NSArray *arrayAboutUs;
@property (nonatomic, strong) UIImageView *imageBackground;

@property (nonatomic, strong) UIView *contactView;
@property (nonatomic, strong) UILabel *labelContact;
@property (nonatomic, strong) UIVisualEffectView *effectView;
@end

@implementation ADConfirmPageViewController

#pragma mark - view load / appear
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    if (self.tabBarController.tabBar.hidden) {
        return;
    }else{
        
        [self.tabBarController.tabBar setHidden:YES];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self adjustViews];
    [self initArrayInfo];
    [self initTableView];
    [self prepareForContactView];
   
}

- (void)adjustViews {
    
    self.imageBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_softText"]];
    self.imageBackground.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    effectView.frame = self.view.bounds;
 //   [self.imageBackground addSubview:effectView];
    [self.view addSubview:_imageBackground];
    
}

- (void)prepareForContactView {
    
    UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    self.effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    _effectView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _effectView.frame = CGRectMake(40, 60, self.view.frame.size.width - 80, self.view.frame.size.height - 240);
    // [_contactView addSubview:effectView];
    _effectView.alpha = 0;
    _effectView.layer.cornerRadius = 12;
    _effectView.layer.masksToBounds = YES;
    [self.view addSubview:_effectView];
    
    self.labelContact = [[UILabel alloc] initWithFrame:CGRectMake(40, 40, self.view.frame.size.width - 80, self.view.frame.size.height - 240)];
    _labelContact.numberOfLines = 0;
    _labelContact.layer.masksToBounds = YES;
    _labelContact.text = @"感谢您的支持\n\n E-mail:(ADPick)mail.com \nTel:13301051937 \nTel:13312212473";
    _labelContact.textAlignment = NSTextAlignmentCenter;
    _labelContact.textColor = ADDARK_BLUE;
    _labelContact.font = [UIFont systemFontOfSize:20];
    _labelContact.alpha = 0;
    [self.view addSubview:_labelContact];
    
}

- (void)initTableView {
    
    self.tabelView = [[UITableView alloc] initWithFrame:CGRectMake(5, 5, self.view.frame.size.width-10, self.view.frame.size.height - 125) style:(UITableViewStyleGrouped)];
    self.tabelView.layer.borderColor = [UIColor whiteColor].CGColor;
   // self.tabelView.layer.borderWidth = 0.5;
    self.tabelView.layer.cornerRadius = 3;
    self.tabelView.layer.masksToBounds = YES;
    self.tabelView.delegate = self;
    self.tabelView.dataSource = self;
    self.tabelView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tabelView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
    self.tabelView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tabelView];
    
}

- (void)initArrayInfo {
    
    self.arrayAboutUser = @[@"版本更新",@"清除缓存"];
    self.arrayAboutUs = @[@"意见反馈",@"联系我们",@"给个好评"];
    
}


#pragma mark - UITableView data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            ADLog(@"case0 ---- %ld",(long)section);
            return self.arrayAboutUser.count;
            break;
        case 1:
            ADLog(@"case1 ---- %ld",(long)section);
            return self.arrayAboutUs.count;
            break;
        default:
            break;
    }
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:identifier];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = self.arrayAboutUser[indexPath.row];
            ADLog(@"case 0 cell========%@",self.arrayAboutUs[indexPath.row]);
            break;
        case 1:
            cell.textLabel.text = self.arrayAboutUs[indexPath.row];
            break;
        default:
            break;
    }
    
    
    return cell;

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (section == 1) {
        
        UIButton *buttonLogout = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [buttonLogout setTitle:@"安全退出" forState:(UIControlStateNormal)];
        buttonLogout.frame = CGRectMake(self.tabelView.frame.size.width - 180, 0, 120, 50);
        buttonLogout.backgroundColor = ADDARK_BLUE;
        buttonLogout.titleLabel.textColor = ADLIGHT_BLUE_(1);
        buttonLogout.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
        [buttonLogout setTitleColor:ADDARK_BLUE forState:(UIControlStateNormal)];
        [buttonLogout addTarget:self action:@selector(clicklogOut) forControlEvents:(UIControlEventTouchUpInside)];
        return buttonLogout;
    }else {
        return NULL;
    }
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 50;
    }
    return 0;
}

#pragma mark - UITabelView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        
        switch (indexPath.row) {
            case 0:
                [self updateLatestVersion];
                break;
            case 1:
                [self clearCache];
                break;
            default:
                break;
        }
        
    }else{
        
        switch (indexPath.row) {
            case 0:
                [self feedback];
                break;
            case 1:
                [self contactWithUs];
                break;
            case 2:
                [self positiveComment];
                break;
            default:
                break;
        }
        
    }
    
    
}


- (void)updateLatestVersion {
    
    // 更新版本
    
}

- (void)clearCache {
    
    // 清除缓存
    [AVFile clearAllCachedFiles];
    
}

- (void)feedback {
    
    // 意见回馈
    Class mailClass = (AD_CLSSFROMSTRING(@"MFMailComposeViewController"));
    if (mailClass != nil) {
        
        [self displaymailComposerSheet];
        
    }else{
        
        [ProgressHUD showError:@"当前设备不支持"];
        
    }
    
    
}

- (void)contactWithUs {
    
    UITapGestureRecognizer *tapEffect = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToHide:)];
    [_effectView addGestureRecognizer:tapEffect];
    
    _effectView.alpha = 1;
    _labelContact.alpha = 1;
    

    // 联系我们
    
    
}

- (void)tapToHide:(UITapGestureRecognizer *)tap {
    
    [UIView animateWithDuration:0.8 animations:^{
   
        _effectView.alpha = 0;
        _labelContact.alpha = 0;
        
    }];
   
    
}

#pragma mark -------  发送邮件  -------
- (void)displaymailComposerSheet {
    
    MFMailComposeViewController *emailPicker = [MFMailComposeViewController new];
    emailPicker.mailComposeDelegate = self;
    [emailPicker setSubject:@"意见反馈"];
    
    
    // 设置收件人
    NSArray *toRecipients = @[@"958226951@qq.com"];
    NSArray *bccRecitients = @[@"958226951@qq.com",@"yxr127@gmail.com"];
    
    [emailPicker setToRecipients:toRecipients];
    
    [emailPicker setBccRecipients:bccRecitients];
    
    [self presentViewController:emailPicker animated:YES completion:nil];
}

#pragma mark - mailComposer delegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    
    switch (result) {
        case MFMailComposeResultCancelled:
        {
            ADLog(@"取消邮件发送");
            break;
        }
        case MFMailComposeResultSaved:
        {
            ADLog(@"保存邮件成功");
            break;
        }
        case MFMailComposeResultSent:
        {
            ADLog(@"邮件发送成功");
            break;
        }
        case MFMailComposeResultFailed:
        {
            ADLog(@"邮件发送失败");
            break;
        }
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:^{
    }];
    
    
}

- (void)positiveComment {
    
    // 好评
    NSURL *myURL_APP_A = [NSURL URLWithString:@"http://www.baidu.com"];
    if ([[UIApplication sharedApplication] canOpenURL:myURL_APP_A]) {
        ADLog(@"----canOpenURL");
        [[UIApplication sharedApplication] openURL:myURL_APP_A];
        //   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://itunesconnect.apple.com"]];
    }
    
}


- (void)clicklogOut {
    
    [AVUser logOut];
    [[EaseMob sharedInstance].chatManager asyncLogoffWithCompletion:^(NSDictionary *info, EMError *error) {
        
        if (error) {
            ADLog(@"------logout info %@  error %@",info,error);
        }else{
            
            [AD_USERDEFAULT setBool:NO forKey:AD_IS_LOGIN];
            
        }
        
    } onQueue:dispatch_get_main_queue()];
    
    
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
