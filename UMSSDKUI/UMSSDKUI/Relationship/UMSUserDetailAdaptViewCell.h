//
//  UMSUserDetailAdaptViewCell.h
//  UMSSDKUI
//
//  Created by 刘靖煌 on 2017/7/3.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import "UMSBaseTableViewCell.h"

@interface UMSUserDetailAdaptViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *keyLabel;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) NSString *value;
@property (nonatomic, assign) CGFloat cellHeight;

@end
