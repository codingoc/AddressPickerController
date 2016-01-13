//
//  BRecentCityCell.h
//  Bee
//
//  Created by 林洁 on 16/1/12.
//  Copyright © 2016年 Lin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BRecentCityCell : UITableViewCell

@property (nonatomic, strong) UIButton *firstButton;

@property (nonatomic, strong) UIButton *secondButton;

@property (nonatomic, copy) void (^buttonClickBlock)(UIButton *button);

- (void)buttonWhenClick:(void(^)(UIButton *button))block;

@end
