//
//  UMSAccountBindingViewController.m
//  UMSSDKUI
//
//  Created by 刘靖煌 on 17/3/13.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import "UMSAccountBindingViewController.h"
#import "UMSAccountBindingCell.h"
#import "UMSImage.h"
#import <UMSSDK/UMSSDK.h>
#import "UMSPhoneAccountBindingViewController.h"
#import <MOBFoundation/MOBFoundation.h>
#import "UMSAlertView.h"
#import <UMSSDK/UMSBindingData.h>
#import "UMSAccountBindingData.h"
#import "UIBarButtonItem+UMS.h"
#import "UMSBaseNavigationController.h"

@interface UMSAccountBindingViewController ()

@property (nonatomic, strong) NSArray *accounts;
@property (nonatomic, strong) NSMutableArray *cellArray;
@property (nonatomic, strong) NSMutableArray *accountBindingArray;

@end

@implementation UMSAccountBindingViewController

-(instancetype)initWithSupportedPlatform:(NSArray *)supportedPlatform
{
    if (self = [super init])
    {
        self.supportedPlatform = supportedPlatform;
        self.cellArray = [NSMutableArray array];
    }
    
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    // 左边按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"return.png"
                                                                 highIcon:@"return.png"
                                                                   target:self
                                                                   action:@selector(leftItemClicked:)];
    
    //中间的标题
    UILabel *navTitle = [[UILabel alloc] init];
    navTitle.frame = CGRectMake(0, 0 , 35, 35);
    navTitle.text = @"账号绑定";
    navTitle.font = [UIFont systemFontOfSize:16];
    self.navigationItem.titleView = navTitle;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    _accountBindingArray = [NSMutableArray array];
    for (NSNumber *platformType in self.supportedPlatform)
    {
        UMSAccountBindingData *account = [[UMSAccountBindingData alloc] init];
        account.type = [platformType integerValue];
        
        MOBFDataService *dataService = [MOBFDataService sharedInstance];
        NSArray *bindedPlatform = [dataService cacheDataForKey:@"UMSCacheBindedPlatform" domain:nil];
        
        if ([bindedPlatform containsObject:platformType])
        {
            account.isBinding = YES;
        }
        else
        {
            account.isBinding = NO;
        }
        
        [_accountBindingArray addObject:account];
    }
}

