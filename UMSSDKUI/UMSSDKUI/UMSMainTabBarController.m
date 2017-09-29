//
//  UMSMainTabBarController.m
//  UMSSDKUI
//
//  Created by 刘靖煌 on 17/5/25.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import "UMSMainTabBarController.h"
#import "UMSProfileViewController.h"
#import "UMSUserListViewController.h"
#import "UMSBaseNavigationController.h"
#import "UMSImage.h"
#import "UMSRecentLoginUserListViewController.h"

@interface UMSMainTabBarController ()

@end

@implementation UMSMainTabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UMSRecentLoginUserListViewController *recomment = [[UMSRecentLoginUserListViewController alloc] init];
    recomment.navTitle = @"最近登录";
    recomment.isHiddleLeftBarButtonItem = YES;
    
    [self addChildViewController:recomment
                           title:@"推荐"
                           image:[UMSImage imageNamed:@"zx.png"]
                        selImage:[UMSImage imageNamed:@"zx_02.png"]];
    
    UMSProfileViewController *profile = [[UMSProfileViewController alloc] init];
    [self addChildViewController:profile
                           title:@"我的"
                           image:[UMSImage imageNamed:@"wd.png"]
                        selImage:[UMSImage imageNamed:@"wd_02.png"]];
}

- (void)addChildViewController:(UIViewController *)childVc
                         title:(NSString *)title
                         image:(UIImage *)image
                      selImage:(UIImage *)selImage
{
    //设置子控制器的TabBarButton属性
    childVc.title = title;
    childVc.tabBarItem.image = image;
    childVc.tabBarItem.selectedImage = [selImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    NSMutableDictionary *AttrDic = [NSMutableDictionary dictionary];
    AttrDic[NSForegroundColorAttributeName] = [UIColor grayColor];
    [childVc.tabBarItem setTitleTextAttributes:AttrDic forState:UIControlStateNormal];
    
    NSMutableDictionary *selAttr = [NSMutableDictionary dictionary];
    selAttr[NSForegroundColorAttributeName] = [UIColor colorWithRed:219/255.0 green:62/255.0 blue:60/255.0 alpha:1.0];
    [childVc.tabBarItem setTitleTextAttributes:selAttr forState:UIControlStateSelected];
    
    //让子控制器包装一个导航控制器
    UMSBaseNavigationController *nav = [[UMSBaseNavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
}

@end
