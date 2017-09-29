//
//  UMSResetPasswordViewController.m
//  UMSSDKUI
//
//  Created by 刘靖煌 on 17/2/26.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import "UMSResetPasswordViewController.h"
#import "UMSImage.h"
#import "UMSSelectRegionViewController.h"
#import <UMSSDK/UMSSDK.h>
#import "UMSAlertView.h"
#import "UIBarButtonItem+UMS.h"

static int count = 0;

@interface UMSResetPasswordViewController ()<IUMSSelectRegionViewControllerDelegate>

//手机号模块
@property (nonatomic, strong) UIImageView *mobileIcon;
@property (nonatomic, strong) UIButton *areaCode;
@property (nonatomic, strong) NSString *areaCodeString;
@property (nonatomic, strong) UITextField *phoneNumber;
@property (nonatomic, strong) UIButton *deleteNumber;

//验证码模块
@property (nonatomic, strong) UIImageView *smsCodeIcon;
@property (nonatomic, strong) UITextField *smsCode;
@property (nonatomic, strong) UIButton *sendSMSCode;

//密码模块
@property (nonatomic, strong) UIImageView *passwordIcon;
@property (nonatomic, strong) UITextField *passwordCode;
@property (nonatomic, strong) UMSSelectRegionViewController *selectRegion;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@property (nonatomic, strong) UILabel *smsCodeTips;
@property (nonatomic, strong) NSTimer *countDownTimer;
@property (nonatomic, strong) NSTimer *repeatSendSMSCodeTimer;
@property (nonatomic, strong)  UIButton *repeatSMSBtn;

@end

@implementation UMSResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 左边按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"return.png"
                                                                 highIcon:@"return.png"
                                                                   target:self
                                                                   action:@selector(leftItemClicked:)];
    
    UILabel *navTitle = [[UILabel alloc] init];
    navTitle.frame = CGRectMake(0, 0 , 35, 35);
    navTitle.text = @"找回密码";
    navTitle.font = [UIFont systemFontOfSize:16];
    self.navigationItem.titleView = navTitle;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.areaCodeString = @"86";
    
    //手机号模块
    [self addPhoneNumbelModule];
    
    //验证码模块
    [self addSMSCodeModule];
    
    //密码模块
    [self addPasswordModule];
    
    self.smsCodeTips = [[UILabel alloc] init];
    self.smsCodeTips.frame = CGRectMake(self.view.frame.size.width /2 - 75, CGRectGetMaxY(self.passwordCode.frame) + 10, 150, 30);
    self.smsCodeTips.textColor = [UIColor colorWithRed:207/255.0 green:207/255.0 blue:217/255.0 alpha:1.0];
    self.smsCodeTips.font = [UIFont systemFontOfSize:12];
    self.smsCodeTips.text = @"接收短信大约需要60秒";
    self.smsCodeTips.hidden = YES;
    self.smsCodeTips.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.smsCodeTips];
    
    _repeatSMSBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _repeatSMSBtn.frame = CGRectMake(self.view.frame.size.width /2 - 75, CGRectGetMaxY(self.passwordCode.frame) + 7, 150, 30);
    [_repeatSMSBtn setTitle:@"收不到短信验证码？" forState:UIControlStateNormal];
    [_repeatSMSBtn addTarget:self action:@selector(CannotGetSMS) forControlEvents:UIControlEventTouchUpInside];
    _repeatSMSBtn.hidden = YES;
    [_repeatSMSBtn setTitleColor:[UIColor colorWithRed:220/255.0 green:63/255.0 blue:59/255.0 alpha:1.0] forState:UIControlStateNormal];
    _repeatSMSBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:_repeatSMSBtn];
    
    //确认按钮
    UIButton *confirmButton = [[UIButton alloc] init];
    confirmButton.frame = CGRectMake(20, CGRectGetMaxY(self.passwordCode.frame)+45, self.view.frame.size.width-40, self.view.frame.size.width*0.11);
    [confirmButton addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [[confirmButton titleLabel] setFont:[UIFont systemFontOfSize:14]];
    confirmButton.layer.cornerRadius = 5;
    confirmButton.layer.masksToBounds = YES;
    confirmButton.backgroundColor = [UIColor colorWithRed:220/255.0 green:63/255.0 blue:59/255.0 alpha:1.0];
    [confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    [self.view addSubview:confirmButton];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 100, 85)];
    self.activityIndicator.center = self.view.center;
    self.activityIndicator.layer.cornerRadius = 10;
    self.activityIndicator.layer.masksToBounds = YES;
    [self.activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.activityIndicator setBackgroundColor:[UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:0.9]];
    [self.activityIndicator setHidesWhenStopped:YES];
    [self.view addSubview:self.activityIndicator];
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