-(void)leftItemClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.supportedPlatform.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.创建cell
    static NSString *ID = @"cell";
    UMSAccountBindingCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil)
    {
        cell = [[UMSAccountBindingCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    
    // 2.设置cell的数据
    UMSAccountBindingData *account = self.accountBindingArray[indexPath.row];
    switch (account.type)
    {
        case UMSPlatformTypePhone:
        {
            cell.platformLabel.text = @"手机号码";
            if (account.isBinding)
            {
                [cell.accountBinding setTitle:@"已绑定" forState:UIControlStateNormal];
                cell.userInteractionEnabled = NO;
                [cell.accountBinding setTitleColor:[UIColor colorWithRed:227/255.0 green:81/255.0 blue:78/255.0 alpha:1.0] forState:UIControlStateNormal];
            }
            else
            {
                [cell.accountBinding setBackgroundImage:[UMSImage imageNamed:@"kuang.png"] forState:UIControlStateNormal];
                [cell.accountBinding setTitle:@"绑定" forState:UIControlStateNormal];
                [cell.accountBinding setTitleColor:[UIColor colorWithRed:173/255.0 green:173/255.0 blue:173/255.0 alpha:1.0] forState:UIControlStateNormal];
            }
        }
            break;
        case UMSPlatformTypeQQ:
        {
            cell.platformLabel.text = @"QQ";
            
            if (account.isBinding)
            {
                [cell.accountBinding setTitle:@"已绑定" forState:UIControlStateNormal];
                cell.userInteractionEnabled = NO;
                [cell.accountBinding setTitleColor:[UIColor colorWithRed:227/255.0 green:81/255.0 blue:78/255.0 alpha:1.0] forState:UIControlStateNormal];
            }
            else
            {
                [cell.accountBinding setBackgroundImage:[UMSImage imageNamed:@"kuang.png"] forState:UIControlStateNormal];
                [cell.accountBinding setTitle:@"绑定" forState:UIControlStateNormal];
                [cell.accountBinding setTitleColor:[UIColor colorWithRed:173/255.0 green:173/255.0 blue:173/255.0 alpha:1.0] forState:UIControlStateNormal];
            }
        }
            break;
        case UMSPlatformTypeWechat:
        {
            cell.platformLabel.text = @"微信";
            
            if (account.isBinding)
            {
                [cell.accountBinding setTitle:@"已绑定" forState:UIControlStateNormal];
                cell.userInteractionEnabled = NO;
                [cell.accountBinding setTitleColor:[UIColor colorWithRed:227/255.0 green:81/255.0 blue:78/255.0 alpha:1.0] forState:UIControlStateNormal];
            }
            else
            {
                [cell.accountBinding setBackgroundImage:[UMSImage imageNamed:@"kuang.png"] forState:UIControlStateNormal];
                [cell.accountBinding setTitle:@"绑定" forState:UIControlStateNormal];
                [cell.accountBinding setTitleColor:[UIColor colorWithRed:173/255.0 green:173/255.0 blue:173/255.0 alpha:1.0] forState:UIControlStateNormal];
            }
        }
            break;
        case UMSPlatformTypeFacebook:
        {
            cell.platformLabel.text = @"Facebook";
            
            if (account.isBinding)
            {
                [cell.accountBinding setTitle:@"已绑定" forState:UIControlStateNormal];
                cell.userInteractionEnabled = NO;
                [cell.accountBinding setTitleColor:[UIColor colorWithRed:227/255.0 green:81/255.0 blue:78/255.0 alpha:1.0] forState:UIControlStateNormal];
            }
            else
            {
                [cell.accountBinding setBackgroundImage:[UMSImage imageNamed:@"kuang.png"] forState:UIControlStateNormal];
                [cell.accountBinding setTitle:@"绑定" forState:UIControlStateNormal];
                [cell.accountBinding setTitleColor:[UIColor colorWithRed:173/255.0 green:173/255.0 blue:173/255.0 alpha:1.0] forState:UIControlStateNormal];
            }
        }
            break;
        case UMSPlatformTypeSinaWeibo:
        {
            cell.platformLabel.text = @"新浪微博";
            
            if (account.isBinding)
            {
                [cell.accountBinding setTitle:@"已绑定" forState:UIControlStateNormal];
                cell.userInteractionEnabled = NO;
                [cell.accountBinding setTitleColor:[UIColor colorWithRed:227/255.0 green:81/255.0 blue:78/255.0 alpha:1.0] forState:UIControlStateNormal];
            }
            else
            {
                [cell.accountBinding setBackgroundImage:[UMSImage imageNamed:@"kuang.png"] forState:UIControlStateNormal];
                [cell.accountBinding setTitle:@"绑定" forState:UIControlStateNormal];
                [cell.accountBinding setTitleColor:[UIColor colorWithRed:173/255.0 green:173/255.0 blue:173/255.0 alpha:1.0] forState:UIControlStateNormal];
            }
        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UMSPlatformType platformType = [self.supportedPlatform[indexPath.row] integerValue];
    
    if (platformType ==0)
    {
        UMSPhoneAccountBindingViewController *phoneAccountBinding = [[UMSPhoneAccountBindingViewController alloc] init];
        // 2.包装一个导航控制器
        UMSBaseNavigationController *nav = [[UMSBaseNavigationController alloc] initWithRootViewController:phoneAccountBinding];
//        [self.navigationController pushViewController:phoneAccountBinding animated:YES];
        [self presentViewController:nav animated:YES completion:nil];
    }
    else
    {
        [UMSSDK accountBindingWithPlatformType:platformType
                                        result:^(UMSBindingData *bindingData,NSError *error) {
                                            
                                            if (!error)
                                            {
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
                                                }];
                                                
                                                [UMSAlertView showAlertViewWithTitle:@"绑定成功"
                                                                             message:@""
                                                                     leftActionTitle:@"好的"
                                                                    rightActionTitle:nil
                                                                      animationStyle:AlertViewAnimationZoom
                                                                        selectAction:^(AlertViewActionType actionType) {
                                                                            
                                                                            UMSAccountBindingData *account = self.accountBindingArray[indexPath.row];
                                                                            account.isBinding = YES;
                                                                            
                                                                            NSIndexPath *path = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
                                                                            [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationBottom];
                                                                            
                                                                            

                                                                        }];
                                            }
                                            else
                                            {
                                                NSInteger status = [[[error userInfo] objectForKey:@"status"] integerValue];
                                                NSInteger errorCode = error.code;
                                                
                                                if (status == 422)
                                                {
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        
                                                        [UMSAlertView showAlertViewWithTitle:@"绑定失败"
                                                                                     message:@"账号或密码错误"
                                                                             leftActionTitle:@"好的"
                                                                            rightActionTitle:nil
                                                                              animationStyle:AlertViewAnimationZoom
                                                                                selectAction:nil];
                                                    });
                                                }
                                                else if(status == 435)
                                                {
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        
                                                        [UMSAlertView showAlertViewWithTitle:@"绑定失败"
                                                                                     message:@"账号已经被绑定"
                                                                             leftActionTitle:@"好的"
                                                                            rightActionTitle:nil
                                                                              animationStyle:AlertViewAnimationZoom
                                                                                selectAction:nil];
                                                    });
                                                }
                                                else if(errorCode == 600002)
                                                {
                                                    dispatch_async(dispatch_get_main_queue(), ^{
                                                        
                                                        [UMSAlertView showAlertViewWithTitle:@"已取消绑定"
                                                                                     message:nil
                                                                             leftActionTitle:@"好的"
                                                                            rightActionTitle:nil
                                                                              animationStyle:AlertViewAnimationZoom
                                                                                selectAction:nil];
                                                    });
                                                }
                                                else
                                                {
                                                    [UMSAlertView showAlertViewWithTitle:@"绑定失败"
                                                                                 message:[error description]
                                                                         leftActionTitle:@"好的"
                                                                        rightActionTitle:nil
                                                                          animationStyle:AlertViewAnimationZoom
                                                                            selectAction:nil];
                                                }
                                            }
                                        }];
    }
}

@end
