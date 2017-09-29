//
//  UMSFansRelationshipListViewController.m
//  UMSSDKUI
//
//  Created by 刘靖煌 on 17/6/9.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import "UMSFansRelationshipListViewController.h"
#import "MJRefresh.h"
#import "UMSAlertView.h"
#import "UMSCheckNetwork.h"

@interface UMSFansRelationshipListViewController ()

@property (nonatomic, assign) NSInteger pageSize;

@end

@implementation UMSFansRelationshipListViewController

- (instancetype)initWithUser:(UMSUser *)user Relationship:(UMSRelationship)relationship
{
    self = [super init];
    if (self)
    {
        _relationship = relationship;
        _user = user;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.pageSize = 20;
    __weak typeof(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [UMSCheckNetwork checkNetwork];
        [UMSSDK getFansListWithUser:_user
                       relationship:_relationship
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
        
        [UMSSDK getFansListWithUser:_user
                       relationship:_relationship
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
                                 
                                 weakSelf.userList = [NSMutableArray arrayWithArray:userList];
                                 [weakSelf.tableView reloadData];
                             }];
    }];
}



@end
