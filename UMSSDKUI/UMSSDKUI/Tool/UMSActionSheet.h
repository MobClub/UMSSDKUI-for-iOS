//
//  UMSActionSheet.h，此类的代码参考了：https://github.com/lsmakethebest/LSActionSheet
//  UMSSDKUI
//
//  Created by 刘靖煌 on 17/4/11.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import <UIKit/UIKit.h>

//按钮顺序index依次从上往下
typedef void(^UMSActionSheetBlock)(int index);

@interface UMSActionSheet : UIView

+(void)showWithTitle:(NSString*)title
    destructiveTitle:(NSString*)destructiveTitle
         otherTitles:(NSArray*)otherTitles
               block:(UMSActionSheetBlock)block;

@end
