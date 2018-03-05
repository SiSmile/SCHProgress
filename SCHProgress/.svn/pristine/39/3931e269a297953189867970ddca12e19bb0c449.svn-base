//
//  SCHHttpManager.h
//  SCHProgress
//
//  Created by Mike on 2018/1/16.
//  Copyright © 2018年 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCHHttpManager : NSObject

/**
 post 网络请求

 @param url 路径
 @param params 参数
 @param success 成功回调
 @param failure 失败回调
 */
- (NSURLSessionDataTask *)postWithUrl:(NSString *)url Params:(NSMutableDictionary *)params ReturnSuccess:(retureSuccessBlock)success ReturnFailure:(retureFailureBlock)failure;


/**
 get 网络请求
 
 @param url 路径
 @param params 参数
 @param success 成功回调
 @param failure 失败回调
 */
- (NSURLSessionDataTask *)getWithUrl:(NSString *)url Params:(NSMutableDictionary *)params ReturnSuccess:(retureSuccessBlock)success ReturnFailure:(retureFailureBlock)failure;


/**
 网络单例

 */
+ (instancetype)shareClient;

/**
 网络状态
 */
+ (void)netWorkState;
@end
