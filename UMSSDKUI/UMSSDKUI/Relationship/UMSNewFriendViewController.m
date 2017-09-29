//
//  UMSNewFriendViewController.m
//  UMSSDKUI
//
//  Created by 刘靖煌 on 17/5/31.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import "UMSNewFriendViewController.h"
#import "UIBarButtonItem+UMS.h"
#import "UMSNewFriendCell.h"
#import <UMSSDK/UMSUser.h>
#import <UMSSDK/UMSSDK+Relationship.h>
#import <UMSSDK/UMSSDK.h>
#import "MJRefresh.h"
#import "UMSAlertView.h"
#import "UMSUserDetailInfoViewController.h"
#import "UMSCheckNetwork.h"

@interface UMSNewFriendViewController ()<IUMSNewFriendCellDelegate>

@property (nonatomic, strong) NSMutableArray *userList;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign) NSInteger selectedRow;

@end

@implementation UMSNewFriendViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UILabel *navTitle = [[UILabel alloc] init];
    navTitle.frame = CGRectMake(0, 0 , 35, 35);
    navTitle.text = @"新的好友";
    navTitle.font = [UIFont systemFontOfSize:16];
    self.navigationItem.titleView = navTitle;
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"return.png"
                                                                 highIcon:@"return.png"
                                                                   target:self
                                                                   action:@selector(leftItemClicked:)];
    
    self.pageSize = 20;
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [UMSCheckNetwork checkNetwork];
        [UMSSDK getInvitedFriendListWithUser:[UMSSDK currentUser]
                                      status:UMSDealWithRequestStatusAll
                                     pageNum:0
                                    pageSize:weakSelf.pageSize
                                      result:^(NSArray<UMSApplyAddFriendData *> *list, NSError *error) {
                                          
                                          weakSelf.userList = [NSMutableArray arrayWithArray:list];
                                          [weakSelf.tableView reloadData];
                                          [weakSelf.tableView.mj_header endRefreshing];
                                      }];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        weakSelf.pageSize = weakSelf.pageSize + 20;
        [UMSCheckNetwork checkNetwork];
        [UMSSDK getInvitedFriendListWithUser:[UMSSDK currentUser]
                                      status:UMSDealWithRequestStatusAll
                                     pageNum:0
                                    pageSize:weakSelf.pageSize
                                      result:^(NSArray<UMSApplyAddFriendData *> *list, NSError *error) {
                                          
                                          if (weakSelf.pageSize > list.count)
                                          {
                                              [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                                          }
                                          else
                                          {
                                              [weakSelf.tableView.mj_footer endRefreshing];
                                          }
                                          
                                          weakSelf.userList = [NSMutableArray arrayWithArray:list];
                                          [weakSelf.tableView reloadData];
                                      }];
    }];
}

- (void)refuseWithTag:(NSInteger)tag
{
    __block UMSApplyAddFriendData *data = self.userList[tag];

    [UMSSDK dealWithFriendRequestWithUser:data.user
                                    reply:UMSDealWithRequestStatusRefuse
                                   result:^(NSError *error) {
                                       
                                       if (error)
                                       {
                                           
                                           NSInteger status = [[[error userInfo] objectForKey:@"status"] integerValue];
                                           
                                           switch (status)
                                           {
                                               case 454:
                                               {
                                                   [UMSAlertView showAlertViewWithTitle:@"处理失败"
                                                                                message:@"用户为黑名单用户，不可添加对方为好友"
                                                                        leftActionTitle:@"好的"
                                                                       rightActionTitle:nil
                                                                         animationStyle:AlertViewAnimationZoom
                                                                           selectAction:nil];
                                               }
                                                   break;
                                               case 456:
                                               {
                                                   [UMSAlertView showAlertViewWithTitle:@"处理失败"
                                                                                message:@"已为好友关系，不能重复添加"
                                                                        leftActionTitle:@"好的"
                                                                       rightActionTitle:nil
                                                                         animationStyle:AlertViewAnimationZoom
                                                                           selectAction:nil];
                                               }
                                                   break;
                                               case 459:
                                               {
                                                   [UMSAlertView showAlertViewWithTitle:@"处理失败"
                                                                                message:@"待处理好友申请信息不存在"
                                                                        leftActionTitle:@"好的"
                                                                       rightActionTitle:nil
                                                                         animationStyle:AlertViewAnimationZoom
                                                                           selectAction:nil];
                                               }
                                                   break;
                                               case 467:
                                               {
                                                   [UMSAlertView showAlertViewWithTitle:@"处理失败"
                                                                                message:@"已经被拉黑不能关注和加对方为好友"
                                                                        leftActionTitle:@"好的"
                                                                       rightActionTitle:nil
                                                                         animationStyle:AlertViewAnimationZoom
                                                                           selectAction:nil];
                                               }
                                                   break;
                                               default:
                                                   [UMSAlertView showAlertViewWithTitle:@"处理失败"
                                                                                message:[error description]
                                                                        leftActionTitle:@"好的"
                                                                       rightActionTitle:nil
                                                                         animationStyle:AlertViewAnimationZoom
                                                                           selectAction:^(AlertViewActionType actionType) {
                                                                               
                                                                           }];
                                                   break;
                                           }
                                       }
                                       else
                                       {
                                           data.requestStatus = UMSDealWithRequestStatusRefuse;
                                           self.userList[tag] = data;
                                           [self.tableView reloadData];
                                       }
                                   }];
}

