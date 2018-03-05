//
//  UIButton+SCH.h
//  SCHProgress
//
//  Created by Mike on 2018/1/24.
//  Copyright © 2018年 Mike. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickBtnBlock)(id sender);

@interface UIButton (SCH)
//分类增加属性要用 runtime
@property (nonatomic,copy) ClickBtnBlock clickBtnBlock;

//增加按钮title属性
@property (nonatomic,strong) NSString *BtnTitle;

- (void)SCH_SetTitle:(NSString *)title forState:(UIControlState)state;
@end
