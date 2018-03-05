//
//  SCHBaiDuViewController.m
//  SCHProgress
//
//  Created by Mike on 2018/3/4.
//  Copyright © 2018年 Mike. All rights reserved.
//

#import "SCHBaiDuViewController.h"

@interface SCHBaiDuViewController ()<BMKMapViewDelegate>
//此view显示地图窗口，并对地图进行一系列操作
@property (nonatomic,strong) BMKMapView *mapView;

@end

@implementation SCHBaiDuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化mapView
    [self setMapView];
}
#pragma mark -- 初始化mapView
- (void)setMapView{
    _mapView = [[BMKMapView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_mapView];
    
    //1.设置地图相关属性
    //设置为标准地图
    _mapView.mapType = BMKMapTypeStandard;
    //是否显示比例尺
    _mapView.showMapScaleBar = YES;
    //比例尺级别 可显示的级别为 3~21级
    _mapView.zoomLevel = 12;
    //最大、小级别
    _mapView.maxZoomLevel = 17;
    _mapView.minZoomLevel = 5;
    //设置实时路况
    _mapView.trafficEnabled = YES;
    //以下_mapView为BMKMapView对象
    _mapView.showsUserLocation = YES;//显示定位图层
    //设置定位的状态为普通定位模式
    _mapView.userTrackingMode = BMKUserTrackingModeFollow;
    
    //遵循代理
    _mapView.delegate = self;
    
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    annotation.coordinate = CLLocationCoordinate2DMake(39.915, 116.404);
    annotation.title = @"这里是北京";
    annotation.subtitle = @"哈哈";
    [_mapView addAnnotation:annotation];
}
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]])
    {
        static NSString *reuseIndetifier = @"annotationReuseIndetifier";
        BMKAnnotationView *annotationView = (BMKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:reuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation
                                                           reuseIdentifier:reuseIndetifier];
        }
        //自定义image图标
        annotationView.image = [UIImage imageNamed:@"projecticon"];
        
        //自定义泡泡按钮
        /*
         PaopaotView
         如:
         SCHCustomPaopaotView *cusPao = [self getCustomPaopaoView];
         cusPao.tag = 123;
         annotationView.paopaoView = [[BMKActionPaopaoView alloc] initWithCustomView:cusPao];
         
         */
        
        return annotationView;
    }
    return nil;
} 
//自2.0.0起，BMKMapView新增viewWillAppear、viewWillDisappear方法来控制BMKMapView的生命周期，并且在一个时刻只能有一个BMKMapView接受回调消息，因此在使用BMKMapView的viewController中需要在viewWillAppear、viewWillDisappear方法中调用BMKMapView的对应的方法，并处理delegate
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    _mapView.delegate = self;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _mapView.delegate = self;
}
@end
