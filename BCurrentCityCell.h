//
//  BCurrentCityCell.h
//  Bee
//
//  Created by 林洁 on 16/1/12.
//  Copyright © 2016年 Lin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LNLocationManager.h"
#import "LNSearchManager.h"

@interface BCurrentCityCell : UITableViewCell

@property (nonatomic, strong) UIButton *GPSButton;

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicatorView;

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) LNLocationManager *locationManager;

@property (nonatomic, strong) LNSearchManager *searchManager;

@property (nonatomic, copy) void (^buttonClickBlock)(UIButton *button);

- (void)buttonWhenClick:(void(^)(UIButton *button))block;

@end
