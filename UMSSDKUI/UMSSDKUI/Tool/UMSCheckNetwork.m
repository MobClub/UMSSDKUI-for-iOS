//
//  UMSCheckNetwork.m
//  UMSSDKUI
//
//  Created by 刘靖煌 on 2017/6/28.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import "UMSCheckNetwork.h"
#import "UMSAlertView.h"
#import <MOBFoundation/MOBFoundation.h>

@implementation UMSCheckNetwork

+ (void)checkNetwork
{
    if ([MOBFDevice currentNetworkType] == MOBFNetworkTypeNone)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [UMSAlertView showAlertViewWithTitle:@"无网络，请连接网络"
                                         message:nil
                                 leftActionTitle:@"好的"
                                rightActionTitle:nil
                                  animationStyle:AlertViewAnimationZoom
                                    selectAction:nil];
        });
    }
}

@end
