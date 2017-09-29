//
//  UMSMyFriendCell.m
//  UMSSDKUI
//
//  Created by 刘靖煌 on 17/5/31.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import "UMSMyFriendCell.h"
#import "UMSImage.h"


@interface UMSMyFriendCell ()

@property (nonatomic, strong) UIImageView *addIcon;
@property (nonatomic, strong) UILabel *friendLabel;
@property (nonatomic, strong) UIButton *arrow;
@property (nonatomic, strong) UILabel *friendCount;

@end

@implementation UMSMyFriendCell

-(instancetype)init
{
    if (self = [super init])
    {
        self.addIcon = [[UIImageView alloc] init];
        self.addIcon.frame = CGRectMake(20, 10, 60, 60);
        self.addIcon.image = [UMSImage imageNamed:@"new.png"];
        [self addSubview:self.addIcon];
        
        self.friendLabel = [[UILabel alloc] init];
        self.friendLabel.frame = CGRectMake(CGRectGetMaxX(self.addIcon.frame) + 10, 30, 100, 20);
        self.friendLabel.text = @"新的好友";
        self.friendLabel.font = [UIFont systemFontOfSize:16];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self addSubview:self.friendLabel];
    }
    
    return self;
}

@end
