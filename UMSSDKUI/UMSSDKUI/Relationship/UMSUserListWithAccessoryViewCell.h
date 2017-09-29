//
//  UMSUserListWithAccessoryViewCell.h
//  UMSSDKUI
//
//  Created by 刘靖煌 on 17/6/1.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UMSSDK/UMSUser.h>
#import "UMSUserView.h"
#import "UMSBaseTableViewCell.h"

@protocol IUMSUserListWithAccessoryViewCellDelegate <NSObject>

- (void)accessoryViewClickedWithTag:(NSInteger)tag;

@end

@interface UMSUserListWithAccessoryViewCell : UMSBaseTableViewCell

@property (nonatomic, strong) UMSUser *userData;
@property (nonatomic, strong) UMSUserView *dataView;
@property (nonatomic, strong) UIButton *accessoryViewer;
@property (nonatomic, weak) id<IUMSUserListWithAccessoryViewCellDelegate> delegate;

@end
