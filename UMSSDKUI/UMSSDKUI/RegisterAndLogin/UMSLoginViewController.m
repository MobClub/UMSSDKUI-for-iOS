//
//  UMSLoginViewController.m
//  UMSSDKUI
//
//  Created by 刘靖煌 on 17/2/26.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import "UMSLoginViewController.h"
#import "UMSRegisterViewController.h"
#import "UMSResetPasswordViewController.h"
#import "UMSImage.h"
#import "UMSSelectRegionViewController.h"
#import <UMSSDK/UMSSDK.h>
#import <MOBFoundation/MOBFoundation.h>
#import "UMSProfileViewController.h"
#import "UMSAddUserInfoViewController.h"
#import "UMSBaseNavigationController.h"
#import "UMSAlertView.h"

@interface UMSLoginViewController ()<IUMSSelectRegionViewControllerDelegate>

//手机号模块
@property (nonatomic, strong) UIImageView *mobileIcon;
@property (nonatomic, strong) UIButton *areaCode;
@property (nonatomic, strong) NSString *areaCodeString;
@property (nonatomic, strong) UITextField *phoneNumber;
@property (nonatomic, strong) UIButton *deleteNumber;

//密码模块
@property (nonatomic, strong) UIImageView *passwordIcon;
@property (nonatomic, strong) UITextField *passwordCode;
@property (nonatomic, strong) UIButton *forgotPassword;

//登录按钮
@property (nonatomic, strong) UIButton *loginButton;

//注册按钮
@property (nonatomic, strong) UIButton *buttonOfRegister;
@property (nonatomic, strong) UMSSelectRegionViewController *selectRegion;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation UMSLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //中间的标题
    UILabel *navTitle = [[UILabel alloc] init];
    navTitle.frame = CGRectMake(0, 0 , 35, 35);
    navTitle.text = @"登录";
    navTitle.font = [UIFont systemFontOfSize:16];
    self.navigationItem.titleView = navTitle;
    self.view.backgroundColor = [UIColor whiteColor];
    self.areaCodeString = @"86";
    
    if (self.leftBarButtonItem)
    {
        self.navigationItem.leftBarButtonItem = self.leftBarButtonItem;
    }
    
    if (self.rightBarButtonItem)
    {
        self.navigationItem.rightBarButtonItem = self.rightBarButtonItem;
    }
    
    //手机号模块
    [self addPhoneNumbelModule];
    
    //密码模块
    [self addPasswordModule];
    
    //登录按钮和去注册
    [self addLoginAndRegisterModule];

    //第三方登录平台
    [self addThirdPartLoginModule];
    
    //添加 UIActivityIndicatorView
    self.activityIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 100, 85)];
    self.activityIndicator.center = self.view.center;
    self.activityIndicator.layer.cornerRadius = 10;
    self.activityIndicator.layer.masksToBounds = YES;
    [self.activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.activityIndicator setBackgroundColor:[UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:0.9]];
    [self.activityIndicator setHidesWhenStopped:YES];
    [self.view addSubview:self.activityIndicator];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)addPhoneNumbelModule
{
    self.mobileIcon = [[UIImageView alloc] init];
    self.mobileIcon.frame = CGRectMake(20, self.view.frame.size.height*0.15+self.view.frame.size.width*0.01, self.view.frame.size.width*0.08, self.view.frame.size.width*0.08);
    self.mobileIcon.image = [UMSImage imageNamed:@"phone.png"];
    [self.view addSubview:self.mobileIcon];
    
    self.areaCode = [[UIButton alloc] init];
    [self.areaCode setTitle:[NSString stringWithFormat:@"+%@",self.areaCodeString] forState:UIControlStateNormal];
    [self.areaCode setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [[self.areaCode titleLabel] setFont:[UIFont systemFontOfSize:14]];
    [self.areaCode setImage:[UMSImage imageNamed:@"xiala.png"] forState:UIControlStateNormal];
    self.areaCode.frame = CGRectMake(CGRectGetMaxX(self.mobileIcon.frame)+10, self.view.frame.size.height*0.15, self.view.frame.size.width*0.15, self.view.frame.size.width*0.1);
    self.areaCode.titleEdgeInsets = UIEdgeInsetsMake(0, -(self.areaCode.frame.size.width - self.areaCode.imageView.frame.size.width), 0, 0);
    self.areaCode.imageEdgeInsets = UIEdgeInsetsMake(0, self.areaCode.frame.size.width - self.areaCode.imageView.frame.origin.x - self.areaCode.imageView.frame.size.width, 0, 0);
    [self.areaCode addTarget:self action:@selector(changeArea:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.areaCode];
    
    UIView *phoneAndAreaLine = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.areaCode.frame)+5, CGRectGetMinY(self.areaCode.frame)+self.view.frame.size.width*0.01, 1.0f, self.view.frame.size.width*0.08)];
    [phoneAndAreaLine setBackgroundColor:[UIColor colorWithRed:207/255.0 green:207/255.0 blue:217/255.0 alpha:1.0]];
    [self.view addSubview:phoneAndAreaLine];
    
    self.phoneNumber = [[UITextField alloc] init];
    self.phoneNumber.frame = CGRectMake(CGRectGetMaxX(self.areaCode.frame)+15, self.view.frame.size.height*0.15, self.view.frame.size.width*0.72-65, self.view.frame.size.width*0.1);
    self.phoneNumber.placeholder = @"请输入手机号";
    self.phoneNumber.font = [UIFont systemFontOfSize:14];
    self.phoneNumber.keyboardType = UIKeyboardTypePhonePad;
    [self.view addSubview:self.phoneNumber];
    
    self.deleteNumber = [[UIButton alloc] init];
    self.deleteNumber.frame = CGRectMake(CGRectGetMaxX(self.phoneNumber.frame), self.view.frame.size.height*0.15+self.view.frame.size.width*0.025, self.view.frame.size.width*0.05, self.view.frame.size.width*0.05);
    [self.deleteNumber setBackgroundImage:[UMSImage imageNamed:@"no.png"] forState:UIControlStateNormal];
    [self.deleteNumber addTarget:self action:@selector(deletePhoneNumber:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.deleteNumber];
    
    UIView *phoneLine = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.phoneNumber.frame)+5,
                                                                self.view.frame.size.width-40, 1.0f)];
    [phoneLine setBackgroundColor:[UIColor colorWithRed:207/255.0 green:207/255.0 blue:217/255.0 alpha:1.0]];
    [self.view addSubview:phoneLine];
}

