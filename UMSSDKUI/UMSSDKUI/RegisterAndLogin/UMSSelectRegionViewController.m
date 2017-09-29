//
//  UMSSelectRegionViewController.m
//  UMSSDKUI
//
//  Created by 刘靖煌 on 17/2/26.
//  Copyright © 2017年 mob.com. All rights reserved.
//

#import "UMSSelectRegionViewController.h"
#import "UMSImage.h"
#import "UIBarButtonItem+UMS.h"

@interface UMSSelectRegionViewController ()<UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate>
{
    BOOL isSearching;
}

@property (nonatomic, strong) UITableView *table;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, strong) NSBundle *bundle;
@property (nonatomic, strong) NSDictionary *allNames;     //字母索引下对应的所有名字和区号
@property (nonatomic, strong) NSMutableDictionary *names; //
@property (nonatomic, strong) NSMutableArray *keys;       //所有的字母索引

@end

@implementation UMSSelectRegionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    CGFloat statusBarHeight = 0;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0)
    {
        statusBarHeight = 20;
    }
    
    //创建一个导航栏
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0,0 + statusBarHeight, self.view.frame.size.width, 44)];
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:@""];
    
    UIBarButtonItem *leftButton = [UIBarButtonItem itemWithIcon:@"return.png"
                                                       highIcon:@"return.png"
                                                         target:self
                                                         action:@selector(clickLeftButton)];
    
    self.navigationItem.leftBarButtonItem = leftButton;
    [navigationBar pushNavigationItem:navigationItem animated:NO];
    [self.view addSubview:navigationBar];
    
    //添加搜索框
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.frame = CGRectMake(0, 44+statusBarHeight, self.view.frame.size.width, 44);
    self.searchBar.delegate = self;
    [self.view addSubview:self.searchBar];
    
    //添加table
    self.table = [[UITableView alloc] initWithFrame:CGRectMake(0, 88 + statusBarHeight, self.view.frame.size.width, self.view.bounds.size.height - (88 + statusBarHeight)) style:UITableViewStylePlain];
    self.table.dataSource = self;
    self.table.delegate = self;
    [self.view addSubview:self.table];
    
    _bundle = [[NSBundle alloc] initWithPath:[[NSBundle mainBundle] pathForResource:@"UMSSDKUI" ofType:@"bundle"]];
    self.allNames = [[NSDictionary alloc] initWithContentsOfFile:[_bundle pathForResource:@"country" ofType:@"plist"]];
    
    [self resetSearch];
    [self.table reloadData];
    [self.table setContentOffset:CGPointMake(0.0, 44.0) animated:NO];
}

- (NSMutableDictionary *)mutableDeepCopy:(NSDictionary *)keysInfo
{
    if (!self.allNames)
    {
        self.allNames = [NSDictionary dictionary];
    }
    
    self.allNames = keysInfo;
    return [self mutableDeepCopy];
}

- (NSMutableDictionary *)mutableDeepCopy
{
    NSMutableDictionary *ret = [[NSMutableDictionary alloc] initWithCapacity:[self.allNames count]];
    NSArray *keysArray = [self.allNames allKeys];
    for (id key in keysArray)
    {
        id oneValue = [self.allNames valueForKey:key];
        id oneCopy = nil;
        
        if ([oneValue respondsToSelector:@selector(mutableDeepCopy)])
            oneCopy = [oneValue mutableDeepCopy];
        else if ([oneValue respondsToSelector:@selector(mutableCopy)])
            oneCopy = [oneValue mutableCopy];
        if (oneCopy == nil) oneCopy = [oneValue copy];
        [ret setValue:oneCopy forKey:key];
    }
    return ret;
}

- (void)resetSearch
{
    NSMutableDictionary *allNamesCopy = [self mutableDeepCopy:self.allNames];
    self.names = allNamesCopy;
    NSMutableArray *keyArray = [NSMutableArray array];
    [keyArray addObject:UITableViewIndexSearch];
    [keyArray addObjectsFromArray:[[self.allNames allKeys]
                                   sortedArrayUsingSelector:@selector(compare:)]];
    self.keys = keyArray;
}

