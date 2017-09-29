//
//  UMSUserView.m
//  UMSSDKUI
//
//  Created by 刘靖煌 on 17/5/24.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import "UMSUserView.h"
#import <JiMu/JIMUGenderConstant.h>
#import "UMSImage.h"
#import <MOBFoundation/MOBFoundation.h>
#import "NSDate+UMSSDK.h"

@interface UMSUserView ()

@end

@implementation UMSUserView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.avatarButton = [[UIButton alloc] init];
        self.avatarButton.frame = CGRectMake(20, 10 , 60, 60);
        self.avatarButton.layer.cornerRadius = 3;
        self.avatarButton.layer.masksToBounds = YES;
        [self addSubview:self.avatarButton];
        
        self.nicknameLabel = [[UILabel alloc] init];
        self.nicknameLabel.frame = CGRectMake(CGRectGetMaxX(self.avatarButton.frame) + 10, 10, 130, 20);
        self.nicknameLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:self.nicknameLabel];
        
        self.genderAgeButton = [[UIButton alloc] init];
        self.genderAgeButton.frame = CGRectMake(CGRectGetMaxX(self.avatarButton.frame) + 10, CGRectGetMaxY(self.nicknameLabel.frame) + 5, 40, 15);
        self.genderAgeButton.titleLabel.font = [UIFont systemFontOfSize:13];
        self.genderAgeButton.layer.cornerRadius = 2;
        self.genderAgeButton.layer.masksToBounds = YES;
        [self addSubview:self.genderAgeButton];
        
        self.locationLabel = [[UILabel alloc] init];
        self.locationLabel.frame = CGRectMake(CGRectGetMaxX(self.genderAgeButton.frame) + 10, CGRectGetMaxY(self.nicknameLabel.frame) + 5, 100, 15);
        self.locationLabel.font = [UIFont systemFontOfSize:13];
        self.locationLabel.textColor = [UIColor grayColor];
        [self addSubview:self.locationLabel];
        
        self.signatureLabel = [[UILabel alloc] init];
        self.signatureLabel.frame = CGRectMake(CGRectGetMaxX(self.avatarButton.frame) + 10, CGRectGetMaxY(self.locationLabel.frame) + 5, 120, 15);
        self.signatureLabel.font = [UIFont systemFontOfSize:13];
        self.signatureLabel.textColor = [UIColor grayColor];
        [self addSubview:self.signatureLabel];
        
        self.loginTimeLabel = [[UILabel alloc] init];
        
        self.loginTimeLabel.textAlignment = NSTextAlignmentRight;
        self.loginTimeLabel.font = [UIFont systemFontOfSize:13];
        self.loginTimeLabel.textColor = [UIColor grayColor];
        [self addSubview:self.loginTimeLabel];
        
    }
    return self;
}

-(void)setUserData:(UMSUser *)userData
{
    if (userData)
    {
        _userData = userData;
    }
    
    [self setNeedsLayout];
}

-(void)layoutSubviews
{
    [[MOBFImageGetter sharedInstance] getImageWithURL:[NSURL URLWithString:_userData.avatars.max]
                                               result:^(UIImage *image, NSError *error) {
                                                   
                                                   self.avatarButton.layer.contents = (id)[image CGImage];
                                               }];
    
    self.nicknameLabel.text = self.userData.nickname;

    //根据性别选择按钮背景颜色和图标
    if (self.userData.gender == JIMUGenderConstantMale)
    {
        self.genderAgeButton.layer.backgroundColor = [UIColor colorWithRed:95/255.0f green:137/255.0f blue:216/255.0f alpha:1.0].CGColor;
        [self.genderAgeButton setImage:[UMSImage imageNamed:@"nan.png"] forState:UIControlStateNormal];
        
    }
    else if (self.userData.gender == JIMUGenderConstantFemale)
    {
        [self.genderAgeButton setImage:[UMSImage imageNamed:@"nv.png"] forState:UIControlStateNormal];
        self.genderAgeButton.layer.backgroundColor = [UIColor colorWithRed:235/255.0f green:138/255.0f blue:182/255.0f alpha:1.0].CGColor;
    }
    else if(self.userData.gender == JIMUGenderConstantSecret)
    {
        [self.genderAgeButton setImage:[UMSImage imageNamed:@"weizhi.png"] forState:UIControlStateNormal];
        self.genderAgeButton.layer.backgroundColor = [UIColor grayColor].CGColor;
    }
    else
    {
        [self.genderAgeButton setImage:[UMSImage imageNamed:@"weizhi.png"] forState:UIControlStateNormal];
        self.genderAgeButton.layer.backgroundColor = [UIColor grayColor].CGColor;
    }
    
    if (self.userData.age)
    {
        [self.genderAgeButton setTitle:[NSString stringWithFormat:@" %zi",[self.userData.age integerValue]] forState:UIControlStateNormal];
    }
    else
    {
        [self.genderAgeButton setTitle:@" -" forState:UIControlStateNormal];
    }
    
    NSMutableString *location = [NSMutableString string];
    
    if (self.userData.city)
    {
        [location appendFormat:@"%@,",self.userData.city.name];
    }
    
    if (self.userData.province)
    {
        [location appendFormat:@"%@,",self.userData.province.name];
    }
    
    if (self.userData.country)
    {
        [location appendFormat:@"%@",self.userData.country.name];
    }
    
    self.locationLabel.text = location;
    
    if (self.userData.signature && ![self.userData.signature isEqualToString:@""])
    {
        if (self.userData.signature.length>9)
        {
            self.signatureLabel.text = [NSString stringWithFormat:@"%@…",[self.userData.signature substringWithRange:NSMakeRange(0,8)]];
        }
        else
        {
            self.signatureLabel.text = self.userData.signature;
        }
    }
    else
    {
        self.signatureLabel.text = @"-";
    }
    
    self.loginTimeLabel.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 120, 10, 100, 15);
    if (self.isShowLoginTime)
    {
        if (self.userData.loginAt)
        {
            self.loginTimeLabel.text = [NSDate getSpecialTimeWithDate:self.userData.loginAt];
        }
        else
        {
            self.loginTimeLabel.text = @"-";
        }
        
        self.loginTimeLabel.hidden = NO;
    }
    else
    {
        self.loginTimeLabel.hidden = YES;
    }
}


@end
