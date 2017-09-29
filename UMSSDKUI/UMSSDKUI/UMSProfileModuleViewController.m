//
//  UMSProfileModuleViewController.m
//  UMSSDKUI
//
//  Created by 刘靖煌 on 17/3/28.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import "UMSProfileModuleViewController.h"
#import <UMSSDK/UMSSDK.h>
#import "UMSLoginViewController.h"
#import "UMSBaseNavigationController.h"
#import "UMSProfileViewController.h"
#import "UMSAlertView.h"

@interface UMSProfileModuleViewController ()

@property (nonatomic, strong) UMSProfileViewController *profile;
@property (nonatomic, strong) UMSLoginViewController *login;
@property (nonatomic, strong) UMSBaseNavigationController *nav;

@property (nonatomic) BOOL isInit;

@end

@implementation UMSProfileModuleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (!self.isInit)
    {
        self.isInit = YES;
        
        self.profile = [[UMSProfileViewController alloc] initWithStyle:UITableViewStylePlain];
        self.nav = [[UMSBaseNavigationController alloc] initWithRootViewController:self.profile];
        
        if (self.leftBarButtonItem)
        {
            self.profile.navigationItem.leftBarButtonItem = self.leftBarButtonItem;
        }
        
        if (self.rightBarButtonItem)
        {
            self.profile.navigationItem.rightBarButtonItem = self.rightBarButtonItem;
        }
        
        
        [self addChildViewController:self.nav];
        UMSUser *currentUser = [UMSSDK currentUser];
        
        if (!currentUser)
        {
            //解决第一次弹出来的黑屏问题
            UMSLoginViewController *tmploginVC = [[UMSLoginViewController alloc] init];
            UMSBaseNavigationController *tmpNav = [[UMSBaseNavigationController alloc] initWithRootViewController:tmploginVC];
            [self addChildViewController:tmpNav];
            [self.view addSubview:tmpNav.view];
            
            __weak typeof(self) theVC = self;
            
            UMSLoginViewController *loginVC = [[UMSLoginViewController alloc] init];
            UMSBaseNavigationController *nav = [[UMSBaseNavigationController alloc] initWithRootViewController:loginVC];
            
            [self presentViewController:nav animated:NO completion:^{
                
                [tmpNav removeFromParentViewController];
                
            }];
            
            UIWindow *window = [UIApplication sharedApplication].keyWindow;
            window.rootViewController = nav;
            
            __weak UMSLoginViewController *weakLoginVC = loginVC;
            loginVC.loginHandler = ^(NSError *error){
                
                if (!error)
                {
                    [theVC.view addSubview:theVC.nav.view];
                    [weakLoginVC dismissViewControllerAnimated:YES completion:nil];
                }
                else
                {
                    NSInteger status = [[[error userInfo] objectForKey:@"status"] integerValue];
                    NSInteger errorCode = error.code;
                    
                    if (status == 422)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [UMSAlertView showAlertViewWithTitle:@"登录失败"
                                                         message:@"账号或密码错误"
                                                 leftActionTitle:@"好的"
                                                rightActionTitle:nil
                                                  animationStyle:AlertViewAnimationZoom
                                                    selectAction:nil];
                        });
                    }
                    else if(errorCode == 600002)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [UMSAlertView showAlertViewWithTitle:@"已取消登录"
                                                         message:nil
                                                 leftActionTitle:@"好的"
                                                rightActionTitle:nil
                                                  animationStyle:AlertViewAnimationZoom
                                                    selectAction:nil];
                        });
                    }
                    else if (errorCode == -1009)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [UMSAlertView showAlertViewWithTitle:@"登录失败"
                                                         message:@"无网络，请连接网络"
                                                 leftActionTitle:@"好的"
                                                rightActionTitle:nil
                                                  animationStyle:AlertViewAnimationZoom
                                                    selectAction:nil];
                        });
                    }
                    else
                    {
                        [UMSAlertView showAlertViewWithTitle:@"登录失败"
                                                     message:[error description]
                                             leftActionTitle:@"好的"
                                            rightActionTitle:nil
                                              animationStyle:AlertViewAnimationZoom
                                                selectAction:nil];
                    }
                }
            };
        }
        else
        {
            [self.view addSubview:self.nav.view];
        }
    }
}

@end
