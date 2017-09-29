//
//  UMSBaseViewController.m
//  UMSSDKUI
//
//  Created by 刘靖煌 on 17/3/31.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import "UMSBaseViewController.h"

@interface UMSBaseViewController ()

@end

@implementation UMSBaseViewController

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

@end
