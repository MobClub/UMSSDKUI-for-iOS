//
//  UMSUserDetailInfoViewController.m
//  UMSSDKUI
//
//  Created by 刘靖煌 on 17/5/29.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import "UMSUserDetailInfoViewController.h"
#import "UMSProfileHeaderView.h"
#import "UIBarButtonItem+UMS.h"
#import "UMSUserDetailInfoFooterView.h"
#import "UMSUserDetailViewCell.h"
#import "UMSUserDetailAdaptViewCell.h"
#import "UMSUserDetailAccountBindingViewCell.h"
#import <MOBFoundation/MOBFoundation.h>
#import <UMSSDK/UMSSDK+Relationship.h>
#import <UMSSDK/UMSSDK.h>
#import "UMSFansRelationshipListViewController.h"
#import "UMSAlertView.h"
#import "UMSLoginModuleViewController.h"
#import "UMSAddFriendAlertView.h"
#import <objc/message.h>

@interface UMSUserDetailInfoViewController ()<IUMSProfileHeaderViewDelegate,IUMSUserDetailInfoFooterViewDelegate,IUMSAddFriendAlertViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UMSProfileHeaderView *headerView;
@property (nonatomic, strong) UMSUserDetailInfoFooterView *footerView;
@property (nonatomic, strong) UMSUser *selectedUser;
@property (nonatomic, strong) UMSLoginModuleViewController *login;
@property (nonatomic, strong) UMSAddFriendAlertView *addFriendAlert;
@property (nonatomic, strong) UMSUserDetailAdaptViewCell *signCell;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation UMSUserDetailInfoViewController

- (instancetype)initWithUser:(UMSUser *)userModel
{
    self = [super init];
    if (self)
    {
        _selectedUser = userModel;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    
    if ([UIScreen mainScreen].bounds.size.height == 812)
    {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 250, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 300 - 34) style:UITableViewStylePlain];
    }
    else
    {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 250, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 300) style:UITableViewStylePlain];
    }
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.headerView = [[UMSProfileHeaderView alloc] init];
    self.headerView.frame = CGRectMake(0, 0, self.view.frame.size.width, 250);
    self.headerView.backgroundColor = [UIColor colorWithRed:227/255.0 green:81/255.0 blue:78/255.0 alpha:1.0];
    self.headerView.delegate = self;
    [self.view addSubview:self.headerView];
    
    self.footerView = [[UMSUserDetailInfoFooterView alloc] init];
    
    if ([UIScreen mainScreen].bounds.size.height == 812)
    {
        self.footerView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 50 - 34, self.view.frame.size.width, 50);
    }
    else
    {
        self.footerView.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 50, self.view.frame.size.width, 50);
    }
    
    self.footerView.delegate = self;
    self.footerView.footerViewModel = [[UMSUserDetailInfoFooterViewModel alloc] init];
    [self.view addSubview:self.footerView];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.0)
    {
        void (*objc_msgSendTyped)(id self, SEL _cmd,float type) = (void*)objc_msgSend;
        objc_msgSendTyped(self.tableView, @selector(setContentInsetAdjustmentBehavior:), 2);
    }
    
    if ([UMSSDK currentUser])
    {
        [self setupFooterView];
    }
    
    UILabel *navTitle = [[UILabel alloc] init];
    self.navigationItem.titleView = navTitle;
    
    // 左边按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"return_white.png"
                                                                 highIcon:@"return_white.png"
                                                                   target:self
                                                                   action:@selector(leftItemClicked:)];
    
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setLayoutMargins:UIEdgeInsetsZero];
}

- (void)setupFooterView
{
    [self setupFriendView];
    [self setupFansView];
    [self setupBlockView];
}

- (void)setupFansView
{
    [[UMSSDK currentUser] fetchFansRelationshipWithUser:_selectedUser
                                                 result:^(UMSUser *user, NSError *error) {
                                                     
                                                     if (user.fansRelationship == UMSRelationshipFollow || user.fansRelationship == UMSRelationshipCoFollow)
                                                     {
                                                         UMSUserDetailInfoFooterViewModel *model = self.footerView.footerViewModel;
                                                         
                                                         model.isFollow = YES;
                                                         self.footerView.footerViewModel = model;
                                                     }
                                                     else
                                                     {
                                                         UMSUserDetailInfoFooterViewModel *model = self.footerView.footerViewModel;
                                                         
                                                         model.isFollow = NO;
                                                         self.footerView.footerViewModel = model;
                                                     }
                                                 }];
}

