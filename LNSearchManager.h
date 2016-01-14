//
//  LNSearchManager.h
//  Bee
//
//  Created by 林洁 on 16/1/14.
//  Copyright © 2016年 Lin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "LNLocationGeocoder.h"

@interface LNSearchManager : NSObject

@property (nonatomic, strong) CLGeocoder *gecoder;

@property (nonatomic, copy) void (^completionBlock)(LNLocationGeocoder *locationGeocoder,NSError *error);

- (void)startReverseGeocode:(CLLocation*)location completeionBlock:(void(^)(LNLocationGeocoder *locationGeocoder,NSError *error))completeion;

@end
