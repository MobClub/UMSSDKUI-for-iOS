//
//  JIMQueryCondition_Private.h
//  Jimu
//
//  Created by 冯鸿杰 on 17/2/10.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import "JIMUQueryCondition.h"

@interface JIMUQueryCondition ()

/**
 条件描述字典
 */
@property (nonatomic, strong) NSDictionary *data;

/**
 连词
 */
@property (nonatomic, copy) NSString *conjunction;

@end
