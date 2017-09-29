//
//  UMSMyFriendViewController.m
//  UMSSDKUI
//
//  Created by 刘靖煌 on 17/5/31.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import "UMSMyFriendViewController.h"
#import "UMSUserListCell.h"
#import "UIBarButtonItem+UMS.h"
#import "UMSMyFriendCell.h"
#import "UMSAccessoryView.h"
#import "UMSUserDetailInfoViewController.h"
#import "UMSNewFriendViewController.h"
#import "UMSSearchForUserViewController.h"
#import <UMSSDK/UMSSDK+Relationship.h>
#import "MJRefresh.h"
#import "UMSAlertView.h"
#import "UMSAccessoryViewWithRedPoint.h"
#import "UMSCheckNetwork.h"

@interface UMSMyFriendViewController ()

@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, copy) NSString *friendCount;

@end

@implementation UMSMyFriendViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *navTitle = [[UILabel alloc] init];
    navTitle.frame = CGRectMake(0, 0 , 35, 35);
    navTitle.text = @"我的好友";
    navTitle.font = [UIFont systemFontOfSize:16];
    self.navigationItem.titleView = navTitle;
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"return.png"
                                                                 highIcon:@"return.png"
                                                                   target:self
                                                                   action:@selector(leftItemClicked:)];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rightButton setTitle:@"添加" forState:UIControlStateNormal];
    [self.rightButton addTarget:self action:@selector(rightItemClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.rightButton.frame = CGRectMake(0, 0, 35, 35);
    self.rightButton.titleLabel.font = [UIFont systemFontOfSize:15];
    self.navigationItem.rightBarButtonItem =  [[UIBarButtonItem alloc] initWithCustomView:self.rightButton];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    [self updateData];
}

- (void)updateData
{
    self.pageSize = 20;
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [UMSCheckNetwork checkNetwork];
        
        [UMSSDK getFriendListWithUser:[UMSSDK currentUser]
                              pageNum:0
                             pageSize:weakSelf.pageSize
                               result:^(NSArray<UMSUser *> *userList, NSError *error)
         {
             weakSelf.userList = [NSMutableArray arrayWithArray:userList];
             
             [UMSSDK getInvitedFriendListWithUser:[UMSSDK currentUser]
                                           status:UMSDealWithRequestStatusPending
                                          pageNum:0
                                         pageSize:10000
                                           result:^(NSArray<UMSApplyAddFriendData *> *list, NSError *error) {
                                            
                                               if (error)
                                               {
                                                   weakSelf.friendCount = @"";
                                               }
                                               else
                                               {
                                                   NSInteger result = list.count;
                                                   if (result > 0)
                                                   {
                                                       weakSelf.friendCount = [NSString stringWithFormat:@"%zi",result];
                                                   }
                                                   else
                                                   {
                                                       weakSelf.friendCount = @"";
                                                   }
                                               }
                                               
                                               [weakSelf.tableView reloadData];
                                               [weakSelf.tableView.mj_header endRefreshing];
                                           }];
         }];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [UMSCheckNetwork checkNetwork];
        
        weakSelf.pageSize = weakSelf.pageSize + 20;
        
        [UMSSDK getFriendListWithUser:[UMSSDK currentUser]
                              pageNum:0
                             pageSize:weakSelf.pageSize
                               result:^(NSArray<UMSUser *> *userList, NSError *error)
         {
             if (weakSelf.pageSize > userList.count)
             {
                 [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
             }
             else
             {
                 [weakSelf.tableView.mj_footer endRefreshing];
             }
             
             weakSelf.userList = [NSMutableArray arrayWithArray:userList];
             [weakSelf.tableView reloadData];
         }];
    }];
}

-(void)rightItemClicked
{
    UMSSearchForUserViewController *search = [[UMSSearchForUserViewController alloc] init];
    [self.navigationController pushViewController:search animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 将导航条变透明
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = nil;
    
    [self updateData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 1;
            break;
        case 1:
            if (self.userList.count <= 0)
            {
                return 0;
            }
            return self.userList.count;
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *UMSUserListCellID = @"UMSUserListCell";
    UMSUserListCell *cell = [tableView dequeueReusableCellWithIdentifier:UMSUserListCellID];
    
    switch (indexPath.section)
    {
        case 0:
        {
            UMSMyFriendCell *cell = [[UMSMyFriendCell alloc] init];
            UMSAccessoryViewWithRedPoint *access;
            
            if (self.friendCount && ![self.friendCount isEqualToString:@""])
            {
                access = [[UMSAccessoryViewWithRedPoint alloc] initWithTitle:self.friendCount isShowRedPoint:YES];
            }
            else
            {
                access = [[UMSAccessoryViewWithRedPoint alloc] initWithTitle:self.friendCount isShowRedPoint:NO];
            }
            
            access.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 85, 50, 70, 50);
            cell.accessoryView = access;
            return cell;
        }
            break;
        case 1:
        {
            if (!cell)
            {
                cell = [[UMSUserListCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:UMSUserListCellID];
            }
            
            cell.userData = self.userList[indexPath.row];
            
            return cell;
        }
        default:
            return cell;
            break;
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0;
    }
    return 0.0f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 10.0f;
    }
    return 0.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

-(void)leftItemClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        UMSNewFriendViewController *newFriend = [[UMSNewFriendViewController alloc] init];
        [self.navigationController pushViewController:newFriend
                                             animated:YES];
    }
    else
    {
        UMSUserDetailInfoViewController *detail = [[UMSUserDetailInfoViewController alloc] initWithUser:self.userList[indexPath.row]];
        detail.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detail
                                             animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return NO;
    }
    
    return YES;
}

@end
