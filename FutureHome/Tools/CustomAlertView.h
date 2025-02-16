//
//  CustomDialogView.h
//  Qian100
//
//  Created by zhaoxiao on 14-9-3.
//  Copyright (c) 2014年 ZOSENDA. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomAlertView : UIView

@property (nonatomic,retain) UILabel *msgLabel;
@property (nonatomic,retain) UIFont *messageFont;
@property (nonatomic,retain) NSArray *buttonColor;

@property (nonatomic,assign) BOOL   seriesAlert;

/**
 *  @两个按钮纯文本显示（block回调方式）
 */
-(id)initWithTitle:(NSString *)title message:(NSString *)message buttonColor:(NSArray *)buttonColor buttonTitles:(NSString *)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;

/**
 *  显示弹出框
 */
-(void)showWithCompletion:(void (^)(NSInteger selectIndex))completeBlock;

-(void)showInView:(UIView *)baseView completion:(void (^)(NSInteger selectIndex))completeBlock;

/**
 *  关闭视图
 */
-(void)closeView;

@end