-(void)CannotGetSMS
{
    [UMSAlertView showAlertViewWithTitle:@"确认手机号码"
                                 message:[NSString stringWithFormat:@"%@%@",@"我们将重新发送短信验证码到这个号码：",self.phoneNumber.text]
                         leftActionTitle:@"取消"
                        rightActionTitle:@"好"
                          animationStyle:AlertViewAnimationZoom
                            selectAction:^(AlertViewActionType actionType) {
                                
                                if (actionType == AlertViewActionTypeRight)
                                {
                                    [self sendSMSCode:nil];
                                }
                            }];
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

-(void)addSMSCodeModule
{
    self.smsCodeIcon = [[UIImageView alloc] init];
    self.smsCodeIcon.frame = CGRectMake(20, CGRectGetMaxY(self.phoneNumber.frame) + 20 + self.view.frame.size.width*0.01, self.view.frame.size.width*0.08, self.view.frame.size.width*0.08);
    self.smsCodeIcon.image = [UMSImage imageNamed:@"yzm.png"];
    [self.view addSubview:self.smsCodeIcon];
    
    self.smsCode = [[UITextField alloc] init];
    self.smsCode.frame = CGRectMake(CGRectGetMaxX(self.smsCodeIcon.frame)+15, CGRectGetMaxY(self.phoneNumber.frame) + 20, self.view.frame.size.width*0.67 -55, self.view.frame.size.width*0.1);
    self.smsCode.font = [UIFont systemFontOfSize:14];
    self.smsCode.placeholder = @"验证码";
    [self.view addSubview:self.smsCode];
    
    self.sendSMSCode = [[UIButton alloc] init];
    self.sendSMSCode.frame = CGRectMake(CGRectGetMaxX(self.smsCode.frame), CGRectGetMaxY(self.phoneNumber.frame) + 20, self.view.frame.size.width*0.25, self.view.frame.size.width*0.1);
    [self.sendSMSCode setTitle:@"发送验证码" forState:UIControlStateNormal];
    [self.sendSMSCode addTarget:self action:@selector(sendSMSCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.sendSMSCode setTitleColor:[UIColor colorWithRed:220/255.0 green:63/255.0 blue:59/255.0 alpha:1.0] forState:UIControlStateNormal];
    [[self.sendSMSCode titleLabel] setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:self.sendSMSCode];
    
    UIView *passwordLine = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.sendSMSCode.frame)+5,
                                                                   self.view.frame.size.width-40, 1.0f)];
    [passwordLine setBackgroundColor:[UIColor colorWithRed:207/255.0 green:207/255.0 blue:217/255.0 alpha:1.0f]];
    [self.view addSubview:passwordLine];
}

-(void)updateTime
{
    count ++;
    if (count >= 60)
    {
        [_countDownTimer invalidate];
        self.smsCodeTips.hidden = YES;
        return;
    }
    
    self.smsCodeTips.text = [NSString stringWithFormat:@"%@%i%@",@"接收验证码大约需要",60 - count, @"秒"];
    
}

-(void)sendSMSCode:(id)sender
{
    [UMSSDK getResetPasswordVerificationCodeWithPhone:self.phoneNumber.text
                                             areaCode:self.areaCodeString
                                               result:^(NSError *error){
                                                   
                                                   if (error)
                                                   {
                                                       if (error.code == 300462)
                                                       {
                                                           [UMSAlertView showAlertViewWithTitle:@"发送失败"
                                                                                        message:@"请求过于频繁，一分钟只能申请发送一条短信"
                                                                                leftActionTitle:@"好的"
                                                                               rightActionTitle:nil
                                                                                 animationStyle:AlertViewAnimationZoom
                                                                                   selectAction:^(AlertViewActionType actionType) {
                                                                                       
                                                                                   }];
                                                       }
                                                       else
                                                       {
                                                           [UMSAlertView showAlertViewWithTitle:@"发送失败"
                                                                                        message:[NSString stringWithFormat:@"%@", [error description]]
                                                                                leftActionTitle:@"好的"
                                                                               rightActionTitle:nil
                                                                                 animationStyle:AlertViewAnimationZoom
                                                                                   selectAction:^(AlertViewActionType actionType) {
                                                                                       
                                                                                   }];
                                                       }
                                                   }
                                                   else
                                                   {
                                                       count = 0;
                                                       [_countDownTimer invalidate];
                                                       [_repeatSendSMSCodeTimer invalidate];
                                                       
                                                       _countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                                                                          target:self
                                                                                                        selector:@selector(updateTime)
                                                                                                        userInfo:nil
                                                                                                         repeats:YES];
                                                       self.repeatSMSBtn.hidden = YES;
                                                       self.smsCodeTips.text = [NSString stringWithFormat:@"%@%i%@",@"接收验证码大约需要",60, @"秒"];
                                                       self.smsCodeTips.hidden = NO;
                                                       [_repeatSendSMSCodeTimer invalidate];
                                                       _repeatSendSMSCodeTimer = [NSTimer scheduledTimerWithTimeInterval:60
                                                                                                                  target:self
                                                                                                                selector:@selector(showRepeatButton)
                                                                                                                userInfo:nil
                                                                                                                 repeats:NO];
                                                   }
        
                                               }];
}

