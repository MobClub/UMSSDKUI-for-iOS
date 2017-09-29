//
//  UMSRecentLoginUserListViewController.m
//  UMSSDKUI
//
//  Created by 刘靖煌 on 17/6/6.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import "UMSRecentLoginUserListViewController.h"
#import <UMSSDK/UMSSDK+Relationship.h>
#import "MJRefresh.h"
#import "UMSAlertView.h"
#import "UMSCheckNetwork.h"

@interface UMSRecentLoginUserListViewController ()

@property (nonatomic, assign) NSInteger pageSize;

@end

@implementation UMSRecentLoginUserListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.pageSize = 20;
    self.isShowLoginTime = YES;
    
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [UMSCheckNetwork checkNetwork];
        [UMSSDK getRecentLoginUserListWithPageNum:0
                                         pageSize:weakSelf.pageSize
                                           result:^(NSArray<UMSUser *> *friendList, NSError *error) {
                                               
                                               weakSelf.userList = [NSMutableArray arrayWithArray:friendList];
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
        [UMSSDK getRecentLoginUserListWithPageNum:0
                                         pageSize:weakSelf.pageSize
                                           result:^(NSArray<UMSUser *> *friendList, NSError *error) {
                                               
                                               if (weakSelf.pageSize > friendList.count)
                                               {
                                                   [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
                                               }
                                               else
                                               {
                                                   [weakSelf.tableView.mj_footer endRefreshing];
                                               }
                                               
                                               weakSelf.userList = [NSMutableArray arrayWithArray:friendList];
                                               [weakSelf.tableView reloadData];
                                           }];
    }];
}


@end
