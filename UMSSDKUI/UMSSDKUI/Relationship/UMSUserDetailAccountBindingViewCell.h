//
//  UMSUserDetailAccountBindingViewCell.h
//  UMSSDKUI
//
//  Created by 刘靖煌 on 17/5/30.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UMSSDK/UMSUser.h>
#import "UMSBaseTableViewCell.h"

@interface UMSUserDetailAccountBindingViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *keyLabel;

- (instancetype)initWithUser:(UMSUser *)userModel;

@end
