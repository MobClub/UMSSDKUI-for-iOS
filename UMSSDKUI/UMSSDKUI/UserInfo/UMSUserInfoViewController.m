//
//  UMSUserInfoViewController.m
//  UMSSDKUI
//
//  Created by 刘靖煌 on 17/2/26.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import "UMSUserInfoViewController.h"
#import "UMSImage.h"
#import "UMSAccountBindingViewController.h"
#import "UMSBaseNavigationController.h"
#import "UMSAccessoryView.h"
#import "UMSPlatformAccountBindingCell.h"
#import <UMSSDK/UMSSDK.h>
#import "UMSInputViewController.h"
#import "UMSPickerViewController.h"
#import <MOBFoundation/MOBFoundation.h>
#import "UMSAlertView.h"
#import "NSDate+UMSSDK.h"
#import "UMSActionSheet.h"
#import "UIBarButtonItem+UMS.h"
#import "UMSBaseTableViewCell.h"

@interface UMSUserInfoViewController ()<UINavigationControllerDelegate,IUMSInputViewControllerDelegate,UIImagePickerControllerDelegate, UIPopoverControllerDelegate,IUMSPickerViewControllerDelegate>

@property (nonatomic, strong) NSMutableArray *supportedPlatform;
@property (nonatomic, strong) UMSInputViewController *inputView;
@property (strong, nonatomic) UIPopoverController *imagePickerPopover;
@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UMSPickerViewController *pickView;

@property (nonatomic, strong) UMSAccessoryView *nicknameAccessory;
@property (nonatomic, strong) UMSAccessoryView *genderAccessory;
@property (nonatomic, strong) UMSAccessoryView *birthdayAccessory;
@property (nonatomic, strong) UMSAccessoryView *ageAccessory;
@property (nonatomic, strong) UMSAccessoryView *constellationAccessory;

@property (nonatomic, strong) UMSAccessoryView *zodiacAccessory;
@property (nonatomic, strong) UMSAccessoryView *locationAccessory;
@property (nonatomic, strong) UMSAccessoryView *signatureAccessory;
@property (nonatomic, strong) UMSAccessoryView *emailAccessory;
@property (nonatomic, strong) UMSAccessoryView *addressAccessory;

@property (nonatomic, strong) UMSAccessoryView *zipCodeAccessory;
@property (nonatomic, strong) UMSUser *user;
@property (nonatomic, assign) NSInteger selectedRow;
@property (nonatomic, assign) UMSPickerViewType pickViewType;
@property (nonatomic, strong) UIButton *avatar;

@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, strong) JIMULocationConstant *selectedCountry;
@property (nonatomic, strong) JIMULocationConstant *selectedProvice;
@property (nonatomic, strong) JIMULocationConstant *selectedCity;

@end

