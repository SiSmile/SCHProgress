//
//  AppDelegate+SCHAppService.h
//  SCHProgress
//
//  Created by Mike on 2018/3/4.
//  Copyright © 2018年 Mike. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (SCHAppService)<BMKGeneralDelegate>
//地图管理者对象
@property (nonatomic,strong) BMKMapManager *mapManager;

//初始化百度地图
- (void)setBaiDuSDK;

//开始定位
- (void)setUserLocation;
@end
