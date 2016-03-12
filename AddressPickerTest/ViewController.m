//
//  ViewController.m
//  AddressPickerTest
//
//  Created by cc on 16/3/12.
//  Copyright © 2016年 onlylin. All rights reserved.
//

#import "ViewController.h"
#import <AddressPicker/AddressPicker.h>


@interface ViewController () <AddressPickerControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 99, 38)];
    [btn setTitle:@"打开地址选择器" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(open:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)open: (UIButton *)sender {
    City *c0 = [[City alloc] initWithName:@"武汉" code:@"4201"];
    City *c1 = [[City alloc] initWithName:@"阿坝州" code:@"4201"];
    City *c2 = [[City alloc] initWithName:@"北京" code:@"4201"];
    City *c3 = [[City alloc] initWithName:@"长春" code:@"4201"];
    City *c4 = [[City alloc] initWithName:@"定州" code:@"4201"];
    City *c5 = [[City alloc] initWithName:@"福建" code:@"4201"];
    City *c6 = [[City alloc] initWithName:@"合肥" code:@"4201"];
    City *c7 = [[City alloc] initWithName:@"荆州" code:@"4201"];
    City *c8 = [[City alloc] initWithName:@"兰州" code:@"4201"];
    City *c9 = [[City alloc] initWithName:@"上海" code:@"4201"];
    City *c10 = [[City alloc] initWithName:@"襄阳" code:@"4201"];
    City *c11 = [[City alloc] initWithName:@"宜昌" code:@"4201"];
    City *c12 = [[City alloc] initWithName:@"自贡" code:@"4201"];
    NSArray *list = @[c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12];
    
    AddressPickerController *picker = [[AddressPickerController alloc] initWithCityList:list hotCityList:@[c11, c12, c1, c2, c3]];
    picker.delegate = self;
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:picker] animated:YES completion:nil];
}

- (void)addressPicker:(AddressPickerController *)addressPicker didSelectCity:(City *)city {
    NSLog(@"%@", city);
}

@end
