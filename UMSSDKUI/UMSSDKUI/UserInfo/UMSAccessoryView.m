//
//  UMSSettingCell.m
//  UMSSDKUI
//
//  Created by 刘靖煌 on 17/3/16.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import "UMSAccessoryView.h"
#import "UMSImage.h"
#import "UIView+UMSBadge.h"

@implementation UMSAccessoryView

- (instancetype)initWithTitle:(NSString *)title
{
    if (self = [super init])
    {
        self.title = title;
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
}

@end
