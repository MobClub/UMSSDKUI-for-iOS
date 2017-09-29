//
//  UMSModifyPasswordViewController.m
//  UMSSDKUI
//
//  Created by 刘靖煌 on 17/2/28.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import "UMSModifyPasswordViewController.h"
#import "UMSImage.h"
#import <UMSSDK/UMSSDK.h>
#import "UMSAlertView.h"
#import "UIBarButtonItem+UMS.h"

@interface UMSModifyPasswordViewController ()

//旧密码模块
@property (nonatomic, strong) UIImageView *oldPasswordIcon;
@property (nonatomic, strong) UITextField *oldPasswordCode;

//新密码模块
@property (nonatomic, strong) UIImageView *passwordIcon;
@property (nonatomic, strong) UITextField *passwordCode;

//新密码模块
@property (nonatomic, strong) UIImageView *passwordIconAgain;
@property (nonatomic, strong) UITextField *passwordCodeAgain;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation UMSModifyPasswordViewController

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
    navTitle.text = @"修改密码";
    navTitle.font = [UIFont systemFontOfSize:16];
    self.navigationItem.titleView = navTitle;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //旧密码模块
    [self addOldPasswordModule];
    
    //新密码模块
    [self addNewPasswordModule];
    
    //再次输入新密码模块
    [self addPasswordAgainModule];
    
    //确认按钮
    UIButton *confirmButton = [[UIButton alloc] init];
    confirmButton.frame = CGRectMake(20, CGRectGetMaxY(self.passwordCodeAgain.frame)+50, self.view.frame.size.width-40, self.view.frame.size.width*0.11);
    [confirmButton addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [[confirmButton titleLabel] setFont:[UIFont systemFontOfSize:14]];
    confirmButton.layer.cornerRadius = 5;
    confirmButton.layer.masksToBounds = YES;
    confirmButton.backgroundColor = [UIColor colorWithRed:220/255.0 green:63/255.0 blue:59/255.0 alpha:1.0];
    [confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    [self.view addSubview:confirmButton];
    
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

- (void)confirmAction:(id)sender
{
    UMSUser *currentUser = [UMSSDK currentUser];
    
    if (self.passwordCode.text && self.passwordCode.text.length >=6 &&
        self.passwordCodeAgain.text && self.passwordCodeAgain.text.length >= 6 &&
        self.oldPasswordCode.text && self.oldPasswordCode.text.length >=6)
    {
        if ([self.passwordCode.text isEqualToString:self.passwordCodeAgain.text])
        {
            [self.activityIndicator startAnimating];
            
            [UMSSDK modifyPasswordWithPhone:currentUser.phone
                                newPassword:self.passwordCode.text
                                oldPassword:self.oldPasswordCode.text
                                     result:^(NSError *error) {
                                         
                                         [self.activityIndicator stopAnimating];
                                         
                                         if (error)
                                         {
                                             [UMSAlertView showAlertViewWithTitle:@"修改失败"
                                                                          message:[error description]
                                                                  leftActionTitle:@"好的"
                                                                 rightActionTitle:nil
                                                                   animationStyle:AlertViewAnimationZoom
                                                                     selectAction:^(AlertViewActionType actionType) {
                                                                         
                                                                     }];
                                             
                                         }
                                         else
                                         {
                                             [UMSAlertView showAlertViewWithTitle:@"修改成功"
                                                                          message:[NSString stringWithFormat:@""]
                                                                  leftActionTitle:@"好的"
                                                                 rightActionTitle:nil
                                                                   animationStyle:AlertViewAnimationZoom
                                                                     selectAction:^(AlertViewActionType actionType) {
                                                                         [self dismissViewControllerAnimated:YES completion:nil];
                                                                     }];
                                         }
                                     }];
        }
        else
        {
            [UMSAlertView showAlertViewWithTitle:@"修改失败"
                                         message:@"2次输入的新密码不一致"
                                 leftActionTitle:@"好的"
                                rightActionTitle:nil
                                  animationStyle:AlertViewAnimationZoom
                                    selectAction:nil];
        }
    }
    else
    {
        [UMSAlertView showAlertViewWithTitle:@"更改失败"
                                     message:@"密码不能为空，且密码不能低于6位"
                             leftActionTitle:@"好的"
                            rightActionTitle:nil
                              animationStyle:AlertViewAnimationZoom
                                selectAction:^(AlertViewActionType actionType) {
                                    
                                }];
    }
}

-(void)leftItemClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) addOldPasswordModule
{
    self.oldPasswordIcon = [[UIImageView alloc] init];
    self.oldPasswordIcon.frame = CGRectMake(20, self.view.frame.size.height*0.15 + self.view.frame.size.width*0.01, self.view.frame.size.width*0.08, self.view.frame.size.width*0.08);
    self.oldPasswordIcon.image = [UMSImage imageNamed:@"jmm.png"];
    [self.view addSubview:self.oldPasswordIcon];
    
    self.oldPasswordCode = [[UITextField alloc] init];
    self.oldPasswordCode.frame = CGRectMake(CGRectGetMaxX(self.oldPasswordIcon.frame)+15, self.view.frame.size.height*0.15, self.view.frame.size.width*0.92-55, self.view.frame.size.width*0.1);
    self.oldPasswordCode.font = [UIFont systemFontOfSize:14];
    self.oldPasswordCode.placeholder = @"请输入旧密码";
    self.oldPasswordCode.secureTextEntry = YES;
    [self.view addSubview:self.oldPasswordCode];
    
    UIView *passwordLine = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.oldPasswordIcon.frame)+5,
                                                                   self.view.frame.size.width-40, 1.0f)];
    [passwordLine setBackgroundColor:[UIColor colorWithRed:207/255.0 green:207/255.0 blue:217/255.0 alpha:1.0f]];
    [self.view addSubview:passwordLine];
}

