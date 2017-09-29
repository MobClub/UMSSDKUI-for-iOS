//
//  UMSUserListViewController.h
//  UMSSDKUI
//
//  Created by 刘靖煌 on 17/5/27.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UMSUserListViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *userList;
@property (nonatomic, strong) NSString *navTitle;
@property (nonatomic, assign) BOOL isHiddleLeftBarButtonItem;
@property (nonatomic, assign) BOOL isShowLoginTime;

@end
