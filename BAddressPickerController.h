//
//  BAddressPickerController.h
//  Bee
//
//  Created by 林洁 on 16/1/12.
//  Copyright © 2016年 Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BAddressPickerController;

@protocol BAddressPickerDataSource <NSObject>

@required
- (NSArray*)arrayOfHotCitiesInAddressPicker:(BAddressPickerController*)addressPicker;

@end

@protocol BAddressPickerDelegate <NSObject>

-(void)addressPicker:(BAddressPickerController*)addressPicker didSelectedCity:(NSString*)city;

- (void)beginSearch:(UISearchBar*)searchBar;

- (void)endSearch:(UISearchBar*)searchBar;

@end

@interface BAddressPickerController : UIViewController<UITableViewDataSource,UITableViewDelegate>

//数据源代理协议
@property (nonatomic, weak) id<BAddressPickerDataSource> dataSource;
//委托代理协议
@property (nonatomic, weak) id<BAddressPickerDelegate> delegate;

- (id)initWithFrame:(CGRect)frame;

@end