- (void)handleSearchForTerm:(NSString *)searchTerm
{
    NSMutableArray *sectionsToRemove = [NSMutableArray array];
    [self resetSearch];
    
    for (NSString *key in self.keys)
    {
        NSMutableArray *array = [self.names valueForKey:key];
        NSMutableArray *toRemove = [NSMutableArray array];
        for (NSString *name in array)
        {
            if ([name rangeOfString:searchTerm
                            options:NSCaseInsensitiveSearch].location == NSNotFound)
                [toRemove addObject:name];
        }
        if ([array count] == [toRemove count])
            [sectionsToRemove addObject:key];
        [array removeObjectsInArray:toRemove];
    }
    [self.keys removeObjectsInArray:sectionsToRemove];
    [self.table reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.keys count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.keys count] == 0)
        return 0;
    
    NSString *key = [self.keys objectAtIndex:section];
    NSArray *nameSection = [self.names objectForKey:key];
    return [nameSection count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = [indexPath section];
    NSString *key = [self.keys objectAtIndex:section];
    NSArray *nameSection = [self.names objectForKey:key];
    
    static NSString *cellIdentifier = @"UMSSelectRegionCellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier: cellIdentifier];
    }
    
    NSString* str1 = [nameSection objectAtIndex:indexPath.row];
    NSRange range = [str1 rangeOfString:@"+"];
    NSString* str2 = [str1 substringFromIndex:range.location];
    NSString* areaCode = [str2 stringByReplacingOccurrencesOfString:@"+" withString:@""];
    NSString* countryName = [str1 substringToIndex:range.location];
    
    cell.textLabel.text = countryName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"+%@",areaCode];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    if ([self.keys count] == 0)
        return nil;
    
    NSString *key = [self.keys objectAtIndex:section];
    if (key == UITableViewIndexSearch)
        return nil;
    
    return key;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (isSearching)
        return nil;
    return self.keys;
}

- (NSIndexPath *)tableView:(UITableView *)tableView
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchBar resignFirstResponder];
    self.searchBar.text = @"";
    isSearching = NO;
    [tableView reloadData];
    return indexPath;
}

- (NSInteger)tableView:(UITableView *)tableView
sectionForSectionIndexTitle:(NSString *)title
               atIndex:(NSInteger)index
{
    NSString *key = [self.keys objectAtIndex:index];
    if (key == UITableViewIndexSearch)
    {
        [tableView setContentOffset:CGPointZero animated:NO];
        return NSNotFound;
    }
    else return index;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = [indexPath section];
    NSString *key = [self.keys objectAtIndex:section];
    NSArray *nameSection = [self.names objectForKey:key];
    
    NSString* str1 = [nameSection objectAtIndex:indexPath.row];
    NSRange range = [str1 rangeOfString:@"+"];
    NSString* str2 = [str1 substringFromIndex:range.location];
    NSString* areaCode = [str2 stringByReplacingOccurrencesOfString:@"+" withString:@""];
//    NSString* countryName = [str1 substringToIndex:range.location];
    
    if ([self.delegate conformsToProtocol:@protocol(IUMSSelectRegionViewControllerDelegate)] && [self.delegate respondsToSelector:@selector(selectedAreaCode:)])
    {
        [self.delegate selectedAreaCode:areaCode];
    }
    
    [self.view endEditing:YES];
    
    //关闭当前
    [self clickLeftButton];
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *searchTerm = [searchBar text];
    [self handleSearchForTerm:searchTerm];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    isSearching = YES;
    [self.table reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar
    textDidChange:(NSString *)searchTerm
{
    if ([searchTerm length] == 0)
    {
        [self resetSearch];
        [self.table reloadData];
        return;
    }
    
    [self handleSearchForTerm:searchTerm];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    isSearching = NO;
    self.searchBar.text = @"";
    [self resetSearch];
    [self.table reloadData];
    [searchBar resignFirstResponder];
}

-(void)clickLeftButton
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
