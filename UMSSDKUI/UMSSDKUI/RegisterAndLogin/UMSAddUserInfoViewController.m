//
//  UMSAddUserInfoViewController.m
//  UMSSDKUI
//
//  Created by 刘靖煌 on 17/2/26.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import "UMSAddUserInfoViewController.h"
#import "UMSImage.h"
#import "UMSPickerViewController.h"
#import <JiMu/JIMULocationConstant.h>
#import <JiMu/JIMUGenderConstant.h>
#import <UMSSDK/UMSSDK.h>
#import "UMSInputViewController.h"
#import "UMSBaseNavigationController.h"
#import "UMSProfileViewController.h"
#import "UMSAlertView.h"
#import <MOBFoundation/MOBFoundation.h>
#import "UMSLoginViewController.h"
#import "UMSActionSheet.h"

@interface UMSAddUserInfoViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate, UIPopoverControllerDelegate,IUMSPickerViewControllerDelegate,IUMSInputViewControllerDelegate>

@property (nonatomic, strong) UIButton *avatar;
@property (nonatomic, strong) UIButton *photoIcon;
@property (nonatomic, strong) UIButton *nickName;
@property (nonatomic, strong) UIButton *gender;
@property (nonatomic, copy) NSString *temGender;
@property (nonatomic, strong) UIButton *region;
@property (nonatomic, strong) UIButton *submitButton;

@property (nonatomic, strong) UIPopoverController *imagePickerPopover;
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UMSPickerViewController *pickView;

@property (nonatomic, strong) JIMULocationConstant *selectedCountry;
@property (nonatomic, strong) JIMULocationConstant *selectedProvice;
@property (nonatomic, strong) JIMULocationConstant *selectedCity;
@property (nonatomic, strong) JIMUGenderConstant *selectedGender;

@property (nonatomic, strong) UMSUser *userData;
@property (nonatomic, strong) UMSInputViewController *inputView;
@property (nonatomic, copy) NSString *smsCode;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *phoneZone;
@property (nonatomic, copy) NSString *password;

@property (nonatomic, assign) NSInteger selectedRow;
@property (nonatomic, assign) UMSPickerViewType pickViewType;
@property (nonatomic, strong) NSDate *selectedDate;

@end

