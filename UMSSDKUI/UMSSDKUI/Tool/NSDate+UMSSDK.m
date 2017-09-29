//
//  NSDate+UMSSDK.m
//  UMSSDKUI
//
//  Created by 刘靖煌 on 17/4/6.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import "NSDate+UMSSDK.h"

@implementation NSDate (UMSSDK)

//根据生日得到年龄
+ (NSUInteger)getAgeWith:(NSDate*)birthday
{
    //日历
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSUInteger unitFlags = NSCalendarUnitYear;
    NSDateComponents *components = [gregorian components:unitFlags
                                                fromDate:birthday
                                                  toDate:[NSDate date]
                                                 options:0];
    
    return [components year];
}

+ (NSString *)getConstellationFromBirthday:(NSDate*)birthday
{
    
    NSCalendar *myCal = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comp1 = [myCal components:NSCalendarUnitMonth| NSCalendarUnitDay fromDate:birthday];
    NSInteger month = [comp1 month];
    NSInteger day = [comp1 day];
    
    return [self getAstroWithMonth:month day:day];
}


+ (NSString *)getZodiacWith:(NSDate*) birthday{
    
    NSCalendar *myCal = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comp1 = [myCal components:NSCalendarUnitYear fromDate:birthday];
    NSInteger year = [comp1 year];
    return [self getZodiacWithYear:year];
}

//得到生肖的算法
+ (NSString *)getZodiacWithYear:(NSInteger)y
{
    if (y <0)
    {
        return @"错误日期格式!!!";
    }
    
//    NSString *zodiacString = @"鼠牛虎兔龙蛇马羊猴鸡狗猪";
    NSString *zodiacString = @"123456789ABC";
    NSRange range = NSMakeRange ((y+9)%12-1, 1);
    NSString*  result = [zodiacString  substringWithRange:range];
    return result;
    
}
//得到星座的算法
+ (NSString *)getAstroWithMonth:(NSInteger)m day:(NSInteger)d
{
//    NSString *astroString = @"魔羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯";
    NSString *astroString = @"AABBCC112233445566778899";
    NSString *astroFormat = @"102123444543";
    NSString *result;
    
    if (m<1||m>12||d<1||d>31)
    {
        return @"错误日期格式!";
    }
    
    if(m ==2 && d > 29)
    {
        return @"错误日期格式!!";
    }
    else if(m==4 || m==6 || m==9 || m==11)
    {
        if (d>30)
        {
            return @"错误日期格式!!!";
        }
    }
    
    result=[NSString stringWithFormat:@"%@",
            [astroString substringWithRange:NSMakeRange(m*2-(d < [[astroFormat substringWithRange:NSMakeRange((m-1), 1)] intValue] - (-19))*2,2)]];
    
    return result;
}

+ (NSString *)getSpecialTimeWithDate:(NSDate *)date
{
    double deltaSeconds = fabs([date timeIntervalSinceDate:[NSDate date]]);
    double deltaMinutes = deltaSeconds / 60.0f;
    
    if (deltaSeconds < 5)
    {
        return @"刚刚";
    }
    else if (deltaSeconds < 60)
    {
        return [NSString stringWithFormat:@"%d秒前",(int)deltaSeconds];
        
    }
    else if (deltaMinutes < 60)
    {
        return [NSString stringWithFormat:@"%d分钟前",(int)deltaMinutes];
        
    }
    else if (deltaMinutes < (24 * 60))
    {
        
        int hour = floor(deltaMinutes/60);
        return [NSString stringWithFormat:@"%d小时前",hour];
        
    }
    else if (deltaMinutes < (24 * 60 * 7))
    {
        
        int day = (int)floor(deltaMinutes/(60 * 24));
        return [NSString stringWithFormat:@"%d天前",day];
        
    }
    else
    {
        //返回具体日期
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy/MM/dd"];
        return [formatter stringFromDate:date];
    }
}


@end
