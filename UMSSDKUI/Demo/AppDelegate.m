//
//  AppDelegate.m
//  Demo
//
//  Created by 刘靖煌 on 17/2/26.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import "AppDelegate.h"
#import <ShareSDK/ShareSDK.h>
#import <UMSSDKUI/UMSMainTabBarController.h>
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //Class debugCls = NSClassFromString(@"UIDebuggingInformationOverlay");
    //[debugCls performSelector:NSSelectorFromString(@"prepareDebuggingOverlay")];
    
    [ShareSDK registerActivePlatforms:@[
                                        @(SSDKPlatformTypeSinaWeibo),
                                        @(SSDKPlatformTypeFacebook),
                                        @(SSDKPlatformTypeWechat),
                                        @(SSDKPlatformTypeQQ),
                                        ]
                             onImport:^(SSDKPlatformType platformType) {
                                 
                             }
                      onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
                          
                          switch (platformType)
                          {
                              case SSDKPlatformTypeSinaWeibo:
                                  //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                                  [appInfo SSDKSetupSinaWeiboByAppKey:@"568898243"
                                                            appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                                                          redirectUri:@"http://www.sharesdk.cn"
                                                             authType:SSDKAuthTypeBoth];
                                  break;
                              case SSDKPlatformTypeFacebook:
                                  //设置Facebook应用信息，其中authType设置为只用SSO形式授权
                                  [appInfo SSDKSetupFacebookByApiKey:@"1201984966578499"
                                                           appSecret:@"eb6e8dcb41cfc7223ffbdaf31fece024"
                                                         displayName:@"UMSSDK"
                                                            authType:SSDKAuthTypeBoth];
                                  break;
                              case SSDKPlatformTypeWechat:
                                  [appInfo SSDKSetupWeChatByAppId:@"wx4868b35061f87885"
                                                        appSecret:@"64020361b8ec4c99936c0e3999a9f249"];
                                  break;
                              case SSDKPlatformTypeQQ:
                                  [appInfo SSDKSetupQQByAppId:@"100371282"
                                                       appKey:@"aed9b0303e3ed1e27bae87c33761161d"
                                                     authType:SSDKAuthTypeBoth];
                                  break;
                              default:
                                  break;
                          }
                      }];
    
    self.window = [[UIWindow alloc]init];
    self.window.frame = [UIScreen mainScreen].bounds;
    self.window.rootViewController = [[UMSMainTabBarController alloc] init];
    self.window.backgroundColor = [UIColor whiteColor];
    
    return YES;
}

@end
