//
//  SCHMvvmViewModel.m
//  SCHProgress
//
//  Created by Mike on 2018/1/16.
//  Copyright © 2018年 Mike. All rights reserved.
//

#import "SCHMvvmViewModel.h"
#import "SCHMvvmModel.h"

@implementation SCHMvvmViewModel

#pragma mark -- 获取数据列表
- (void)loadProjectListData{
    //进行网络请求
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc] init];
    paramsDic[@"COUNT"] = @"100";
    paramsDic[@"access_token"] = @"2.00NofgBD0L1k4pc584f79cc48SKGdD";
    
    [[SCHHttpManager shareClient] getWithUrl:SCH_MVVM_WEIBOLIST Params:paramsDic ReturnSuccess:^(id successValue) {
        //1.处理数据
        NSArray *valueDataArr = successValue[@"statuses"];
        NSMutableArray *dataArray = [[NSMutableArray alloc]init];
        for (NSDictionary *dic in valueDataArr) {
            SCHMvvmModel *model = [SCHMvvmModel mj_objectWithKeyValues:dic];
            [dataArray addObject:model];
        }
        
        //2.回调给ViewController 所以要定义block
        if (self.successBlock) {
            self.successBlock(dataArray);
        }
    } ReturnFailure:^(id errorCode) {
        if (self.failureBlock) {
            self.failureBlock(errorCode);
        }
    }];
}


@end
