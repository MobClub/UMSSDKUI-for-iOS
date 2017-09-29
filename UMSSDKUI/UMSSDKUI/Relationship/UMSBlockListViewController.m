//
//  UMSBlockListViewController.m
//  UMSSDKUI
//
//  Created by 刘靖煌 on 17/6/9.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import "UMSBlockListViewController.h"
#import <UMSSDK/UMSSDK+Relationship.h>
#import "MJRefresh.h"
#import "UMSAlertView.h"
#import "UMSUserListWithAccessoryViewCell.h"
#import "UMSCheckNetwork.h"

@interface UMSBlockListViewController ()<IUMSUserListWithAccessoryViewCellDelegate>

@property (nonatomic, assign) NSInteger pageSize;

@end

@implementation UMSBlockListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.pageSize = 20;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [UMSCheckNetwork checkNetwork];
        [UMSSDK getBlockedUserListWithUser:[UMSSDK currentUser]
                                   pageNum:0
                                  pageSize:weakSelf.pageSize
                                    result:^(NSArray<UMSUser *> *userList, NSError *error) {
                                        
                                        weakSelf.userList = [NSMutableArray arrayWithArray:userList];
                                        [weakSelf.tableView reloadData];
                                        
                                        [weakSelf.tableView.mj_header endRefreshing];
                                    }];
        
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [UMSCheckNetwork checkNetwork];
        weakSelf.pageSize = weakSelf.pageSize + 20;
        
        [UMSSDK getBlockedUserListWithUser:[UMSSDK currentUser]
                                   pageNum:0
                                  pageSize:weakSelf.pageSize
                                    result:^(NSArray<UMSUser *> *userList, NSError *error) {
                                        
                                        if (weakSelf.pageSize > userList.count)
                                        {
                                            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                                        }
                                        else
                                        {
                                            [weakSelf.tableView.mj_footer endRefreshing];
                                        }
                                        
                                        weakSelf.userList = [NSMutableArray arrayWithArray:userList];;
                                        [weakSelf.tableView reloadData];

                                    }];
        }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *UMSUserListCellID = @"UMSUserListWithAccessoryViewCell";
    UMSUserListWithAccessoryViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UMSUserListCellID];
    
    if (!cell)
    {
        cell = [[UMSUserListWithAccessoryViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:UMSUserListCellID];
    }

    cell.delegate = self;
    cell.tag = indexPath.row;
    cell.userData = self.userList[indexPath.row];
    [cell.accessoryViewer setTitle:@"解除黑名单" forState:UIControlStateNormal];
    
    return cell;
}

- (void)accessoryViewClickedWithTag:(NSInteger)tag
{
    [UMSSDK removeFromBlockedUserListWithUser:self.userList[tag]
                                       result:^(NSError *error) {
                                           
                                           if (error)
                                           {
                                               [UMSAlertView showAlertViewWithTitle:@"解除失败"
                                                                            message:[error description]
                                                                    leftActionTitle:@"好的"
                                                                   rightActionTitle:nil
                                                                     animationStyle:AlertViewAnimationNone
                                                                           delegate:nil];
                                           }
                                           else
                                           {
                                               [UMSAlertView showAlertViewWithTitle:nil
                                                                            message:@"解除黑名单成功"
                                                                    leftActionTitle:@"好的"
                                                                   rightActionTitle:nil
                                                                     animationStyle:AlertViewAnimationZoom
                                                                       selectAction:^(AlertViewActionType actionType) {
                                                                           
                                                                           [self.userList removeObjectAtIndex:tag];
                                                                           [self.tableView reloadData];
                                                                       }];
                                           }
                                       }];
}

@end
