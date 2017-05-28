//
//  XSAlertView.m
//
//
//  Created by Xaofly Sho on 2016.
//  Copyright © 2016年 Xaofly Sho. All rights reserved.
//

#import "XSAlertView.h"

//屏幕宽度
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
//屏幕高度
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
//RGBColor
#define COLOR_RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define UIColorFromHex(s) [UIColor colorWithRed:(((s & 0xFF0000) >> 16))/255.0 green:(((s &0xFF00) >>8))/255.0 blue:((s &0xFF))/255.0 alpha:1.0]

@interface XSAlertView () {
    
    BOOL isButton;
    
}

@property (nonatomic, strong) UIVisualEffectView *backView;
@property (nonatomic) CGSize textSize;
@property (nonatomic) XSAlertViewStyle style;

@end

@implementation XSAlertView


- (instancetype)initWithXSAlertViewStyle:(XSAlertViewStyle)alertViewStyle Message:(NSString *)message CancelButtonTitle:(NSString *)cancelButtonTitle OtherButtonTitles:(NSArray *)otherButtonTitles {
    
    NSMutableArray *buttonTitles = [[NSMutableArray alloc]initWithArray:otherButtonTitles];
    
    if (cancelButtonTitle.length > 0) {
        [buttonTitles addObject:cancelButtonTitle];
    }
    
    if (buttonTitles.count != 0) {
        
        isButton = YES;
        [self backViewInit];
    }
    
    [self setTextSizeWithMessage:message buttonTitles:buttonTitles];
    
    CGFloat sizeHeight = self.textSize.height + 24 + buttonTitles.count * 45 + 8;
    
    if (self = [super init]) {
        
        self.frame = CGRectMake(0, 0, self.textSize.width + 24, sizeHeight);
        
        self.backgroundColor = [UIColor clearColor];
        
        self.style = alertViewStyle;
        
        [self baseInitWithMessage:message];
        
        [self baseInitWithButtonTitles:buttonTitles];
        
        
    }
    
    return self;
}

- (void)setTextSizeWithMessage:(NSString *)message buttonTitles:(NSArray *)buttonTitles {
    
    self.textSize = [self countTextSizeWithText:message fontSize:15.0f];
    
    [buttonTitles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGSize textSize = [self countTextSizeWithText:obj fontSize:17.0f];
        
        if (self.textSize.width < textSize.width) {
            self.textSize = textSize;
        }
        
    }];
    
}

- (CGSize)countTextSizeWithText:(NSString *)text fontSize:(CGFloat)fontSize {
    
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 24 - 32, MAXFLOAT)
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading |NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]}
                                       context:nil].size;
    
    if (textSize.width < 150) {
        textSize.width = 150;
    }
    
    return textSize;
    
}

- (void)baseInitWithMessage:(NSString *)message {
    
    UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 12, self.textSize.width, self.textSize.height)];
    
    messageLabel.text = message;
    messageLabel.textColor = [UIColor whiteColor];
    messageLabel.numberOfLines = 0;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.font = [UIFont systemFontOfSize:15.0];
    messageLabel.backgroundColor = [UIColor clearColor];
    messageLabel.userInteractionEnabled = NO;
    
    UIView *labelBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.textSize.width + 24, self.textSize.height + 24)];
    labelBackView.userInteractionEnabled = NO;
    
    [self viewSetStyleWithView:labelBackView];
    
    [self addSubview:labelBackView];
    [self addSubview:messageLabel];
    
}

- (void)baseInitWithButtonTitles:(NSArray *)buttonTitles {
    
    for (int i = 0; i < buttonTitles.count; i ++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        
        button.frame = CGRectMake(0, self.textSize.height + 32 + i * 45, self.bounds.size.width, 44);
        
        [button setTitle:buttonTitles[i] forState:UIControlStateNormal];
        
        [self viewSetStyleWithView:button];
        button.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
        
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == buttonTitles.count - 1) {
            button.tag = 0;
            button.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
        }else{
            button.tag = i + 1;
            button.titleLabel.font = [UIFont systemFontOfSize:17.0f];
        }
        
        [self addSubview:button];
        
    }
    
}

