//
//  UMSUserDetailViewCell.m
//  UMSSDKUI
//
//  Created by 刘靖煌 on 17/5/30.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import "UMSUserDetailViewCell.h"

@implementation UMSUserDetailViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self setupElement];
    }
    return self;
}

-(void)setupElement
{
    self.keyLabel = [[UILabel alloc] init];
    self.keyLabel.frame = CGRectMake(20, 15, 75, 20);
    self.keyLabel.font = [UIFont systemFontOfSize:14];
    self.keyLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.keyLabel];
    
    self.valueLabel = [[UILabel alloc] init];
    self.valueLabel.frame = CGRectMake(CGRectGetMaxX(self.keyLabel.frame) + 20, 15, 175, 20);
    self.valueLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.valueLabel];
}

@end
