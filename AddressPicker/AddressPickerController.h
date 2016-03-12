//
//  AddressPickerController.h
//  BAddressPickerDemo
//
//  Created by cc on 16/3/12.
//  Copyright © 2016年 onlylin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class City;
@class AddressPickerController;
@protocol AddressPickerControllerDelegate <NSObject>
- (void)addressPicker:(AddressPickerController *)addressPicker didSelectCity: (City *)city;
@end

@interface AddressPickerController : UIViewController
@property (weak) id<AddressPickerControllerDelegate> delegate;
@property (strong) NSArray *cityList;
@property (strong) NSArray *hotCityList;
- (instancetype)initWithCityList:(NSArray *)list hotCityList: (NSArray *)hotList;
@end

@interface City : NSObject <NSCoding>
@property (readonly) NSString *name;
@property (readonly) NSString *code;
@property (readonly) NSString *F;
@property (readonly) NSString *pinyin;
- (instancetype)initWithName: (NSString *)name code: (NSString *)code;
@end

@interface CityButtonCell : UITableViewCell
@property (strong) NSArray *cities;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cities: (NSArray *)cities;
+ (CGFloat)calcHeightWithCityCount:(NSInteger)count;
@end


@interface LocationButtonCell : UITableViewCell
+ (CGFloat)calcHeight;
@end