//
//  LNLocationGeocoder.h
//  Bee
//
//  Created by 林洁 on 16/1/14.
//  Copyright © 2016年 Lin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LNLocationGeocoder : NSObject

@property (nonatomic, copy) NSString *formatterAddress;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *district;
@property (nonatomic, copy) NSString *locality;

@end
