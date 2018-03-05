//
//  SCHLocationManager.m
//  SCHProgress
//
//  Created by Mike on 2018/3/4.
//  Copyright © 2018年 Mike. All rights reserved.
//

#import "SCHLocationManager.h"

@interface SCHLocationManager ()<BMKLocationServiceDelegate>

@property (nonatomic,strong) BMKLocationService *locationService;

@property (nonatomic,copy) SCHBMKLocationBlock locationBlock;
@end


@implementation SCHLocationManager
+ (instancetype)shareLocationManager{
    static SCHLocationManager *_locationManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _locationManager = [[SCHLocationManager alloc] init];
        
    });
    return _locationManager;
}
- (BMKLocationService *)locationService{
    if (!_locationService) {
        _locationService = [[BMKLocationService alloc] init];
        _locationService.delegate = self;
        
    }
    return _locationService;
}
#pragma mark -- 开始定位
- (void)startUserLoactionWith:(SCHBMKLocationBlock)locationBlock{
    [self.locationService startUserLocationService];
    _locationBlock = locationBlock;
}

//实现相关delegate 处理位置信息更新
//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //原始坐标
    CLLocationCoordinate2D coor = userLocation.location.coordinate;
    //NSLog(@"heading is %@",userLocation.heading);
    if (_locationBlock) {
        _locationBlock(coor.latitude,coor.longitude,nil);
    }
    
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    //原始坐标
    CLLocationCoordinate2D coor = userLocation.location.coordinate;
    //NSLog(@"heading is %@",userLocation.heading);
    if (_locationBlock) {
        _locationBlock(coor.latitude,coor.longitude,nil);
    }
}
@end
