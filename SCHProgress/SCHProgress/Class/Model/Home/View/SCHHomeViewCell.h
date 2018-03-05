//
//  SCHHomeViewCell.h
//  SCHProgress
//
//  Created by Mike on 2018/1/15.
//  Copyright © 2018年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCHHomeModel.h"

@interface SCHHomeViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (nonatomic,strong) SCHHomeModel *model;
@end
