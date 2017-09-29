//
//  UMSPickerViewController.m
//  UMSSDKUI
//
//  Created by 刘靖煌 on 17/2/27.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import "UMSPickerViewController.h"
#import <MOBFoundation/MOBFoundation.h>
#import <JiMu/JIMULocationConstant.h>
#import <JiMu/JIMUGenderConstant.h>
#import <JiMu/JIMUConstellationConstant.h>
#import <JiMu/JIMUZodiacConstant.h>

@interface UMSPickerViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic, strong) UIPickerView *genderPicker;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) NSString *selectedTitle;
@property (nonatomic, assign) UMSPickerViewType type;

@property (nonatomic, strong) JIMULocationConstant *selectedCountry;
@property (nonatomic, strong) JIMULocationConstant *selectedProvice;
@property (nonatomic, strong) JIMULocationConstant *selectedCity;
@property (nonatomic, strong) NSArray *selectedProvices;
@property (nonatomic, strong) NSArray *selectedCities;

@property (nonatomic, assign) NSInteger selectedCountryRow;
@property (nonatomic, assign) NSInteger selectedProviceRow;

@property (nonatomic, strong) JIMUGenderConstant *selectedGender;
@property (nonatomic, assign) NSInteger selectedRow;
@property (nonatomic, assign) UMSPickerViewType pickViewType;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) NSDate *selectedDate;

@end

@implementation UMSPickerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [MOBFColor colorWithARGB:0x4c000000];
    
    if (self.type == UMSPickerViewTypeBirthday)
    {
        self.datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 200, self.view.frame.size.width, 200)];
        self.datePicker.backgroundColor = [UIColor whiteColor];
        self.datePicker.datePickerMode = UIDatePickerModeDate;
        self.datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
        [self.datePicker addTarget:self
                            action:@selector(changeDate:)
                  forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:self.datePicker];
    }
    else
    {
        self.genderPicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 200, self.view.frame.size.width, 200)];
        self.genderPicker.dataSource = self;
        self.genderPicker.delegate = self;
        self.genderPicker.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.genderPicker];
    }
    
    self.containerView = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 200 + 1, [UIScreen mainScreen].bounds.size.width, 44)];
    self.containerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.containerView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 43, self.view.frame.size.width, 0.8f)];
    [line setBackgroundColor:[UIColor colorWithRed:207/255.0 green:207/255.0 blue:217/255.0 alpha:1.0]];
    [self.containerView addSubview:line];
    
    UIButton *btnOK = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width -60, 5, 40, 32)];
    btnOK.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [btnOK setTitle:@"确定" forState:UIControlStateNormal];
    [btnOK setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnOK addTarget:self action:@selector(pickerViewBtnOk:) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:btnOK];
    
    UIButton *btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(20, 5, 40, 32)];
    btnCancel.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [btnCancel setTitle:@"取消" forState:UIControlStateNormal];
    [btnCancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(pickerViewBtnCancel:) forControlEvents:UIControlEventTouchUpInside];
    [self.containerView addSubview:btnCancel];
    
    if (self.type == UMSPickerViewTypeBirthday)
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy年MM月dd日";
        NSString *dateStr = [formatter stringFromDate:[NSDate date]];
        self.dateLabel.text = dateStr;
        
        self.dateLabel = [[UILabel alloc] init];
        self.dateLabel.frame = CGRectMake(self.view.frame.size.width/2 - 75, 5, 150, 32);
        self.dateLabel.textAlignment = NSTextAlignmentCenter;
        self.dateLabel.font = [UIFont systemFontOfSize:18];
        self.dateLabel.text = dateStr;
        [self.containerView addSubview:self.dateLabel];
    }
}

- (instancetype)initWithType:(UMSPickerViewType)type
{
    if (self = [super init])
    {
        self.type = type;
    }
    
    return self;
}

-(void)changeDate:(UIDatePicker *)datePicker
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy年MM月dd日";
    NSString *dateStr = [formatter stringFromDate:datePicker.date];
    
    if (datePicker.date)
    {
        self.selectedDate = datePicker.date;
        self.dateLabel.text = dateStr;
    }
}

- (void)pickerViewBtnCancel:(UIButton *)btn
{
    if ([self.delegate conformsToProtocol:@protocol(IUMSPickerViewControllerDelegate)] &&
        [self.delegate respondsToSelector:@selector(selectCancel)])
    {
        [self.delegate selectCancel];
    }
}

- (void)btnResignFirstResponder
{
    [self.genderPicker resignFirstResponder];
}

