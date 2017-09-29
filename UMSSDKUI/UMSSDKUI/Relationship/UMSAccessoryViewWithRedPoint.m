//
//  UMSAccessoryViewWithRedPoint.m
//  UMSSDKUI
//
//  Created by 刘靖煌 on 2017/6/15.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import "UMSAccessoryViewWithRedPoint.h"
#import "UMSImage.h"
#import "UIView+UMSBadge.h"

@interface UMSAccessoryViewWithRedPoint ()

@property (nonatomic, assign) BOOL isShowRedPoint;

@end

@implementation UMSAccessoryViewWithRedPoint

- (instancetype)initWithTitle:(NSString *)title isShowRedPoint:(BOOL)isShowRedPoint
{
    if (self = [super init])
    {
        self.title = title;
        self.isShowRedPoint = isShowRedPoint;
        [self setupElement];
    }
    
    return self;
}

-(void)setupElement
{
    self.arrow = [[UIButton alloc] init];
    self.arrow.frame = CGRectMake(50, 35/2.0, 15, 15);
    [self.arrow setBackgroundImage:[UMSImage imageNamed:@"yjt.png"] forState:UIControlStateNormal];
    [self addSubview:self.arrow];
    
    self.text = [[UILabel alloc] init];
    self.text.text = self.title;
    self.text.textAlignment = NSTextAlignmentRight;
    self.text.font = [UIFont systemFontOfSize:14];
    self.text.frame = CGRectMake(CGRectGetMinX(self.arrow.frame) - 150, 10, 150, 30);
    [self addSubview:self.text];
    
    if (self.isShowRedPoint)
    {
        [self.text showBadge];
    }
    else
    {
        [self.text hidenBadge];
    }
}


@end