@implementation UMSUserInfoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 左边按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"return.png"
                                                                 highIcon:@"return.png"
                                                                   target:self
                                                                   action:@selector(leftItemClicked:)];
    
    [UMSSDK supportedLoginPlatforms:^(NSArray *supportedPlatforms) {
        
        if ([supportedPlatforms isKindOfClass:[NSArray class]])
        {
            self.supportedPlatform = [NSMutableArray arrayWithArray:supportedPlatforms];
            [self.supportedPlatform addObject:@(0)];
        }
    }];
    
    //中间的标题
    UILabel *navTitle = [[UILabel alloc] init];
    navTitle.frame = CGRectMake(0, 0 , 35, 35);
    navTitle.text = @"个人信息";
    navTitle.font = [UIFont systemFontOfSize:16];
    self.navigationItem.titleView = navTitle;
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.navigationItem.hidesBackButton = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // 将导航条变透明
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = nil;
    
    NSIndexPath *path = [NSIndexPath indexPathForRow:12 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)leftItemClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 13;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 1.创建cell
    static NSString *ID = @"cell";
    UMSBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil)
    {
        cell = [[UMSBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
    }
    
    cell.selectionStyle =UITableViewCellSelectionStyleNone;
    UMSUser *currentUser = [UMSSDK currentUser];
    
    // 2.设置cell的数据
    switch (indexPath.row)
    {
        case 0:
        {
            cell.textLabel.text = @"头像";
            self.avatar = [UIButton buttonWithType:UIButtonTypeSystem];
            self.avatar.frame = CGRectMake(0.0f, 0.0f, 30.0f, 30.0f);
            
            if (currentUser.avatars.middle)
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
                    [[MOBFImageGetter sharedInstance] getImageWithURL:[NSURL URLWithString:currentUser.avatars.middle]
                                                               result:^(UIImage *image, NSError *error) {
                                                                   
                                                                   self.avatar.layer.contents = (id)[image CGImage];
                                                                   [UIImageJPEGRepresentation(image, 1.0) writeToFile:filePath atomically:NO];
                                                                   
                                                               }];
                }
            }
            else
            {
                self.avatar.layer.contents = (id)[[UMSImage imageNamed:@"toux02.png"] CGImage];
            }
            
            [self.avatar.layer setCornerRadius:CGRectGetHeight([self.avatar bounds]) / 2];
            self.avatar.layer.masksToBounds = YES;
            [self.avatar addTarget:self
                            action:@selector(changeAvatar:)
                  forControlEvents:UIControlEventTouchUpInside];
            cell.accessoryView = self.avatar;
        }
            break;
        case 1:
        {
            if (currentUser.nickname)
            {
                self.nicknameAccessory = [[UMSAccessoryView alloc] initWithTitle:currentUser.nickname];
            }
            else
            {
                self.nicknameAccessory = [[UMSAccessoryView alloc] initWithTitle:@"未填写"];
            }
            
            cell.textLabel.text = @"昵称";
            self.nicknameAccessory.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 85, 50, 70, 50);
            cell.accessoryView = self.nicknameAccessory;
            
            break;
        }
        case 2:
        {
            if (currentUser.gender)
            {
                cell.textLabel.text = @"性别";
                self.genderAccessory = [[UMSAccessoryView alloc] initWithTitle:currentUser.gender.name];
                self.genderAccessory.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 85, 50, 70, 50);
                cell.accessoryView = self.genderAccessory;
            }
            else
            {
                cell.textLabel.text = @"性别";
                self.genderAccessory = [[UMSAccessoryView alloc] initWithTitle:@"未填写"];
                self.genderAccessory.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 85, 50, 70, 50);
                cell.accessoryView = self.genderAccessory;
            }
            break;
        }
        case 3:
        {
            if (currentUser.birthday)
            {
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                dateFormatter.dateFormat = @"yyyy年MM月dd日";
                NSString *dateStr = [dateFormatter stringFromDate:currentUser.birthday];
                
                cell.textLabel.text = @"出生日期";
                self.birthdayAccessory = [[UMSAccessoryView alloc] initWithTitle:dateStr];
                self.birthdayAccessory.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 85, 50, 70, 50);
                cell.accessoryView = self.birthdayAccessory;
                break;
            }
            else
            {
                cell.textLabel.text = @"出生日期";
                self.birthdayAccessory = [[UMSAccessoryView alloc] initWithTitle:@"未填写"];
                self.birthdayAccessory.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 85, 50, 70, 50);
                cell.accessoryView = self.birthdayAccessory;
                break;
            }
        }
        case 4:
        {
            if ([currentUser.age integerValue] > 0)
            {
                cell.textLabel.text = @"年龄";
                self.ageAccessory = [[UMSAccessoryView alloc] initWithTitle:[NSString stringWithFormat:@"%zi",[currentUser.age integerValue]]];
                self.ageAccessory.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 85, 50, 70, 50);
                cell.accessoryView = self.ageAccessory;
            }
            else
            {
                cell.textLabel.text = @"年龄";
                self.ageAccessory = [[UMSAccessoryView alloc] initWithTitle:@"未填写"];
                self.ageAccessory.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 85, 50, 70, 50);
                cell.accessoryView = self.ageAccessory;
            }
            break;
        }
        case 5:
        {
            if (currentUser.constellation)
            {
                cell.textLabel.text = @"星座";
                self.constellationAccessory = [[UMSAccessoryView alloc] initWithTitle:currentUser.constellation.name];
                self.constellationAccessory.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 85, 50, 70, 50);
                cell.accessoryView = self.constellationAccessory;
            }
            else
            {
                cell.textLabel.text = @"星座";
                self.constellationAccessory = [[UMSAccessoryView alloc] initWithTitle:@"未填写"];
                self.constellationAccessory.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 85, 50, 70, 50);
                cell.accessoryView = self.constellationAccessory;
            }
            break;
        }
        case 6:
        {
            if (currentUser.zodiac)
            {
                cell.textLabel.text = @"生肖";
                self.zodiacAccessory = [[UMSAccessoryView alloc] initWithTitle:currentUser.zodiac.name];
                self.zodiacAccessory.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 85, 50, 70, 50);
                cell.accessoryView = self.zodiacAccessory;
            }
            else
            {
                cell.textLabel.text = @"生肖";
                self.zodiacAccessory = [[UMSAccessoryView alloc] initWithTitle:@"未填写"];
                self.zodiacAccessory.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 85, 50, 70, 50);
                cell.accessoryView = self.zodiacAccessory;
            }
            break;
        }
        case 7:
        {
            NSMutableString *site;
            
            if (currentUser.country)
            {
                site = [NSMutableString string];
                [site appendString:currentUser.country.name];
                
                if (currentUser.province)
                {
                    [site appendString:@","];
                    [site appendString:currentUser.province.name];
                    
                    if (currentUser.city)
                    {
                        [site appendString:@","];
                        [site appendString:currentUser.city.name];
                    }
                }
            }
            
            if (site)
            {
                cell.textLabel.text = @"所在地";
                self.locationAccessory = [[UMSAccessoryView alloc] initWithTitle:site];
                self.locationAccessory.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 85, 50, 70, 50);
                cell.accessoryView = self.locationAccessory;
            }
            else
            {
                cell.textLabel.text = @"所在地";
                self.locationAccessory = [[UMSAccessoryView alloc] initWithTitle:@"未填写"];
                self.locationAccessory.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 85, 50, 70, 50);
                cell.accessoryView = self.locationAccessory;
            }

            break;
        }
        case 8:
        {
            if (currentUser.signature)
            {
                cell.textLabel.text = @"个性签名";
                self.signatureAccessory = [[UMSAccessoryView alloc] initWithTitle:currentUser.signature];
                self.signatureAccessory.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 85, 50, 70, 50);
                cell.accessoryView = self.signatureAccessory;
            }
            else
            {
                cell.textLabel.text = @"个性签名";
                self.signatureAccessory = [[UMSAccessoryView alloc] initWithTitle:@"未填写"];
                self.signatureAccessory.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 85, 50, 70, 50);
                cell.accessoryView = self.signatureAccessory;
            }
            break;
        }
        case 9:
        {
            if (currentUser.email)
            {
                cell.textLabel.text = @"电子邮箱";
                self.emailAccessory = [[UMSAccessoryView alloc] initWithTitle:currentUser.email];
                self.emailAccessory.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 85, 50, 70, 50);
                cell.accessoryView = self.emailAccessory;
            }
            else
            {
                cell.textLabel.text = @"电子邮箱";
                self.emailAccessory = [[UMSAccessoryView alloc] initWithTitle:@"未填写"];
                self.emailAccessory.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 85, 50, 70, 50);
                cell.accessoryView = self.emailAccessory;
            }
            break;
        }
        case 10:
        {
            if (currentUser.address)
            {
                self.addressAccessory = [[UMSAccessoryView alloc] initWithTitle:currentUser.address];
            }
            else
            {
                self.addressAccessory = [[UMSAccessoryView alloc] initWithTitle:@"未填写"];
            }
            
            cell.textLabel.text = @"地址";
            self.addressAccessory.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 85, 50, 70, 50);
            cell.accessoryView = self.addressAccessory;
            
            break;
        }
        case 11:
        {
            if (currentUser.zipCode > 0)
            {
                self.zipCodeAccessory = [[UMSAccessoryView alloc] initWithTitle:[NSString stringWithFormat:@"%ld",(long)currentUser.zipCode]];
            }
            else
            {
                self.zipCodeAccessory = [[UMSAccessoryView alloc] initWithTitle:@"未填写"];
            }
            
            cell.textLabel.text = @"邮编";
            self.zipCodeAccessory.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 85, 50, 70, 50);
            cell.accessoryView = self.zipCodeAccessory;
            break;
        }
        case 12:
        {
            UMSPlatformAccountBindingCell *platformCell = [[UMSPlatformAccountBindingCell alloc] init];
            return platformCell;
            break;
        }
        default:
            cell.textLabel.text = @"个人资料";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            break;
    }
    
    return cell;
}

