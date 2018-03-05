//
//  SCHMvvmCell.m
//  SCHProgress
//
//  Created by Mike on 2018/1/16.
//  Copyright © 2018年 Mike. All rights reserved.
//

#import "SCHMvvmCell.h"
#import "SCHMvvmModel.h"

@implementation SCHMvvmCell

- (void)setModel:(SCHMvvmModel *)model{
    _model = model;
    _nameLabel.text = model.user.name;
    [_iconImage sd_setImageWithURL:[NSURL URLWithString:model.user.avatar_large]];
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
