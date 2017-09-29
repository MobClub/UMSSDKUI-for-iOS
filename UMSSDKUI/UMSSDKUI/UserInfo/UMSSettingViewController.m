//
//  UMSSettingViewController.m
//  UMSSDKUI
//
//  Created by 刘靖煌 on 17/2/26.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import "UMSSettingViewController.h"
#import "UMSImage.h"
#import "UMSModifyPasswordViewController.h"
#import <UMSSDK/UMSSDK.h>
#import "UMSLoginViewController.h"
#import "UMSBaseNavigationController.h"
#import "UMSAlertView.h"
#import <MOBFoundation/MOBFoundation.h>
#import "UIBarButtonItem+UMS.h"
#import "UMSBlockListViewController.h"

@interface UMSSettingViewController ()

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation UMSSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 左边按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"return.png"
                                                                 highIcon:@"return.png"
                                                                   target:self
                                                                   action:@selector(leftItemClicked:)];
    
    //中间的标题
    UILabel *navTitle = [[UILabel alloc] init];
    navTitle.frame = CGRectMake(0, 0 , 35, 35);
    navTitle.text = @"设置";
    navTitle.font = [UIFont systemFontOfSize:16];
    self.navigationItem.titleView = navTitle;
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    
    //添加 UIActivityIndicatorView
    self.activityIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 100, 85)];
    self.activityIndicator.center = self.view.center;
    self.activityIndicator.layer.cornerRadius = 10;
    self.activityIndicator.layer.masksToBounds = YES;
    [self.activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [self.activityIndicator setBackgroundColor:[UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:0.9]];
    [self.activityIndicator setHidesWhenStopped:YES];
    [self.view addSubview:self.activityIndicator];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 将导航条变透明
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = nil;
}

-(void)leftItemClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            //如果没有绑定手机，则不显示修改密码
            if (self.isBindingPhone)
            {
                return 2;
            }
            return 1;
            
            break;
        case 1:
            return 1;
            break;
        default:
            break;
    }
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.创建cell
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    
    switch (indexPath.section)
    {
        case 0:
        {
            if (self.isBindingPhone)
            {
                switch (indexPath.row)
                {
                    case 0:
                        cell.textLabel.text = @"修改密码";
                        cell.textLabel.font = [UIFont systemFontOfSize:14];
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                        break;
                    case 1:
                    {
                        cell.textLabel.text = @"黑名单";
                        cell.textLabel.font = [UIFont systemFontOfSize:14];
                        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                    }
                        break;
                        
                    default:
                        break;
                }
            }
            else
            {
                cell.textLabel.text = @"黑名单";
                cell.textLabel.font = [UIFont systemFontOfSize:14];
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
        }
            break;
        case 1:
        {
            UIButton *cellButton = [[UIButton alloc] init];
            cellButton.frame = CGRectMake(0, 0, self.view.bounds.size.width, cell.bounds.size.height);
            [cellButton setTitle:@"退出登录" forState:UIControlStateNormal];
            cellButton.titleLabel.font = [UIFont systemFontOfSize: 14];
            [cellButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [cellButton addTarget:self action:@selector(logoutAction) forControlEvents:UIControlEventTouchUpInside];
            [cell.contentView addSubview:cellButton];
        }
            break;

        default:
            break;
            
    }
    return cell;
}

-(void)logoutAction
{
    [self.activityIndicator startAnimating];
    
    [UMSSDK logoutWithResult:^(NSError *error) {
        
        [self.activityIndicator stopAnimating];
        
        if (error)
        {
            if (error.code == -1009)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [UMSAlertView showAlertViewWithTitle:@"退出登录失败"
                                                 message:@"无网络，请连接网络"
                                         leftActionTitle:@"好的"
                                        rightActionTitle:nil
                                          animationStyle:AlertViewAnimationZoom
                                            selectAction:nil];
                });
            }
            else
            {
                [UMSAlertView showAlertViewWithTitle:@"退出登录失败"
                                             message:[error description]
                                     leftActionTitle:@"好的"
                                    rightActionTitle:nil
                                      animationStyle:AlertViewAnimationZoom
                                        selectAction:nil];
            }
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 0:
        {
            if (self.isBindingPhone)
            {
                switch (indexPath.row)
                {
                    case 0:
                    {
                        UMSModifyPasswordViewController *modify = [[UMSModifyPasswordViewController alloc] init];
                        [self.navigationController pushViewController:modify animated:YES];
                    }
                        break;
                    case 1:
                    {
                        [self didSelectedBlockListWithTableView:tableView indexPath:indexPath];
                    }
                        break;
                    default:
                        break;
                }
            }
            else
            {
                [self didSelectedBlockListWithTableView:tableView indexPath:indexPath];
            }
        }
            break;
        case 1:
            {}
            break;
        default:
            break;
    }
}

-(void)didSelectedBlockListWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    UMSBlockListViewController *blockList = [[UMSBlockListViewController alloc] init];
    blockList.navTitle = @"黑名单";
    blockList.isHiddleLeftBarButtonItem = NO;

    [self.navigationController pushViewController:blockList animated:YES];
}

@end
