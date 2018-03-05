//
//  AppDelegate+SCHAppService.m
//  SCHProgress
//
//  Created by Mike on 2018/3/4.
//  Copyright © 2018年 Mike. All rights reserved.
//

#define MapManagerKey @"MapManagerKey"
#import "AppDelegate+SCHAppService.h"
#import "SCHLocationManager.h"

@implementation AppDelegate (SCHAppService)

 //原生runtime
#pragma mark -- 利用runtime 给分类增加属性mapManager
- (void)setMapManager:(BMKMapManager *)mapManager{
    objc_setAssociatedObject(self, MapManagerKey, mapManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BMKMapManager *)mapManager{
    return objc_getAssociatedObject(self, MapManagerKey);
}

#pragma mark -- 初始化百度地图BMKMapManager
- (void)setUserLocation{
    [[SCHLocationManager shareLocationManager] startUserLoactionWith:^(CLLocationDegrees latitude, CLLocationDegrees longitude, NSError *error) {
        //开启定位了
//        NSLog(@"l==%f  c==%f",latitude,longitude);
    }];
}

#pragma mark -- 初始化百度地图BMKMapManager
- (void)setBaiDuSDK{
    self.mapManager = [[BMKMapManager alloc] init];
    
    //    [BMKMapManager setCoordinateTypeUsedInBaiduMapSDK:BMK_COORDTYPE_COMMON];
    /**
     *百度地图SDK所有接口均支持百度坐标（BD09）和国测局坐标（GCJ02），用此方法设置您使用的坐标类型.
     *默认是BD09（BMK_COORDTYPE_BD09LL）坐标.
     *如果需要使用GCJ02坐标，需要设置CoordinateType为：BMK_COORDTYPE_COMMON.
     */
    
//    if ([BMKMapManager setCoordinateTypeUsedInBaiduMapSDK:BMK_COORDTYPE_COMMON]) {
//        NSLog(@"经纬度类型设置成功");
//    }else{
//        NSLog(@"经纬度类型设置失败");
//    }
//    
    //关注网络及授权验证 设定generalDelegate参数
    /*
     start :appkey
     */
    BOOL ret = [self.mapManager start:BaiDuSDK_KEY generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
}
@end