- (void)backViewInit {
    
    self.backView = [[UIVisualEffectView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.backView.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.6];
    self.backView.alpha = 0;
    
    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    [self.backView setEffect:blurEffect];
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    [window addSubview:self.backView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    [self.backView addGestureRecognizer:tap];
    
}

- (UIView *)viewSetStyleWithView:(UIView *)view {
    
    view.backgroundColor = [self colorWithXSAlertViewStyle:self.style];
    view.layer.cornerRadius = 10;
    view.clipsToBounds = YES;
    view.alpha = 0.9;
    
    return view;
}

- (UIColor *)colorWithXSAlertViewStyle:(XSAlertViewStyle)alertViewStyle{
    
    UIColor *color;
    switch (alertViewStyle) {
        case XSAlertViewStylePlain:{
//            color = COLOR_RGBA(130, 130, 130, 1);
            color = UIColorFromHex(0x99CCFF);
        }
            break;
        case XSAlertViewStyleDone:{
            
            color = COLOR_RGBA(86, 163, 78, 1);
//            color = UIColorFromHex(0x669933);
            
        }
            break;
        case XSAlertViewStyleWarning:{
            
            color = COLOR_RGBA(255, 150, 46, 1);
//            color = UIColorFromHex(0xFFCC33);
            
        }
            break;
        case XSAlertViewStyleError:{
            
            color = COLOR_RGBA(255, 2, 27, 1);
//            color = UIColorFromHex(0xCC3333);
            
        }
            break;
            
        default:
            break;
    }
    
    return color;
}

- (void)buttonClick:(UIButton *)sender {
    
    if ([_delegate respondsToSelector:@selector(XSAlertView:clickedButtonAtIndex:)]) {
        [_delegate XSAlertView:self clickedButtonAtIndex:sender.tag];
    }
    
    if ([_delegate respondsToSelector:@selector(XSAlertViewCancel:)]) {
        [_delegate XSAlertViewCancel:self];
    }
    
    [self viewHide];
    
}

- (void)tap:(UITapGestureRecognizer *)sender {
    
    if ([_delegate respondsToSelector:@selector(XSAlertViewCancel:)]) {
        [_delegate XSAlertViewCancel:self];
    }
    
    [self viewHide];
    
}

- (void)viewHide {
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         
                         self.backView.alpha = 0;
                         
                         self.alpha = 0;
                         
                         self.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT + self.bounds.size.height / 2);
                         
                     } completion:^(BOOL finished) {
                         
                         [self removeFromSuperview];
                         [self.backView removeFromSuperview];
                         
                     }];
    
}

- (void)viewShow {
    
    self.alpha = 0;
    
    self.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT + self.bounds.size.height / 2);
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    [window addSubview:self];
    
    [window endEditing:YES];
    
    [window bringSubviewToFront:self];
    
    [UIView animateWithDuration:1
                          delay:0
         usingSpringWithDamping:0.5
          initialSpringVelocity:10
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         
                         self.backView.alpha = 1;
                         
                         self.alpha = 1;
                         
                         if (isButton) {
                             
                             self.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT - 16 - self.bounds.size.height / 2);
                             
                         }else {
                             
                             self.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT - 57 - self.bounds.size.height / 2);
                             
                         }
                         
                         
                         
                     } completion:^(BOOL finished) {
                         
                         if (finished) {
                             
                             if (!isButton) {
                                 
                                 [UIView animateWithDuration:0.3
                                                       delay:3
                                                     options:UIViewAnimationOptionCurveEaseInOut
                                                  animations:^{
                                                      
                                                      self.alpha = 0;
                                                      
                                                      self.center = CGPointMake(SCREEN_WIDTH / 2, SCREEN_HEIGHT + self.bounds.size.height / 2);
                                                      
                                                  } completion:^(BOOL finished) {
                                                      
                                                      if ([_delegate respondsToSelector:@selector(XSAlertViewCancel:)]) {
                                                          [_delegate XSAlertViewCancel:self];
                                                      }
                                                      
                                                      [self removeFromSuperview];
                                                      
                                                  }];
                             }
                         }
                         
                     }];
    
}

@end
