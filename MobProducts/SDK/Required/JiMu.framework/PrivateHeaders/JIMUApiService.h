//
//  JIMUApService.h
//  JiMu
//
//  Created by 冯鸿杰 on 17/2/23.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 接口服务
 */
@interface JIMUApiService : NSObject

/**
 设置服务器时间，该方法在请求到服务器时间时立刻设置。

 @param date 服务器时间
 */
+ (void)setServerTime:(NSDate *)date;

/**
 创建请求

 @param url 请求地址
 @param data 请求数据
 @param zipData 是否压缩数据
 @return 请求对象
 */
+ (NSURLRequest *)requestWithURL:(NSURL *)url
                            data:(NSDictionary *)data
                         zipData:(BOOL)zipData;

/**
 解码回复数据

 @param response 报文回复对象
 @param responseData 回复数据
 @param request 对应回复的请求
 @return 回复数据
 */
+ (id)decodeResponse:(NSHTTPURLResponse *)response
        responseData:(NSData *)responseData
             request:(NSURLRequest *)request;

@end
