//
//  UMSProfileHeaderView.m
//  UMSSDKUI
//
//  Created by 刘靖煌 on 17/3/21.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import "UMSProfileHeaderView.h"
#import "UMSImage.h"
#import <MOBFoundation/MOBFoundation.h>

@interface UMSProfileHeaderView ()

@property (nonatomic, strong) UIButton *avatar;
@property (nonatomic, strong) UIButton *phone;
@property (nonatomic, strong) UIButton *followButton;
@property (nonatomic, strong) UILabel *followLabel;
@property (nonatomic, strong) UIButton *fansButton;
@property (nonatomic, strong) UILabel *fansLabel;
@property (nonatomic, strong) UIButton *coFollowButton;
@property (nonatomic, strong) UILabel *coFollowLabel;

@property (nonatomic, strong) UILabel *genderLocationLabel;
@property (nonatomic, copy) NSString *genderString;
@property (nonatomic, copy) NSString *locationString;

@end

@implementation UMSProfileHeaderView

-(instancetype)init
{
    if (self = [super init])
    {
        //头像
        self.avatar = [[UIButton alloc] init];
        self.avatar.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 35, 60, 70, 70);
        [self.avatar.layer setCornerRadius:CGRectGetHeight([self.avatar bounds]) / 2];
        self.avatar.layer.masksToBounds = YES;
        self.avatar.layer.borderWidth = 1;       //可以根据需求设置边框宽度、颜色
        self.avatar.layer.borderColor = [[UIColor whiteColor] CGColor];
        [self.avatar addTarget:self
                        action:@selector(avatarClicked:) 
              forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.avatar];
        
        self.phone = [[UIButton alloc] init];
        self.phone.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 100, CGRectGetMaxY(self.avatar.frame) + 5, 200, 30);
        self.phone.titleLabel.textColor = [UIColor whiteColor];
        self.phone.titleLabel.font = [UIFont systemFontOfSize:15];
        self.phone.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.phone addTarget:self
                       action:@selector(phoneClick:)
             forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.phone];
        
        //性别和位置
        self.genderLocationLabel = [[UILabel alloc] init];
        self.genderLocationLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/2 - 100, CGRectGetMaxY(self.phone.frame), 200, 20);
        self.genderLocationLabel.textColor = [UIColor whiteColor];
        self.genderLocationLabel.textAlignment = NSTextAlignmentCenter;
        self.genderLocationLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.genderLocationLabel];
        
        self.followButton = [[UIButton alloc] init];
        self.followButton.frame = CGRectMake(0, CGRectGetMaxY(self.genderLocationLabel.frame)+10, [UIScreen mainScreen].bounds.size.width/3, 20);
        self.followButton.titleLabel.textColor = [UIColor whiteColor];
        self.followButton.titleLabel.font = [UIFont systemFontOfSize:18];
        self.followButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.followButton addTarget:self
                              action:@selector(followItemClicked:)
                    forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.followButton];
        
        self.followLabel = [[UILabel alloc] init];
        self.followLabel.frame = CGRectMake(0,CGRectGetMaxY(self.followButton.frame) , [UIScreen mainScreen].bounds.size.width/3, 20);
        self.followLabel.textColor = [UIColor whiteColor];
        self.followLabel.textAlignment = NSTextAlignmentCenter;
        self.followLabel.font = [UIFont systemFontOfSize:13];
        self.followLabel.text = @"关注";
        [self addSubview:self.followLabel];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/3,
                                                                CGRectGetMinY(self.followButton.frame)+5,
                                                                1.0f,
                                                                30)];
        [line setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:line];
        
        self.fansButton = [[UIButton alloc] init];
        self.fansButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/3, CGRectGetMaxY(self.genderLocationLabel.frame)+10, [UIScreen mainScreen].bounds.size.width/3, 20);
        self.fansButton.titleLabel.textColor = [UIColor whiteColor];
        self.fansButton.titleLabel.font = [UIFont systemFontOfSize:18];
        self.fansButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.fansButton addTarget:self
                              action:@selector(fansItemClicked:)
                    forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.fansButton];
        
        self.fansLabel = [[UILabel alloc] init];
        self.fansLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width/3,CGRectGetMaxY(self.followButton.frame) , [UIScreen mainScreen].bounds.size.width/3, 20);
        self.fansLabel.textColor = [UIColor whiteColor];
        self.fansLabel.textAlignment = NSTextAlignmentCenter;
        self.fansLabel.font = [UIFont systemFontOfSize:13];
        self.fansLabel.text = @"粉丝";
        [self addSubview:self.fansLabel];
        
        UIView *facsline = [[UIView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width * 2/3,
                                                                CGRectGetMinY(self.fansButton.frame)+5,
                                                                1.0f,
                                                                30)];
        [facsline setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:facsline];
        
        self.coFollowButton = [[UIButton alloc] init];
        self.coFollowButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width * 2/3, CGRectGetMaxY(self.genderLocationLabel.frame)+10, [UIScreen mainScreen].bounds.size.width/3, 20);
        self.coFollowButton.titleLabel.textColor = [UIColor whiteColor];
        self.coFollowButton.titleLabel.font = [UIFont systemFontOfSize:18];
        self.coFollowButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.coFollowButton addTarget:self
                            action:@selector(coFollowClicked:)
                  forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.coFollowButton];
        
        self.coFollowLabel = [[UILabel alloc] init];
        self.coFollowLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width * 2/3,CGRectGetMaxY(self.followButton.frame) , [UIScreen mainScreen].bounds.size.width/3, 20);
        self.coFollowLabel.textColor = [UIColor whiteColor];
        self.coFollowLabel.textAlignment = NSTextAlignmentCenter;
        self.coFollowLabel.font = [UIFont systemFontOfSize:13];
        self.coFollowLabel.text = @"相互关注";
        [self addSubview:self.coFollowLabel];
    }
    
    return self;
}

