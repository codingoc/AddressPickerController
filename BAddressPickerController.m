//
//  BAddressPickerController.m
//  Bee
//
//  Created by 林洁 on 16/1/12.
//  Copyright © 2016年 Lin. All rights reserved.
//

#import "BAddressPickerController.h"
#import "ChineseToPinyin.h"
#import "BAddressHeader.h"
#import "BCurrentCityCell.h"
#import "BRecentCityCell.h"
#import "BHotCityCell.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"

@implementation City

- (instancetype)init:(NSString *)name code:(NSString *)code {
    if (self = [super init]) {
        _name = name;
        _code = code;
    }
    return self;
}

- (NSString *)pinyin
{
    return [ChineseToPinyin pinyinFromChiniseString:self.name];
}

- (NSString *)F {
    return [self.pinyin substringToIndex:1].capitalizedString;
}

@end

@interface BAddressPickerController ()<UISearchBarDelegate,UISearchDisplayDelegate>{
    UITableView *_tableView;
    UISearchBar *_searchBar;
    UISearchDisplayController *_displayController;
    
    NSMutableArray *searchResult;
}
@end

@implementation BAddressPickerController

- (id)initWithDataSource:(id<BAddressPickerDataSource>)dataSource delegate:(id<BAddressPickerDelegate>)delegate {
    if (self = [super init]) {
        _delegate = delegate;
        _dataSource = dataSource;
        [self initSearchBar];
        [self initTableView];
        searchResult = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return self;
}

#pragma mark - UISearchBar Delegate
/**
 *  搜索开始回调用于更新UI
 *
 *  @param searchBar
 *
 *  @return
 */
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    if ([self.delegate respondsToSelector:@selector(beginSearch:)]) {
        [self.delegate beginSearch:searchBar];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
            [UIView animateWithDuration:0.25 animations:^{
                [self.view setBackgroundColor:UIColorFromRGBA(198, 198, 203, 1.0)];
                for (UIView *subview in self.view.subviews){
                    subview.transform = CGAffineTransformMakeTranslation(0, statusBarFrame.size.height);
                }
            }];
        }
    }
    return YES;
}

/**
 *  搜索结束回调用于更新UI
 *
 *  @param searchBar
 *
 *  @return
 */
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    if ([self.delegate respondsToSelector:@selector(endSearch:)]) {
        [self.delegate endSearch:searchBar];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            [UIView animateWithDuration:0.25 animations:^{
                for (UIView *subview in self.view.subviews){
                    subview.transform = CGAffineTransformMakeTranslation(0, 0);
                }
            } completion:^(BOOL finished) {
                [self.view setBackgroundColor:[UIColor whiteColor]];
            }];
        }
    }
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString{
    NSArray *cities = [self.dataSource cityListWithAlphabetKey:self];
    //  正则表达式
    NSMutableString *regex = [NSMutableString stringWithString:@"^"];
    for (int i = 0; i < [searchString length]; i++) {
        [regex appendFormat:@"%c%@", [searchString characterAtIndex:i], @"\\w*"];
    }
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF.pinyin matches[cd] %@", regex];
    [searchResult removeAllObjects];
    [searchResult addObjectsFromArray:[cities filteredArrayUsingPredicate:pre]];
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption{
    [self searchDisplayController:controller shouldReloadTableForSearchString:_searchBar.text];
    return YES;
}

#pragma mark - UITableView Delegate
- (NSArray *)getCityAlphabet {
    NSMutableSet *tSet = [NSMutableSet setWithCapacity:10];
    [[self.dataSource cityListWithAlphabetKey:self] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        City *c = (City *)obj;
        [tSet addObject:c.F];
    }];
    return [[tSet allObjects] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:nil ascending:YES]]];
}

