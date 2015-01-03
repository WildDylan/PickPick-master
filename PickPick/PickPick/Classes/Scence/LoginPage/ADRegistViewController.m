//
//  ADRegistViewController.m
//  PickPick
//
//  Created by Alice on 14/12/17.
//  Copyright (c) 2014年 Alice. All rights reserved.
//

#import "ADRegistViewController.h"
#import "ProgressHUD.h"
#import "SVProgressHUD.h"
@interface ADRegistViewController ()<UITextFieldDelegate>
{
    UIView *bgView;
}
@property (strong, nonatomic)  UITextField *textFieldPhoneNumber;
@property (strong, nonatomic)  UITextField *textFieldPassword;
@property (strong, nonatomic)  UITextField *textFieldVerifyCode;

@property (strong, nonatomic)  UIButton *buttonVerifyCode;
@property (strong, nonatomic)  UIButton *buttonRegist;


@end

@implementation ADRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initSubviews];
}

- (void)initSubviews {
    
    self.view.backgroundColor = ADLIGHT_BLUE;
 
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-64)];
   
    
    UIImageView *imageLogo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logoCube"]];
    imageLogo.layer.cornerRadius = 10;
    imageLogo.layer.masksToBounds = YES;
    imageLogo.frame = CGRectMake(60, 50, self.view.frame.size.width-120, self.view.frame.size.height/7+5);
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
    UILabel *labelPassword = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(labelPhondeNumber.frame), CGRectGetMaxY(labelPhondeNumber.frame) + 4, CGRectGetWidth(labelPhondeNumber.frame), CGRectGetHeight(labelPhondeNumber.frame))];
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
    
    // verifiedCode
    self.textFieldVerifyCode = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(labelPassword.frame), CGRectGetMaxY(_textFieldPassword.frame) + 4, CGRectGetWidth(_textFieldPassword.frame) - 30, CGRectGetHeight(_textFieldPassword.frame)-2)];
    self.textFieldVerifyCode.layer.borderColor = [UIColor whiteColor].CGColor;
    self.textFieldVerifyCode.layer.borderWidth = 1.1;
    self.textFieldVerifyCode.layer.cornerRadius = 3;
    self.textFieldVerifyCode.layer.masksToBounds = YES;
    self.textFieldVerifyCode.delegate = self;
    self.textFieldVerifyCode.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    _textFieldVerifyCode.placeholder = @"验证码";
    _textFieldVerifyCode.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:_textFieldVerifyCode];
    
    self.buttonVerifyCode = [UIButton buttonWithType:(UIButtonTypeSystem)];
    self.buttonVerifyCode.frame = CGRectMake(CGRectGetMaxX(_textFieldVerifyCode.frame)+5, CGRectGetMinY(_textFieldVerifyCode.frame), CGRectGetWidth(_textFieldPhoneNumber.frame) + CGRectGetWidth(labelPhondeNumber.frame) - CGRectGetWidth(_textFieldVerifyCode.frame)- 5, CGRectGetHeight(_textFieldVerifyCode.frame));
    self.buttonVerifyCode.backgroundColor = ADDARK_BLUE;
    [_buttonVerifyCode setTitle:@"获取" forState:(UIControlStateNormal)];
    [_buttonVerifyCode setTitleColor:ADLIGHT_BLUE_(0.8) forState:(UIControlStateNormal)];
    [_buttonVerifyCode addTarget:self action:@selector(clickButton:) forControlEvents:(UIControlEventTouchUpInside)];
    _buttonVerifyCode.tag = 1010;
    [bgView addSubview:_buttonVerifyCode];
    
    
    // buttons :
    // buttonLogin
    self.buttonRegist = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self.buttonRegist setTitle:@"注册" forState:(UIControlStateNormal)];
    self.buttonRegist.frame = CGRectMake(CGRectGetMinX(_textFieldVerifyCode.frame),CGRectGetMaxY(_textFieldVerifyCode.frame)+12,CGRectGetWidth(_textFieldPhoneNumber.frame)+CGRectGetWidth(labelPhondeNumber.frame),CGRectGetHeight(_textFieldPhoneNumber.frame));
    self.buttonRegist.backgroundColor = ADDARK_BLUE_(0.5);
    [self.buttonRegist setTitleColor:ADDARK_BLUE forState:(UIControlStateNormal)];
    [self.buttonRegist addTarget:self action:@selector(clickButton:) forControlEvents:(UIControlEventTouchUpInside)];
    self.buttonRegist.alpha = 0;
    _buttonRegist.tag = 1020;
    [bgView addSubview:_buttonRegist];
    
    
    /**
     make keyboard reback when clikc white space
     */
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rebackKeyboard)];
    [self.view addGestureRecognizer:tap];
    [self.view addSubview:bgView];
    
    
    
    
    
}
- (void)rebackKeyboard {
    
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.3 animations:^{
        
        bgView.frame = CGRectMake(0, 40, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-44);
        
    }];
    
}

#pragma mark - textField delegate

