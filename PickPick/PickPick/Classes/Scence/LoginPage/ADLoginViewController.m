//
//  ADLoginViewController.m
//  PickPick
//
//  Created by Alice on 14/12/17.
//  Copyright (c) 2014年 Alice. All rights reserved.
//

#import "ADLoginViewController.h"
#import "ADRegistViewController.h"
#import "ProgressHUD.h"

@interface ADLoginViewController ()<UITextFieldDelegate>
{
    UIView *bgView;
}
@property (strong, nonatomic)  UITextField *textFieldPhoneNumber;
@property (strong, nonatomic)  UITextField *textFieldPassword;
@property (strong, nonatomic)  UIButton *buttonRegist;
@property (strong, nonatomic)  UIButton *buttonLogin;
@property (strong, nonatomic)  UIButton *buttonBack;
@end

@implementation ADLoginViewController

#pragma mark - view load / appear
- (void)viewWillAppear:(BOOL)animated {
    
    [self.navigationController setNavigationBarHidden:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubviews];
}

- (void)initSubviews {
    
    bgView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = RGBACOLOR(55, 91, 130, 1);
    
    UIImageView *imageLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
    imageLogo.frame = CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height/4);
    [bgView addSubview:imageLogo];

    // phoneNumber
    UILabel *labelPhondeNumber = [[UILabel alloc] initWithFrame:CGRectMake(40,self.view.frame.size.height/4+20 , (self.view.frame.size.width-80)/4, 30)];
    labelPhondeNumber.layer.masksToBounds = YES;
    labelPhondeNumber.text = @"+86";
    labelPhondeNumber.textColor = [UIColor whiteColor];
    labelPhondeNumber.textAlignment = NSTextAlignmentCenter;
    labelPhondeNumber.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    [bgView addSubview:labelPhondeNumber];

    self.textFieldPhoneNumber = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labelPhondeNumber.frame), CGRectGetMinY(labelPhondeNumber.frame), (self.view.frame.size.width-80)/4*3, 30)];
    self.textFieldPhoneNumber.layer.borderColor = [UIColor whiteColor].CGColor;
    self.textFieldPhoneNumber.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    self.textFieldPhoneNumber.keyboardType = UIKeyboardTypeNumberPad;
    self.textFieldPhoneNumber.borderStyle = UITextBorderStyleNone;
    self.textFieldPhoneNumber.placeholder = @" 请输入手机号";
    self.textFieldPhoneNumber.delegate = self;
    [bgView addSubview:_textFieldPhoneNumber];
    
    // password
    UILabel *labelPassword = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(labelPhondeNumber.frame), CGRectGetMaxY(labelPhondeNumber.frame)+2, CGRectGetWidth(labelPhondeNumber.frame), CGRectGetHeight(labelPhondeNumber.frame))];
    labelPassword.text = @"密码";
    labelPassword.textColor = [UIColor whiteColor];
    labelPassword.textAlignment = NSTextAlignmentCenter;
    labelPassword.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    [bgView addSubview:labelPassword];

    self.textFieldPassword = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(labelPassword.frame),CGRectGetMinY(labelPassword.frame),CGRectGetWidth(_textFieldPhoneNumber.frame),CGRectGetHeight(_textFieldPhoneNumber.frame))];
    
    self.textFieldPassword.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    self.textFieldPassword.borderStyle = UITextBorderStyleNone;
    self.textFieldPassword.placeholder = @" 请输入密码";
    self.textFieldPassword.secureTextEntry = YES;
    self.textFieldPassword.delegate = self;
    [bgView addSubview:_textFieldPassword];
    
    // buttons :
    // buttonLogin
    self.buttonLogin = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.buttonLogin setTitle:@"登录" forState:(UIControlStateNormal)];
    self.buttonLogin.frame = CGRectMake(CGRectGetMinX(labelPhondeNumber.frame), CGRectGetMaxY(_textFieldPassword.frame)+20, CGRectGetWidth(labelPhondeNumber.frame)+CGRectGetWidth(_textFieldPhoneNumber.frame), CGRectGetHeight(_textFieldPhoneNumber.frame));
    self.buttonLogin.backgroundColor = RGBACOLOR(86, 150, 220, 0.5);
    [self.buttonLogin setTitleColor:RGBCOLOR(55, 91, 130) forState:(UIControlStateNormal)];
    [self.buttonLogin addTarget:self action:@selector(clickLoginOrRegist:) forControlEvents:(UIControlEventTouchUpInside)];
    self.buttonLogin.alpha = 0;
    _buttonLogin.tag = 1001;
    [bgView addSubview:_buttonLogin];
    
    
    // buttonRegist
    UILabel *labelLine = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_textFieldPassword.frame)-40, CGRectGetMaxY(_buttonLogin.frame)+12, 40, 20)];
    labelLine.textColor = [UIColor whiteColor];
    labelLine.text = @"____";
    [bgView addSubview:labelLine];

    
    self.buttonRegist = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.buttonRegist.frame = CGRectMake(CGRectGetMaxX(_textFieldPassword.frame)-40, CGRectGetMaxY(_buttonLogin.frame)+10, 40, 20);
    _buttonRegist.tag = 1002;
    [_buttonRegist addTarget:self action:@selector(clickLoginOrRegist:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.buttonRegist setTitle:@"注册" forState:(UIControlStateNormal)];
    [self.buttonRegist setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];

    [bgView addSubview:_buttonRegist];
    
    // buttonBack
    UILabel *labelLine_1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(labelLine.frame),CGRectGetMaxY(labelLine.frame)+8,CGRectGetWidth(labelLine.frame),CGRectGetHeight(labelLine.frame))];
    labelLine_1.textColor = [UIColor whiteColor];
    labelLine_1.text = @"____";
    [bgView addSubview:labelLine_1];
    
    
    self.buttonBack = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.buttonBack.frame = CGRectMake(CGRectGetMinX(_buttonRegist.frame), CGRectGetMaxY(_buttonRegist.frame)+8, CGRectGetWidth(_buttonRegist.frame), CGRectGetHeight(_buttonRegist.frame));
    _buttonBack.tag = 1003;
    [_buttonBack addTarget:self action:@selector(clickLoginOrRegist:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.buttonBack setTitle:@"返回" forState:(UIControlStateNormal)];
    [self.buttonBack setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    
    [bgView addSubview:_buttonBack];
    
    
    /**
         make keyboard reback when clikc white space
     */
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rebackKeyboard)];
    [self.view addGestureRecognizer:tap];
    [self.view addSubview:bgView];
    
}

