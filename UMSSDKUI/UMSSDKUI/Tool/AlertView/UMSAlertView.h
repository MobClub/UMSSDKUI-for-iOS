//
//  UMSAlertView.h，此类的代码参考了：https://github.com/guowilling/SRAlertView
//  UMSSDKUI
//
//  Created by 刘靖煌 on 17/3/22.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UMSAlertView;

typedef NS_ENUM(NSInteger, AlertViewActionType) {
    AlertViewActionTypeLeft,
    AlertViewActionTypeRight,
};

typedef NS_ENUM(NSInteger, AlertViewAnimationStyle) {
    AlertViewAnimationNone,
    AlertViewAnimationZoom,
    AlertViewAnimationTopToCenterSpring,
    AlertViewAnimationDownToCenterSpring,
    AlertViewAnimationLeftToCenterSpring,
    AlertViewAnimationRightToCenterSpring,
};

@protocol IUMSAlertViewDelegate <NSObject>

@required
- (void)alertViewDidSelectAction:(AlertViewActionType)actionType;

@end

typedef void(^AlertViewDidSelectAction)(AlertViewActionType actionType);

@interface UMSAlertView : UIView

/**
 The Animation style to show alert.
 */
@property (nonatomic, assign) AlertViewAnimationStyle animationStyle;

/**
 Whether blur the current background view, default is YES.
 */
@property (nonatomic, assign) BOOL blurCurrentBackgroundView;

/**
 Action's title color when highlighted.
 */
@property (nonatomic, strong) UIColor *actionWhenHighlightedTitleColor;

/**
 Action's background color when highlighted.
 */
@property (nonatomic, strong) UIColor *actionWhenHighlightedBackgroundColor;

#pragma mark - BLOCK

/**
 Quickly show a alert view with block.
 */
+ (void)showAlertViewWithTitle:(NSString *)title
                       message:(NSString *)message
               leftActionTitle:(NSString *)leftActionTitle
              rightActionTitle:(NSString *)rightActionTitle
                animationStyle:(AlertViewAnimationStyle)animationStyle
                  selectAction:(AlertViewDidSelectAction)selectAction;

/**
 Init a Alert view with block.
 */
- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
              leftActionTitle:(NSString *)leftActionTitle
             rightActionTitle:(NSString *)rightActionTitle
               animationStyle:(AlertViewAnimationStyle)animationStyle
                 selectAction:(AlertViewDidSelectAction)selectAction;

#pragma mark - DELEGATE

/**
 Quickly show a alert view with delegate.
 */
+ (void)showAlertViewWithTitle:(NSString *)title
                       message:(NSString *)message
               leftActionTitle:(NSString *)leftActionTitle
              rightActionTitle:(NSString *)rightActionTitle
                animationStyle:(AlertViewAnimationStyle)animationStyle
                      delegate:(id<IUMSAlertViewDelegate>)delegate;

/**
 Init a Alert view with delegate.
 */
- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
              leftActionTitle:(NSString *)leftActionTitle
             rightActionTitle:(NSString *)rightActionTitle
               animationStyle:(AlertViewAnimationStyle)animationStyle
                     delegate:(id<IUMSAlertViewDelegate>)delegate;

@end
