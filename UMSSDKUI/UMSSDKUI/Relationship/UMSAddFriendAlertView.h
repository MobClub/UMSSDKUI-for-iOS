//
//  UMSAddFriendAlertView.h
//  UMSSDKUI
//
//  Created by 刘靖煌 on 17/6/1.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSAddFriendView.h"
#import <UMSSDK/UMSUser.h>

@protocol IUMSAddFriendAlertViewDelegate <NSObject>

@optional

- (void)cancelClicked;
- (void)addFriendClicked;

@end

@interface UMSAddFriendAlertView : NSObject<IUMSAddFriendAlertViewDelegate>

@property (nonatomic, weak) id<IUMSAddFriendAlertViewDelegate> delegate;
@property (nonatomic, strong) UMSAddFriendView *addFriendView;

- (instancetype)initWithUser:(UMSUser *)user;

- (void)show;

@end
