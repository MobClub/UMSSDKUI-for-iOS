//
//  UMSMyFollowersCell.m
//  UMSSDKUI
//
//  Created by 刘靖煌 on 17/5/22.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import "UMSMyFollowersCell.h"

@interface UMSMyFollowersCell ()

@property (nonatomic, strong) UIButton *avatar;
@property (nonatomic, strong) UILabel *nickname;
@property (nonatomic, strong) UIButton *isFollowButton;

@end

@implementation UMSMyFollowersCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self setupElement];
    }
    
    return self;
}

- (void)setupElement
{
    self.avatar = [UIButton buttonWithType:UIButtonTypeSystem];
    self.avatar.frame = CGRectMake(20.0f, self.frame.size.height/2 - 15.0f, 30.0f, 30.0f);
    [self.avatar.layer setCornerRadius:CGRectGetHeight([self.avatar bounds]) / 2];
    self.avatar.layer.masksToBounds = YES;
    [self.contentView addSubview:self.avatar];
    
    self.nickname = [[UILabel alloc] init];
    self.nickname.frame = CGRectMake(CGRectGetMaxX(self.avatar.frame)+20, self.frame.size.height/2 - 15.0f, 100, 30);
    self.nickname.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.nickname];

    self.isFollowButton = [[UIButton alloc] init];
    self.isFollowButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 70, self.frame.size.height/2 - 15.0f, 50, 30);
    self.isFollowButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.isFollowButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.isFollowButton.enabled = NO;
    [self.contentView addSubview:self.isFollowButton];
}


@end
