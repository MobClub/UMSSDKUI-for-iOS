//
//  UMSProfileViewController.m
//  UMSSDKUI
//
//  Created by 刘靖煌 on 17/2/26.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import "UMSProfileViewController.h"
#import "UMSUserInfoViewController.h"
#import "UMSBaseNavigationController.h"
#import "UMSSettingViewController.h"
#import "UMSImage.h"
#import "UMSAccessoryView.h"
#import "UMSAccessoryViewWithRedPoint.h"
#import <UMSSDK/UMSSDK.h>
#import "UMSPickerViewController.h"
#import "UMSProfileHeaderView.h"
#import "UMSAlertView.h"
#import <UMSSDK/UMSBindingData.h>
#import "UMSLoginViewController.h"
#import "UMSFansRelationshipListViewController.h"
#import "UMSMyFriendViewController.h"
#import "UMSLoginModuleViewController.h"
#import "UIBarButtonItem+UMS.h"
#import "UMSAlertView.h"
#import <objc/message.h>
#import "MJRefresh.h"
#import "UMSCheckNetwork.h"

@interface UMSProfileViewController ()<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate, UIPopoverControllerDelegate,IUMSProfileHeaderViewDelegate>

@property (nonatomic, strong) UMSProfileHeaderView *headerView;
@property (nonatomic, strong) UIPopoverController *imagePickerPopover;
@property (nonatomic, strong) UIImage *avatarImage;
@property (nonatomic, strong) UIButton *rightButton;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@property (nonatomic, assign) BOOL isBindingPhone;
@property (nonatomic, strong) UMSLoginModuleViewController *login;
@property (nonatomic, assign) BOOL isShowRedPoint;
@property (nonatomic, assign) BOOL firstLoad;
@property (nonatomic, assign) BOOL isAllowLoading;

@end

@implementation UMSProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];

    self.headerView = [[UMSProfileHeaderView alloc] init];
    self.headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, 250);
    self.headerView.backgroundColor = [UIColor colorWithRed:227/255.0 green:81/255.0 blue:78/255.0 alpha:1.0];
    self.headerView.delegate = self;
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithIcon:@"sz.png"
                                                                  highIcon:@"sz.png"
                                                                    target:self
                                                                    action:@selector(rightItemClicked)];
    
    
    self.navigationItem.hidesBackButton = YES;
    self.firstLoad = YES;
    
    UILabel *navTitle = [[UILabel alloc] init];
    self.navigationItem.titleView = navTitle;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0)
    {
        void (*objc_msgSendTyped)(id self, SEL _cmd,float type) = (void*)objc_msgSend;
        objc_msgSendTyped(self.tableView, @selector(setContentInsetAdjustmentBehavior:), 2);
    }
    
    if (self.leftBarButtonItem)
    {
        self.navigationItem.leftBarButtonItem = self.leftBarButtonItem;
    }
    
    if (self.rightBarButtonItem)
    {
        self.navigationItem.rightBarButtonItem = self.rightBarButtonItem;
    }
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.isAllowLoading = YES;
    
    [self requestData];
}