/**
 *  when the lenth of characters, typed in the textFieldPhoneNumber is  11 , should the buttonLogin appear
 *
 *  @param textField verifyCode
 */

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [UIView animateWithDuration:0.5 animations:^{
       
        bgView.frame = CGRectMake(0, 20, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-24);
        
    }];
    
    if (_textFieldVerifyCode.text != nil && _textFieldPhoneNumber.text.length > 2) {
        
        [UIView animateWithDuration:0.5 animations:^{
            
            [_buttonRegist setAlpha:1];
            
        }];
        
        
    }
    
}



#pragma mark - buttons' selector
- (void)clickButton:(UIButton *)button {
    
    switch (button.tag) {
        case 1010:
            [self getVerifyCode];
            break;
        case 1020:
            [self regist];
            break;
        default:
            break;
    }
    
    
}

- (void)getVerifyCode {
    
    if (self.textFieldPassword.text == nil || [self.textFieldPassword.text length] == 0) {
        
        [ProgressHUD showError:@"请填写密码"];
        
    }else{
    
        NSLog(@"获取验证码");
        AVUser * user = [AVUser user];
        user.username = self.textFieldPhoneNumber.text;
        user.password = self.textFieldPassword.text;
        user.mobilePhoneNumber = self.textFieldPhoneNumber.text;
        
        
        ADLog(@"%@",user);
        [user signUp];
    
    }

}

- (void)regist {
   
    [self.textFieldPassword resignFirstResponder];
    [self.textFieldPhoneNumber resignFirstResponder];
    [self.textFieldVerifyCode resignFirstResponder];
    [UIView animateWithDuration:0.5 animations:^{
       
        bgView.frame = CGRectMake(0, 42, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-44);
        
    }];
    
    [AVUser verifyMobilePhone:self.textFieldVerifyCode.text withBlock:^(BOOL succeeded, NSError *error) {
        ADLog(@"------verify mobile phone ----- ");
                if (succeeded) {

                    [[EaseMob sharedInstance].chatManager asyncRegisterNewAccount:self.textFieldPhoneNumber.text password:self.textFieldPassword.text withCompletion:^(NSString *username, NSString *password, EMError *error) {
                        
                        if (!error) {
                            [self showProgressHUD];
                            NSLog(@"----------------------------------------------------------------------------");
                            AD_SAVEL(AD_USERDEFAULT, AD_CURRENT_USER, self.textFieldPhoneNumber.text);
                            AD_SAVEL(AD_USERDEFAULT, AD_CURRENT_PASSWORD, self.textFieldPassword.text);
                            AD_SAVE_BOLEAN(AD_USERDEFAULT, AD_IS_LOGIN, YES);
                            [AD_USERDEFAULT synchronize];
                            
                            AVUser *user = [AVUser currentUser];
                            ADLog(@"----AV current user %@, username = %@-----",user,user.username);
                            UIImage *image = [UIImage imageNamed:@"chatListCellHead"];
                            NSData *imageData = UIImagePNGRepresentation(image);
                            AVFile *imageFile = [AVFile fileWithName:[NSString stringWithFormat:@"%@.png",user.mobilePhoneNumber] data:imageData];
                            
                            [user setObject:imageFile forKey:@"imageHeader"];
                            [user setObject:self.textFieldPhoneNumber.text forKey:@"nickname"];
                            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                
                                if (succeeded) {
//                                    ADLog(@"----succeed---- ");
//                                    AVUser *user = [AVUser currentUser];
//                                    
//                                    ADLog(@"-----get file %@------",[user objectForKey:@"imageHeader"]);
//                                    AVFile *file = [user objectForKey:@"imageHeader"];
//                                    NSData *data = [file getData];
//                                    UIImage *image = [UIImage imageWithData:data];
//                                    [self.buttonVerifyCode setBackgroundImage:image forState:(UIControlStateNormal)];
                                    
                                    [SVProgressHUD dismiss];
                                    [self dismissViewControllerAnimated:YES completion:nil];
                                    
                                }else{
                                    
                                    [SVProgressHUD dismiss];
                                    [ProgressHUD show:@"注册失败"];
                                    ADLog(@"----error = %@---",error);
                                    
                                }
                                
                            }];
                            
//                            [imageFile save];
//
//                            AVObject *objc = [AVObject objectWithClassName:@"Host"];
//                            [objc setObject:self.textFieldPhoneNumber.text forKey:@"account"];
//                            [objc setObject:imageFile forKey:@"headerImage"];
                            
                            
                            
                        }else{
                            
                            ADLog(@"--- Ease Mob register failed ---%@",error);
                        }

                    } onQueue:dispatch_get_main_queue()];
            
        }else{
            
            ADLog(@"--- avuser verifyMobilePhone failed --- %@",error);
            
            [ProgressHUD showError:@"验证码输入有误"];
        }
        
        
    }];
    
    
 //   [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)showProgressHUD {
    
    [SVProgressHUD setBackgroundColor:ADDARK_BLUE];
    [SVProgressHUD setForegroundColor:[UIColor whiteColor]];
    [SVProgressHUD show];
}

#pragma mark - view load / appear
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