- (NSArray *)getCityForFirstChar:(NSString *)F {
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF.F == %@", F];
    return [[self.dataSource cityListWithAlphabetKey:self] filteredArrayUsingPredicate:pre];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _tableView) {
        return [self getCityAlphabet].count + 3;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _tableView) {
        if (section > 2) {
            NSString *F = [[self getCityAlphabet] objectAtIndex:section - 3];
            return [self getCityForFirstChar:F].count;
        }
        return 1;
    }else{
        return searchResult.count;
    }
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Identifier = @"Cell";
    if (tableView == _tableView) {
        if (indexPath.section == 0) {
            BCurrentCityCell *currentCityCell = [tableView dequeueReusableCellWithIdentifier:@"currentCityCell"];
            if (currentCityCell == nil) {
                currentCityCell = [[BCurrentCityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"currentCityCell"];
            }
            currentCityCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return currentCityCell;
        }else if (indexPath.section == 1){
            BRecentCityCell *recentCityCell = [tableView dequeueReusableCellWithIdentifier:@"recentCityCell"];
            if (recentCityCell == nil) {
                recentCityCell = [[BRecentCityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"recentCityCell"];
            }
            recentCityCell.selectionStyle = UITableViewCellSelectionStyleNone;
            //如果第一次使用没有最近访问的城市则赢该行
            if (![[NSUserDefaults standardUserDefaults] objectForKey:currentCity]) {
                recentCityCell.frame = CGRectMake(0, 0, 0, 0);
                [recentCityCell setHidden:YES];
            }
            return recentCityCell;
        }else if (indexPath.section == 2){
            BHotCityCell *hotCell = [tableView dequeueReusableCellWithIdentifier:@"hotCityCell"];
            if (hotCell == nil) {
                hotCell = [[BHotCityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hotCityCell" array:[self.dataSource arrayOfHotCitiesInAddressPicker:self]];
            }
            hotCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return hotCell;
        }else{
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }else{
        static NSString *Identifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableView) {
        if ([cell isKindOfClass:[BCurrentCityCell class]]) {
            [(BCurrentCityCell*)cell buttonWhenClick:^(UIButton *button) {
                if ([self.delegate respondsToSelector:@selector(addressPicker:didSelectedCity:)]) {
                    [self saveCurrentCity:button.titleLabel.text];
                    [self.delegate addressPicker:self didSelectedCity:button.titleLabel.text];
                }
            }];
        }else if ([cell isKindOfClass:[BRecentCityCell class]]){
            [(BRecentCityCell*)cell buttonWhenClick:^(UIButton *button) {
                if ([self.delegate respondsToSelector:@selector(addressPicker:didSelectedCity:)]) {
                    [self saveCurrentCity:button.titleLabel.text];
                    [self.delegate addressPicker:self didSelectedCity:button.titleLabel.text];
                }
            }];
        }else if([cell isKindOfClass:[BHotCityCell class]]){
            [(BHotCityCell*)cell buttonWhenClick:^(UIButton *button) {
                if ([self.delegate respondsToSelector:@selector(addressPicker:didSelectedCity:)]) {
                    [self saveCurrentCity:button.titleLabel.text];
                    [self.delegate addressPicker:self didSelectedCity:button.titleLabel.text];
                }
            }];
        }else{
            NSString *F = [[self getCityAlphabet] objectAtIndex:indexPath.section - 3];
            cell.textLabel.text = ((City *)[[self getCityForFirstChar:F] objectAtIndex:indexPath.row]).name;
            cell.textLabel.font = [UIFont systemFontOfSize:16.0];
        }

    }else{
        cell.textLabel.text = [(City *)[searchResult objectAtIndex:indexPath.row] name];
        cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    }
}

//右侧索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (tableView == _tableView) {
        NSMutableArray *titleSectionArray = [NSMutableArray arrayWithObjects:@"当前",@"最近",@"热门", nil];
        [[self getCityAlphabet] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [titleSectionArray addObject:[NSString stringWithFormat:@"    %@", obj]];
        }];
        return titleSectionArray;
    }else{
        return nil;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == _tableView) {
        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 28)];
        headerView.backgroundColor = UIColorFromRGBA(235, 235, 235, 1.0);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, ScreenWidth - 15, 28)];
        label.font = [UIFont systemFontOfSize:14.0];
        [headerView addSubview:label];
        if (section == 0) {
            label.text = @"当前城市";
        }else if (section == 1){
            //如果第一次使用没有最近访问的城市则赢该行
            if (![[NSUserDefaults standardUserDefaults] objectForKey:currentCity]) {
                return nil;
            }
            label.text = @"最近访问城市";
        }else if (section == 2){
            label.text = @"热门城市";
        }else{
            label.text = [[self getCityAlphabet] objectAtIndex:section - 3];
        }
        return headerView;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == _tableView) {
        if (section == 1) {
            //如果第一次使用没有最近访问的城市则赢该行
            if (![[NSUserDefaults standardUserDefaults] objectForKey:currentCity]) {
                return 0.01;
            }
        }
        return 28;
    }else{
        return 0.01;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1) {
        //如果第一次使用没有最近访问的城市则赢该行
        if (![[NSUserDefaults standardUserDefaults] objectForKey:currentCity]) {
            return 0.01;
        }
    }
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _tableView) {
        if (indexPath.section == 2) {
            return ceil((float)[[self.dataSource arrayOfHotCitiesInAddressPicker:self] count] / 3) * (BUTTON_HEIGHT + 15) + 15;
        }else if (indexPath.section > 2){
            return 42;
        }else if (indexPath.section == 1){
            //如果第一次使用没有最近访问的城市则赢该行
            if (![[NSUserDefaults standardUserDefaults] objectForKey:currentCity]) {
                return 0;
            }
        }
        return BUTTON_HEIGHT + 30;
    }else{
        return 42;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _tableView) {
        if (indexPath.section > 2) {
            NSString *F = [[self getCityAlphabet] objectAtIndex:indexPath.section - 3];
            City *c = [[self getCityForFirstChar:F] objectAtIndex:indexPath.row];
            if ([self.delegate respondsToSelector:@selector(addressPicker:didSelectedCity:)]) {
                [self saveCurrentCity:c];
                [self.delegate addressPicker:self didSelectedCity:c];
            }
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(addressPicker:didSelectedCity:)]) {
            [self saveCurrentCity:[searchResult objectAtIndex:indexPath.row]];
            [self.delegate addressPicker:self didSelectedCity:[searchResult objectAtIndex:indexPath.row]];
        }
    }
}

//保存访问过的城市
- (void)saveCurrentCity:(City *)city{
    NSMutableArray *currentArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:currentCity]];
    if (currentArray == nil) {
        currentArray = [NSMutableArray array];
    }
    if ([currentArray count] < 2 && ![currentArray containsObject:city]) {
        [currentArray addObject:city];
    }else{
        if (![currentArray containsObject:city]) {
            currentArray[1] = currentArray[0];
            currentArray[0] = city;
        }
    }
    [[NSUserDefaults standardUserDefaults] setObject:currentArray forKey:currentCity];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - init
- (void)initTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, ScreenWidth, self.view.frame.size.height) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    _tableView.sectionIndexColor = [UIColor grayColor];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.01)];
    [self.view addSubview:_tableView];
}

- (void)initSearchBar{
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    _searchBar.placeholder = @"输入城市名或拼音";
    _searchBar.delegate = self;
    _searchBar.layer.borderColor = [[UIColor clearColor] CGColor];
    _displayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    _displayController.delegate = self;
    _displayController.searchResultsDataSource = self;
    _displayController.searchResultsDelegate = self;
    [self.view addSubview:_searchBar];
}

@end
#pragma clang diagnostic pop