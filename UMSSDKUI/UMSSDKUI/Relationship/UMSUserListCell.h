//
//  UMSUserListCell.h
//  UMSSDKUI
//
//  Created by 刘靖煌 on 17/5/24.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UMSSDK/UMSUser.h>
#import "UMSUserView.h"
#import "UMSBaseTableViewCell.h"

@interface UMSUserListCell : UMSBaseTableViewCell

@property (nonatomic, strong) UMSUser *userData;
@property (nonatomic, strong) UMSUserView *dataView;
@property (nonatomic, assign) BOOL isShowLoginTime;

@end
