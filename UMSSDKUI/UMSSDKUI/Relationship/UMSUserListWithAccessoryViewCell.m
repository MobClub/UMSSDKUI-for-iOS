//
//  UMSUserListWithAccessoryViewCell.m
//  UMSSDKUI
//
//  Created by 刘靖煌 on 17/6/1.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import "UMSUserListWithAccessoryViewCell.h"
#import "UMSImage.h"

@interface UMSUserListWithAccessoryViewCell ()

@end

@implementation UMSUserListWithAccessoryViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.dataView = [[UMSUserView alloc] init];
        [self.contentView addSubview:self.dataView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.accessoryViewer = [[UIButton alloc] init];
        self.accessoryViewer.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.accessoryViewer setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.contentView addSubview:self.accessoryViewer];
        
        [self.accessoryViewer addTarget:self
                                 action:@selector(accessoryViewClicked:)
                       forControlEvents:UIControlEventTouchUpInside];
        [self.accessoryViewer setTitleColor:[UIColor colorWithRed:173/255.0 green:173/255.0 blue:173/255.0 alpha:1.0] forState:UIControlStateNormal];
    }
    return self;
}

-(void)setUserData:(UMSUser *)userData
{
    if (userData)
    {
        self.dataView.userData = userData;
    }
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    self.accessoryViewer.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 95, 25, 75, 30);
    [self.accessoryViewer setBackgroundImage:[UMSImage imageNamed:@"kuang.png"] forState:UIControlStateNormal];
}

-(void)accessoryViewClicked:(UIButton *)sender
{
    if ([self.delegate conformsToProtocol:@protocol(IUMSUserListWithAccessoryViewCellDelegate)] &&
        [self.delegate respondsToSelector:@selector(accessoryViewClickedWithTag:)])
    {
        [self.delegate accessoryViewClickedWithTag:self.tag];
    }
}


@end
