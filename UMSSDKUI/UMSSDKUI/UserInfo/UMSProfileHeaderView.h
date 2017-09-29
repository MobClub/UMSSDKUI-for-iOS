//
//  UMSProfileHeaderView.h
//  UMSSDKUI
//
//  Created by 刘靖煌 on 17/3/21.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UMSSDK/UMSUser.h>

@protocol IUMSProfileHeaderViewDelegate <NSObject>

@optional

- (void)avatarItemClicked;
- (void)phoneItemClicked;
- (void)followItemClicked;
- (void)fansItemClicked;
- (void)coFollowItemClicked;
- (void)clickToLogin;

@end

@interface UMSProfileHeaderView : UIView



@property (nonatomic, strong) UMSUser *userModel;

@property (nonatomic, weak) id<IUMSProfileHeaderViewDelegate> delegate;

@end