- (void)changeArea:(id)sender
{
    self.selectRegion = [[UMSSelectRegionViewController alloc] init];
    self.selectRegion.delegate = self;
    [self.navigationController pushViewController:self.selectRegion animated:YES];
}

- (void)selectedAreaCode:(NSString *)areaCode
{
    if (areaCode)
    {
        self.areaCodeString = areaCode;
        [self.areaCode setTitle:[NSString stringWithFormat:@"%@%@",@"+",areaCode] forState:UIControlStateNormal];
    }
}

- (void)addPasswordModule
{
    self.passwordIcon = [[UIImageView alloc] init];
    self.passwordIcon.frame = CGRectMake(20, CGRectGetMaxY(self.phoneNumber.frame) + 20+self.view.frame.size.width*0.01, self.view.frame.size.width*0.08, self.view.frame.size.width*0.08);
    self.passwordIcon.image = [UMSImage imageNamed:@"key.png"];
    [self.view addSubview:self.passwordIcon];
    
    self.passwordCode = [[UITextField alloc] init];
    self.passwordCode.frame = CGRectMake(CGRectGetMaxX(self.passwordIcon.frame)+15, CGRectGetMaxY(self.phoneNumber.frame) + 20, self.view.frame.size.width*0.67-55, self.view.frame.size.width*0.1);
    self.passwordCode.font = [UIFont systemFontOfSize:14];
    self.passwordCode.placeholder = @"请输入密码";
    self.passwordCode.secureTextEntry = YES;
    [self.view addSubview:self.passwordCode];
    
    self.forgotPassword = [[UIButton alloc] init];
    self.forgotPassword.frame = CGRectMake(CGRectGetMaxX(self.passwordCode.frame), CGRectGetMaxY(self.phoneNumber.frame) + 20, self.view.frame.size.width*0.25, self.view.frame.size.width*0.1);
    [self.forgotPassword setTitle:@"忘记密码？" forState:UIControlStateNormal];
    self.forgotPassword.titleLabel.textAlignment = NSTextAlignmentRight;
    self.forgotPassword.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.forgotPassword addTarget:self action:@selector(forgotPassword:) forControlEvents:UIControlEventTouchUpInside];
    [self.forgotPassword setTitleColor:[UIColor colorWithRed:207/255.0 green:207/255.0 blue:217/255.0 alpha:1.0] forState:UIControlStateNormal];
    [[self.forgotPassword titleLabel] setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:self.forgotPassword];
    
    UIView *passwordLine = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.forgotPassword.frame)+5,
                                                                   self.view.frame.size.width-40, 1.0f)];
    [passwordLine setBackgroundColor:[UIColor colorWithRed:207/255.0 green:207/255.0 blue:217/255.0 alpha:1.0f]];
    [self.view addSubview:passwordLine];
}

