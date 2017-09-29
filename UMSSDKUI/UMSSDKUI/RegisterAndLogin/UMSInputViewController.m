//
//  UMSInputViewController.m
//  UMSSDKUI
//
//  Created by 刘靖煌 on 17/3/14.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import "UMSInputViewController.h"
#import "UMSImage.h"
#import "UITextView+UMSPlaceholder.h"
#import "UIBarButtonItem+UMS.h"

@interface UMSInputViewController ()

@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIButton *finishButton;
@property (nonatomic, copy) NSString *oldData;

@end

@implementation UMSInputViewController

- (instancetype)initWithTitle:(NSString*)title andOldData:(NSString *)oldData
{
    if (self = [super init])
    {
        self.title = title;
        self.oldData = oldData;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 左边按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"return.png"
                                                                 highIcon:@"return.png"
                                                                   target:self
                                                                   action:@selector(leftItemClicked:)];
    
    self.finishButton = [[UIButton alloc] init];
    self.finishButton.frame = CGRectMake(0, 0, 44, 44);
    [self.finishButton setTitle:@"完成" forState:UIControlStateNormal];
    [[self.finishButton titleLabel] setFont:[UIFont systemFontOfSize:16]];
    [self.finishButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.finishButton addTarget:self action:@selector(finishAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.finishButton];
    
    //中间的标题
    UILabel *navTitle = [[UILabel alloc] init];
    navTitle.frame = CGRectMake(0, 0 , 35, 35);
    navTitle.text = self.title;
    navTitle.font = [UIFont systemFontOfSize:16];
    self.navigationItem.titleView = navTitle;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width - 20, self.view.bounds.size.height)];
    self.textView.font = [UIFont systemFontOfSize:15];
    
    if (!self.oldData)
    {
        self.textView.placeholder = [NSString stringWithFormat:@" 请输入您的%@",self.title];
    }
    else
    {
        self.textView.text = self.oldData;
    }
    
    [self.view addSubview:self.textView];
}

-(void)leftItemClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)finishAction:(id)sender
{
    if ([self.delegate conformsToProtocol:@protocol(IUMSInputViewControllerDelegate)] && [self.delegate respondsToSelector:@selector(selectFinishWithData:)])
    {
        [self.delegate performSelector:@selector(selectFinishWithData:) withObject:self.textView.text];
    }
    
    if ([self.delegate conformsToProtocol:@protocol(IUMSInputViewControllerDelegate)] && [self.delegate respondsToSelector:@selector(selectFinishWithData:type:)])
    {
        [self.delegate performSelector:@selector(selectFinishWithData:type:) withObject:self.textView.text withObject:@(self.view.tag)];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
