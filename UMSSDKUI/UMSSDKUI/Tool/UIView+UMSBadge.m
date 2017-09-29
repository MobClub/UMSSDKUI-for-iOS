//
//  UIView+UMSBadge.m
//  UMSSDKUI
//
//  Created by 刘靖煌 on 2017/6/15.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import "UIView+UMSBadge.h"
#import <objc/runtime.h>

static char badgeViewKey;
static NSInteger const UMSPointWidth = 6; //小红点的宽高
static NSInteger const UMSRightRange = 2; //距离控件右边的距离
static CGFloat const UMSBadgeFont = 9; //字体的大小

@implementation UIView (UMSBadge)

- (void)showBadge
{
    if (self.badge == nil)
    {
        CGRect frame = CGRectMake(CGRectGetWidth(self.frame) + UMSRightRange, - UMSPointWidth / 2, UMSPointWidth, UMSPointWidth);
        self.badge = [[UILabel alloc] initWithFrame:frame];
        self.badge.backgroundColor = [UIColor redColor];
        //圆角为宽度的一半
        self.badge.layer.cornerRadius = UMSPointWidth / 2;
        //确保可以有圆角
        self.badge.layer.masksToBounds = YES;
        [self addSubview:self.badge];
        [self bringSubviewToFront:self.badge];
    }
}

- (void)showBadgeWithCount:(NSInteger)redCount
{
    if (redCount < 0)
    {
        return;
    }
    [self showBadge];
    self.badge.textColor = [UIColor whiteColor];
    self.badge.font = [UIFont systemFontOfSize:UMSBadgeFont];
    self.badge.textAlignment = NSTextAlignmentCenter;
    self.badge.text = (redCount > 99 ? [NSString stringWithFormat:@"99+"] : [NSString stringWithFormat:@"%@", @(redCount)]);
    [self.badge sizeToFit];
    CGRect frame = self.badge.frame;
    frame.size.width += 4;
    frame.size.height += 4;
    frame.origin.y = -frame.size.height / 2;
    if (CGRectGetWidth(frame) < CGRectGetHeight(frame)) {
        frame.size.width = CGRectGetHeight(frame);
    }
    self.badge.frame = frame;
    self.badge.layer.cornerRadius = CGRectGetHeight(self.badge.frame) / 2;
}

- (void)hidenBadge
{
    //从父视图上面移除
    [self.badge removeFromSuperview];
    self.badge = nil;
}

#pragma mark - GetterAndSetter

- (UILabel *)badge
{
    //通过runtime创建一个UILabel的属性
    return objc_getAssociatedObject(self, &badgeViewKey);
}

- (void)setBadge:(UILabel *)badge
{
    objc_setAssociatedObject(self, &badgeViewKey, badge, OBJC_ASSOCIATION_RETAIN);
}

@end
