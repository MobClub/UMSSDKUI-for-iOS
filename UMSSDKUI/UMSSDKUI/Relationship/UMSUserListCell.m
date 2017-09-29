//
//  UMSUserListCell.m
//  UMSSDKUI
//
//  Created by 刘靖煌 on 17/5/24.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import "UMSUserListCell.h"

@interface UMSUserListCell ()

@end

@implementation UMSUserListCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.dataView = [[UMSUserView alloc] init];
        [self.contentView addSubview:self.dataView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

-(void)setUserData:(UMSUser *)userData
{
    if (userData)
    {
        self.dataView.isShowLoginTime = self.isShowLoginTime;
        self.dataView.userData = userData;
    }
}

@end
