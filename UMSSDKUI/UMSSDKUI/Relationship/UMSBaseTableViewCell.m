
//
//  UMSBaseTableViewCell.m
//  UMSSDKUI
//
//  Created by 刘靖煌 on 2017/6/20.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import "UMSBaseTableViewCell.h"

@implementation UMSBaseTableViewCell

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef cxt = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(cxt, 0.5);
    CGContextSetStrokeColorWithColor(cxt, [UIColor colorWithWhite:0.910 alpha:1.000].CGColor);
    CGContextMoveToPoint(cxt, 0.0 , self.frame.size.height - 0.5);
    CGContextAddLineToPoint(cxt,self.frame.size.width , self.frame.size.height - 0.5);
    CGContextStrokePath(cxt);
}

@end
