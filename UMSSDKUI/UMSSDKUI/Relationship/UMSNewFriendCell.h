//
//  UMSNewFriendCell.h
//  UMSSDKUI
//
//  Created by 刘靖煌 on 17/5/31.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UMSSDK/UMSApplyAddFriendData.h>
#import "UMSBaseTableViewCell.h"

@protocol IUMSNewFriendCellDelegate <NSObject>

- (void)agreeWithTag:(NSInteger)tag;
- (void)refuseWithTag:(NSInteger)tag;

@end

@interface UMSNewFriendCell : UMSBaseTableViewCell

@property (nonatomic, strong) UMSApplyAddFriendData *dataModel;
@property (nonatomic, weak) id<IUMSNewFriendCellDelegate> delegate;

@end
