//
//  LSPaoMaView.h
//  LSDevelopmentModel
//
//  Created by  tsou117 on 15/7/29.
//  Copyright (c) 2015年  tsou117. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TEXTCOLOR COLOR_11
#define TEXTFONTSIZE SCREEN_HEIGHT/667*12

@interface LSPaoMaView : UIView
@property(nonatomic,strong)UILabel* textLb;
@property(nonatomic,strong)UILabel* reserveTextLb;
- (instancetype)initWithFrame:(CGRect)frame title:(NSString*)title;

- (void)start;//开始跑马
- (void)stop;//停止跑马

@end
