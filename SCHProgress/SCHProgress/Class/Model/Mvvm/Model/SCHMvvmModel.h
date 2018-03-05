//
//  SCHMvvmModel.h
//  SCHProgress
//
//  Created by Mike on 2018/1/16.
//  Copyright © 2018年 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCHMvvmUserModel.h"

@interface SCHMvvmModel : NSObject

@property (strong, nonatomic) NSString *weiboId;
@property (strong, nonatomic) SCHMvvmUserModel *user;
@end
