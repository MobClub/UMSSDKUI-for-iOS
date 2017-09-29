//
//  UMSFansRelationshipListViewController.h
//  UMSSDKUI
//
//  Created by 刘靖煌 on 17/6/9.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import "UMSUserListViewController.h"
#import <UMSSDK/UMSSDK+Relationship.h>

@interface UMSFansRelationshipListViewController : UMSUserListViewController

@property (nonatomic, strong) UMSUser *user;
@property (nonatomic, assign) UMSRelationship relationship;

- (instancetype)initWithUser:(UMSUser *)user Relationship:(UMSRelationship)relationship;

@end
