//
//  AddressPickerController.m
//  BAddressPickerDemo
//
//  Created by cc on 16/3/12.
//  Copyright © 2016年 onlylin. All rights reserved.
//

#import "AddressPickerController.h"
#import "PinYin4Objc.h"

@protocol CityButtonCallDelegate <NSObject>
- (void)didSelectCity: (City *)city;
@end

@interface AddressPickerController () <UISearchResultsUpdating, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, CityButtonCallDelegate>
@property (readonly) UISearchController *searchController;
@property (readonly) UITableView *tableView;
@property (nonatomic, strong) NSArray *searchList;
@property (readonly) NSDictionary *cityListByFirstChar;
@property (readonly) NSArray *recentCities;
@end

@class CityButtonCell;
@class CityButton;
@implementation AddressPickerController

- (instancetype)initWithCityList:(NSArray *)list hotCityList:(NSArray *)hotList
{
    if (self = [super init]) {
        _cityList = list;
        _hotCityList = hotList;
        NSMutableDictionary *tDict = [[NSMutableDictionary alloc] init];
        NSArray *AZ = @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z"];
        for (NSString *F in AZ) {
            NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF.F == %@", F];
            NSArray *filter = [_cityList filteredArrayUsingPredicate:pre];
            if (filter && filter.count) {
                [tDict setObject:filter forKey:F];
            }
        }
        _cityListByFirstChar = tDict;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUpTableView];
    [self setUpSearchBar];
    [self setUpRecentCities];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpSearchBar {
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.searchResultsUpdater = self;
    _searchController.dimsBackgroundDuringPresentation = NO;
    _searchController.hidesNavigationBarDuringPresentation = NO;
    _searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    self.tableView.tableHeaderView = self.searchController.searchBar;
}

- (void)setUpTableView {
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

- (NSString *)recentCityCacheFilePath {
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"com.cc.AddressPicker.data"];
    return filePath;
}

- (void)setUpRecentCities {
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"com.cc.AddressPicker.data"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    if (data) {
        NSArray *recent = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        _recentCities = recent;
    }else  {
        _recentCities = nil;
    }
}

// MARK: - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.searchController.active) {
        return 1;
    }else {
        return self.cityListByFirstChar.allKeys.count + 3; // +3包括 当前定位, 最近访问, 热门城市
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchController.active) {
        return self.searchList.count;
    }else {
        if (section < 3) {
            return 1;
        }else  {
            NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
            return [self.cityListByFirstChar[sectionTitle] count];
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searchController.active) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text = [(City *)self.searchList[indexPath.row] name];
        return cell;
    }
    if (indexPath.section < 3) {
        if (indexPath.section == 0) {
            LocationButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LocationButtonCell"];
            if (!cell) {
                cell = [[LocationButtonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LocationButtonCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell setValue:self forKey:@"delegate"];
            }
            return cell;
        }
        CityButtonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CityButtonCell"];
        if (!cell) {
            cell = [[CityButtonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CityButtonCell" cities:indexPath.section == 1 ? self.recentCities : self.hotCityList];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setValue:self forKey:@"delegate"];
        }
        return cell;
    }else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        NSString *F = [self tableView:tableView titleForHeaderInSection:indexPath.section];
        NSArray *citiesF = self.cityListByFirstChar[F];
        cell.textLabel.text = [citiesF[indexPath.row] name];
        return cell;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (self.searchController.active) {
        return @"";
    }else {
        NSArray *arr = @[@"定位城市", @"最近访问的城市", @"热门城市"];
        if (section < 3) {
            return arr[section];
        }else {
            // A-Z排序
            NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];
            return [[self.cityListByFirstChar allKeys] sortedArrayUsingDescriptors:@[sort]][section - 3];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [LocationButtonCell calcHeight];
    }else if (indexPath.section == 1) {
        return [CityButtonCell calcHeightWithCityCount:2];
    }else if (indexPath.section == 2) {
        return [CityButtonCell calcHeightWithCityCount:self.hotCityList.count];
    }else {
        return 44;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.searchController.active) {
        [self didSelectCity:self.searchList[indexPath.row]];
    }else {
        if (indexPath.section > 2) {
            NSString *F = [self tableView:tableView titleForHeaderInSection:indexPath.section];
            City *city = self.cityListByFirstChar[F][indexPath.row];
            [self didSelectCity:city];
        }
    }
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *tArr = [NSMutableArray arrayWithObjects:@"#", @"$", @"*", nil];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];
    NSArray *Fs = [[self.cityListByFirstChar allKeys] sortedArrayUsingDescriptors:@[sort]];
    [tArr addObjectsFromArray:Fs];
    return tArr;
}


// MARK: - UISearchController
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSMutableString *regex = [NSMutableString stringWithFormat:@"^"];
    NSString *searchString = [self.searchController.searchBar text].lowercaseString;
    for (int index = 0; index < [searchString length]; index++) {
        [regex appendFormat:@"%c\\w*", [searchString characterAtIndex:index]];
    }
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF.pinyin MATCHES %@ OR SELF.name CONTAINS %@", regex, searchString];
    self.searchList = [self.cityList filteredArrayUsingPredicate:pre];
    [self.tableView reloadData];
}

