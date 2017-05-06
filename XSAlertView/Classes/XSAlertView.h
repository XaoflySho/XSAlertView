//
//  XSAlertView.h
//
//
//  Created by Xaofly Sho on 2016.
//  Copyright © 2016年 Xaofly Sho. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XSAlertViewDelegate;

typedef enum {
    XSAlertViewStylePlain = 0,   //普通   灰色
    XSAlertViewStyleDone,        //完成   绿色
    XSAlertViewStyleError,       //错误   红色
    XSAlertViewStyleWarning,     //警告   黄色
}XSAlertViewStyle;

@interface XSAlertView : UIView

/*
 初始化方法
 
 可选择性设置取消按钮，及其他按钮
 
 若有按钮，则最底部按钮为取消按钮
 
 若不设置按钮，则在弹出后3秒自动消失
 */
- (instancetype)initWithXSAlertViewStyle:(XSAlertViewStyle)alertViewStyle Message:(NSString *)message CancelButtonTitle:(NSString *)cancelButtonTitle OtherButtonTitles:(NSArray *)otherButtonTitles;

/**
 显示AlertView
 */
- (void)viewShow;

@property (nonatomic, weak) id <XSAlertViewDelegate> delegate;

@end

@protocol XSAlertViewDelegate <NSObject>

@optional

/*
 按钮被点击时调用此方法
 
 取消按钮Index为0，其他按钮由上至下，依次为1、2、3...
 */
- (void)XSAlertView:(XSAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

/*
 AlertView消失时调用此方法
 */
- (void)XSAlertViewCancel:(XSAlertView *)alertView;

@end