-(void)changeAvatar:(id)sender
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
    
//    [self.avatar setBackgroundImage:image forState:UIControlStateNormal];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UMSUser *currentUser = [UMSSDK currentUser];
    
    switch (indexPath.row)
    {
        case 0:
        {
            [self changeAvatar:nil];
        }
            break;
        case 1:
        {
            self.inputView = [[UMSInputViewController alloc] initWithTitle:@"昵称" andOldData:currentUser.nickname];
            self.inputView.delegate = self;
            self.inputView.view.tag = indexPath.row;
            [self.navigationController pushViewController:self.inputView animated:YES];
            break;
        }
        case 2:
        {
            //性别
            [self selectGender];
            break;
        }
        case 3:
        {
            //出生日期
            [self selectBirthday];
            break;
        }
        case 4:
        {
            //年龄
            [self selectAge];
            break;
        }
        case 5:
        {
            //星座
            [self selectConstellation];
            break;
        }
        case 6:
        {
            //生肖
            [self selectZodiac];
            break;
        }
        case 7:
        {
            //所在地
            [self selectRegion];
            break;
        }
        case 8:
        {
            //个性签名
            self.inputView = [[UMSInputViewController alloc] initWithTitle:@"个性签名" andOldData:currentUser.signature];
            self.inputView.delegate = self;
            self.inputView.view.tag = indexPath.row;
            [self.navigationController pushViewController:self.inputView animated:YES];
            break;
        }
        case 9:
        {
            //电子邮箱
            self.inputView = [[UMSInputViewController alloc] initWithTitle:@"电子邮箱" andOldData:currentUser.email];
            self.inputView.delegate = self;
            self.inputView.view.tag = indexPath.row;
            [self.navigationController pushViewController:self.inputView animated:YES];
            break;
        }
        case 10:
        {
            //地址
            self.inputView = [[UMSInputViewController alloc] initWithTitle:@"地址" andOldData:currentUser.address];
            self.inputView.delegate = self;
            self.inputView.view.tag = indexPath.row;
            [self.navigationController pushViewController:self.inputView animated:YES];
            break;
        }
        case 11:
        {
            //邮编
            if (currentUser.zipCode > 0)
            {
                self.inputView = [[UMSInputViewController alloc] initWithTitle:@"邮编" andOldData:[NSString stringWithFormat:@"%zi",currentUser.zipCode]];
            }
            else
            {
                self.inputView = [[UMSInputViewController alloc] initWithTitle:@"邮编" andOldData:nil];
            }
            
            self.inputView.delegate = self;
            self.inputView.view.tag = indexPath.row;
            [self.navigationController pushViewController:self.inputView animated:YES];
            break;
        }
        case 12:
        {
            UMSAccountBindingViewController *accountVC = [[UMSAccountBindingViewController alloc] initWithSupportedPlatform:self.supportedPlatform];
            [self.navigationController pushViewController:accountVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -
#pragma mark - PickerViewController

- (void)selectGender
{
    self.pickView = [[UMSPickerViewController alloc] initWithType:UMSPickerViewTypeGender];
    self.pickView.delegate = self;
    self.pickViewType = UMSPickerViewTypeGender;
    
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.windowLevel = [UIApplication sharedApplication].keyWindow.windowLevel + 1;
    _window.userInteractionEnabled = YES;
    _window.rootViewController = self.pickView;
    [_window makeKeyAndVisible];
}

- (void)selectBirthday
{
    self.pickView = [[UMSPickerViewController alloc] initWithType:UMSPickerViewTypeBirthday];
    self.pickView.delegate = self;
    self.pickViewType = UMSPickerViewTypeBirthday;
    
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
    self.pickViewType = UMSPickerViewTypeRegion;
    
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.windowLevel = [UIApplication sharedApplication].keyWindow.windowLevel + 1;
    _window.userInteractionEnabled = YES;
    _window.rootViewController = self.pickView;
    [_window makeKeyAndVisible];
}

- (void)selectAge
{
    self.pickView = [[UMSPickerViewController alloc] initWithType:UMSPickerViewTypeAge];
    self.pickView.delegate = self;
    self.pickViewType = UMSPickerViewTypeAge;
    
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.windowLevel = [UIApplication sharedApplication].keyWindow.windowLevel + 1;
    _window.userInteractionEnabled = YES;
    _window.rootViewController = self.pickView;
    [_window makeKeyAndVisible];
}

- (void)selectConstellation
{
    self.pickView = [[UMSPickerViewController alloc] initWithType:UMSPickerViewTypeConstellation];
    self.pickView.delegate = self;
    self.pickViewType = UMSPickerViewTypeConstellation;
    
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.windowLevel = [UIApplication sharedApplication].keyWindow.windowLevel + 1;
    _window.userInteractionEnabled = YES;
    _window.rootViewController = self.pickView;
    [_window makeKeyAndVisible];
}

- (void)selectZodiac
{
    self.pickView = [[UMSPickerViewController alloc] initWithType:UMSPickerViewTypeZodiac];
    self.pickView.delegate = self;
    self.pickViewType = UMSPickerViewTypeZodiac;
    
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.windowLevel = [UIApplication sharedApplication].keyWindow.windowLevel + 1;
    _window.userInteractionEnabled = YES;
    _window.rootViewController = self.pickView;
    [_window makeKeyAndVisible];
}

- (void)selectOKWithData:(id)data
{
    if ([data isKindOfClass:[NSDictionary class]])
    {
        self.selectedRow = [[data objectForKey:@"Row"] integerValue];
        self.pickViewType = [[data objectForKey:@"Type"] intValue];
        self.selectedDate = [data objectForKey:@"selectedDate"];
    }
    
    switch (self.pickViewType)
    {
        case UMSPickerViewTypeConstellation:
        {
            self.constellationAccessory.text.text = [JIMUConstellationConstant constellations][self.selectedRow].name;
            self.user.constellation = [JIMUConstellationConstant constellations][self.selectedRow];
            
            UMSUser *currentUser = [UMSSDK currentUser];
            currentUser.constellation = [JIMUConstellationConstant constellations][self.selectedRow];
            
            [UMSSDK updateUserInfoWithUser:currentUser
                                    result:^(UMSUser *user, NSError *error) {
                                        
                                        if (error)
                                        {
                                            [UMSAlertView showAlertViewWithTitle:@"修改资料失败"
                                                                         message:[error description]
                                                                 leftActionTitle:@"好的"
                                                                rightActionTitle:nil
                                                                  animationStyle:AlertViewAnimationZoom
                                                                    selectAction:^(AlertViewActionType actionType) {
                                                                        
                                                                    }];
                                        }
                                        
                                         }];
        }
            
            break;
        case UMSPickerViewTypeZodiac:
        {
            self.zodiacAccessory.text.text = [JIMUZodiacConstant zodiacs][self.selectedRow].name;
            self.user.zodiac = [JIMUZodiacConstant zodiacs][self.selectedRow];
            
            UMSUser *currentUser = [UMSSDK currentUser];
            currentUser.zodiac = [JIMUZodiacConstant zodiacs][self.selectedRow];
            
            [UMSSDK updateUserInfoWithUser:currentUser
                                    result:^(UMSUser *user, NSError *error) {
                                        
                                        if (error)
                                        {
                                            [UMSAlertView showAlertViewWithTitle:@"修改资料失败"
                                                                         message:[error description]
                                                                 leftActionTitle:@"好的"
                                                                rightActionTitle:nil
                                                                  animationStyle:AlertViewAnimationZoom
                                                                    selectAction:^(AlertViewActionType actionType) {
                                                                        
                                                                    }];
                                        }
                                        
                                         }];
        }
            break;
        case UMSPickerViewTypeAge:
        {
            self.ageAccessory.text.text = [NSString stringWithFormat:@"%zi",self.selectedRow+1];
            self.user.age = @(self.selectedRow + 1);
            
            UMSUser *currentUser = [UMSSDK currentUser];
            currentUser.age = @(self.selectedRow + 1);
            
            [UMSSDK updateUserInfoWithUser:currentUser
                                    result:^(UMSUser *user, NSError *error) {
                                        
                                        if (error)
                                        {
                                            [UMSAlertView showAlertViewWithTitle:@"修改资料失败"
                                                                         message:[error description]
                                                                 leftActionTitle:@"好的"
                                                                rightActionTitle:nil
                                                                  animationStyle:AlertViewAnimationZoom
                                                                    selectAction:^(AlertViewActionType actionType) {
                                                                        
                                                                    }];
                                        }
                                        
                                         }];
        }
            break;
        case UMSPickerViewTypeGender:
        {
            self.genderAccessory.text.text = [JIMUGenderConstant genders][self.selectedRow].name;
            
            UMSUser *currentUser = [UMSSDK currentUser];
            currentUser.gender = [JIMUGenderConstant genders][self.selectedRow];
            
            [UMSSDK updateUserInfoWithUser:currentUser
                                    result:^(UMSUser *user, NSError *error) {
                                        
                                        if (error)
                                        {
                                            [UMSAlertView showAlertViewWithTitle:@"修改资料失败"
                                                                         message:[error description]
                                                                 leftActionTitle:@"好的"
                                                                rightActionTitle:nil
                                                                  animationStyle:AlertViewAnimationZoom
                                                                    selectAction:^(AlertViewActionType actionType) {
                                                                        
                                                                    }];
                                        }
                                        
                                         }];
            
        }
            break;
        case UMSPickerViewTypeBirthday:
        {
            if (self.selectedDate)
            {
                NSTimeInterval selectedTime = [self.selectedDate timeIntervalSince1970];
                NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
                NSUInteger theAge = [NSDate getAgeWith:self.selectedDate];
                
                if (selectedTime > nowTime)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [UMSAlertView showAlertViewWithTitle:nil
                                                     message:@"出生日期不能超过当前时间"
                                             leftActionTitle:@"好的"
                                            rightActionTitle:nil
                                              animationStyle:AlertViewAnimationZoom
                                                selectAction:nil];
                        
                    });
                }
                else if(theAge > 150)
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        [UMSAlertView showAlertViewWithTitle:nil
                                                     message:@"出生日期不能超过150年前"
                                             leftActionTitle:@"好的"
                                            rightActionTitle:nil
                                              animationStyle:AlertViewAnimationZoom
                                                selectAction:nil];
                        
                    });
                }
                else
                {
                    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                    formatter.dateFormat = @"yyyy年MM月dd日";
                    NSString *dateStr = [formatter stringFromDate:self.selectedDate];
                    
                    NSString *zodiac = [NSDate getZodiacWith:self.selectedDate];
                    NSString *zodiacString = [NSString stringWithFormat:@"%lu",strtoul([zodiac UTF8String],0,16)];
                    NSInteger zodiacValue = [zodiacString integerValue];
                    
                    NSString *constellation = [NSDate getConstellationFromBirthday:self.selectedDate];
                    constellation = [constellation substringToIndex:1];//截取掉下标1之前的字符串
                    NSString *constellationString = [NSString stringWithFormat:@"%lu",strtoul([constellation UTF8String],0,16)];
                    NSInteger constellationValue = [constellationString integerValue];
                    
                    self.birthdayAccessory.text.text = dateStr;
                    self.ageAccessory.text.text = [NSString stringWithFormat:@"%zi",theAge];
                    self.zodiacAccessory.text.text = [JIMUZodiacConstant getZodiac:zodiacValue].name;
                    self.constellationAccessory.text.text =[JIMUConstellationConstant getConstellation:constellationValue].name;
                    
                    UMSUser *currentUser = [UMSSDK currentUser];
                    currentUser.birthday = self.selectedDate;
                    currentUser.age = @(theAge);
                    currentUser.zodiac = [JIMUZodiacConstant getZodiac:zodiacValue];
                    currentUser.constellation = [JIMUConstellationConstant getConstellation:constellationValue];
                    
                    [UMSSDK updateUserInfoWithUser:currentUser
                                            result:^(UMSUser *user, NSError *error) {
                                                
                                                if (error)
                                                {
                                                    NSDictionary *userInfo = [error userInfo];
                                                    NSInteger status = [[userInfo objectForKey:@"status"] integerValue];
                                                    
                                                    switch (status)
                                                    {
                                                        case 431:
                                                        {
                                                            [UMSAlertView showAlertViewWithTitle:@"提交修改资料失败，请重新选择日期"
                                                                                         message:@"出生日期不能超过当前时间"
                                                                                 leftActionTitle:@"好的"
                                                                                rightActionTitle:nil
                                                                                  animationStyle:AlertViewAnimationZoom
                                                                                    selectAction:nil];
                                                        }
                                                            break;
                                                            
                                                        default:
                                                        {
                                                            [UMSAlertView showAlertViewWithTitle:@"修改资料失败"
                                                                                         message:[error description]
                                                                                 leftActionTitle:@"好的"
                                                                                rightActionTitle:nil
                                                                                  animationStyle:AlertViewAnimationZoom
                                                                                    selectAction:nil];
                                                        }
                                                            break;
                                                    }
                                                }
                                            }];
                }
            }
        }
            break;
        case UMSPickerViewTypeRegion:
        {
            if ([data objectForKey:@"selectedCountry"])
            {
                UMSUser *currentUser = [UMSSDK currentUser];
                NSMutableString *str = [NSMutableString string];
                self.selectedCountry = [data objectForKey:@"selectedCountry"];
                [str appendString:self.selectedCountry.name];
                currentUser.country = self.selectedCountry;
                
                if ([data objectForKey:@"selectedProvince"])
                {
                    self.selectedProvice = [data objectForKey:@"selectedProvince"];
                    currentUser.province = self.selectedProvice;
                    [str appendString:@" "];
                    [str appendString:self.selectedProvice.name];
                }
                else if([JIMULocationConstant provinces:self.selectedCountry].count > 0)
                {
                    self.selectedProvice = [JIMULocationConstant provinces:self.selectedCountry][0];
                    currentUser.province = self.selectedProvice;
                    [str appendString:@" "];
                    [str appendString:self.selectedProvice.name];
                }
                else
                {
                    currentUser.province = nil;
                }
                
                if ([data objectForKey:@"selectedCity"])
                {
                    self.selectedCity = [data objectForKey:@"selectedCity"];
                    currentUser.city = self.selectedCity;
                    [str appendString:@" "];
                    [str appendString:self.selectedCity.name];
                }
                else if ([JIMULocationConstant cities:self.selectedProvice].count >0)
                {
                    self.selectedCity = [JIMULocationConstant cities:self.selectedProvice][0];
                    currentUser.city = self.selectedCity;
                    [str appendString:@" "];
                    [str appendString:self.selectedCity.name];
                }
                else
                {
                    currentUser.city = nil;
                }
                
                self.locationAccessory.text.text = str;
                [UMSSDK updateUserInfoWithUser:currentUser
                                        result:^(UMSUser *user, NSError *error) {
                                            
                                            if (error)
                                            {
                                                [UMSAlertView showAlertViewWithTitle:@"修改资料失败"
                                                                             message:[error description]
                                                                     leftActionTitle:@"好的"
                                                                    rightActionTitle:nil
                                                                      animationStyle:AlertViewAnimationZoom
                                                                        selectAction:nil];
                                            }
                                        }];
            }
        }
            break;
        default:
            break;
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