@implementation UMSAddUserInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.hidesBackButton = YES;
    
    //右边按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"跳过" forState:UIControlStateNormal];
    [[button titleLabel] setFont:[UIFont systemFontOfSize:14]];
    [button addTarget:self action:@selector(rightItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.frame = (CGRect){CGPointZero, CGSizeMake(44, 44)};
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    //中间的标题
    UILabel *navTitle = [[UILabel alloc] init];
    navTitle.frame = CGRectMake(0, 0 , 35, 35);
    navTitle.text = @"完善资料";
    navTitle.font = [UIFont systemFontOfSize:16];
    self.navigationItem.titleView = navTitle;
    
    //头像
    self.avatar = [[UIButton alloc] init];
    self.avatar.frame = CGRectMake(self.view.frame.size.width/2 - 35, 100 , 70, 70);
    [self.avatar.layer setCornerRadius:CGRectGetHeight([self.avatar bounds]) / 2];
    self.avatar.layer.masksToBounds = YES;
    self.avatar.layer.borderWidth = 1;       //可以根据需求设置边框宽度、颜色
    self.avatar.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.avatar.layer.contents = (id)[[UMSImage imageNamed:@"tx_moren.png"] CGImage];  //设置图片
    [self.avatar addTarget:self action:@selector(changeAvatar:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.avatar];
    
    self.photoIcon = [[UIButton alloc] init];
    self.photoIcon.frame = CGRectMake(CGRectGetMaxX(self.avatar.frame) - 20, CGRectGetMaxY(self.avatar.frame) - 20 , 20, 20);
    self.photoIcon.layer.contents = (id)[[UMSImage imageNamed:@"photo.png"] CGImage];  //设置图片
    [self.photoIcon addTarget:self action:@selector(changeAvatar:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.photoIcon];
    
    //昵称模块
    [self addNickNameModule];
    
    //性别模块
    [self addGenderModule];
    
    //地区模块
    [self addRegionModule];
    
    //提交按钮
    self.submitButton = [[UIButton alloc] init];
    self.submitButton.frame = CGRectMake(20, CGRectGetMaxY(self.region.frame)+30, self.view.frame.size.width-40, self.view.frame.size.width*0.1);
    [self.submitButton addTarget:self action:@selector(submitButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.submitButton.backgroundColor = [UIColor colorWithRed:220/255.0 green:63/255.0 blue:59/255.0 alpha:1.0];
    [self.submitButton setTitle:@"提 交" forState:UIControlStateNormal];
    [[self.submitButton titleLabel] setFont:[UIFont systemFontOfSize:14]];
    self.submitButton.layer.cornerRadius = 5;
    [self.view addSubview:self.submitButton];
}


- (UMSUser *)userData
{
    if (_userData)
    {
        return _userData;
    }
    
    _userData = [[UMSUser alloc] init];
    return _userData;
}

- (void)changeAvatar:(id)sender
{
    if ([self.imagePickerPopover isPopoverVisible])
    {
        [self.imagePickerPopover dismissPopoverAnimated:YES];
        self.imagePickerPopover = nil;
        return;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.editing = YES;
    imagePicker.delegate = self;
    /*
     如果这里allowsEditing设置为false，则下面的UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
     应该改为： UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
     也就是改为原图像，而不是编辑后的图像。
     */
    //允许编辑图片
    imagePicker.allowsEditing = YES;
    //如果设备支持相机，就使用拍照技术
    //否则让用户从照片库中选择照片
    //  if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    //  {
    //    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    //  }
    //  else{
    //    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //  }
    
    /*
     这里以弹出选择框的形式让用户选择是打开照相机还是图库
     */
    [UMSActionSheet showWithTitle:nil
                 destructiveTitle:nil
                      otherTitles:@[@"相机",@"从相册选择"]
                            block:^(int index) {
                                
                                switch (index)
                                {
                                    case 0:
                                    {
                                        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                                        //创建UIPopoverController对象前先检查当前设备是不是ipad
                                        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
                                        {
                                            self.imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
                                            self.imagePickerPopover.delegate = self;
                                            [self.imagePickerPopover presentPopoverFromBarButtonItem:sender
                                                                            permittedArrowDirections:UIPopoverArrowDirectionAny
                                                                                            animated:YES];
                                        }
                                        else
                                        {
                                            [self presentViewController:imagePicker animated:YES completion:nil];
                                        }
                                    }
                                        break;
                                    case 1:
                                    {
                                        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                                        //创建UIPopoverController对象前先检查当前设备是不是ipad
                                        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
                                        {
                                            self.imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
                                            self.imagePickerPopover.delegate = self;
                                            [self.imagePickerPopover presentPopoverFromBarButtonItem:sender
                                                                            permittedArrowDirections:UIPopoverArrowDirectionAny
                                                                                            animated:YES];
                                        }
                                        else
                                        {
                                            [self presentViewController:imagePicker animated:YES completion:nil];
                                        }
                                    }
                                        break;
                                    default:
                                        break;
                                }
                            }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //通过info字典获取选择的照片
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    //以itemKey为键，将照片存入ImageStore对象中
    [[UMSImage sharedInstance] setImage:image forKey:@"CYFStore"];
    //将照片放入UIImageView对象
    self.avatar.layer.contents = (id)[image CGImage];
    //把一张照片保存到图库中，此时无论是这张照片是照相机拍的还是本身从图库中取出的，都会保存到图库中；
//    UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    
    //压缩图片,如果图片要上传到服务器或者网络，则需要执行该步骤（压缩），第二个参数是压缩比例，转化为NSData类型；
    NSString* documentPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filePath = [NSString stringWithFormat:@"%@/UMSSDK/avatar.png",documentPath];
    [UIImageJPEGRepresentation(image, 1.0) writeToFile:filePath atomically:NO];
    
    //压缩图片,如果图片要上传到服务器或者网络，则需要执行该步骤（压缩），第二个参数是压缩比例，转化为NSData类型；
    [UMSSDK uploadUserAvatarWithImage:image
                         platformType:UMSPlatformTypePhone
                               result:^(UMSAvatar *avatar, NSError *error)
     {
         //更新数据资料
         if (!error)
         {
             [UMSSDK getUserInfoWithResult:^(UMSUser *user, NSError *error) {
                 
                 if (!error)
                 {
                     UMSUser *currentUser = user;
                     currentUser.avatars = avatar;
                     
                     [UMSSDK updateUserInfoWithUser:currentUser
                                             result:^(UMSUser *user, NSError *error) {
                                                      
                                                  }];
                 }
             }];
         }
     }];
    
    //判断UIPopoverController对象是否存在
    if (self.imagePickerPopover)
    {
        [self.imagePickerPopover dismissPopoverAnimated:YES];
        self.imagePickerPopover = nil;
    }
    else
    {
        //关闭以模态形式显示的UIImagePickerController
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)addNickNameModule
{
    UILabel *nickNameLabel = [[UILabel alloc] init];
    nickNameLabel.frame = CGRectMake(20, self.view.frame.size.height*0.4, self.view.frame.size.width*0.15, self.view.frame.size.width*0.1);
    nickNameLabel.text = @"昵称";
    nickNameLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:nickNameLabel];
    
    self.nickName = [[UIButton alloc] init];
    self.nickName.frame = CGRectMake(CGRectGetMaxX(nickNameLabel.frame)+15, self.view.frame.size.height*0.4, self.view.frame.size.width*0.85 - 55, self.view.frame.size.width*0.1);
    [self.nickName setTitle:@"请输入你的昵称" forState:UIControlStateNormal];
    [self.nickName setTitleColor:[UIColor colorWithRed:162/255.0 green:162/255.0 blue:162/255.0 alpha:1.0] forState:UIControlStateNormal];
    [self.nickName addTarget:self action:@selector(inputNickname) forControlEvents:UIControlEventTouchUpInside];
    [[self.nickName titleLabel] setFont:[UIFont systemFontOfSize:16]];
    self.nickName.titleLabel.textAlignment = NSTextAlignmentRight;
    self.nickName.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.view addSubview:self.nickName];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.nickName.frame)+5,self.view.frame.size.width-40 , 1.0f)];
    [line setBackgroundColor:[UIColor colorWithRed:207/255.0 green:207/255.0 blue:217/255.0 alpha:1.0]];
    [self.view addSubview:line];
}

- (void)inputNickname
{
    self.inputView = [[UMSInputViewController alloc] initWithTitle:@"昵称" andOldData:nil];
    self.inputView.delegate = self;
    
    [self.navigationController pushViewController:self.inputView animated:YES];
}

-(void)selectFinishWithData:(NSString *)data
{
    if (data && [data isKindOfClass:[NSString class]])
    {
        [self.nickName setTitle:data forState:UIControlStateNormal];
        self.userData.nickname = data;
    }
}

- (void)addGenderModule
{
    UILabel *genderLabel = [[UILabel alloc] init];
    genderLabel.frame = CGRectMake(20, CGRectGetMaxY(self.nickName.frame) + 20, self.view.frame.size.width*0.15, self.view.frame.size.width*0.1);
    genderLabel.text = @"性别";
    genderLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:genderLabel];
    
    self.gender = [[UIButton alloc] init];
    self.gender.frame = CGRectMake(CGRectGetMaxX(genderLabel.frame)+15, CGRectGetMaxY(self.nickName.frame) + 20, self.view.frame.size.width*0.85 - 55, self.view.frame.size.width*0.1);
    [self.gender setTitle:@"请选择" forState:UIControlStateNormal];
    [self.gender setTitleColor:[UIColor colorWithRed:162/255.0 green:162/255.0 blue:162/255.0 alpha:1.0] forState:UIControlStateNormal];
    [[self.gender titleLabel] setFont:[UIFont systemFontOfSize:16]];
    self.gender.titleLabel.textAlignment = NSTextAlignmentRight;
    self.gender.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.gender addTarget:self action:@selector(selectGender) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.gender];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.gender.frame)+5,self.view.frame.size.width-40 , 1.0f)];
    [line setBackgroundColor:[UIColor colorWithRed:207/255.0 green:207/255.0 blue:217/255.0 alpha:1.0]];
    [self.view addSubview:line];
}

