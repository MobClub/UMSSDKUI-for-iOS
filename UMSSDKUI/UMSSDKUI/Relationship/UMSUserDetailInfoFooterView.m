//
//  UMSUserDetailInfoFooterView.m
//  UMSSDKUI
//
//  Created by 刘靖煌 on 17/5/29.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import "UMSUserDetailInfoFooterView.h"
#import "UMSImage.h"

@interface UMSUserDetailInfoFooterView ()

@property (nonatomic, strong) UIButton *followButton;
@property (nonatomic, strong) UIButton *friendButton;
@property (nonatomic, strong) UIButton *blockButton;

@end

@implementation UMSUserDetailInfoFooterView

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.backgroundColor = [UIColor colorWithRed:246.0/255.0f green:246.0/255.0f blue:246.0/255.0f alpha:1.0];
        
        self.followButton = [[UIButton alloc] init];
        self.followButton.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width/3, 50);
        self.followButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.followButton addTarget:self
                              action:@selector(followClicked:)
                    forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.followButton];

        UIView *line = [[UIView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/3,
                                                                10,
                                                                0.5f,
                                                                30)];
        [line setBackgroundColor:[UIColor grayColor]];
        [self addSubview:line];
        
        self.friendButton = [[UIButton alloc] init];
        self.friendButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/3, 0, [UIScreen mainScreen].bounds.size.width/3, 50);
        self.friendButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.friendButton];
        [self.friendButton addTarget:self
                              action:@selector(friendClicked:)
                    forControlEvents:UIControlEventTouchUpInside];
        
        UIView *facsline = [[UIView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * 2/3,
                                                                    10,
                                                                    0.5f,
                                                                    30)];
        [facsline setBackgroundColor:[UIColor grayColor]];
        [self addSubview:facsline];
        
        self.blockButton = [[UIButton alloc] init];
        self.blockButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width * 2/3, 0, [UIScreen mainScreen].bounds.size.width/3, 50);
        self.blockButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.blockButton addTarget:self
                             action:@selector(blockClicked:)
                   forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.blockButton];
    }
    return self;
}

-(void)setFooterViewModel:(UMSUserDetailInfoFooterViewModel *)footerViewModel
{
    _footerViewModel = footerViewModel;
    
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    if (_footerViewModel.isFollow)
    {
        [self.followButton setTitle:@"取消关注" forState:UIControlStateNormal];
        [self.followButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.followButton setImage:nil forState:UIControlStateNormal];
    }
    else
    {
        [self.followButton setImage:[UMSImage imageNamed:@"guanzhu.png"] forState:UIControlStateNormal];
        [self.followButton setTitle:@"关注" forState:UIControlStateNormal];
        [self.followButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }

    if (_footerViewModel.isFriend)
    {
        [self.friendButton setTitle:@"删除好友" forState:UIControlStateNormal];
        [self.friendButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.friendButton setImage:nil forState:UIControlStateNormal];
    }
    else
    {
        [self.friendButton setImage:[UMSImage imageNamed:@"jiahaoyou.png"] forState:UIControlStateNormal];
        [self.friendButton setTitle:@"加为好友" forState:UIControlStateNormal];
        [self.friendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    
    if (_footerViewModel.isBlock)
    {
        [self.blockButton setTitle:@"取消拉黑" forState:UIControlStateNormal];
        [self.blockButton setImage:nil forState:UIControlStateNormal];
        [self.blockButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    else
    {
        [self.blockButton setImage:[UMSImage imageNamed:@"lahei.png"] forState:UIControlStateNormal];
        [self.blockButton setTitle:@"拉黑" forState:UIControlStateNormal];
        [self.blockButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

- (void)followClicked:(id)sender
{
    if ([self.delegate conformsToProtocol:@protocol(IUMSUserDetailInfoFooterViewDelegate)] && [self.delegate respondsToSelector:@selector(followButtonClicked)])
    {
        [self.delegate followButtonClicked];
    }
}

- (void)friendClicked:(id)sender
{
    if ([self.delegate conformsToProtocol:@protocol(IUMSUserDetailInfoFooterViewDelegate)] && [self.delegate respondsToSelector:@selector(addFriendButtonClicked)]) {
        [self.delegate addFriendButtonClicked];
    }
}

- (void)blockClicked:(id)sender
{
    if ([self.delegate conformsToProtocol:@protocol(IUMSUserDetailInfoFooterViewDelegate)] && [self.delegate respondsToSelector:@selector(blockButtonClicked)])
    {
        [self.delegate blockButtonClicked];
    }
}

@end