- (void)pickerViewBtnOk:(UIButton *)btn
{
    if ([self.delegate conformsToProtocol:@protocol(IUMSPickerViewControllerDelegate)] &&
        [self.delegate respondsToSelector:@selector(selectOKWithData:)])
    {
        switch (self.type)
        {
            case UMSPickerViewTypeGender:
            {
                NSMutableDictionary *selectedData = [NSMutableDictionary dictionary];
                [selectedData setObject:@(self.selectedRow) forKey:@"Row"];
                [selectedData setObject:@(UMSPickerViewTypeGender) forKey:@"Type"];
                [self.delegate selectOKWithData:selectedData];
            }
                break;
            case UMSPickerViewTypeRegion:
            {
                NSMutableDictionary *selectedData = [NSMutableDictionary dictionary];
                [selectedData setObject:@(UMSPickerViewTypeRegion) forKey:@"Type"];
                if (self.selectedCountry)
                {
                    [selectedData setObject:self.selectedCountry forKey:@"selectedCountry"];
                    
                    if (self.selectedProvice)
                    {
                        [selectedData setObject:self.selectedProvice forKey:@"selectedProvince"];
                        
                        if (self.selectedCity)
                        {
                            [selectedData setObject:self.selectedCity forKey:@"selectedCity"];
                        }
                    }
                }
                [self.delegate selectOKWithData:selectedData];
            }
                break;
            case UMSPickerViewTypeConstellation:
            {
                NSMutableDictionary *selectedData = [NSMutableDictionary dictionary];
                [selectedData setObject:@(self.selectedRow) forKey:@"Row"];
                [selectedData setObject:@(UMSPickerViewTypeConstellation) forKey:@"Type"];
                [self.delegate selectOKWithData:selectedData];
            }
                break;
            case UMSPickerViewTypeZodiac:
            {
                NSMutableDictionary *selectedData = [NSMutableDictionary dictionary];
                [selectedData setObject:@(self.selectedRow) forKey:@"Row"];
                [selectedData setObject:@(UMSPickerViewTypeZodiac) forKey:@"Type"];
                [self.delegate selectOKWithData:selectedData];
            }
                break;
            case UMSPickerViewTypeAge:
            {
                NSMutableDictionary *selectedData = [NSMutableDictionary dictionary];
                [selectedData setObject:@(self.selectedRow) forKey:@"Row"];
                [selectedData setObject:@(UMSPickerViewTypeAge) forKey:@"Type"];
                [self.delegate selectOKWithData:selectedData];
            };
                break;
            case UMSPickerViewTypeBirthday:
            {
                NSMutableDictionary *selectedData = [NSMutableDictionary dictionary];
                if (self.selectedDate)
                {
                    [selectedData setObject:self.selectedDate forKey:@"selectedDate"];
                }
                else
                {
                    [selectedData setObject:[NSDate date] forKey:@"selectedDate"];
                }
                
                [selectedData setObject:@(UMSPickerViewTypeBirthday) forKey:@"Type"];
                [self.delegate selectOKWithData:selectedData];
            }
                break;
            default:
                break;
        }
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    switch (self.type)
    {
        case UMSPickerViewTypeGender:
            return 1;
            break;
        case UMSPickerViewTypeRegion:
            return 3;
            break;
        case UMSPickerViewTypeBirthday:
            return 3;
            break;
        default:
            return 1;
            break;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (self.type)
    {
        case UMSPickerViewTypeGender:
            return 3;
            break;
        case UMSPickerViewTypeRegion:
            switch (component)
        {
            case 0:
                return [[JIMULocationConstant countries] count];
                break;
            case 1:
            {
                self.selectedProvices = [JIMULocationConstant provinces:self.selectedCountry];
                
//                if (self.selectedProvices.count > 0)
//                {
//                    return [self.selectedProvices count];
//                }
                return [self.selectedProvices count];
            }
                break;
            case 2:
            {
                self.selectedCities = [JIMULocationConstant cities:self.selectedProvice];
                
//                if (self.selectedCities.count > 0)
//                {
//                    return [self.selectedCities count];
//                }
                
                return [self.selectedCities count];
            }
                break;
            default:
                break;
                
        }
            break;
        case UMSPickerViewTypeConstellation:
            return 12;
            break;
        case UMSPickerViewTypeZodiac:
            return 12;
            break;
        case UMSPickerViewTypeAge:
            return 150;
            break;
        default:
            break;
    }
    return 2;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    switch (self.type)
    {
        case UMSPickerViewTypeGender:
        {
            NSArray *genders = [JIMUGenderConstant genders];
            JIMUGenderConstant *gender = genders[row];
            self.selectedGender = gender;
            return gender.name;
        }
            break;
        case UMSPickerViewTypeRegion:
            
            switch (component)
        {
            case 0:
            {
                NSArray<JIMULocationConstant *> *countries = [JIMULocationConstant countries];
                self.selectedCountry = countries[row];
                return self.selectedCountry.name;
            }
                break;
            case 1:
            {
//                if ([JIMULocationConstant provinces:self.selectedCountry].count > row)
//                {
//                    JIMULocationConstant *provice = [JIMULocationConstant provinces:self.selectedCountry][row];
//                    return provice.name;
//                }
                JIMULocationConstant *provice = [JIMULocationConstant provinces:self.selectedCountry][row];
                return provice.name;
            }
                break;
            case 2:
            {
//                if ([JIMULocationConstant cities:self.selectedProvice].count > row)
//                {
//                    JIMULocationConstant *city = [JIMULocationConstant cities:self.selectedProvice][row];
//                    return city.name;
//                }
                
                JIMULocationConstant *city = [JIMULocationConstant cities:self.selectedProvice][row];
                return city.name;
            }
                break;
            default:
                break;
        }
            break;
        case UMSPickerViewTypeConstellation:
        {
            return [JIMUConstellationConstant constellations][row].name;
            
        }
            break;
        case UMSPickerViewTypeZodiac:
        {
            return [JIMUZodiacConstant zodiacs][row].name;
        }
            break;
        case UMSPickerViewTypeAge:
        {
            return [NSString stringWithFormat:@"%zi",row+1];
        }
            break;
        default:
            break;
    }

    return @"";
}

//- (nullable NSAttributedString *)pickerView:(UIPickerView *)pickerView
//                      attributedTitleForRow:(NSInteger)row
//                               forComponent:(NSInteger)component
//{
//    NSDictionary *dict = @{
//                           NSFontAttributeName:[UIFont systemFontOfSize:10.0f],
//                           NSForegroundColorAttributeName : [UIColor redColor]
//                           };
//    switch (self.type)
//    {
//        case UMSPickerViewTypeGender:
//        {
//            NSArray *genders = [JIMUGenderConstant genders];
//            JIMUGenderConstant *gender = genders[row];
//            self.selectedGender = gender;
//            NSAttributedString *attString = [[NSAttributedString alloc] initWithString:gender.name
//                                                                            attributes:dict];
//            return attString;
//        }
//            break;
//        case UMSPickerViewTypeRegion:
//            
//            switch (component)
//        {
//            case 0:
//            {
//                NSArray<JIMULocationConstant *> *countries = [JIMULocationConstant countries];
//                self.selectedCountry = countries[row];
//                NSAttributedString *attString = [[NSAttributedString alloc] initWithString:self.selectedCountry.name
//                                                                                attributes:dict];
//                return attString;
//            }
//                break;
//            case 1:
//            {
//                JIMULocationConstant *provice = [JIMULocationConstant provinces:self.selectedCountry][row];
//                NSAttributedString *attString = [[NSAttributedString alloc] initWithString:provice.name
//                                                                                attributes:dict];
//                return attString;
//            }
//                break;
//            case 2:
//            {
//                JIMULocationConstant *city = [JIMULocationConstant cities:self.selectedProvice][row];
//                NSAttributedString *attString = [[NSAttributedString alloc] initWithString:city.name
//                                                                                attributes:dict];
//                return attString;
//                
//            }
//                break;
//            default:
//                break;
//        }
//            break;
//        case UMSPickerViewTypeConstellation:
//        {
//            return [[NSAttributedString alloc] initWithString:[JIMUConstellationConstant constellations][row].name
//                                                   attributes:dict];
//            
//        }
//            break;
//        case UMSPickerViewTypeZodiac:
//        {
//            return [[NSAttributedString alloc] initWithString:[JIMUZodiacConstant zodiacs][row].name
//                                                   attributes:dict];
//        }
//            break;
//        case UMSPickerViewTypeAge:
//        {
//            return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%zi",row+1]
//                                                   attributes:dict];
//        }
//            break;
//        default:
//            break;
//    }
//   
//    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:@"----"
//                                                                    attributes:dict];
//    return attString;
//}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (self.type)
    {
        case UMSPickerViewTypeGender:
        {
            self.selectedRow = row;
        }
            break;
        case UMSPickerViewTypeRegion:
            
            if (component == 0)
            {
                self.selectedCountry = [JIMULocationConstant countries][row];
            }
            else if(component == 1)
            {
                if ([JIMULocationConstant provinces:self.selectedCountry].count > row)
                {
                    self.selectedProvice = [JIMULocationConstant provinces:self.selectedCountry][row];
                }
            }
            else
            {
                if ([JIMULocationConstant cities:self.selectedProvice].count > row)
                {
                    self.selectedCity = [JIMULocationConstant cities:self.selectedProvice][row];
                }
            }
            [pickerView reloadAllComponents];
            break;
        case UMSPickerViewTypeAge:
            self.selectedRow = row;
            break;
        case UMSPickerViewTypeConstellation:
            self.selectedRow = row;
            break;
        case UMSPickerViewTypeZodiac:
            self.selectedRow = row;
        default:
            break;
    }
}


@end
