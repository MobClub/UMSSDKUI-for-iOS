//
//  UMSAddFriendView.h
//  UMSSDKUI
//
//  Created by 刘靖煌 on 17/6/1.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UMSSDK/UMSUser.h>
#import "UITextView+UMSPlaceholder.h"

@protocol IUMSAddFriendViewDelegate <NSObject>

@optional

-(void)cancelClicked;
-(void)addFriendClicked;

@end

@interface UMSAddFriendView : UIView

@property (nonatomic, strong) UMSUser *userData;
@property (nonatomic, weak) id<IUMSAddFriendViewDelegate> delegate;
@property (nonatomic, strong) UITextView *message;

@end
