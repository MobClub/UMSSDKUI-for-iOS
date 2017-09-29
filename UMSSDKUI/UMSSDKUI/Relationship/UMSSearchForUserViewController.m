//
//  UMSSearchForUserViewController.m
//  UMSSDKUI
//
//  Created by 刘靖煌 on 17/5/31.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import "UMSSearchForUserViewController.h"
#import "UIBarButtonItem+UMS.h"
#import "UMSUserListWithAccessoryViewCell.h"
#import "UMSAddFriendAlertView.h"
#import <UMSSDK/UMSSDK+Relationship.h>
#import <UMSSDK/UMSSDK.h>
#import "MJRefresh.h"
#import "UMSAlertView.h"
#import "UMSUserDetailInfoViewController.h"
#import "UMSCheckNetwork.h"

@interface UMSSearchForUserViewController ()<UISearchBarDelegate,IUMSUserListWithAccessoryViewCellDelegate,IUMSAddFriendAlertViewDelegate>

@property (nonatomic, strong) UISearchBar *searchbar;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) NSMutableArray *userList;
@property (nonatomic, strong) UMSAddFriendAlertView *alert;
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, strong) NSMutableArray *friendIDList;
@property (nonatomic, strong) UILabel *warningLabel;
@property (nonatomic, assign) BOOL isFirstLoad;

@end

@implementation UMSSearchForUserViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.hidesBackButton = YES;
    
    self.searchbar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width-40*2,44)];
    self.searchbar.placeholder = @"搜索ID/昵称/手机号";
    self.searchbar.searchBarStyle = UISearchBarStyleProminent;
    self.searchbar.delegate = self;
    self.searchbar.barTintColor = [UIColor whiteColor];
    self.searchbar.returnKeyType = UIReturnKeySearch;
    self.searchbar.enablesReturnKeyAutomatically = YES;
    
    self.navigationItem.titleView =self.searchbar;
    
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.cancelButton setTitle:@"取消"forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.cancelButton addTarget:self action:@selector(cancelSearch:)forControlEvents:UIControlEventTouchUpInside];
    [self.cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.cancelButton.frame = CGRectMake(0, 0, 35, 35);
    UIBarButtonItem *rigth = [[UIBarButtonItem alloc]initWithCustomView:self.cancelButton];
    self.navigationItem.rightBarButtonItem = rigth;
    
    self.warningLabel = [[UILabel alloc] init];
    self.warningLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 100,150, 200, 35);
    self.warningLabel.font = [UIFont systemFontOfSize:15];
    self.warningLabel.textColor = [UIColor grayColor];
    self.warningLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.warningLabel];
    
    self.isFirstLoad = YES;
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [UMSSDK getFriendListWithUser:[UMSSDK currentUser]
                          pageNum:0
                         pageSize:1000000
                           result:^(NSArray<UMSUser *> *userList, NSError *error)
    {
        NSMutableArray *array = [NSMutableArray array];
        
        for (UMSUser *user in userList)
        {
            [array addObject:user.uid];
        }
        
        [array addObject:[UMSSDK currentUser].uid];
        
        self.friendIDList = array;
    }];
}

