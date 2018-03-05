//
//  SCHTableView.h
//  SCHProgress
//
//  Created by Mike on 2018/1/15.
//  Copyright © 2018年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SCHTableView : UITableView

/**
 当前第几页
 */
@property (nonatomic,assign) NSInteger page;


/**
 一共多少页
 */
@property (nonatomic,assign) NSInteger totalPage;

/**
 数据源
 */
@property (nonatomic,strong) NSMutableArray  *dataArray;
@end
