//
//  UMSAddFriendAlertView.m
//  UMSSDKUI
//
//  Created by 刘靖煌 on 17/6/1.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import "UMSAddFriendAlertView.h"

@interface UMSAddFriendAlertView ()<IUMSAddFriendViewDelegate>

@property (nonatomic, strong) UIView *maskView;

@end

@implementation UMSAddFriendAlertView

-(instancetype)initWithUser:(UMSUser *)user;
{
    self = [super init];
    if (self)
    {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window endEditing:YES];
        
        _maskView = [[UIView alloc] initWithFrame:window.bounds];
        _maskView.backgroundColor = [UIColor colorWithRed:109/255.0f green:109/255.0f blue:109/255.0f alpha:0.75];
        [window addSubview:_maskView];
        
        self.addFriendView = [[UMSAddFriendView alloc] init];
        self.addFriendView.userData = user;
        _addFriendView.delegate = self;
        self.addFriendView.frame = CGRectMake(40,_maskView.bounds.size.height/2 - 125 , _maskView.bounds.size.width - 80, 250);
        [_maskView addSubview:self.addFriendView];
        
        UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
        [_maskView addGestureRecognizer:tapGr];
    }
    return self;
}

- (void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [self.addFriendView.message resignFirstResponder];
}

- (void)show
{
    [self showAnimation];
}

- (void)cancelClicked
{
    [self hideAnimation];
    
    if ([self.delegate conformsToProtocol:@protocol(IUMSAddFriendAlertViewDelegate)] &&
        [self.delegate respondsToSelector:@selector(cancelClicked)])
    {
        [self.delegate cancelClicked];
    }
}

-(void)addFriendClicked
{
    [self hideAnimation];
    
    if ([self.delegate conformsToProtocol:@protocol(IUMSAddFriendAlertViewDelegate)] &&
        [self.delegate respondsToSelector:@selector(addFriendClicked)])
    {
        [self.delegate addFriendClicked];
    }
}

- (void)showAnimation
{
    [UIView animateWithDuration:0.5f
                          delay:0
         usingSpringWithDamping:1.0f
          initialSpringVelocity:0.1f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _maskView.alpha = 1;
                     } completion:nil];
}

- (void)hideAnimation
{
    [UIView animateWithDuration:0.5f
                          delay:0
         usingSpringWithDamping:1.0f
          initialSpringVelocity:0.1f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         _maskView.alpha = 0;
                     } completion:^(BOOL finished) {
                         [_maskView removeFromSuperview];
                     }];
}

@end
