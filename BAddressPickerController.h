//
//  BAddressPickerController.h
//  Bee
//
//  Created by 林洁 on 16/1/12.
//  Copyright © 2016年 Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BAddressPickerController;
@class City;

@protocol BAddressPickerDataSource <NSObject>
@required
// 热门城市列表
- (NSArray*)arrayOfHotCitiesInAddressPicker:(BAddressPickerController*)addressPicker;
// 字母表顺序的城市列表
- (NSArray *)cityListWithAlphabetKey: (BAddressPickerController *)addressPicker;
@end

@protocol BAddressPickerDelegate <NSObject>

-(void)addressPicker:(BAddressPickerController*)addressPicker didSelectedCity:(City *)city;

- (void)beginSearch:(UISearchBar*)searchBar;

- (void)endSearch:(UISearchBar*)searchBar;

@end

@interface BAddressPickerController : UIViewController<UITableViewDataSource,UITableViewDelegate>

//数据源代理协议
@property (nonatomic, weak) id<BAddressPickerDataSource> dataSource;
//委托代理协议
@property (nonatomic, weak) id<BAddressPickerDelegate> delegate;

- (id)initWithDataSource: (id<BAddressPickerDataSource>)dataSource delegate:(id<BAddressPickerDelegate>)delegate;

@end

// 城市数据结构
@interface  City: NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *code;
@property (nonatomic, readonly, getter=pinyin) NSString *pinyin;
@property (nonatomic, readonly, getter=F) NSString *F; // 首字母大写
- (instancetype)init: (NSString *)name code: (NSString *)code;
@end