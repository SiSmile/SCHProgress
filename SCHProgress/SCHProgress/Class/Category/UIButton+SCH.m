//
//  UIButton+SCH.m
//  SCHProgress
//
//  Created by Mike on 2018/1/24.
//  Copyright © 2018年 Mike. All rights reserved.
//

#import "UIButton+SCH.h"
#import <objc/runtime.h>

static const void *ButtonKey = @"ButtonKey";
static const void *ButtonTitle = @"ButtonTitle";
@implementation UIButton (SCH)

- (ClickBtnBlock)clickBtnBlock{
    return objc_getAssociatedObject(self, &ButtonKey);
}
- (void)setClickBtnBlock:(ClickBtnBlock)clickBtnBlock{
    objc_setAssociatedObject(self, &ButtonKey, clickBtnBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(SCHBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)SCHBtnClick:(id)sender{
    if (self.clickBtnBlock) {
        self.clickBtnBlock(sender);
    }

}

//title
- (NSString *)BtnTitle{
    return objc_getAssociatedObject(self, &ButtonTitle);
}
- (void)setBtnTitle:(NSString *)BtnTitle{
    
    objc_setAssociatedObject(self, &ButtonTitle, BtnTitle, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
}

//load方法会在类第一次加载的时候被调用
//调用的时间比较靠前，适合在这个方法里做方法交换
+(void)load{
    //方法交换应该被保证，在程序中只会执行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL OldSel = @selector(setTitle: forState:);
        SEL NewSel = @selector(SCH_SetTitle: forState:);
        
        //系统原有方法
        Method OldMethod = class_getInstanceMethod([self class],OldSel);
        //要替换成的方法
        Method NewMethod = class_getInstanceMethod([self class],NewSel);
        
        //首先动态添加方法，实现是被交换的方法，返回值表示添加成功还是失败
        BOOL isAdd = class_addMethod(self, OldSel, method_getImplementation(NewMethod), method_getTypeEncoding(NewMethod));
        if (isAdd) {
            //如果成功，说明类中不存在这个方法的实现
            //将被交换方法的实现替换到这个并不存在的实现
            class_replaceMethod(self, NewSel, method_getImplementation(OldMethod), method_getTypeEncoding(OldMethod));
        }else{
            //否则，交换两个方法的实现
            method_exchangeImplementations(OldMethod, NewMethod);
        }
    });
    
}
- (void)SCH_SetTitle:(NSString *)title forState:(UIControlState)state{
    [self SCH_SetTitle:title forState:state];
}




@end
