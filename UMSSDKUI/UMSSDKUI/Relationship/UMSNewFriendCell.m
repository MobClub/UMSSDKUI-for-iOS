//
//  UMSNewFriendCell.m
//  UMSSDKUI
//
//  Created by 刘靖煌 on 17/5/31.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import "UMSNewFriendCell.h"
#import "UMSImage.h"
#import <MOBFoundation/MOBFoundation.h>

@interface UMSNewFriendCell()

@property (nonatomic, strong) UIButton *avatar;
@property (nonatomic, strong) UILabel *nickname;
@property (nonatomic, strong) UILabel *requestMessage;
@property (nonatomic, strong) UIButton *agreeButton;
@property (nonatomic, strong) UIButton *refuseButton;
@property (nonatomic, strong) UILabel *statueLabel;

@end

@implementation UMSNewFriendCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setupElement];
    }
    return self;
}

- (void)setupElement
{
    self.avatar = [[UIButton alloc] init];
    self.avatar.frame = CGRectMake(20, 10 , 60, 60);
    self.avatar.layer.cornerRadius = 3;
    self.avatar.layer.masksToBounds = YES;
    
    [self addSubview:self.avatar];
    
    self.nickname = [[UILabel alloc] init];
    self.nickname.frame = CGRectMake(CGRectGetMaxX(self.avatar.frame) + 10, 10, 130, 20);
    self.nickname.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.nickname];
    
    self.requestMessage = [[UILabel alloc] init];
    self.requestMessage.frame = CGRectMake(CGRectGetMaxX(self.avatar.frame) + 10, CGRectGetMaxY(self.nickname.frame) + 15, 150, 15);
    self.requestMessage.font = [UIFont systemFontOfSize:14];
    self.requestMessage.textColor = [UIColor grayColor];
    [self addSubview:self.requestMessage];
    
    self.refuseButton = [[UIButton alloc] init];
    self.refuseButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 65, 25, 50, 30);
    [self.refuseButton setBackgroundImage:[UMSImage imageNamed:@"kuang.png"] forState:UIControlStateNormal];
    [self.refuseButton setTitle:@"拒绝" forState:UIControlStateNormal];
    self.refuseButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.refuseButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.refuseButton addTarget:self
                          action:@selector(refuse:)
                forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.refuseButton];
    
    self.agreeButton = [[UIButton alloc] init];
    self.agreeButton.frame = CGRectMake(CGRectGetMinX(self.refuseButton.frame) - 65, 25, 50, 30);
    self.agreeButton.backgroundColor = [UIColor colorWithRed:220/255.0 green:63/255.0 blue:59/255.0 alpha:1.0];
    [self.agreeButton setTitle:@"同意" forState:UIControlStateNormal];
    self.agreeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.agreeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.agreeButton.layer.cornerRadius = 5;
    self.agreeButton.layer.masksToBounds = YES;
    [self.agreeButton addTarget:self
                         action:@selector(agree:)
               forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.agreeButton];
    
    self.statueLabel = [[UILabel alloc] init];
    self.statueLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 65, 25, 50, 30);
    self.statueLabel.font = [UIFont systemFontOfSize:14];
    self.statueLabel.textColor = [UIColor grayColor];
    [self addSubview:self.statueLabel];
}

-(void)refuse:(id)sender
{
    if ([self.delegate conformsToProtocol:@protocol(IUMSNewFriendCellDelegate)] &&
        [self.delegate respondsToSelector:@selector(refuseWithTag:)])
    {
        [self.delegate refuseWithTag:self.tag];
    }
}

- (void)agree:(id)sender
{
    if ([self.delegate conformsToProtocol:@protocol(IUMSNewFriendCellDelegate)] &&
        [self.delegate respondsToSelector:@selector(agreeWithTag:)])
    {
        [self.delegate agreeWithTag:self.tag];
    }
}

-(void)setDataModel:(UMSApplyAddFriendData *)dataModel
{
    _dataModel = dataModel;
    
    [self setNeedsLayout];
}

-(void)layoutSubviews
{
    self.nickname.text = _dataModel.user.nickname;
    
    //NSLog(@"message: %@ , status: %zi",_dataModel.applyMessage,_dataModel.requestStatus);
    
    if (_dataModel.applyMessage)
    {
        if (_dataModel.applyMessage.length >9)
        {
            self.requestMessage.text = [NSString stringWithFormat:@"%@…",[_dataModel.applyMessage substringWithRange:NSMakeRange(0,8)]];
        }
        else
        {
            self.requestMessage.text = _dataModel.applyMessage;
        }
    }
    else
    {
        self.requestMessage.text = _dataModel.applyMessage;
    }
    
    [[MOBFImageGetter sharedInstance] getImageWithURL:[NSURL URLWithString:_dataModel.user.avatars.max]
                                               result:^(UIImage *image, NSError *error) {
                                                   
                                                   self.avatar.layer.contents = (id)[image CGImage];
                                               }];
    
    switch (_dataModel.requestStatus)
    {
        case UMSDealWithRequestStatusPending:
        {
            self.statueLabel.hidden = YES;
            self.refuseButton.hidden = NO;
            self.agreeButton.hidden = NO;
        }
            break;
        case UMSDealWithRequestStatusAgree:
        {
            self.statueLabel.text = @"已同意";
            self.statueLabel.hidden = NO;
            self.refuseButton.hidden = YES;
            self.agreeButton.hidden = YES;
        }
            break;
        case UMSDealWithRequestStatusRefuse:
        {
            self.statueLabel.text = @"已拒绝";
            self.statueLabel.hidden = NO;
            self.refuseButton.hidden = YES;
            self.agreeButton.hidden = YES;
        }
            break;
        default:
            break;
    }
}



@end