- (void)addNewPasswordModule
{
    self.passwordIcon = [[UIImageView alloc] init];
    self.passwordIcon.frame = CGRectMake(20, CGRectGetMaxY(self.oldPasswordCode.frame) + 20, self.view.frame.size.width*0.08, self.view.frame.size.width*0.08);
    self.passwordIcon.image = [UMSImage imageNamed:@"key.png"];
    [self.view addSubview:self.passwordIcon];
    
    self.passwordCode = [[UITextField alloc] init];
    self.passwordCode.frame = CGRectMake(CGRectGetMaxX(self.passwordIcon.frame)+15, CGRectGetMaxY(self.oldPasswordCode.frame) + 20, self.view.frame.size.width*0.92-55, self.view.frame.size.width*0.1);
    self.passwordCode.font = [UIFont systemFontOfSize:14];
    self.passwordCode.placeholder = @"请输入新密码";
    self.passwordCode.secureTextEntry = YES;
    [self.view addSubview:self.passwordCode];
    
    UIView *passwordLine = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.passwordCode.frame)+5,
                                                                   self.view.frame.size.width-40, 1.0f)];
    [passwordLine setBackgroundColor:[UIColor colorWithRed:207/255.0 green:207/255.0 blue:217/255.0 alpha:1.0f]];
    [self.view addSubview:passwordLine];
}

-(void)addPasswordAgainModule
{
    self.passwordIconAgain = [[UIImageView alloc] init];
    self.passwordIconAgain.frame = CGRectMake(20, CGRectGetMaxY(self.passwordCode.frame) + 20, self.view.frame.size.width*0.08, self.view.frame.size.width*0.08);
    self.passwordIconAgain.image = [UMSImage imageNamed:@"key.png"];
    [self.view addSubview:self.passwordIconAgain];
    
    self.passwordCodeAgain = [[UITextField alloc] init];
    self.passwordCodeAgain.frame = CGRectMake(CGRectGetMaxX(self.passwordIconAgain.frame)+15, CGRectGetMaxY(self.passwordCode.frame) + 20, self.view.frame.size.width*0.92-55, self.view.frame.size.width*0.1);
    self.passwordCodeAgain.font = [UIFont systemFontOfSize:14];
    self.passwordCodeAgain.placeholder = @"请再次输入新密码";
    self.passwordCodeAgain.secureTextEntry = YES;
    [self.view addSubview:self.passwordCodeAgain];
    
    UIView *passwordLine = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.passwordCodeAgain.frame)+5,
                                                                   self.view.frame.size.width-40, 1.0f)];
    [passwordLine setBackgroundColor:[UIColor colorWithRed:207/255.0 green:207/255.0 blue:217/255.0 alpha:1.0f]];
    [self.view addSubview:passwordLine];
}


@end