- (void)rebackKeyboard {
    
    [self.textFieldPhoneNumber resignFirstResponder];
    [self.textFieldPassword resignFirstResponder];
    
}

#pragma mark - textField delegate
/**
 *  when the lenth of characters, typed in the textFieldPhoneNumber is  11 , should the buttonLogin appear
 *
 *  @param textField phoneNumber
 */

- (void)textFieldDidEndEditing:(UITextField *)textField {
  
    if ([_textFieldPhoneNumber.text length] != 11) {
        
        _buttonLogin.userInteractionEnabled = NO;
        
        
        if (_buttonLogin.alpha == 1) {
            
            [UIView animateWithDuration:0.5 animations:^{
                
                _buttonLogin.alpha = 0;
                
            }];
            
        }
        
    }else{
        
        _buttonLogin.userInteractionEnabled = YES;
        
        [UIView animateWithDuration:0.5 animations:^{
            
            [_buttonLogin setAlpha:1];
            
        }];
        
    }
    
}

- (void)clickLoginOrRegist:(UIButton *)button {
    ADRegistViewController *registVC = [ADRegistViewController new];

    
    switch (button.tag) {
        case 1001:
            [self login];
            break;
        case 1002:
            [self.navigationController pushViewController:registVC animated:YES];
            break;
        case 1003:
            [self dismissViewControllerAnimated:YES completion:nil];
        default:
            break;
    }
    
}




- (void)login {
    
    ADLog(@"登录");
    

        
        [AVUser logInWithMobilePhoneNumberInBackground:self.textFieldPhoneNumber.text password:self.textFieldPassword.text block:^(AVUser *user, NSError *error) {
            ADLog(@"-------------login with phonenumber --------------");
            
        if (!error) {
            ADLog(@"-------------avuser login with phonenumber succeed--------------");
            [self loginInBackgroundInEaseMob];
            
        }else{
            [AVUser logInWithUsernameInBackground:self.textFieldPhoneNumber.text password:self.textFieldPassword.text block:^(AVUser *user, NSError *error) {
               
                if (!error) {
                    ADLog(@"-------------login with uername succeed--------------");
                    [self loginInBackgroundInEaseMob];
                    
                }else{
                    ADLog(@"--------login with username failed --------- %@",error);
                    
                }
                
            }];
            
            ADLog(@"--------login with phonenumber failed -------- %@",error);
            [ProgressHUD showError:@"登录失败"];
            
        }
    }];
    
}


/*!
 登录返回的 info
 LastLoginTime = 1418957793933; // 最后登录时间
 jid = "dylanmac#imoney_alice@easemob.com"; // jid
 password = 123456; // 密码
 resource = mobile; // 登录设备
 token = "YWMtpAka8IcqEeSlI2HBEtd6iwAAAUuVdzov07QL4H_dGo3okgRP3ephs2yomSg"; // Token
 username = alice; // 用户名
 */
- (void)loginInBackgroundInEaseMob {
    
    //TODO: LOGIN
    [[EaseMob sharedInstance].chatManager asyncLoginWithUsername:self.textFieldPhoneNumber.text
                                                        password:self.textFieldPassword.text
                                                      completion:
     ^(NSDictionary *loginInfo, EMError *error) {
         
         if (loginInfo && !error) {
            
             ADLog(@"Login sunceed------> %@", loginInfo);
             AD_SAVEL(AD_USERDEFAULT, AD_CURRENT_USER, self.textFieldPhoneNumber.text);
             AD_SAVEL(AD_USERDEFAULT, AD_CURRENT_PASSWORD, self.textFieldPassword.text);
             AD_SAVE_BOLEAN(AD_USERDEFAULT, AD_IS_LOGIN, YES);
             [AD_USERDEFAULT synchronize];
            // [ProgressHUD showSuccess:@"登录成功"];
             [self dismissViewControllerAnimated:YES completion:nil];
             
         }else {

             ADLog(@"Login Eroor------> %@",error);
             switch (error.errorCode) {
                 case EMErrorServerNotReachable:
                     NSLog(@"Failed to connect server!");
                     break;
                 case EMErrorServerAuthenticationFailure:
                     NSLog(@"check username or password!");
                     break;
                 case EMErrorServerTimeout:
                     NSLog(@"server timeout!");
                     break;
                 default:
                     NSLog(@"login failure");
                     break;
             }
             
             [ProgressHUD showError:@"登录失败" Interaction:YES];
         }
     } onQueue:nil];

    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