- (void)addLoginAndRegisterModule
{
    //登录按钮
    self.loginButton = [[UIButton alloc] init];
    self.loginButton.frame = CGRectMake(20,self.view.center.y, self.view.frame.size.width-40, self.view.frame.size.width*0.11);
    [self.loginButton addTarget:self action:@selector(loginActionWithResult:) forControlEvents:UIControlEventTouchUpInside];
    self.loginButton.backgroundColor = [UIColor colorWithRed:220/255.0 green:63/255.0 blue:59/255.0 alpha:1.0];
    [self.loginButton setTitle:@"登 录" forState:UIControlStateNormal];
    self.loginButton.layer.cornerRadius = 5;
    self.loginButton.layer.masksToBounds = YES;
    [[self.loginButton titleLabel] setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:self.loginButton];
    
    UILabel *noAccount = [[UILabel alloc] init];
    noAccount.frame = CGRectMake(self.view.frame.size.width - 150, CGRectGetMaxY(self.loginButton.frame) + 5 , 85, 35);
    noAccount.text = @"还没有账号?";
    noAccount.textAlignment = NSTextAlignmentRight;
    noAccount.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:noAccount];
    
    //去注册按钮
    self.buttonOfRegister = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.buttonOfRegister setFrame:CGRectMake(CGRectGetMaxX(noAccount.frame), CGRectGetMaxY(self.loginButton.frame) + 5, 45, 35)];
    [self.buttonOfRegister setTitle:@"去注册" forState:UIControlStateNormal];
    self.buttonOfRegister.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.buttonOfRegister.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [[self.buttonOfRegister titleLabel] setFont:[UIFont systemFontOfSize:14]];
    [self.buttonOfRegister addTarget:self action:@selector(goRegister:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonOfRegister setTitleColor:[UIColor colorWithRed:220/255.0 green:63/255.0 blue:59/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.view addSubview:self.buttonOfRegister];
    
    UIView *underline = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(noAccount.frame), CGRectGetMaxY(self.buttonOfRegister.frame)-11 ,45, 1.0f)];
    [underline setBackgroundColor:[UIColor colorWithRed:220/255.0 green:63/255.0 blue:59/255.0 alpha:1.0]];
    [self.view addSubview:underline];
}

-(void)addThirdPartLoginModule
{
    //横线
    UIView *divisionLine = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(self.view.frame) - 130 + self.view.frame.size.width*0.05,
                                                                   self.view.frame.size.width - 20, 1.0f)];
    [divisionLine setBackgroundColor:[UIColor colorWithRed:207/255.0 green:207/255.0 blue:217/255.0 alpha:1.0]];
    [self.view addSubview:divisionLine];
    
    //其他登录方式
    UILabel *OtherLogin = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/3, CGRectGetMaxY(self.view.frame)-130, self.view.frame.size.width/3, self.view.frame.size.width*0.1)];
    [OtherLogin setFont:[UIFont systemFontOfSize:14]];
    [OtherLogin setTextAlignment:NSTextAlignmentCenter];
    [OtherLogin setText:@"其他登录方式"];
    [OtherLogin setBackgroundColor:self.view.backgroundColor];
    OtherLogin.textColor = [UIColor colorWithRed:207/255.0 green:207/255.0 blue:217/255.0 alpha:1.0];
    [self.view addSubview:OtherLogin];
    
    //第三方登录平台
    [UMSSDK supportedLoginPlatforms:^(NSArray *supportedPlatforms) {
        
        if ([supportedPlatforms isKindOfClass:[NSArray class]])
        {
            if ([supportedPlatforms containsObject:@0])
            {
                NSMutableArray *temArray = [[NSMutableArray alloc] initWithArray:supportedPlatforms];
                [temArray removeObject:@0];
                supportedPlatforms = temArray;
            }
            
            NSUInteger n = supportedPlatforms.count;
            CGFloat platformWidth = 40;
            
            for (int i = 0; i < n; i++)
            {
                NSNumber *platformTypeNum = supportedPlatforms[i];
                UMSPlatformType platformType = [platformTypeNum integerValue];
                UIButton *platform = [[UIButton alloc] init];
                CGFloat interval = (self.view.frame.size.width - 40*n)/(n+1);
                platform.frame = CGRectMake(interval + (interval+platformWidth)*i, CGRectGetMaxY(OtherLogin.frame) + 18, platformWidth, platformWidth);
                platform.tag = platformType;
                [platform addTarget:self action:@selector(selectedLoginPlatformAction:) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:platform];
                switch (platformType)
                {
                    case 1:
                        [platform setImage:[UMSImage imageNamed:@"weibo.png"] forState:UIControlStateNormal];
                        break;
                    case 10:
                        [platform setImage:[UMSImage imageNamed:@"facebook.png"] forState:UIControlStateNormal];
                        break;
                    case 22:
                        [platform setImage:[UMSImage imageNamed:@"wechat.png"] forState:UIControlStateNormal];
                        break;
                    case 24:
                        [platform setImage:[UMSImage imageNamed:@"qq.png"] forState:UIControlStateNormal];
                        break;
                    default:
                        break;
                }
            }
        }
    }];
}

