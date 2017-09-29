//
//  UMSUserView.h
//  UMSSDKUI
//
//  Created by 刘靖煌 on 17/5/24.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UMSSDK/UMSUser.h>

@interface UMSUserView : UIView

@property (nonatomic, strong) UIButton *avatarButton;
@property (nonatomic, strong) UILabel *nicknameLabel;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UIButton *genderAgeButton;
@property (nonatomic, strong) UILabel *signatureLabel;
@property (nonatomic, strong) UMSUser *userData;
@property (nonatomic, assign) BOOL isShowLoginTime;
@property (nonatomic, strong) UILabel *loginTimeLabel;

@end