-(void)showRepeatButton
{
    self.repeatSMSBtn.hidden = NO;
    self.smsCodeTips.hidden = YES;
    count = 0;
    
    [_countDownTimer invalidate];
    return;
}

-(void)deletePhoneNumber:(id)sender
{
    self.phoneNumber.text = nil;
}

-(void)addPasswordModule
{
    self.passwordIcon = [[UIImageView alloc] init];
    self.passwordIcon.frame = CGRectMake(20, CGRectGetMaxY(self.sendSMSCode.frame) + 20, self.view.frame.size.width*0.08, self.view.frame.size.width*0.08);
    self.passwordIcon.image = [UMSImage imageNamed:@"key.png"];
    [self.view addSubview:self.passwordIcon];
    
    self.passwordCode = [[UITextField alloc] init];
    self.passwordCode.frame = CGRectMake(CGRectGetMaxX(self.passwordIcon.frame)+15, CGRectGetMaxY(self.sendSMSCode.frame) + 20, self.view.frame.size.width*0.5-15, self.view.frame.size.width*0.1);
    self.passwordCode.font = [UIFont systemFontOfSize:14];
    self.passwordCode.placeholder = @"请输入新密码";
    self.passwordCode.secureTextEntry = YES;
    [self.view addSubview:self.passwordCode];
    
    UIView *passwordLine = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.passwordCode.frame)+5,
                                                                   self.view.frame.size.width-40, 1.0f)];
    [passwordLine setBackgroundColor:[UIColor colorWithRed:207/255.0 green:207/255.0 blue:217/255.0 alpha:1.0f]];
    [self.view addSubview:passwordLine];
}

-(void)leftItemClicked:(id)sender
{
    //    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)confirmAction:(id)sender
{
    if (self.phoneNumber.text && ![self.phoneNumber.text isEqualToString:@""]
        && self.areaCodeString&& ![self.areaCodeString isEqualToString:@""]
        && self.smsCode.text&& ![self.smsCode.text isEqualToString:@""]
        && self.passwordCode.text&& ![self.passwordCode.text isEqualToString:@""]
        && self.passwordCode.text.length >= 6)
    {
        [self.activityIndicator startAnimating];
        
        [UMSSDK resetPasswordWithPhone:self.phoneNumber.text
                              areaCode:self.areaCodeString
                           newPassword:self.passwordCode.text
                               smsCode:self.smsCode.text
                                result:^(NSError *error) {
                                    
                                    [self.activityIndicator stopAnimating];
                                    
                                    if (error)
                                    {
                                        [UMSAlertView showAlertViewWithTitle:@"修改密码失败"
                                                                     message:[error description]
                                                             leftActionTitle:@"好的"
                                                            rightActionTitle:nil
                                                              animationStyle:AlertViewAnimationZoom
                                                                selectAction:^(AlertViewActionType actionType) {
                                                                    
                                                                }];
                                    }
                                    else
                                    {
                                        [UMSAlertView showAlertViewWithTitle:@"修改密码成功"
                                                                     message:nil
                                                             leftActionTitle:@"好的"
                                                            rightActionTitle:nil
                                                              animationStyle:AlertViewAnimationZoom
                                                                selectAction:^(AlertViewActionType actionType) {
                                                                    
                                                                    [self.navigationController popViewControllerAnimated:YES];
                                                                    
                                                                }];
                                    }
                                }];
    }
    else
    {
        [UMSAlertView showAlertViewWithTitle:@"注册失败"
                                     message:@"电话号码、验证码或者密码不能为空，且密码不能低于6位"
                             leftActionTitle:@"好的"
                            rightActionTitle:nil
                              animationStyle:AlertViewAnimationZoom
                                selectAction:^(AlertViewActionType actionType) {
                                    
                                }];
    }
}


@end
