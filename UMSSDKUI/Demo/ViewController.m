//
//  ViewController.m
//  Demo
//
//  Created by 刘靖煌 on 17/2/26.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import "ViewController.h"

#import <UMSSDKUI/UMSLoginModuleViewController.h>
#import <UMSSDKUI/UMSProfileModuleViewController.h>
#import <UMSSDKUI/UMSProfileViewController.h>
#import <UMSSDK/UMSSDK.h>

@interface ViewController ()

@property (nonatomic, strong) UMSLoginModuleViewController *login;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:@"登录" forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 80, self.view.frame.size.width, 50);
    [btn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)login:(id)sender
{
//    UMSProfileViewController *profile = [[UMSProfileViewController alloc] init];
//    UMSProfileModuleViewController *profile = [[UMSProfileModuleViewController alloc] init];
//
//    profile.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
//                                                                              target:self
//                                                                              action:@selector(leftItemClicked:)];
//    [self presentViewController:profile animated:YES completion:nil];
    
    self.login = [[UMSLoginModuleViewController alloc] init];
    
    self.login.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                 target:self
                                                                                 action:@selector(leftItemClicked:)];
    
    
    
    __weak typeof(self) weakSelf = self;
    
    self.login.loginVC.loginHandler = ^(NSError *error)
    {
        if (!error)
        {
            [weakSelf.login close];
         
            UMSUser *currentUser = [UMSSDK currentUser];
            NSLog(@"currentUser : %@", currentUser);
        }
        else
        {
            NSInteger status = [[[error userInfo] objectForKey:@"status"] integerValue];
            NSInteger errorCode = error.code;

        }
    };
    
    [self presentViewController:self.login animated:YES completion:nil];
}

- (void)leftItemClicked:(id)sender
{
//    [self dismissViewControllerAnimated:YES
//                             completion:nil];
    
    [self dismissViewControllerAnimated:YES
                             completion:nil];
//    [login show];
}

@end