- (void)agreeWithTag:(NSInteger)tag
{
    __block UMSApplyAddFriendData *data = self.userList[tag];
    
    [UMSSDK dealWithFriendRequestWithUser:data.user
                                    reply:UMSDealWithRequestStatusAgree
                                   result:^(NSError *error) {
                                       
                                       if (error)
                                       {
                                           NSInteger status = [[[error userInfo] objectForKey:@"status"] integerValue];
                                           
                                           switch (status)
                                           {
                                               case 454:
                                               {
                                                   [UMSAlertView showAlertViewWithTitle:@"处理失败"
                                                                                message:@"用户为黑名单用户，不可添加对方为好友"
                                                                        leftActionTitle:@"好的"
                                                                       rightActionTitle:nil
                                                                         animationStyle:AlertViewAnimationZoom
                                                                           selectAction:nil];
                                               }
                                                   break;
                                               case 456:
                                               {
                                                   [UMSAlertView showAlertViewWithTitle:@"处理失败"
                                                                                message:@"已为好友关系，不能重复添加"
                                                                        leftActionTitle:@"好的"
                                                                       rightActionTitle:nil
                                                                         animationStyle:AlertViewAnimationZoom
                                                                           selectAction:nil];
                                               }
                                                   break;
                                               case 459:
                                               {
                                                   [UMSAlertView showAlertViewWithTitle:@"处理失败"
                                                                                message:@"待处理好友申请信息不存在"
                                                                        leftActionTitle:@"好的"
                                                                       rightActionTitle:nil
                                                                         animationStyle:AlertViewAnimationZoom
                                                                           selectAction:nil];
                                               }
                                                   break;
                                               case 467:
                                               {
                                                   [UMSAlertView showAlertViewWithTitle:@"处理失败"
                                                                                message:@"已经被拉黑不能关注和加对方为好友"
                                                                        leftActionTitle:@"好的"
                                                                       rightActionTitle:nil
                                                                         animationStyle:AlertViewAnimationZoom
                                                                           selectAction:nil];
                                               }
                                                   break;
                                               default:
                                                   [UMSAlertView showAlertViewWithTitle:@"处理失败"
                                                                                message:[error description]
                                                                        leftActionTitle:@"好的"
                                                                       rightActionTitle:nil
                                                                         animationStyle:AlertViewAnimationZoom
                                                                           selectAction:^(AlertViewActionType actionType) {
                                                                               
                                                                           }];
                                                   break;
                                           }
                                       }
                                       else
                                       {
                                           data.requestStatus = UMSDealWithRequestStatusAgree;
                                           self.userList[tag] = data;
                                           [self.tableView reloadData];
                                       }
                                   }];
}

- (void)leftItemClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 将导航条变透明
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.userList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *UMSUserListCellID = @"UMSNewFriendCell";
    UMSNewFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:UMSUserListCellID];

    if (!cell)
    {
        cell = [[UMSNewFriendCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:UMSUserListCellID];
    }
    self.selectedRow = indexPath.row;
    cell.dataModel = self.userList[indexPath.row];
    cell.delegate = self;
    cell.tag = self.selectedRow;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UMSApplyAddFriendData *selectedData = self.userList[indexPath.row];
    UMSUserDetailInfoViewController *detail = [[UMSUserDetailInfoViewController alloc] initWithUser:selectedData.user];
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail
                                         animated:YES];
}


@end
