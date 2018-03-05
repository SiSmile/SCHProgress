//
//  SCHTableView.m
//  SCHProgress
//
//  Created by Mike on 2018/1/15.
//  Copyright © 2018年 Mike. All rights reserved.
//

#import "SCHTableView.h"

@implementation SCHTableView
#pragma mark -- 初始化数据源
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
#pragma mark -- init初始化tableview
- (instancetype)init{
    self = [super init];
    if (self) {
        
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        self.dataArray = [NSMutableArray array];
        self.page =1;
        self.totalPage = 0;
        self.backgroundColor = HexRGB(0xf6f6f6);
        
    }
    return self;
}

#pragma mark -- initWithFrame初始化tableview
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        self.dataArray = [NSMutableArray array];
        self.page =1;
        self.totalPage = 0;
        self.backgroundColor = HexRGB(0xf6f6f6);
    }
    return self;
}
#pragma mark -- initWithFrame: style:初始化tableview
- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        self.dataArray = [NSMutableArray array];
        self.page =1;
        self.totalPage = 0;
        self.backgroundColor = HexRGB(0xf6f6f6);
    }
    return self;
}
@end
