//
//  UIBarButtonItem+UMS.h
//  UMSSDKUI
//
//  Created by 刘靖煌 on 17/5/2.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (UMS)

+ (UIBarButtonItem *)itemWithIcon:(NSString *)icon highIcon:(NSString *)highIcon target:(id)target action:(SEL)action;

@end
