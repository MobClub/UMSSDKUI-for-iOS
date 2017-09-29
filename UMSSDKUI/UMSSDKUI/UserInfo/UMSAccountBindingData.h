//
//  UMSAccountBindingData.h
//  UMSSDKUI
//
//  Created by 刘靖煌 on 17/3/29.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UMSSDK/UMSTypeDefine.h>

@interface UMSAccountBindingData : NSObject

@property (nonatomic, assign) UMSPlatformType type;
@property (nonatomic, assign) BOOL isBinding;

@end
