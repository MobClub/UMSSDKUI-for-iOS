//
//  UMSAccountBindingCell.m
//  UMSSDKUI
//
//  Created by 刘靖煌 on 17/3/15.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import "UMSAccountBindingCell.h"
#import "UMSImage.h"

@implementation UMSAccountBindingCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self setupElement];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

-(void)setupElement
{
    self.platformLabel = [[UILabel alloc] init];
    self.platformLabel.frame = CGRectMake(20, 10, 100, 30);
    self.platformLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.platformLabel];
    
    self.accountBinding = [[UIButton alloc] init];
    self.accountBinding.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 70, 10, 50, 30);
    self.accountBinding.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.accountBinding setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.accountBinding.enabled = NO;
    [self.contentView addSubview:self.accountBinding];
}

@end
