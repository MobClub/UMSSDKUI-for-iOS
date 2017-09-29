//
//  UMSAccessoryViewWithRedPoint.h
//  UMSSDKUI
//
//  Created by 刘靖煌 on 2017/6/15.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UMSAccessoryViewWithRedPoint : UIView

@property (nonatomic, strong) UIButton *arrow;
@property (nonatomic, strong) UILabel *text;
@property (nonatomic, copy) NSString *title;

- (instancetype)initWithTitle:(NSString *)title isShowRedPoint:(BOOL)isShowRedPoint;

@end
