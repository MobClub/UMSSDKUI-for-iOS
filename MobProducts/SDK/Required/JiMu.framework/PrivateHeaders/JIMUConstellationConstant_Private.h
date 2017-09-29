//
//  JIMUConstellationConstant_Private.h
//  JiMu
//
//  Created by 冯鸿杰 on 17/3/15.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <JiMu/JiMu.h>

@interface JIMUConstellationConstant ()

/**
 索引值
 */
@property (nonatomic) NSInteger index;

/**
 名字
 */
@property (nonatomic, copy) NSString *name;

#if DEBUG

/**
 英文名字
 */
@property (nonatomic, copy) NSString *enName;

#endif

@end
