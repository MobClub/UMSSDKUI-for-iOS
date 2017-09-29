//
//  UMSPlatformAccountBindingCell.m
//  UMSSDKUI
//
//  Created by 刘靖煌 on 17/3/15.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import "UMSPlatformAccountBindingCell.h"
#import <UMSSDK/UMSSDK.h>
#import "UMSImage.h"
#import <MOBFoundation/MOBFoundation.h>
#import <UMSSDK/UMSBindingData.h>

@implementation UMSPlatformAccountBindingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self setupElement];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
}

-(void)setupElement
{
    self.platformLabel = [[UILabel alloc] init];
    self.platformLabel.frame = CGRectMake(20, 10, 100, 30);
    self.platformLabel.text = @"账号绑定";
    self.platformLabel.textAlignment = NSTextAlignmentLeft;
    self.platformLabel.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.platformLabel];
    
    [self addPlatformData];
    
    self.arrow = [[UIButton alloc] init];
    self.arrow.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 35, 35/2.0, 15, 15);
    [self.arrow setBackgroundImage:[UMSImage imageNamed:@"yjt.png"] forState:UIControlStateNormal];
    [self.contentView addSubview:self.arrow];
}

-(void)addPlatformData
{
    [UMSSDK supportedLoginPlatforms:^(NSArray *supportedPlatform) {
        
        if ([supportedPlatform isKindOfClass:[NSArray class]])
        {
            NSMutableArray *supportedPlatforms = [NSMutableArray arrayWithArray:supportedPlatform];
            [supportedPlatforms addObject:@(0)];
            NSUInteger n = supportedPlatforms.count;
            CGFloat platformWidth = 20;
            
            [UMSSDK getBindingDataWithResult:^(NSArray<UMSBindingData *> *list, NSError *error) {
                //已经绑定的平台
                NSMutableArray *bindedPlatform = [NSMutableArray array];
                
                if (list)
                {
                    for (UMSBindingData *bindingData in list)
                    {
                        [bindedPlatform addObject:@(bindingData.bindType)];
                    }
                }
                
                MOBFDataService *dataService = [MOBFDataService sharedInstance];
                [dataService setCacheData:bindedPlatform forKey:@"UMSCacheBindedPlatform" domain:nil];
                
                for (int i = 0; i < n; i++)
                {
                    NSNumber *platformTypeNum = supportedPlatforms[i];
                    UMSPlatformType platformType = [platformTypeNum integerValue];
                    
                    UIButton *platform = [[UIButton alloc] init];
                    platform.enabled = NO;
                    platform.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 55 -(platformWidth+5)*i, 15, platformWidth, platformWidth);
                    [self.contentView addSubview:platform];
                    
                    switch (platformType)
                    {
                        case 0:
                        {
                            if ([bindedPlatform containsObject:@(0)])
                            {
                                [platform setImage:[UMSImage imageNamed:@"phone_2_2.png"] forState:UIControlStateDisabled];
                            }
                            else
                            {
                                [platform setImage:[UMSImage imageNamed:@"phone_2.png"] forState:UIControlStateDisabled];
                            }
                        }
                            break;
                        case 1:
                        {
                            if ([bindedPlatform containsObject:@(1)])
                            {
                                [platform setImage:[UMSImage imageNamed:@"weibo_2_2.png"] forState:UIControlStateDisabled];
                            }
                            else
                            {
                                [platform setImage:[UMSImage imageNamed:@"weibo_2.png"] forState:UIControlStateDisabled];
                            }
                        }
                            break;
                        case 10:
                        {
                            if ([bindedPlatform containsObject:@(10)])
                            {
                                [platform setImage:[UMSImage imageNamed:@"facebook_2_2.png"] forState:UIControlStateDisabled];
                            }
                            else
                            {
                                [platform setImage:[UMSImage imageNamed:@"facebook_2.png"] forState:UIControlStateDisabled];
                            }
                        }
                            break;
                        case 22:
                        {
                            if ([bindedPlatform containsObject:@(22)])
                            {
                                [platform setImage:[UMSImage imageNamed:@"wechat_2_2.png"] forState:UIControlStateDisabled];
                            }
                            else
                            {
                                [platform setImage:[UMSImage imageNamed:@"wechat_2.png"] forState:UIControlStateDisabled];
                            }
                        }
                            break;
                        case 24:
                        {
                            if ([bindedPlatform containsObject:@(24)])
                            {
                                [platform setImage:[UMSImage imageNamed:@"qq_2_2.png"] forState:UIControlStateDisabled];
                            }
                            else
                            {
                                [platform setImage:[UMSImage imageNamed:@"qq_2.png"] forState:UIControlStateDisabled];
                            }
                        }
                            break;
                        default:
                            break;
                    }
                }
            }];
        }
    }];
}

@end