- (void)setupFriendView
{
    [[UMSSDK currentUser] fetchFriendRelationshipWithUser:_selectedUser
                                                   result:^(UMSUser *user, NSError *error) {
                                                       
                                                       if (user.isFriend)
                                                       {
                                                           UMSUserDetailInfoFooterViewModel *model = self.footerView.footerViewModel;
                                                           
                                                           model.isFriend = YES;
                                                           self.footerView.footerViewModel = model;
                                                       }
                                                       else
                                                       {
                                                           UMSUserDetailInfoFooterViewModel *model = self.footerView.footerViewModel;
                                                           
                                                           model.isFriend = NO;
                                                           self.footerView.footerViewModel = model;
                                                       }
                                                   }];
}

- (void)setupBlockView
{
    [[UMSSDK currentUser] fetchBlockRelationshipWithUser:_selectedUser
                                                  result:^(UMSUser *user, NSError *error) {
                                                      
                                                      if (user.isBlock)
                                                      {
                                                          UMSUserDetailInfoFooterViewModel *model = self.footerView.footerViewModel;
                                                          
                                                          model.isBlock = YES;
                                                          self.footerView.footerViewModel = model;
                                                      }
                                                      else
                                                      {
                                                          UMSUserDetailInfoFooterViewModel *model = self.footerView.footerViewModel;
                                                          
                                                          model.isBlock = NO;
                                                          self.footerView.footerViewModel = model;
                                                      }
                                                  }];
}

- (void)followItemClicked
{
    UMSFansRelationshipListViewController *userList = [[UMSFansRelationshipListViewController alloc] initWithUser:_selectedUser
                                                                                                     Relationship:UMSRelationshipFollow];
    userList.navTitle = @"我的关注";
    userList.isHiddleLeftBarButtonItem = NO;
    
    [self.navigationController pushViewController:userList
                                         animated:YES];
}

- (void)fansItemClicked
{
    UMSFansRelationshipListViewController *userList = [[UMSFansRelationshipListViewController alloc] initWithUser:_selectedUser
                                                                                                     Relationship:UMSRelationshipFans];
    userList.navTitle = @"我的粉丝";
    userList.isHiddleLeftBarButtonItem = NO;
    
    [self.navigationController pushViewController:userList
                                         animated:YES];
}

- (void)coFollowItemClicked
{
    UMSFansRelationshipListViewController *userList = [[UMSFansRelationshipListViewController alloc] initWithUser:_selectedUser
                                                                                                     Relationship:UMSRelationshipCoFollow];
    userList.navTitle = @"相互关注";
    userList.isHiddleLeftBarButtonItem = NO;
    
    [self.navigationController pushViewController:userList
                                         animated:YES];
}

