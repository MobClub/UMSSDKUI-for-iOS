//
//  UMSActionSheet.m
//  UMSSDKUI
//
//  Created by 刘靖煌 on 17/4/11.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import "UMSActionSheet.h"

//字体
#define  UMSActionSheetCancelButtonFont  [UIFont systemFontOfSize:16]
#define  UMSActionSheetDestructiveButtonFont  [UIFont systemFontOfSize:16]
#define  UMSActionSheetOtherButtonFont  [UIFont systemFontOfSize:16]
#define  UMSActionSheetTitleLabelFont  [UIFont systemFontOfSize:13]

//颜色
#define  UMSActionSheetButtonBackgroundColor [UIColor colorWithRed:251/255.0 green:251/255.0 blue:253/255.0 alpha:1]
#define  UMSActionSheetBackgroundColor [UIColor colorWithRed:129/255.0 green:129/255.0 blue:129/255.0 alpha:0.5]
#define  UMSActionSheetTitleLabelColor  [UIColor colorWithRed:137/255.0 green:137/255.0 blue:137/255.0 alpha:1]
#define  UMSActionSheetCancelButtonColor [UIColor blackColor]
#define  UMSActionSheetDestructiveButtonColor   [UIColor redColor]
#define  UMSActionSheetOtherButtonColor  [UIColor blackColor]
#define  UMSActionSheetContentViewBackgroundColor [UIColor colorWithRed:251/255.0 green:251/255.0 blue:253/255.0 alpha:0.5]
#define  UMSActionSheetButtonHighlightedColor [UIColor colorWithRed:219/255.0 green:219/255.0 blue:219/255.0 alpha:0.5]

//高度
#define  UMSActionSheetCancelButtonHeight 50
#define  UMSActionSheetDestructiveButtonHeight 50
#define  UMSActionSheetOtherButtonHeight 50
#define  UMSActionSheetLineHeight 1.0/[UIScreen mainScreen].scale

//底部取消按钮距离上面按钮距离
#define  UMSActionSheetTopMargin 20
#define  UMSActionSheetBottomMargin 5
#define  UMSActionSheetLeftMargin 20
#define  UMSActionSheetAnimationTime 0.25
#define  UMSActionSheetScreenWidth [UIScreen mainScreen].bounds.size.width
#define  UMSActionSheetScreenHeight [UIScreen mainScreen].bounds.size.height

@interface UMSActionSheet ()

@property (nonatomic,weak) UIView *contentView;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *destructiveTitle;
@property(nonatomic,strong) NSArray *otherTitles;
@property (nonatomic,copy) UMSActionSheetBlock  block;

@end

@implementation UMSActionSheet

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = UMSActionSheetBackgroundColor;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
        [tap addTarget:self action:@selector(handleGesture:)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

-(void)handleGesture:(UITapGestureRecognizer*)tap
{
    if ([tap locationInView:tap.view].y<self.frame.size.height -self.contentView.frame.size.height)
    {
        [self cancel];
    }
}

+(void)showWithTitle:(NSString *)title
    destructiveTitle:(NSString *)destructiveTitle
         otherTitles:(NSArray *)otherTitles
               block:(UMSActionSheetBlock)block
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    UMSActionSheet *sheet=[[UMSActionSheet alloc]init];
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    sheet.frame=window.bounds;
    sheet.title=title;
    sheet.destructiveTitle=destructiveTitle;
    sheet.otherTitles=otherTitles;
    sheet.block=block;
    [sheet show];
    [window addSubview:sheet];
}

