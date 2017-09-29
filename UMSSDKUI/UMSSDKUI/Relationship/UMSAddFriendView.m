//
//  UMSAddFriendView.m
//  UMSSDKUI
//
//  Created by 刘靖煌 on 17/6/1.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import "UMSAddFriendView.h"
#import "UMSUserView.h"

@interface UMSAddFriendView ()

@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UIButton *addFriendBtn;
@property (nonatomic, strong) UMSUserView *userView;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UIView *intervalLine;

@end

@implementation UMSAddFriendView

- (instancetype)init
{
    if (self = [super init])
    {
        _userView = [[UMSUserView alloc] init];
        
        [self addSubview:_userView];
        
        _message = [[UITextView alloc] init];
        _message.placeholder = @"请输入留言";
        _message.layer.cornerRadius = 5;
        _message.layer.masksToBounds = YES;
        [self addSubview:_message];
        
        self.backgroundColor = [UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1.0];
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setTitle:@"取消"
                    forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_cancelBtn setTitleColor:[UIColor colorWithRed:219/255.0 green:62/255.0 blue:60/255.0 alpha:1.0] forState:UIControlStateNormal];
        [self addSubview:_cancelBtn];
        [_cancelBtn addTarget:self
                       action:@selector(cancel:)
             forControlEvents:UIControlEventTouchUpInside];
        
        UIView *line = [[UIView alloc] init];
        [line setBackgroundColor:[UIColor colorWithRed:207/255.0 green:207/255.0 blue:217/255.0 alpha:1.0]];
        _line = line;
        [self addSubview:_line];
        
        UIView *intervalLine = [[UIView alloc] init];
        [intervalLine setBackgroundColor:[UIColor colorWithRed:207/255.0 green:207/255.0 blue:217/255.0 alpha:1.0]];
        _intervalLine = intervalLine;
        [self addSubview:_intervalLine];
        
        _addFriendBtn = [[UIButton alloc] init];
        [_addFriendBtn setTitle:@"添加好友"
                    forState:UIControlStateNormal];
        _addFriendBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_addFriendBtn setTitleColor:[UIColor colorWithRed:219/255.0 green:62/255.0 blue:60/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_addFriendBtn addTarget:self
                          action:@selector(addFriend:)
                forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_addFriendBtn];
    }
    
    return self;
}

-(void)cancel:(id)sender
{
    if ([self.delegate conformsToProtocol:@protocol(IUMSAddFriendViewDelegate)] &&
        [self.delegate respondsToSelector:@selector(cancelClicked)])
    {
        [self.delegate cancelClicked];
    }
}

-(void)addFriend:(id)sender
{
    if ([self.delegate conformsToProtocol:@protocol(IUMSAddFriendViewDelegate)] &&
        [self.delegate respondsToSelector:@selector(addFriendClicked)])
    {
        [self.delegate addFriendClicked];
    }
}

-(void)setUserData:(UMSUser *)userData
{
    if (userData)
    {
        _userView.userData = userData;
    }
    
    [self setNeedsLayout];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    _userView.frame = CGRectMake(0, 10, self.bounds.size.width, 90);
    self.message.frame = CGRectMake(20, CGRectGetMaxY(_userView.frame), self.bounds.size.width - 40, 75);
    
    _cancelBtn.frame = CGRectMake(0, self.bounds.size.height - 35, self.bounds.size.width/2, 35);
    _addFriendBtn.frame = CGRectMake(self.bounds.size.width/2, self.bounds.size.height - 35, self.bounds.size.width/2, 35);
    
    _line.frame = CGRectMake(0, self.bounds.size.height - 35,
                             self.bounds.size.width, 1.0f);
    _intervalLine.frame = CGRectMake(self.bounds.size.width/2, self.bounds.size.height - 35,
                                     1.0f, 35);
}


@end
