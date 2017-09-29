//
//  UIBarButtonItem+UMS.m
//  UMSSDKUI
//
//  Created by 刘靖煌 on 17/5/2.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import "UIBarButtonItem+UMS.h"
#import "UMSImage.h"

@implementation UIBarButtonItem (UMS)

+ (UIBarButtonItem *)itemWithIcon:(NSString *)icon highIcon:(NSString *)highIcon target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UMSImage imageNamed:icon] forState:UIControlStateNormal];
    [button setBackgroundImage:[UMSImage imageNamed:highIcon] forState:UIControlStateHighlighted];
    
    button.frame = (CGRect){CGPointZero, button.currentBackgroundImage.size};
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

@end