// MARK: - CityButton
- (void)didSelectCity:(City *)city {
    if ([self.delegate respondsToSelector:@selector(addressPicker:didSelectCity:)]) {
        [self.delegate addressPicker:self didSelectCity:city];
        [self writeToRecentFile:city];
    }
}

- (void)writeToRecentFile: (City *)city{
    // 异步写
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSArray *recentCity = [NSKeyedUnarchiver unarchiveObjectWithFile:[self recentCityCacheFilePath]];
        if (recentCity && recentCity.count) {
            ![city isEqual:recentCity[0]] &&
            [NSKeyedArchiver archiveRootObject:@[city, recentCity[0]] toFile:[self recentCityCacheFilePath]];
        }else {
            [NSKeyedArchiver archiveRootObject:@[city] toFile:[self recentCityCacheFilePath]];
        }
    });
}

@end

@implementation City
- (instancetype)initWithName:(NSString *)name code:(NSString *)code {
    if (self = [super init]) {
        _name = name;
        _code = code;
        HanyuPinyinOutputFormat *outputFormat = [[HanyuPinyinOutputFormat alloc] init];
        [outputFormat setToneType:ToneTypeWithoutTone];
        [outputFormat setVCharType:VCharTypeWithV];
        [outputFormat setCaseType:CaseTypeLowercase];
        _pinyin = [PinyinHelper toHanyuPinyinStringWithNSString:_name withHanyuPinyinOutputFormat:outputFormat withNSString:@""];
        _F = [_pinyin substringToIndex:1].capitalizedString;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    _name = [aDecoder decodeObjectForKey:@"name"];
    _code = [aDecoder decodeObjectForKey:@"code"];
    return [self initWithName:_name code:_code];
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.code forKey:@"code"];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"name: %@ | code: %@", self.name, self.code];
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[City class]]) {
        City *c = (City *)object;
        return [c.name isEqualToString:self.name] && [c.code isEqualToString:self.code];
    }
    return NO;
}

@end

@interface CityButton : UIButton
@property (strong) City *city;
@end
@implementation CityButton
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 2.0f;
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderWidth = 1.0f;
    }
    return self;
}
@end

@interface CityButtonCell ()
@property (weak) id <CityButtonCallDelegate> delegate;
@end
@implementation CityButtonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cities:(NSArray *)cities {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _cities = cities;
        for (int index = 0; index < cities.count; index++) {
            int row = index / 3;
            int col = index % 3;
            CGFloat itemW = 99;
            CGFloat itemH = 38;
            CGFloat screenWith = [[UIScreen mainScreen] bounds].size.width;
            CGFloat spaceW = (screenWith - 3*itemW)/4.0;
            CGFloat spaceH = 8;
            CGRect rect = CGRectMake(spaceW+(itemW+spaceW)*col, spaceH+(itemH+spaceH)*row, itemW, itemH);
            CityButton *btn = [[CityButton alloc] initWithFrame:rect];
            [btn setTitle:((City *)cities[index]).name forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btn.city = cities[index];
            [btn addTarget:self action:@selector(onBtn:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:btn];
        }
    }
    return self;
}

- (void)onBtn: (CityButton *)sender {
    if (sender.city && [self.delegate respondsToSelector:@selector(didSelectCity:)]) {
        [self.delegate didSelectCity:sender.city];
    }
}

+ (CGFloat)calcHeightWithCityCount:(NSInteger)count
{
    if (count == 0) return 44;
    return ((count + 2)/3) * (38+8) + 8;
}

@end

@interface LocationButtonCell ()
@property (strong) CityButton *button;
@property (weak) id <CityButtonCallDelegate> delegate;
@end
@implementation LocationButtonCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        CGFloat screenWith = [[UIScreen mainScreen] bounds].size.width;
        CGFloat itemW = 99;
        CGFloat itemH = 38;
        CGFloat spaceW = (screenWith - 3*itemW)/4.0;
        CGRect rect = CGRectMake(spaceW, 8, itemW, itemH);
        _button = [[CityButton alloc] initWithFrame:rect];
        [_button addTarget:self action:@selector(onBtn:) forControlEvents:UIControlEventTouchUpInside];
        [_button setTitle:@"定位中..." forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.contentView addSubview:_button];
    }
    return self;
}

- (void)onBtn: (CityButton *)sender
{
    if (sender.city && [self.delegate respondsToSelector:@selector(didSelectCity:)]) {
        [self.delegate didSelectCity:sender.city];
    }
}

+ (CGFloat)calcHeight {
    return [CityButtonCell calcHeightWithCityCount:1];
}

@end