-(void)selectedLoginPlatformAction:(id)sender
{
    if ([sender isKindOfClass:[UIButton class]])
    {
        UIButton *loginPlatform = sender;
        UMSPlatformType platformType = loginPlatform.tag;
        
        [self.activityIndicator startAnimating];
        
        [UMSSDK loginWithPlatformType:platformType result:^(UMSUser *user, NSError *error) {
            
            [self.activityIndicator stopAnimating];
            
            if (_loginHandler)
            {
                _loginHandler(error);
            }
        }];
    }
}

- (void)deletePhoneNumber:(id)sender
{
    self.phoneNumber.text = nil;
}

-(void)forgotPassword:(id)sender
{
    UMSResetPasswordViewController *reset = [[UMSResetPasswordViewController alloc] init];
    [self.navigationController pushViewController:reset animated:YES];
}

- (void)goRegister:(id)sender
{
    UMSRegisterViewController *registerVC = [[UMSRegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC
                                         animated:YES];
}

- (void)loginActionWithResult:(void (^) (NSError *error))handler
{
    if ([self validationPasswordText:self.passwordCode.text])
    {
        [self.activityIndicator startAnimating];
        
        [self.phoneNumber resignFirstResponder];
        [self.passwordCode resignFirstResponder];
        
        [UMSSDK loginWithPhone:self.phoneNumber.text
                      areaCode:self.areaCodeString
                      password:self.passwordCode.text
                        result:^(UMSUser *user,NSError *error) {
                            
                            [self.activityIndicator stopAnimating];
                            
                            if (_loginHandler)
                            {
                                _loginHandler(error);
                            }
                        }];
    }
    else
    {
        [UMSAlertView showAlertViewWithTitle:@"登录失败"
                                     message:@"密码格式有误（密码不能低于6位）"
                             leftActionTitle:@"好的"
                            rightActionTitle:nil
                              animationStyle:AlertViewAnimationZoom
                                selectAction:nil];
    }
}

/**
 *  验证密码输入框
 *
 *  @param password 密码
 *
 *  @return YES 表示验证成功， NO 表示验证失败
 */
- (BOOL)validationPasswordText:(NSString *)password
{
    if ([password isEqualToString:@""] || password.length < 6)
    {
        return NO;
    }
    
    return YES;
}

/**
 *  验证手机号码输入框
 *
 *  @param phone 手机号码
 *
 *  @return YES 表示验证成功，NO 表示验证失败
 */
- (BOOL)validationPhoneText:(NSString *)phone
{
    if ([phone isEqualToString:@""])
    {        
        return NO;
    }
    
    if (![MOBFRegex isMatchedByRegex:@"^0?(13[0-9]|15[3-9]|15[0-2]|18[0-9]|17[5-8]|14[0-9]|170|171)[0-9]{8}$"
                             options:MOBFRegexOptionsCaseless
                             inRange:NSMakeRange(0, phone.length)
                          withString:phone])
    {
        return NO;
    }
    
    return YES;
}



@end
