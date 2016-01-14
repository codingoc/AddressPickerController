//
//  LNLocationManager.m
//  BAddressPickerDemo
//
//  Created by 林洁 on 16/1/14.
//  Copyright © 2016年 onlylin. All rights reserved.
//

#import "LNLocationManager.h"

static CLLocation *oldLocation;

@implementation LNLocationManager

- (id)init{
    self = [super init];
    if (self) {
        
    }
    return self;
}


- (void)startWithBlock:(void (^)(void))start completionBlock:(void (^)(CLLocation *))success failure:(void (^)(CLLocation *, NSError *))failure{
    [self setStartBlock:start completionBlock:success failure:failure];
    [self startLocation];
}


- (void)setStartBlock:(void(^)(void))start completionBlock:(void(^)(CLLocation*))success failure:(void (^)(CLLocation *, NSError *))failure{
    self.startBlock = start;
    self.successCompletionBlock = success;
    self.failureCompletionBlock = failure;
}


- (void)startLocation{
    self.startBlock();
    self.loactionManager.delegate = self;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [self.loactionManager requestWhenInUseAuthorization];
    }
    self.loactionManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    self.loactionManager.distanceFilter = 10.0f;
    [self.loactionManager startUpdatingLocation];
}


#pragma mark - CLLocationManager Delegate
//定位成功
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    [self.loactionManager stopUpdatingLocation];
    oldLocation = [locations lastObject];
    self.successCompletionBlock(oldLocation);
}

//定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    self.failureCompletionBlock(oldLocation,error);
}


#pragma mark - Getter and Setter
- (CLLocationManager*)loactionManager{
    if (_loactionManager == nil) {
        _loactionManager = [[CLLocationManager alloc] init];
    }
    return _loactionManager;
}


@end
