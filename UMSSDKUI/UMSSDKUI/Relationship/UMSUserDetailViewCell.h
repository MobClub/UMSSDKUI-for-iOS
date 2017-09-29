//
//  UMSUserDetailViewCell.h
//  UMSSDKUI
//
//  Created by 刘靖煌 on 17/5/30.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSBaseTableViewCell.h"

@interface UMSUserDetailViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *keyLabel;
@property (nonatomic, strong) UILabel *valueLabel;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