- (void)requestData
{
    self.tableView.scrollEnabled = YES;
    
    if (self.isAllowLoading)
    {
        __weak typeof(self) weakSelf = self;
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            
            dispatch_group_t group = dispatch_group_create();
            dispatch_queue_t queue = dispatch_queue_create("UMSProfileViewRequestQueue", DISPATCH_QUEUE_SERIAL);
            
            dispatch_group_enter(group);
            dispatch_group_async(group, queue, ^{
                
                [UMSSDK getUserInfoWithResult:^(UMSUser *user, NSError *error){
                    
                    dispatch_group_leave(group);
                    
                }];
            });
            
            dispatch_group_enter(group);
            dispatch_group_async(group, queue, ^{
                
                [UMSSDK getBindingDataWithResult:^(NSArray<UMSBindingData *> *list, NSError *error) {
                    
                    if (!error)
                    {
                        weakSelf.isBindingPhone = NO;
                        
                        for (UMSBindingData *bindingData in list)
                        {
                            if (bindingData.bindType == UMSPlatformTypePhone)
                            {
                                weakSelf.isBindingPhone = YES;
                            }
                        }
                    }
                    
                    dispatch_group_leave(group);
                }];
            });
            
            dispatch_group_enter(group);
            dispatch_group_async(group, queue, ^{
                
                [UMSSDK getInvitedFriendListWithUser:[UMSSDK currentUser]
                                              status:UMSDealWithRequestStatusPending
                                             pageNum:0
                                            pageSize:10000
                                              result:^(NSArray<UMSApplyAddFriendData *> *list, NSError *error) {
                                                  
                                                  if (list.count > 0)
                                                  {
                                                      weakSelf.isShowRedPoint = YES;
                                                  }
                                                  else
                                                  {
                                                      weakSelf.isShowRedPoint = NO;
                                                  }
                                                  
                                                  dispatch_group_leave(group);
                                              }];
            });
            
            dispatch_group_notify(group, queue, ^{
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //获取当前用户信息
                    UMSUser *currentUser = [UMSSDK currentUser];
                    
                    if (currentUser)
                    {
                        weakSelf.headerView.userModel = currentUser;
                    }
                    else
                    {
                        weakSelf.headerView.userModel = nil;
                    }
                    
                    [weakSelf.tableView reloadData];
                    [weakSelf.tableView.mj_header endRefreshing];
                    [UMSCheckNetwork checkNetwork];
                    
                    self.isAllowLoading = YES;
                });
            });
        }];
        
        header.lastUpdatedTimeLabel.hidden = YES;
        self.tableView.mj_header = header;
        [self.tableView.mj_header beginRefreshing];
        
        self.isAllowLoading = NO;
    }
}

- (void)followItemClicked
{
    if ([UMSSDK currentUser])
    {
        UMSFansRelationshipListViewController *userList = [[UMSFansRelationshipListViewController alloc] initWithUser:[UMSSDK currentUser]
                                                                                                         Relationship:UMSRelationshipFollow];
        userList.navTitle = @"我的关注";
        userList.isHiddleLeftBarButtonItem = NO;
        userList.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:userList
                                             animated:YES];
    }
    else
    {
        [self LoginAction];
    }
}

- (void)LoginAction
{
    _login = [[UMSLoginModuleViewController alloc] init];
    __weak typeof(self) weakSelf = self;
    [self presentViewController:_login
                       animated:YES
                     completion:nil];
    
    _login.loginVC.loginHandler = ^(NSError *error){
        
        if (error)
        {
            NSInteger status = [[[error userInfo] objectForKey:@"status"] integerValue];
            NSInteger errorCode = error.code;
            
            if (status == 422)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [UMSAlertView showAlertViewWithTitle:@"登录失败"
                                                 message:@"账号或密码错误"
                                         leftActionTitle:@"好的"
                                        rightActionTitle:nil
                                          animationStyle:AlertViewAnimationZoom
                                            selectAction:nil];
                });
            }
            else if(errorCode == 600002)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [UMSAlertView showAlertViewWithTitle:@"已取消登录"
                                                 message:nil
                                         leftActionTitle:@"好的"
                                        rightActionTitle:nil
                                          animationStyle:AlertViewAnimationZoom
                                            selectAction:nil];
                });
            }
            else if (errorCode == -1009)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [UMSAlertView showAlertViewWithTitle:@"登录失败"
                                                 message:@"无网络，请连接网络"
                                         leftActionTitle:@"好的"
                                        rightActionTitle:nil
                                          animationStyle:AlertViewAnimationZoom
                                            selectAction:nil];
                });
            }
            else
            {
                [UMSAlertView showAlertViewWithTitle:@"登录失败"
                                             message:[error description]
                                     leftActionTitle:@"好的"
                                    rightActionTitle:nil
                                      animationStyle:AlertViewAnimationZoom
                                        selectAction:nil];
            }
        }
        else
        {
            [weakSelf.login close];
        }
    };
}

- (void)fansItemClicked
{
    if ([UMSSDK currentUser])
    {
        UMSFansRelationshipListViewController *userList = [[UMSFansRelationshipListViewController alloc] initWithUser:[UMSSDK currentUser] Relationship:UMSRelationshipFans];
        userList.navTitle = @"我的粉丝";
        userList.isHiddleLeftBarButtonItem = NO;
        userList.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:userList
                                             animated:YES];
    }
    else
    {
        [self LoginAction];
    }
}

