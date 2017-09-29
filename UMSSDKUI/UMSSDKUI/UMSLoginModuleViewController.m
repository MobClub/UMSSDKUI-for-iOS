//
//  UMSLoginModuleViewController.m
//  UMSSDKUI
//
//  Created by 刘靖煌 on 17/3/28.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import "UMSLoginModuleViewController.h"
#import "UMSBaseNavigationController.h"
#import "UIBarButtonItem+UMS.h"

@interface UMSLoginModuleViewController ()

@property (nonatomic, strong) UIWindow *window;

@property (nonatomic, strong) UMSBaseNavigationController *nav;

@end

@implementation UMSLoginModuleViewController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _loginVC = [[UMSLoginViewController alloc] init];
        
        _loginVC.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"return.png"
                                                          highIcon:@"return.png"
                                                            target:self
                                                            action:@selector(leftItemClicked:)];
        
        UMSBaseNavigationController *nav = [[UMSBaseNavigationController alloc] initWithRootViewController:_loginVC];
        
        [self addChildViewController:nav];
        [self.view addSubview:nav.view];
    }
    return self;
}

- (void)setLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem
{
    if (leftBarButtonItem)
    {
        _loginVC.leftBarButtonItem = leftBarButtonItem;
    }
}

-(void)setRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem
{
    if (rightBarButtonItem)
    {
        _loginVC.rightBarButtonItem = rightBarButtonItem;
    }
}

- (void)leftItemClicked:(id)sender
{
    [self close];
}

- (void)close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
