//
//  BAddressPickerController.m
//  Bee
//
//  Created by 林洁 on 16/1/12.
//  Copyright © 2016年 Lin. All rights reserved.
//

#import "BAddressPickerController.h"
#import "BAddressHeader.h"
#import "BCurrentCityCell.h"
#import "BRecentCityCell.h"
#import "BHotCityCell.h"


@interface BAddressPickerController (){
    UITableView *_tableView;
    UISearchBar *_searchBar;
    UISearchDisplayController *_displayController;
    NSArray *hotCities;
}

@end

@implementation BAddressPickerController

- (id)initWithFrame:(CGRect)frame{
    self = [super init];
    if (self) {
        self.view.frame = frame;
        self.view.backgroundColor = [UIColor redColor];
        [self initSearchBar];
        [self initTableView];
    }
    return self;
}

#pragma mark - Getter and Setter
- (void)setDataSource:(id<BAddressPickerDataSource>)dataSource{
    hotCities = [dataSource arrayOfCitiesInAddressPicker:self];
    [_tableView reloadData];
}

#pragma mark - UITableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *Identifier = @"Cell";
    if (indexPath.section == 0) {
        BCurrentCityCell *currentCityCell = [tableView dequeueReusableCellWithIdentifier:@"currentCityCell"];
        if (currentCityCell == nil) {
            currentCityCell = [[BCurrentCityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"currentCityCell"];
        }
        currentCityCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [currentCityCell buttonWhenClick:^(UIButton *button) {
            if ([self.delegate respondsToSelector:@selector(addressPicker:didSelectedCity:)]) {
                [self.delegate addressPicker:self didSelectedCity:button.titleLabel.text];
            }
        }];
        return currentCityCell;
    }else if (indexPath.section == 1){
        BRecentCityCell *recentCityCell = [tableView dequeueReusableCellWithIdentifier:@"recentCityCell"];
        if (recentCityCell == nil) {
            recentCityCell = [[BRecentCityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"recentCityCell"];
        }
        recentCityCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [recentCityCell buttonWhenClick:^(UIButton *button) {
            if ([self.delegate respondsToSelector:@selector(addressPicker:didSelectedCity:)]) {
                [self.delegate addressPicker:self didSelectedCity:button.titleLabel.text];
            }
        }];
        return recentCityCell;
    }else if (indexPath.section == 2){
        BHotCityCell *hotCell = [tableView dequeueReusableCellWithIdentifier:Identifier];
        if (hotCell == nil) {
            hotCell = [[BHotCityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"hotCityCell" array:hotCities];
        }
        hotCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [hotCell buttonWhenClick:^(UIButton *button) {
            if ([self.delegate respondsToSelector:@selector(addressPicker:didSelectedCity:)]) {
                [self.delegate addressPicker:self didSelectedCity:button.titleLabel.text];
            }
        }];
        return hotCell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
        }
        return cell;
    }
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 28)];
    headerView.backgroundColor = UIColorFromRGBA(235, 235, 235, 1.0);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, ScreenWidth - 15, 28)];
    label.font = [UIFont systemFontOfSize:14.0];
    [headerView addSubview:label];
    if (section == 0) {
        label.text = @"当前城市";
    }else if (section == 1){
        label.text = @"最近访问城市";
    }else if (section == 2){
        label.text = @"热门城市";
    }else{
        label.text = @"A";
    }
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 28;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        
        return ceil((float)[hotCities count] / 3) * (BUTTON_HEIGHT + 15) + 15;
    }
    return BUTTON_HEIGHT + 30;
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
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, ScreenWidth, ScreenHeight - 44) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)initSearchBar{
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44)];
    _searchBar.placeholder = @"输入城市名或拼音";
    _displayController = [[UISearchDisplayController alloc] initWithSearchBar:_searchBar contentsController:self];
    [self.view addSubview:_searchBar];
}

@end