- (void)coFollowItemClicked
{
    if ([UMSSDK currentUser])
    {
        UMSFansRelationshipListViewController *userList = [[UMSFansRelationshipListViewController alloc] initWithUser:[UMSSDK currentUser] Relationship:UMSRelationshipCoFollow];
        userList.navTitle = @"相互关注";
        userList.isHiddleLeftBarButtonItem = NO;
        userList.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:userList
                                             animated:YES];
    }
    else
    {
        [self LoginAction];
    }
}

- (void)avatarItemClicked
{
    if (![UMSSDK currentUser])
    {
        [self LoginAction];
    }
}

- (void)clickToLogin
{
    if (![UMSSDK currentUser])
    {
        [self LoginAction];
    }
}

- (UIActivityIndicatorView *)activityIndicator
{
    if (!_activityIndicator)
    {
        //添加 UIActivityIndicatorView
        _activityIndicator = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, 100, 85)];
        _activityIndicator.center = self.view.center;
        _activityIndicator.layer.cornerRadius = 10;
        _activityIndicator.layer.masksToBounds = YES;
        [_activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
        [_activityIndicator setBackgroundColor:[UIColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:0.9]];
        [_activityIndicator setHidesWhenStopped:YES];
        [self.view addSubview:_activityIndicator];
    }
    return _activityIndicator;
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (self.firstLoad)
    {
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.firstLoad = NO;
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 将导航条变透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    //获取当前用户信息
    UMSUser *currentUser = [UMSSDK currentUser];
    
    if (currentUser)
    {
        self.headerView.userModel = currentUser;
        
        [self requestData];
    }
    else
    {
        self.headerView.userModel = nil;
    }
    
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 0;
            break;
        case 1:
            return 1;
            break;
        case 2:
            return 1;
            break;
        default:
            break;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.创建cell
    static NSString *ID = @"UMSProfileCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.selectionStyle =UITableViewCellSelectionStyleNone;
    }

    if (indexPath.section == 1)
    {
        switch (indexPath.row)
        {
            case 0:
            {
                // 2.设置cell的数据
                cell.textLabel.text = @"我的好友";
                
                UMSUser *currentUser = [UMSSDK currentUser];
                
                if (currentUser.friendCount)
                {
                    UMSAccessoryViewWithRedPoint *temText = [[UMSAccessoryViewWithRedPoint alloc] initWithTitle:[NSString stringWithFormat:@"%zi",currentUser.friendCount] isShowRedPoint:self.isShowRedPoint];
                    temText.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 85, 50, 70, 50);
                    cell.accessoryView = temText;
                }
                else
                {
                    UMSAccessoryViewWithRedPoint *temText = [[UMSAccessoryViewWithRedPoint alloc] initWithTitle:[NSString stringWithFormat:@"%zi",0] isShowRedPoint:self.isShowRedPoint];
                    temText.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 85, 50, 70, 50);
                    cell.accessoryView = temText;
                }
            }
                break;
            default:
                break;
        }
    }
    else if (indexPath.section == 2)
    {
        switch (indexPath.row)
        {
            case 0:
            {
                // 2.设置cell的数据
                cell.textLabel.text = @"个人资料";
                
                UMSAccessoryView *temText = [[UMSAccessoryView alloc] initWithTitle:@"13"];
                temText.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 85, 50, 70, 50);
                cell.accessoryView = temText;
            }
                break;
            default:
                break;
        }
    }

    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return self.headerView;
            break;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 250;
            break;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0 || section==1)
    {
        return 10.0f;
    }
    return 0.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section)
    {
        case 1:
        {
            if ([UMSSDK currentUser])
            {
                UMSMyFriendViewController *newFriend = [[UMSMyFriendViewController alloc] initWithStyle:UITableViewStylePlain];
                newFriend.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:newFriend animated:YES];
            }
            else
            {
                [self LoginAction];
            }
        }
            break;
        case 2:
        {
            if ([UMSSDK currentUser])
            {
                UMSUserInfoViewController *userInfo = [[UMSUserInfoViewController alloc] init];
                userInfo.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:userInfo animated:YES];
            }
            else
            {
                [self LoginAction];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)rightItemClicked
{
    if ([UMSSDK currentUser])
    {
        UMSSettingViewController *setting = [[UMSSettingViewController alloc] initWithStyle:UITableViewStyleGrouped];
        setting.isBindingPhone = self.isBindingPhone;
        setting.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:setting animated:YES];
    }
    else
    {
        [self LoginAction];
    }
}

@end