- (void)searchBarSearchButtonClicked:(UISearchBar*)searchBar
{
    if (self.searchbar.text && ![self.searchbar.text isEqualToString:@""])
    {
        //防止快速点击搜索时，结果页面下移
        if (self.isFirstLoad)
        {
            self.pageSize = 500;
            self.userList = [NSMutableArray array];
            __weak typeof(self) weakSelf = self;
            MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                [UMSCheckNetwork checkNetwork];
                [UMSSDK searchForUserWithKey:weakSelf.searchbar.text
                                     pageNum:0
                                    pageSize:weakSelf.pageSize
                                      result:^(NSArray<UMSUser *> *userList, NSError *error) {
                                          
                                          if (userList.count <= 0)
                                          {
                                              weakSelf.warningLabel.hidden = NO;
                                              weakSelf.userList = [NSMutableArray array];
                                              [weakSelf.tableView reloadData];
                                              weakSelf.warningLabel.text = @"没有找到相关用户，请重试。";
                                          }
                                          else
                                          {
                                              weakSelf.warningLabel.hidden = YES;
                                              weakSelf.userList = [NSMutableArray arrayWithArray:userList];
                                              [weakSelf.tableView reloadData];
                                          }
                                          
                                          [weakSelf.tableView.mj_header endRefreshing];
                                          weakSelf.isFirstLoad = YES;
                                      }];
                
            }];
            header.lastUpdatedTimeLabel.hidden = YES;
            self.tableView.mj_header = header;
            [self.tableView.mj_header beginRefreshing];
            
            self.isFirstLoad = NO;
        }
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (searchBar.text.length == 0)
    {
        self.userList = [NSMutableArray array];
        [self.tableView reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [_userList count];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 将导航条变透明
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = nil;
}

- (void)leftItemClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancelSearch:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *UMSUserListCellID = @"UMSUserListWithAccessoryViewCell";
    UMSUserListWithAccessoryViewCell *cell = [tableView dequeueReusableCellWithIdentifier:UMSUserListCellID];

    if (!cell)
    {
        cell = [[UMSUserListWithAccessoryViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:UMSUserListCellID];
    }
    
    if (self.userList.count > 0)
    {
        UMSUser *user = self.userList[indexPath.row];
        cell.userData = user;
        cell.delegate = self;
        cell.tag = indexPath.row;
        
        if ([self.friendIDList containsObject:user.uid])
        {
            cell.accessoryViewer.hidden = YES;
        }
        else
        {
            cell.accessoryViewer.hidden = NO;
            [cell.accessoryViewer setTitle:@"加为好友" forState:UIControlStateNormal];
        }
    }
    
    return cell;
}

-(void)accessoryViewClickedWithTag:(NSInteger)tag
{
    _tag = tag;
    
    self.alert = [[UMSAddFriendAlertView alloc] initWithUser:self.userList[tag]];
    self.alert.delegate = self;
    [self.alert show];
}

- (void)addFriendClicked
{
    [UMSSDK addFriendRequestWithUser:self.userList[_tag]
                             message:self.alert.addFriendView.message.text
                              result:^(NSError *error) {
                                  
                                  if (error)
                                  {
                                      NSInteger status = [[[error userInfo] objectForKey:@"status"] integerValue];
                                      
                                      switch (status)
                                      {
                                          case 454:
                                          {
                                              [UMSAlertView showAlertViewWithTitle:@"添加失败"
                                                                           message:@"用户为黑名单用户，不可添加对方为好友"
                                                                   leftActionTitle:@"好的"
                                                                  rightActionTitle:nil
                                                                    animationStyle:AlertViewAnimationZoom
                                                                      selectAction:nil];
                                          }
                                              break;
                                          case 455:
                                          {
                                              [UMSAlertView showAlertViewWithTitle:@"添加失败"
                                                                           message:@"用户已经在黑名单中"
                                                                   leftActionTitle:@"好的"
                                                                  rightActionTitle:nil
                                                                    animationStyle:AlertViewAnimationZoom
                                                                      selectAction:nil];
                                          }
                                              break;
                                          case 456:
                                          {
                                              [UMSAlertView showAlertViewWithTitle:nil
                                                                           message:@"双方已是好友关系"
                                                                   leftActionTitle:@"好的"
                                                                  rightActionTitle:nil
                                                                    animationStyle:AlertViewAnimationZoom
                                                                      selectAction:nil];
                                          }
                                              break;
                                          case 467:
                                          {
                                              [UMSAlertView showAlertViewWithTitle:@"添加失败"
                                                                           message:@"对方将你拉为黑名单"
                                                                   leftActionTitle:@"好的"
                                                                  rightActionTitle:nil
                                                                    animationStyle:AlertViewAnimationZoom
                                                                      selectAction:nil];
                                          }
                                              break;
                                          case 458:
                                          {
                                              [UMSAlertView showAlertViewWithTitle:@"添加失败"
                                                                           message:@"不可以添加自己为好友"
                                                                   leftActionTitle:@"好的"
                                                                  rightActionTitle:nil
                                                                    animationStyle:AlertViewAnimationZoom
                                                                      selectAction:nil];
                                          }
                                              break;
                                          default:
                                              [UMSAlertView showAlertViewWithTitle:@"添加失败"
                                                                           message:[error description]
                                                                   leftActionTitle:@"好的"
                                                                  rightActionTitle:nil
                                                                    animationStyle:AlertViewAnimationZoom
                                                                      selectAction:nil];
                                              break;
                                      }
                                  }
                                  else
                                  {
                                      [UMSAlertView showAlertViewWithTitle:@"已发送，等待对方同意"
                                                                   message:nil
                                                           leftActionTitle:@"好的"
                                                          rightActionTitle:nil
                                                            animationStyle:AlertViewAnimationZoom
                                                              selectAction:nil];
                                  }
                              }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //解决因键盘引起的动画脱页问题
    [self.searchbar resignFirstResponder];
    
    UMSUserDetailInfoViewController *detail = [[UMSUserDetailInfoViewController alloc] initWithUser:self.userList[indexPath.row]];
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail
                                         animated:YES];
}


@end
