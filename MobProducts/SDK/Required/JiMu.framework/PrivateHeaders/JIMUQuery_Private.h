//
//  JIMUQuery_Private.h
//  JiMu
//
//  Created by 冯鸿杰 on 17/3/1.
//  Copyright © 2017年 Mob. All rights reserved.
//

#import <JiMu/JiMu.h>

typedef NSDictionary* (^JIMUQueryExtensionParamsHandler) (NSString *name);

@interface JIMUQuery ()

/**
 数据视图名称
 */
@property (nonatomic, copy) NSString *name;

/**
 查询描述字典
 */
@property (nonatomic, strong) NSArray *selectFields;

/**
 查询条件
 */
@property (nonatomic, strong) JIMUQueryCondition *condition;

/**
 排序字段集合
 */
@property (nonatomic, strong) JIMUQueryOrder *order;

/**
 添加配置
 
 @param config 配置信息
 */
+ (void)addConfig:(NSArray *)config;

/**
 注册类型名称，主要用于Query在find时返回的列表元素类型，如果不设置视图对应的类型，则返回时为一个JIMUDataModel的数组，注册后则对应视图返回的是一个注册类型为元素的数组。
 注：dataModelClass必须继承JIMUDataModel。
 
 @param dataModelClass 数据模型类型
 @param name 数据视图名称
 */
+ (void)registerClass:(Class)dataModelClass forName:(NSString *)name;

/**
 设置扩展参数处理回调，每个视图在查询时可能存在不一样的扩展参数，该方法目的是设置一个处理回调，当Query请求时会触发该回调来取得与视图相关的扩展参数集合
 
 @param handler 参数处理回调
 @param name 数据视图名称
 */
+ (void)setExtensionParamsHandler:(JIMUQueryExtensionParamsHandler)handler forName:(NSString *)name;

@end
