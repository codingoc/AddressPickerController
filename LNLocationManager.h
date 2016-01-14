//
//  LNLocationManager.h
//  BAddressPickerDemo
//
//  Created by 林洁 on 16/1/14.
//  Copyright © 2016年 onlylin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface LNLocationManager : UIView<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *loactionManager;

@property (nonatomic, copy) void (^startBlock)(void);

@property (nonatomic, copy) void (^successCompletionBlock)(CLLocation *location);

@property (nonatomic, copy) void (^failureCompletionBlock)(CLLocation *location,NSError *error);


- (void)startWithBlock:(void(^)(void))start
       completionBlock:(void(^)(CLLocation *location))success
               failure:(void(^)(CLLocation *location, NSError *error))failure;

@end