-(void)show
{
    UIView *contentView = [[UIView alloc]init];
    contentView.backgroundColor = [UIColor whiteColor];
    self.contentView = contentView;
    
    CGFloat y=0;
    NSInteger tag=0;
    if (self.title)
    {
        UILabel *titleLabel=[[UILabel alloc]init];
        titleLabel.font=UMSActionSheetTitleLabelFont;
        titleLabel.textColor=UMSActionSheetTitleLabelColor;
        titleLabel.numberOfLines=0;
        titleLabel.textAlignment=NSTextAlignmentCenter;
        titleLabel.text=self.title;
        titleLabel.tag=tag;
        CGSize size= [self.title boundingRectWithSize:CGSizeMake(UMSActionSheetScreenWidth-2*UMSActionSheetLeftMargin, MAXFLOAT)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:@{NSFontAttributeName:titleLabel.font}
                                              context:nil]
        .size;
        
        titleLabel.frame=CGRectMake(UMSActionSheetLeftMargin, UMSActionSheetTopMargin,UMSActionSheetScreenWidth-2*UMSActionSheetLeftMargin ,size.height );
        UIView *view=[[UIView alloc]init];
        view.backgroundColor=UMSActionSheetButtonBackgroundColor;
        view.frame=CGRectMake(0, 0, UMSActionSheetScreenWidth, size.height+2*UMSActionSheetTopMargin);
        [contentView addSubview:view];
        [contentView addSubview:titleLabel];
        y=size.height+2*UMSActionSheetTopMargin+UMSActionSheetLineHeight;
    }
    
    for (int i=0; i<self.otherTitles.count; i++)
    {
        UIButton *button=[self createButtonWithTitle:self.otherTitles[i] color:UMSActionSheetOtherButtonColor font:UMSActionSheetOtherButtonFont height:UMSActionSheetOtherButtonHeight y:y+(UMSActionSheetOtherButtonHeight+UMSActionSheetLineHeight)*i];
        [contentView addSubview:button];
        if (i==self.otherTitles.count-1)
        {
            y=y+(UMSActionSheetOtherButtonHeight+UMSActionSheetLineHeight)*i+UMSActionSheetOtherButtonHeight;
        }
        button.tag=tag;
        tag++;
    }
    if (self.destructiveTitle)
    {
        UIButton *button=[self createButtonWithTitle:self.destructiveTitle color:UMSActionSheetDestructiveButtonColor font:UMSActionSheetDestructiveButtonFont height:UMSActionSheetDestructiveButtonHeight y:y+UMSActionSheetLineHeight];
        button.tag=tag;
        [contentView addSubview:button];
        y+=(UMSActionSheetDestructiveButtonHeight+UMSActionSheetBottomMargin);
        tag++;
        
    }
    else
    {
        y+=UMSActionSheetBottomMargin;
    }
    
    UIButton *cancel= [self createButtonWithTitle:@"取消"
                                            color:UMSActionSheetCancelButtonColor
                                             font:UMSActionSheetCancelButtonFont
                                           height:UMSActionSheetCancelButtonHeight
                                                y:y];
    cancel.tag=tag;
    [contentView addSubview:cancel];
    contentView.backgroundColor=UMSActionSheetContentViewBackgroundColor;
    CGFloat maxY= CGRectGetMaxY(contentView.subviews.lastObject.frame);
    contentView.frame=CGRectMake(0, self.frame.size.height-maxY, UMSActionSheetScreenWidth, maxY);
    [self addSubview:contentView];
    
    CGRect frame= self.contentView.frame;
    CGRect newframe= frame;
    self.alpha=0.1;
    newframe.origin.y=self.frame.size.height;
    contentView.frame=newframe;
    [UIView animateWithDuration:UMSActionSheetAnimationTime animations:^{
        self.contentView.frame=frame;
        self.alpha=1;
    }completion:^(BOOL finished)
    {}];
}
-(UIButton*)createButtonWithTitle:(NSString*)title
                            color:(UIColor*)color
                             font:(UIFont*)font
                           height:(CGFloat)height
                                y:(CGFloat)y
{
    UIButton *button=[[UIButton alloc]init];
    button.backgroundColor=UMSActionSheetButtonBackgroundColor;
    [button setBackgroundImage:[self imageWithColor:UMSActionSheetButtonHighlightedColor] forState:UIControlStateHighlighted];
    button.titleLabel.font=font;
    button.titleLabel.textAlignment=NSTextAlignmentCenter;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:color forState:UIControlStateNormal];
    button.frame=CGRectMake(0, y, UMSActionSheetScreenWidth, height);
    [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

-(void)click:(UIButton*)button
{
    if (self.block)
    {
        self.block((int)button.tag);
    }
    [self cancel];
}

#pragma mark - 取消
-(void)cancel
{
    CGRect frame= self.contentView.frame;
    frame.origin.y+=frame.size.height;
    [UIView animateWithDuration:UMSActionSheetAnimationTime
                     animations:^{
        self.contentView.frame=frame;
        self.alpha=0.1;
    }
                     completion:^(BOOL finished){
        [self removeFromSuperview];
    }];
}

-(UIImage*)imageWithColor:(UIColor*)color
{
    UIGraphicsBeginImageContext(CGSizeMake(1, 1));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddRect(context, CGRectMake(0, 0, 1, 1));
    [color set];
    CGContextFillPath(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