- (void)selectOKWithData:(id)data
{
    if ([data isKindOfClass:[NSDictionary class]])
    {
        self.selectedRow = [[data objectForKey:@"Row"] integerValue];
        self.pickViewType = [[data objectForKey:@"Type"] intValue];
        self.selectedDate = [data objectForKey:@"selectedDate"];
        
        switch (self.pickViewType)
        {
            case UMSPickerViewTypeGender:
            {
                self.selectedGender = [JIMUGenderConstant genders][self.selectedRow];;
                self.userData.gender = self.selectedGender;
                [self.gender setTitle:self.selectedGender.name forState:UIControlStateNormal];
            }
                break;
            case UMSPickerViewTypeRegion:
            {
                if ([data objectForKey:@"selectedCountry"])
                {
                    NSMutableString *str = [NSMutableString string];
                    self.selectedCountry = [data objectForKey:@"selectedCountry"];
                    [str appendString:self.selectedCountry.name];
                    
                    if ([data objectForKey:@"selectedProvince"])
                    {
                        self.selectedProvice = [data objectForKey:@"selectedProvince"];
                        [str appendString:@" "];
                        [str appendString:self.selectedProvice.name];
                    }
                    else if([JIMULocationConstant provinces:self.selectedCountry].count > 0)
                    {
                        self.selectedProvice = [JIMULocationConstant provinces:self.selectedCountry][0];
                        [str appendString:@" "];
                        [str appendString:self.selectedProvice.name];
                    }
                    
                    if ([data objectForKey:@"selectedCity"])
                    {
                        self.selectedCity = [data objectForKey:@"selectedCity"];
                        [str appendString:@" "];
                        [str appendString:self.selectedCity.name];
                        self.userData.city = self.selectedCity;
                    }
                    else if ([JIMULocationConstant cities:self.selectedProvice].count >0)
                    {
                        self.selectedCity = [JIMULocationConstant cities:self.selectedProvice][0];
                        [str appendString:@" "];
                        [str appendString:self.selectedCity.name];
                    }
                    
                    self.userData.province = self.selectedProvice;
                    self.userData.country = self.selectedCountry;
                    self.userData.city = self.selectedCity;
                    [self.region setTitle:str forState:UIControlStateNormal];
                }
            }
                break;
            default:
                break;
        }
    }
    
    if (_window)
    {
        [_window resignKeyWindow];
        _window.hidden = YES;
        _window = nil;
    }
}

