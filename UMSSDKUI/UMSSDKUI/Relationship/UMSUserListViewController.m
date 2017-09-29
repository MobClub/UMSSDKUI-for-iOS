//
//  UMSUserListViewController.m
//  UMSSDKUI
//
//  Created by 刘靖煌 on 17/5/27.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import "UMSUserListViewController.h"
#import "UMSUserListCell.h"
#import "UIBarButtonItem+UMS.h"
#import "UMSUserDetailInfoViewController.h"
#import <UMSSDK/UMSSDK+Relationship.h>

@interface UMSUserListViewController ()

@end

@implementation UMSUserListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.userList = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *navTitle = [[UILabel alloc] init];
    navTitle.frame = CGRectMake(0, 0 , 35, 35);
    navTitle.text = self.navTitle;
    navTitle.font = [UIFont systemFontOfSize:16];
    self.navigationItem.titleView = navTitle;
    
    if (!self.isHiddleLeftBarButtonItem)
    {
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"return.png"
                                                                     highIcon:@"return.png"
                                                                       target:self
                                                                       action:@selector(leftItemClicked:)];
    }
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.modalPresentationCapturesStatusBarAppearance = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 将导航条变透明
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.userList.count <= 0)
    {
        return 0;
    }
    return self.userList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *UMSUserListCellID = @"UMSUserListCell";
    UMSUserListCell *cell = [tableView dequeueReusableCellWithIdentifier:UMSUserListCellID];

    if (!cell)
    {
        cell = [[UMSUserListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:UMSUserListCellID];
    }
    
    cell.isShowLoginTime = self.isShowLoginTime;
    cell.userData = self.userList[indexPath.row];
    
    return cell;
}

- (void)leftItemClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UMSUserDetailInfoViewController *detail = [[UMSUserDetailInfoViewController alloc] initWithUser:self.userList[indexPath.row]];
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail
                                         animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

@end
