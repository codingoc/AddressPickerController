//
//  AddressPickerDemo.m
//  BAddressPickerDemo
//
//  Created by 林洁 on 16/1/13.
//  Copyright © 2016年 onlylin. All rights reserved.
//

#import "AddressPickerDemo.h"
#import "BAddressPickerController.h"

@interface AddressPickerDemo ()<BAddressPickerDelegate,BAddressPickerDataSource>

@end

@implementation AddressPickerDemo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.navigationController.navigationBar.translucent = NO;
    }
    BAddressPickerController *addressPickerController = [[BAddressPickerController alloc] initWithDataSource:self delegate:self];
    
    [self addChildViewController:addressPickerController];
    [self.view addSubview:addressPickerController.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - BAddressController Delegate
- (NSArray*)arrayOfHotCitiesInAddressPicker:(BAddressPickerController *)addressPicker{
    City *c1 = [[City alloc] init:@"宜昌" code:@"4205"];
    City *c2 = [[City alloc] init:@"武汉" code:@"4201"];
    return @[c1, c2];
}

- (NSArray *)cityListWithAlphabetKey:(BAddressPickerController *)addressPicker
{
    City *c1 = [[City alloc] init:@"宜昌" code:@"4205"];
    City *c2 = [[City alloc] init:@"武汉" code:@"4201"];
    return @[c1, c2];
}

- (void)addressPicker:(BAddressPickerController *)addressPicker didSelectedCity:(City *)city{
    NSLog(@"%@",city);
}

- (void)beginSearch:(UISearchBar *)searchBar{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)endSearch:(UISearchBar *)searchBar{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