-(void)setUserModel:(UMSUser *)userModel
{
    _userModel = userModel;
    
    [self setNeedsLayout];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_userModel.avatars.max)
    {
        //如果有缓存
        NSString* documentPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *filePath = [NSString stringWithFormat:@"%@/UMSSDK/avatar.png",documentPath];
        if ([UIImage imageWithContentsOfFile:filePath])
        {
            self.avatar.layer.contents = (id)[[UIImage imageWithContentsOfFile:filePath] CGImage];
        }
        else
        {
            [[MOBFImageGetter sharedInstance] getImageWithURL:[NSURL URLWithString:_userModel.avatars.max]
                                                       result:^(UIImage *image, NSError *error) {
                                                           
                                                           self.avatar.layer.contents = (id)[image CGImage];
                                                           [UIImageJPEGRepresentation(image, 1.0) writeToFile:filePath atomically:NO];
                                                       }];
        }
    }
    else
    {
        self.avatar.layer.contents = (id)[[UMSImage imageNamed:@"tx_moren.png"] CGImage];  //设置图片
    }
    
    if (_userModel.nickname)
    {
        [self.phone setTitle:_userModel.nickname forState:UIControlStateNormal];
    }
    else if (_userModel.phone)
    {
        [self.phone setTitle:[_userModel.phone stringByReplacingCharactersInRange:NSMakeRange(3,5) withString:@"*****"] forState:UIControlStateNormal];
    }
    else
    {
        [self.phone setTitle:@"点击登录" forState:UIControlStateNormal];
        [self.phone addTarget:self
                       action:@selector(clickToLogin:)
             forControlEvents:UIControlEventTouchUpInside];
    }
    
    if (_userModel.gender)
    {
        self.genderString = _userModel.gender.name;
    }
    else
    {
        self.genderString = @"-";
    }
    
    NSMutableString *location = [NSMutableString string];
    if (_userModel.country)
    {
        [location appendFormat:@"%@",_userModel.country.name];
        if (_userModel.province)
        {
            [location appendFormat:@"%@",_userModel.province.name];
            
            if (_userModel.city)
            {
                [location appendFormat:@"%@",_userModel.city.name];
            }
        }
        self.locationString = location;
    }
    else
    {
        self.locationString = @"-";
    }
    
    if(_userModel)
    {
        self.genderLocationLabel.text = [NSString stringWithFormat:@"%@ %@",self.genderString,self.locationString];
    }
    else
    {
        self.genderLocationLabel.text = @"";
    }
    
    if (_userModel.followCount)
    {
        [self.followButton setTitle:[NSString stringWithFormat:@"%zi",_userModel.followCount] forState:UIControlStateNormal];
        self.followButton.enabled = YES;
    }
    else
    {
        [self.followButton setTitle:@"0" forState:UIControlStateNormal];
        self.followButton.enabled = NO;
    }
    
    if (_userModel.fansCount)
    {
        [self.fansButton setTitle:[NSString stringWithFormat:@"%zi",_userModel.fansCount] forState:UIControlStateNormal];
        self.fansButton.enabled = YES;
    }
    else
    {
        [self.fansButton setTitle:@"0" forState:UIControlStateNormal];
        self.fansButton.enabled = NO;
    }
    
    if (_userModel.coFollowCount)
    {
        [self.coFollowButton setTitle:[NSString stringWithFormat:@"%zi",_userModel.coFollowCount] forState:UIControlStateNormal];
        self.coFollowButton.enabled = YES;
    }
    else
    {
        [self.coFollowButton setTitle:@"0" forState:UIControlStateNormal];
        self.coFollowButton.enabled = NO;
    }
}

- (void)clickToLogin:(id)sender
{
    if ([self.delegate conformsToProtocol:@protocol(IUMSProfileHeaderViewDelegate)] && [self.delegate respondsToSelector:@selector(clickToLogin)])
    {
        [self.delegate clickToLogin];
    }
}

- (void)avatarClicked:(id)sender
{
    if ([self.delegate conformsToProtocol:@protocol(IUMSProfileHeaderViewDelegate)] &&
        [self.delegate respondsToSelector:@selector(avatarItemClicked)])
    {
        [self.delegate avatarItemClicked];
    }
}

- (void)phoneClick:(id)sender
{
    if ([self.delegate conformsToProtocol:@protocol(IUMSProfileHeaderViewDelegate)] &&
        [self.delegate respondsToSelector:@selector(phoneItemClicked)])
    {
        [self.delegate phoneItemClicked];
    }
}

- (void)followItemClicked:(id)sender
{
    if ([self.delegate conformsToProtocol:@protocol(IUMSProfileHeaderViewDelegate)] &&
        [self.delegate respondsToSelector:@selector(followItemClicked)])
    {
        [self.delegate followItemClicked];
    }
}

- (void)fansItemClicked:(id)sender
{
    if ([self.delegate conformsToProtocol:@protocol(IUMSProfileHeaderViewDelegate)] &&
        [self.delegate respondsToSelector:@selector(fansItemClicked)])
    {
        [self.delegate fansItemClicked];
    }
}

- (void)coFollowClicked:(id)sender
{
    if ([self.delegate conformsToProtocol:@protocol(IUMSProfileHeaderViewDelegate)] &&
        [self.delegate respondsToSelector:@selector(coFollowItemClicked)])
    {
        [self.delegate coFollowItemClicked];
    }
}

@end
