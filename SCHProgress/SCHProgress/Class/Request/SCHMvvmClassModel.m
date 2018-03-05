//
//  SCHMvvmClassModel.m
//  SCHProgress
//
//  Created by Mike on 2018/1/16.
//  Copyright © 2018年 Mike. All rights reserved.
//

#import "SCHMvvmClassModel.h"

@implementation SCHMvvmClassModel
#pragma mark -- 回调
- (void)setDataBlockWithRetureSuccessBlock:(retureSuccessBlock)successBlock RetureFailureBlock:(retureFailureBlock)failureBlock{
    _successBlock = successBlock;
    _failureBlock = failureBlock;
}
@end
