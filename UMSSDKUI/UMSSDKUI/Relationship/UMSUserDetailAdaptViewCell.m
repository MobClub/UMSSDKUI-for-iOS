//
//  UMSUserDetailAdaptViewCell.m
//  UMSSDKUI
//
//  Created by 刘靖煌 on 2017/7/3.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import "UMSUserDetailAdaptViewCell.h"

@implementation UMSUserDetailAdaptViewCell

- (instancetype)init
{
    if (self = [super init])
    {
        [self setupElement];
    }
    
    return self;
}

- (void)setupElement
{
    self.keyLabel = [[UILabel alloc] init];
    self.keyLabel.font = [UIFont systemFontOfSize:14];
    self.keyLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.keyLabel];
    
    self.valueLabel = [[UILabel alloc] init];
    self.valueLabel.numberOfLines = 0;
    self.valueLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.valueLabel];
}

- (void)setValue:(NSString *)value
{
    _value = value;
    
    self.keyLabel.frame = CGRectMake(20, 15, 75, 20);
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 135;
    CGSize contentLabelSize = [_value sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(width, MAXFLOAT)];
    self.valueLabel.frame = (CGRect){{CGRectGetMaxX(self.keyLabel.frame) + 20, 15}, contentLabelSize};
    self.valueLabel.text = value;
    CGFloat height = contentLabelSize.height + 30;
    self.cellHeight = height;
}

@end