- (void)leftItemClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 将导航条变透明
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    self.headerView.userModel = _selectedUser;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.创建cell
    static NSString *ID = @"UMSUserDetailCell";
    UMSUserDetailViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell)
    {
        cell = [[UMSUserDetailViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.row)
    {
        case 0:
        {
            // 2.设置cell的数据
            cell.keyLabel.text = @"出生日期";
            
            if (_selectedUser.birthday)
            {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                dateFormatter.dateFormat = @"yyyy-MM-dd";
                NSString *dateStr = [dateFormatter stringFromDate:_selectedUser.birthday];
                
                cell.valueLabel.text = dateStr;
            }
            else
            {
                cell.valueLabel.text = @"未填写";
            }
        }
            break;
        case 1:
        {
            cell.keyLabel.text = @"年龄";
            
            if ([_selectedUser.age integerValue] > 0)
            {
                cell.valueLabel.text = [NSString stringWithFormat:@"%zi",[_selectedUser.age integerValue]];
            }
            else
            {
                cell.valueLabel.text = @"未填写";
            }
        }
            break;
        case 2:
        {
            cell.keyLabel.text = @"星座";
            
            if (_selectedUser.constellation)
            {
                cell.valueLabel.text = _selectedUser.constellation.name;
            }
            else
            {
                cell.valueLabel.text = @"未填写";
            }
        }
            break;
        case 3:
        {
            cell.keyLabel.text = @"生肖";
            
            if (_selectedUser.zodiac)
            {
                cell.valueLabel.text = _selectedUser.zodiac.name;
            }
            else
            {
                cell.valueLabel.text = @"未填写";
            }
        }
            break;
        case 4:
        {
            cell.keyLabel.text = @"电子邮件";
            
            if (_selectedUser.email)
            {
                cell.valueLabel.text = _selectedUser.email;
            }
            else
            {
                cell.valueLabel.text = @"未填写";
            }
        }
            break;
        case 5:
        {
            cell.keyLabel.text = @"地址";
            
            if (_selectedUser.address)
            {
                cell.valueLabel.text = _selectedUser.address;
            }
            else
            {
                cell.valueLabel.text = @"未填写";
            }
        }
            break;
        case 6:
        {
            cell.keyLabel.text = @"邮编";
            
            if (_selectedUser.zipCode)
            {
                cell.valueLabel.text = [NSString stringWithFormat:@"%zi",_selectedUser.zipCode];
            }
            else
            {
                cell.valueLabel.text = @"未填写";
            }
        }
            break;
        case 7:
        {
            UMSUserDetailAccountBindingViewCell *bindingCell = [[UMSUserDetailAccountBindingViewCell alloc] initWithUser:_selectedUser];
            bindingCell.keyLabel.text = @"账号绑定";
            
            return bindingCell;
        }
            break;
        case 8:
        {
            
            if (!self.signCell)
            {
                self.signCell = [[UMSUserDetailAdaptViewCell alloc] init];
                self.signCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            self.signCell.keyLabel.text = @"个性签名";
            
            if (_selectedUser.signature)
            {
                self.signCell.value = _selectedUser.signature;
            }
            else
            {
                self.signCell.value = @"未填写";
            }
            
            return self.signCell;
        }
            break;
        default:
            break;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 8)
    {
        if (!self.signCell)
        {
            self.signCell = [[UMSUserDetailAdaptViewCell alloc] init];
            self.signCell.selectionStyle =UITableViewCellSelectionStyleNone;
        }
        
        self.signCell.value = _selectedUser.signature;
        
        if (_selectedUser.signature)
        {
            self.signCell.value = _selectedUser.signature;
        }
        else
        {
            self.signCell.value = @"未填写";
        }
        
        return self.signCell.cellHeight;
    }
    
    return 50;
}

- (void)followButtonClicked
{
    if ([UMSSDK currentUser])
    {
        if (self.footerView.footerViewModel.isFollow)
        {
            [UMSAlertView showAlertViewWithTitle:@"是否确定不关注该用户？"
                                         message:nil
                                 leftActionTitle:@"取消"
                                rightActionTitle:@"不关注"
                                  animationStyle:AlertViewAnimationZoom
                                    selectAction:^(AlertViewActionType actionType) {
                                        
                                        if (actionType == AlertViewActionTypeRight)
                                        {
                                            [UMSSDK unfollowUserWithUser:_selectedUser
                                                                  result:^(NSError *error) {
                                                                      
                                                                      if (error)
                                                                      {
                                                                          NSInteger status = [[[error userInfo] objectForKey:@"status"] integerValue];
                                                                          
                                                                          switch (status)
                                                                          {
                                                                              case 452:
                                                                              {
                                                                                  [UMSAlertView showAlertViewWithTitle:@"取消关注失败"
                                                                                                               message:@"该用户不存在"
                                                                                                       leftActionTitle:@"好的"
                                                                                                      rightActionTitle:nil
                                                                                                        animationStyle:AlertViewAnimationZoom
                                                                                                          selectAction:nil];
                                                                              }
                                                                                  break;
                                                                              default:
                                                                                  [UMSAlertView showAlertViewWithTitle:@"取消关注失败"
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
                                                                          UMSUserDetailInfoFooterViewModel *model = self.footerView.footerViewModel;
                                                                          
                                                                          model.isFollow = NO;
                                                                          self.footerView.footerViewModel = model;
                                                                      }
                                                                  }];
                                        }
                                    }];
        }
        else
        {
            [UMSSDK followWithUser:_selectedUser
                            result:^(NSError *error) {
                                
                                if (error)
                                {
                                    NSInteger status = [[[error userInfo] objectForKey:@"status"] integerValue];
                                    switch (status)
                                    {
                                        case 450:
                                        {
                                            [UMSAlertView showAlertViewWithTitle:@"关注失败"
                                                                         message:@"用户为黑名单用户不能关注"
                                                                 leftActionTitle:@"好的"
                                                                rightActionTitle:nil
                                                                  animationStyle:AlertViewAnimationZoom
                                                                    selectAction:nil];
                                        }
                                            break;
                                        case 453:
                                        {
                                            [UMSAlertView showAlertViewWithTitle:@"关注失败"
                                                                         message:@"不能关注自己"
                                                                 leftActionTitle:@"好的"
                                                                rightActionTitle:nil
                                                                  animationStyle:AlertViewAnimationZoom
                                                                    selectAction:nil];
                                        }
                                            break;
                                        case 467:
                                        {
                                            [UMSAlertView showAlertViewWithTitle:@"关注失败"
                                                                         message:@"对方将你拉为黑名单"
                                                                 leftActionTitle:@"好的"
                                                                rightActionTitle:nil
                                                                  animationStyle:AlertViewAnimationZoom
                                                                    selectAction:nil];
                                        }
                                            break;
                                        default:
                                            [UMSAlertView showAlertViewWithTitle:@"关注失败"
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
                                    [UMSAlertView showAlertViewWithTitle:@"关注成功"
                                                                 message:nil
                                                         leftActionTitle:@"好的"
                                                        rightActionTitle:nil
                                                          animationStyle:AlertViewAnimationZoom
                                                            selectAction:^(AlertViewActionType actionType) {
                                                                
                                                                UMSUserDetailInfoFooterViewModel *model = self.footerView.footerViewModel;
                                                                
                                                                model.isFollow = YES;
                                                                self.footerView.footerViewModel = model;
                                                            }];
                                }
                            }];
        }
    }
    else
    {
        //提示尚未登录
        [UMSAlertView showAlertViewWithTitle:@"请先进行登录"
                                     message:@""
                             leftActionTitle:@"取消"
                            rightActionTitle:@"登录"
                              animationStyle:AlertViewAnimationZoom
                                selectAction:^(AlertViewActionType actionType) {
                                    
                                    if (actionType == AlertViewActionTypeRight)
                                    {
                                        _login = [[UMSLoginModuleViewController alloc] init];
                                        __weak typeof(self) weakSelf = self;
                                        [self presentViewController:_login
                                                           animated:YES
                                                         completion:nil];
                                        
                                        _login.loginVC.loginHandler = ^(NSError *error){
                                            
                                            [weakSelf.login close];
                                            [weakSelf setupFooterView];
                                        };
                                    }
                                }];
    }
}

- (void)addFriendButtonClicked
{
    if ([UMSSDK currentUser])
    {
        if (self.footerView.footerViewModel.isFriend)
        {
            [UMSAlertView showAlertViewWithTitle:@"是否确定删除好友关系？"
                                         message:nil
                                 leftActionTitle:@"取消"
                                rightActionTitle:@"删除"
                                  animationStyle:AlertViewAnimationZoom
                                    selectAction:^(AlertViewActionType actionType) {
                                        
                                        if (actionType == AlertViewActionTypeRight)
                                        {
                                            [UMSSDK deleteFriendWithUser:_selectedUser
                                                                  result:^(NSError *error) {
                                                                      
                                                                      if (error)
                                                                      {
                                                                          
                                                                          NSInteger status = [[[error userInfo] objectForKey:@"status"] integerValue];
                                                                          switch (status)
                                                                          {
                                                                              case 465:
                                                                              {
                                                                                  [UMSAlertView showAlertViewWithTitle:@"删除失败"
                                                                                                               message:@"不是好友关系不能执行删除操作"
                                                                                                       leftActionTitle:@"好的"
                                                                                                      rightActionTitle:nil
                                                                                                        animationStyle:AlertViewAnimationZoom
                                                                                                          selectAction:nil];
                                                                              }
                                                                                  break;
                                                                              default:
                                                                                  [UMSAlertView showAlertViewWithTitle:@"删除失败"
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
                                                                          UMSUserDetailInfoFooterViewModel *model = self.footerView.footerViewModel;
                                                                          
                                                                          model.isFriend = NO;
                                                                          self.footerView.footerViewModel = model;
                                                                      }
                                                                  }];
                                        }
                                    }];
        }
        else
        {
            self.addFriendAlert = [[UMSAddFriendAlertView alloc] initWithUser:_selectedUser];
            self.addFriendAlert.delegate = self;
            [self.addFriendAlert show];
        }
    }
    else
    {
        //提示尚未登录
        [UMSAlertView showAlertViewWithTitle:@"请先进行登录"
                                     message:@""
                             leftActionTitle:@"取消"
                            rightActionTitle:@"登录"
                              animationStyle:AlertViewAnimationZoom
                                selectAction:^(AlertViewActionType actionType) {
                                    
                                    if (actionType == AlertViewActionTypeRight)
                                    {
                                        _login = [[UMSLoginModuleViewController alloc] init];
                                        __weak typeof(self) weakSelf = self;
                                        [self presentViewController:_login
                                                           animated:YES
                                                         completion:nil];
                                        
                                        _login.loginVC.loginHandler = ^(NSError *error){
                                            
                                            if (!error)
                                            {
                                                [weakSelf.login close];
                                                [weakSelf setupFooterView];
                                            }
                                            else
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
                                        };
                                    }
                                }];
    }
}

- (void)addFriendClicked
{
    [UMSSDK addFriendRequestWithUser:_selectedUser
                             message:self.addFriendAlert.addFriendView.message.text
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

- (void)blockButtonClicked
{
    if ([UMSSDK currentUser])
    {
        if (self.footerView.footerViewModel.isBlock)
        {
            [UMSSDK removeFromBlockedUserListWithUser:_selectedUser
                                               result:^(NSError *error) {
                                                   
                                                   if (error)
                                                   {
                                                       [UMSAlertView showAlertViewWithTitle:@"解除黑名单失败"
                                                                                    message:[error description]
                                                                            leftActionTitle:@"好的"
                                                                           rightActionTitle:nil
                                                                             animationStyle:AlertViewAnimationZoom
                                                                               selectAction:^(AlertViewActionType actionType) {
                                                                                   
                                                                               }];
                                                   }
                                                   else
                                                   {
                                                       [UMSAlertView showAlertViewWithTitle:@"解除黑名单成功"
                                                                                    message:nil
                                                                            leftActionTitle:@"好的"
                                                                           rightActionTitle:nil
                                                                             animationStyle:AlertViewAnimationZoom
                                                                               selectAction:^(AlertViewActionType actionType) {
                                                                                   
                                                                                   UMSUserDetailInfoFooterViewModel *model = self.footerView.footerViewModel;
                                                                                   
                                                                                   model.isBlock = NO;
                                                                                   self.footerView.footerViewModel = model;
                                                                               }];
                                                   }
                                               }];
        }
        else
        {
            
            [UMSAlertView showAlertViewWithTitle:nil
                                         message:@"加为黑名单后，对方不可关注你和加你为好友？"
                                 leftActionTitle:@"取消"
                                rightActionTitle:@"拉黑"
                                  animationStyle:AlertViewAnimationZoom
                                    selectAction:^(AlertViewActionType actionType) {
                                        
                                        if (actionType == AlertViewActionTypeRight)
                                        {
                                            [UMSSDK blockUser:_selectedUser
                                                       result:^(NSError *error) {
                                                           
                                                           if (error)
                                                           {
                                                               NSDictionary *userInfo = [error userInfo];
                                                               NSInteger status = [[userInfo objectForKey:@"status"] integerValue];
                                                               
                                                               switch (status)
                                                               {
                                                                   case 464:
                                                                   {
                                                                       [UMSAlertView showAlertViewWithTitle:@"拉黑失败"
                                                                                                    message:@"自己不能拉黑自己"
                                                                                            leftActionTitle:@"好的"
                                                                                           rightActionTitle:nil
                                                                                             animationStyle:AlertViewAnimationZoom
                                                                                               selectAction:nil];
                                                                   }
                                                                       break;
                                                                   default:
                                                                       [UMSAlertView showAlertViewWithTitle:@"拉黑失败"
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
                                                               UMSUserDetailInfoFooterViewModel *model = self.footerView.footerViewModel;
                                                               
                                                               model.isBlock = YES;
                                                               self.footerView.footerViewModel = model;
                                                           }
                                                       }];
                                        }
                                    }];
        }
    }
    else
    {
        //提示尚未登录
        [UMSAlertView showAlertViewWithTitle:@"请先进行登录"
                                     message:@""
                             leftActionTitle:@"取消"
                            rightActionTitle:@"登录"
                              animationStyle:AlertViewAnimationZoom
                                selectAction:^(AlertViewActionType actionType) {
                                    
                                    if (actionType == AlertViewActionTypeRight)
                                    {
                                        _login = [[UMSLoginModuleViewController alloc] init];
                                        __weak typeof(self) weakSelf = self;
                                        [self presentViewController:_login
                                                           animated:YES
                                                         completion:nil];
                                        
                                        _login.loginVC.loginHandler = ^(NSError *error){
                                            
                                            [weakSelf.login close];
                                            [weakSelf setupFooterView];
                                        };
                                    }
                                }];
    }
}

@end