-(void)selectFinishWithData:(NSString *)data type:(id)typetap
{
    if (data)
    {
        switch ([typetap integerValue])
        {
            case 0:
            {
                
            }
                break;
            case 1:
            {
                if (data)
                {
                    self.nicknameAccessory.text.text = data;
                    self.user.nickname = data;
                    
                    UMSUser *currentUser = [UMSSDK currentUser];
                    currentUser.nickname = data;
                    
                    [UMSSDK updateUserInfoWithUser:currentUser
                                            result:^(UMSUser *user, NSError *error) {
                                                
                                                /**
                                                if (error)
                                                {
                                                    [UMSAlertView showAlertViewWithTitle:@"修改资料失败"
                                                                                 message:[error description]
                                                                         leftActionTitle:@"好的"
                                                                        rightActionTitle:nil
                                                                          animationStyle:AlertViewAnimationZoom
                                                                            selectAction:nil];
                                                }
                                                 */
                                            }];
                }
                break;
            }
            case 2:
            {
                //性别
                
                break;
            }
            case 3:
            {
                //出生日期
                
                break;
            }
            case 4:
            {
                //年龄
                
                break;
            }
            case 5:
            {
                //星座
                break;
            }
            case 6:
            {
                //生肖
                break;
            }
            case 7:
            {
                //所在地
                break;
            }
            case 8:
            {
                //个性签名
                if (data)
                {
                    self.signatureAccessory.text.text = data;
                    self.user.signature = data;
                    
                    UMSUser *currentUser = [UMSSDK currentUser];
                    currentUser.signature = data;
                    
                    [UMSSDK updateUserInfoWithUser:currentUser
                                            result:^(UMSUser *user, NSError *error) {
                                                
                                                if (error)
                                                {
                                                    [UMSAlertView showAlertViewWithTitle:@"修改资料失败"
                                                                                 message:[error description]
                                                                         leftActionTitle:@"好的"
                                                                        rightActionTitle:nil
                                                                          animationStyle:AlertViewAnimationZoom
                                                                            selectAction:^(AlertViewActionType actionType) {
                                                                                
                                                                            }];
                                                }
                                                
                                                 }];
                }
                
                break;
            }
            case 9:
            {
                //电子邮箱
                if (data)
                {
                    self.emailAccessory.text.text = data;
                    self.user.email = data;
                    
                    UMSUser *currentUser = [UMSSDK currentUser];
                    currentUser.email = data;
                    
                    [UMSSDK updateUserInfoWithUser:currentUser
                                            result:^(UMSUser *user, NSError *error) {
                                                
                                                if (error)
                                                {
                                                    NSInteger status = [[[error userInfo] objectForKey:@"status"] integerValue];
                                                    switch (status)
                                                    {
                                                        case 431:
                                                        {
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                
                                                                [UMSAlertView showAlertViewWithTitle:@"修改资料失败"
                                                                                             message:@"邮件格式有误"
                                                                                     leftActionTitle:@"好的"
                                                                                    rightActionTitle:nil
                                                                                      animationStyle:AlertViewAnimationZoom
                                                                                        selectAction:nil];
                                                                
                                                            });
                                                        }
                                                            break;
                                                            
                                                        default:
                                                            [UMSAlertView showAlertViewWithTitle:@"修改资料失败"
                                                                                         message:[error description]
                                                                                 leftActionTitle:@"好的"
                                                                                rightActionTitle:nil
                                                                                  animationStyle:AlertViewAnimationZoom
                                                                                    selectAction:nil];
                                                            break;
                                                    }
                                                    
                                                    UMSUser *currentUser = [UMSSDK currentUser];
                                                    
                                                    if (currentUser.email)
                                                    {
                                                        self.emailAccessory.text.text = currentUser.email;
                                                    }
                                                    else
                                                    {
                                                        self.emailAccessory.text.text = @"未填写";
                                                    }
                                                }
                                            }];
                }
                
                break;
            }
            case 10:
            {
                //地址
                if (data)
                {
                    self.addressAccessory.text.text = data;
                    self.user.address = data;
                    
                    UMSUser *currentUser = [UMSSDK currentUser];
                    currentUser.address = data;
                    
                    [UMSSDK updateUserInfoWithUser:currentUser
                                            result:^(UMSUser *user, NSError *error) {
                                                
                                                if (error)
                                                {
                                                    [UMSAlertView showAlertViewWithTitle:@"修改资料失败"
                                                                                 message:[error description]
                                                                         leftActionTitle:@"好的"
                                                                        rightActionTitle:nil
                                                                          animationStyle:AlertViewAnimationZoom
                                                                            selectAction:^(AlertViewActionType actionType) {
                                                                                
                                                                            }];
                                                }
                                                
                                                 }];
                }
                
                break;
            }
            case 11:
            {
                //邮编
                if (data)
                {
                    self.zipCodeAccessory.text.text = data;
                    self.user.zipCode = [data integerValue];
                    
                    UMSUser *currentUser = [UMSSDK currentUser];
                    currentUser.zipCode = [data integerValue];
                    
                    [UMSSDK updateUserInfoWithUser:currentUser
                                            result:^(UMSUser *user, NSError *error) {
                                                
                                                if (error)
                                                {
                                                    [UMSAlertView showAlertViewWithTitle:@"修改资料失败"
                                                                                 message:[error description]
                                                                         leftActionTitle:@"好的"
                                                                        rightActionTitle:nil
                                                                          animationStyle:AlertViewAnimationZoom
                                                                            selectAction:^(AlertViewActionType actionType) {
                                                                                
                                                                            }];
                                                }
                                                
                                                 }];
                }
                break;
            }
            case 12:
            {
                
            }
                break;
                
            default:
                break;
        }
    }
}

@end
