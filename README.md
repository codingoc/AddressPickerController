# BAddressPickerDemo

#开始
导入 "BAddressPickerController.h"

BAddressPickerController *addressPickerController = [[BAddressPickerController alloc] initWithFrame:self.view.frame];

addressPickerController.dataSource = self;

addressPickerController.delegate = self;
    
[self addChildViewController:addressPickerController];
[self.view addSubview:addressPickerController.view];

#实现BAddressPickerDataSource数据源协议
- (NSArray*)arrayOfHotCitiesInAddressPicker:(BAddressPickerController *)addressPicker;

#实现BAddressPickerDelegate代理协议

- (void)addressPicker:(BAddressPickerController *)addressPicker didSelectedCity:(NSString *)city;

- (void)beginSearch:(UISearchBar *)searchBar;

- (void)endSearch:(UISearchBar *)searchBar;
