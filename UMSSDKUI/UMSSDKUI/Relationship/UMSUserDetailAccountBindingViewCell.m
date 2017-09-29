//
//  UMSUserDetailAccountBindingViewCell.m
//  UMSSDKUI
//
//  Created by 刘靖煌 on 17/5/30.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import "UMSUserDetailAccountBindingViewCell.h"
#import <UMSSDK/UMSSDK.h>
#import <UMSSDK/UMSSDK+Relationship.h>
#import <MOBFoundation/MOBFoundation.h>
#import <UMSSDK/UMSBindingData.h>
#import "UMSImage.h"

@interface UMSUserDetailAccountBindingViewCell ()

@property (nonatomic, strong) UMSUser *userModel;

@end

@implementation UMSUserDetailAccountBindingViewCell

- (instancetype)initWithUser:(UMSUser *)userModel
{
    if (self = [super init])
    {
        _userModel = userModel;
        [self setupElement];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return self;
        
}

- (void)setupElement
{
    self.keyLabel = [[UILabel alloc] init];
    self.keyLabel.frame = CGRectMake(20, 15, 75, 20);
    self.keyLabel.font = [UIFont systemFontOfSize:14];
    self.keyLabel.textColor = [UIColor grayColor];
    [self.contentView addSubview:self.keyLabel];
    
    CGFloat platformWidth = 20;
    [UMSSDK getBindingDataWithUser:_userModel
                            result:^(NSArray<UMSBindingData *> *list, NSError *error) {
                                
                                //已经绑定的平台
                                for (int i = 0; i < [list count]; i++)
                                {
                                    UIButton *platform = [[UIButton alloc] init];
                                    platform.enabled = NO;
                                    platform.frame = CGRectMake(CGRectGetMaxX(self.keyLabel.frame) + 20 + (platformWidth+5)*i, 15, platformWidth, platformWidth);
                                    [self.contentView addSubview:platform];
                                    
                                    UMSBindingData *bindingData = list[i];
                                    UMSPlatformType platformType = bindingData.bindType;
                                    
                                    switch (platformType)
                                    {
                                        case 0:
                                        {
                                            [platform setImage:[UMSImage imageNamed:@"phone_2_2.png"] forState:UIControlStateDisabled];
                                        }
                                            break;
                                        case 1:
                                        {
                                            [platform setImage:[UMSImage imageNamed:@"weibo_2_2.png"] forState:UIControlStateDisabled];
                                        }
                                            break;
                                        case 10:
                                        {
                                            [platform setImage:[UMSImage imageNamed:@"facebook_2_2.png"] forState:UIControlStateDisabled];
                                        }
                                            break;
                                        case 22:
                                        {
                                            [platform setImage:[UMSImage imageNamed:@"wechat_2_2.png"] forState:UIControlStateDisabled];
                                        }
                                            break;
                                        case 24:
                                        {
                                            [platform setImage:[UMSImage imageNamed:@"qq_2_2.png"] forState:UIControlStateDisabled];
                                        }
                                            break;
                                        default:
                                            break;
                                    }
                                }
                            }];
}


@end
