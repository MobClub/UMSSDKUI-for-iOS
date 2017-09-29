//
//  NSDate+UMSSDK.h
//  UMSSDKUI
//
//  Created by 刘靖煌 on 17/4/6.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (UMSSDK)

/**
 根据生日计算年龄

 @param birthday 出生日期

 @return 年龄
 */
+ (NSUInteger)getAgeWith:(NSDate*)birthday;


/**
 根据生日得到星座

 @param birthday 出生日期
 */
+ (NSString *)getConstellationFromBirthday:(NSDate*)birthday;

/**
 根据生日得到生肖

 @param birthday 出生日期
 */
+ (NSString *)getZodiacWith:(NSDate*) birthday;

/**
 根据时间换成具体的时间
 
 @param birthday 要转换的时间
 */
+ (NSString *)getSpecialTimeWithDate:(NSDate *)date;


@end
