## 城市地址选择
iOS8+城市地址选择控制器，使用方法如下，源码可随意定制:

```objc
- (void)openAddressPicker {
	City *c0 = [[City alloc] initWithName:@"宜昌" code:@"4201"];
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
	City *c12 = [[City alloc] initWithName:@"武汉" code:@"4201"];
	NSArray *list = @[c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10, c11, c12];
	
	AddressPickerController *picker = [[AddressPickerController alloc] initWithCityList:list hotCityList:@[c11, c12, c1, c2, c3]];
	picker.delegate = self;
	[self presentViewController:[[UINavigationController alloc] initWithRootViewController:picker] animated:YES completion:nil];
}
    
- (void)addressPicker:(AddressPickerController *)addressPicker didSelectCity:(City *)city {
    NSLog(@"%@", city);
}
```

最终显示效果如下: 
![](https://github.com/codingoc/AddressPickerController/raw/master/snapshot.PNG)