- (void)selectCancel
{
    if (_window)
    {
        [_window resignKeyWindow];
        _window.hidden = YES;
        _window = nil;
    }
}

- (void)addRegionModule
{
    UILabel *regionLabel = [[UILabel alloc] init];
    regionLabel.frame = CGRectMake(20, CGRectGetMaxY(self.gender.frame) + 20, self.view.frame.size.width*0.15, self.view.frame.size.width*0.1);
    regionLabel.text = @"地区";
    regionLabel.font = [UIFont systemFontOfSize:16];
    [self.view addSubview:regionLabel];
    
    self.region = [[UIButton alloc] init];
    self.region.frame = CGRectMake(CGRectGetMaxX(regionLabel.frame)+15, CGRectGetMaxY(self.gender.frame) + 20, self.view.frame.size.width*0.85 - 55, self.view.frame.size.width*0.1);
    [self.region setTitle:@"请选择" forState:UIControlStateNormal];
    [self.region setTitleColor:[UIColor colorWithRed:162/255.0 green:162/255.0 blue:162/255.0 alpha:1.0] forState:UIControlStateNormal];
    [[self.region titleLabel] setFont:[UIFont systemFontOfSize:16]];
    self.region.titleLabel.textAlignment = NSTextAlignmentRight;
    self.region.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.region addTarget:self action:@selector(selectRegion) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.region];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.region.frame)+5,self.view.frame.size.width-40 , 1.0f)];
    [line setBackgroundColor:[UIColor colorWithRed:207/255.0 green:207/255.0 blue:217/255.0 alpha:1.0]];
    [self.view addSubview:line];
}

- (void)selectGender
{
    self.pickView = [[UMSPickerViewController alloc] initWithType:UMSPickerViewTypeGender];
    self.pickView.delegate = self;
    
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.windowLevel = [UIApplication sharedApplication].keyWindow.windowLevel + 1;
    _window.userInteractionEnabled = YES;
    _window.rootViewController = self.pickView;
    [_window makeKeyAndVisible];
}

- (void)selectRegion
{
    self.pickView = [[UMSPickerViewController alloc] initWithType:UMSPickerViewTypeRegion];
    self.pickView.delegate = self;
    
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.windowLevel = [UIApplication sharedApplication].keyWindow.windowLevel + 1;
    _window.userInteractionEnabled = YES;
    _window.rootViewController = self.pickView;
    [_window makeKeyAndVisible];
}

- (void)submitButtonAction:(id)sender
{
    [UMSSDK updateUserInfoWithUser:self.userData
                            result:^(UMSUser *user, NSError *error)
    {
                                     if (error)
                                     {
                                         [UMSAlertView showAlertViewWithTitle:@"提交失败"
                                                                      message:[error description]
                                                              leftActionTitle:@"好的"
                                                             rightActionTitle:nil
                                                               animationStyle:AlertViewAnimationZoom
                                                                 selectAction:nil];
                                     }
                                     else
                                     {                                        
                                         [UMSAlertView showAlertViewWithTitle:@"提交成功"
                                                                      message:@""
                                                              leftActionTitle:@"好的"
                                                             rightActionTitle:nil
                                                               animationStyle:AlertViewAnimationZoom
                                                                 selectAction:^(AlertViewActionType actionType) {
                                                                     
//                                                                     UMSProfileViewController *profile = [[UMSProfileViewController alloc] init];
//                                                                     
//                                                                     UMSBaseNavigationController *nav = [[UMSBaseNavigationController alloc] initWithRootViewController:profile];
//                                                                     
//                                                                     [[MOBFViewController currentViewController] presentViewController:nav animated:YES completion:^{
//                                                                         
//                                                                     }];
                                                                     
                                                                     [self dismissViewControllerAnimated:YES completion:nil];
                                                                 }];
                                     }
                                 }];
}

- (void)rightItemClicked:(id)sender
{
//    UMSProfileViewController *profile = [[UMSProfileViewController alloc] init];
//    UMSBaseNavigationController *nav = [[UMSBaseNavigationController alloc] initWithRootViewController:profile];
//    [[MOBFViewController currentViewController] presentViewController:nav animated:YES completion:^{
//
//    }];
//    [self.navigationController pushViewController:profile
//                                         animated:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
