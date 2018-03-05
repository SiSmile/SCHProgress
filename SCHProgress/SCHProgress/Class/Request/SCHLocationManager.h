//
//  SCHLocationManager.h
//  SCHProgress
//
//  Created by Mike on 2018/3/4.
//  Copyright © 2018年 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>

//用户经纬度
typedef void(^SCHBMKLocationBlock)(CLLocationDegrees latitude,CLLocationDegrees longitude,NSError *error);

@interface SCHLocationManager : NSObject
+ (instancetype)shareLocationManager;

//开始定位用户
- (void)startUserLoactionWith:(SCHBMKLocationBlock)locationBlock;
@end
