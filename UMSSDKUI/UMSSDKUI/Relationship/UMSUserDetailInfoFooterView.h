//
//  UMSUserDetailInfoFooterView.h
//  UMSSDKUI
//
//  Created by 刘靖煌 on 17/5/29.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSUserDetailInfoFooterViewModel.h"

@protocol IUMSUserDetailInfoFooterViewDelegate <NSObject>

-(void)followButtonClicked;
-(void)addFriendButtonClicked;
-(void)blockButtonClicked;

@end

@interface UMSUserDetailInfoFooterView : UIView

@property (nonatomic, weak) id<IUMSUserDetailInfoFooterViewDelegate> delegate;
@property (nonatomic, strong) UMSUserDetailInfoFooterViewModel *footerViewModel;

@end
