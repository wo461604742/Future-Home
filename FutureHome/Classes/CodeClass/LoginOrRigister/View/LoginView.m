//
//  LoginView.m
//  RWGame
//
//  Created by liuchao on 2017/6/28.
//  Copyright © 2017年 chao.liu. All rights reserved.
//

#import "LoginView.h"

@implementation LoginView

#pragma mark - Life Cycle
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    //验证码登录
    [self.leftTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(2.5);
        make.left.mas_equalTo(32.5);
        make.height.equalTo(@30);
    }];
    //忘记密码
    [self.rightTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.leftTitle);
        make.right.mas_equalTo(-32.5);
        make.height.equalTo(self.leftTitle);
    }];
    //登录
    [self.underButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.5);
        make.right.mas_equalTo(-20.5);
        make.top.equalTo(@40);
        make.height.equalTo(@55);
    }];
    
    //注册
    [self.rigisterBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.5);
        make.right.mas_equalTo(-20.5);
        make.top.equalTo(@100);
        make.height.equalTo(@55);
    }];
}

- (void)drawRect:(CGRect)rect
{
//    [self.underButton setRoundedCorners:UIRectCornerAllCorners radius:44];
}

#pragma mark - Event Response
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UIView *view = touches.anyObject.view;
    
    if (view == self.leftTitle)
    {
        [self touchView:self.leftTitle.text];
    }
    else if (view == self.rightTitle)
    {
        [self touchView:self.rightTitle.text];
    }
}

- (void)touchView:(NSString *)name
{
    if ([self.delegate respondsToSelector:@selector(loginView:withName:)])
    {
        [self.delegate loginView:self withName:name];
    }
}

- (void)onClickUnderButton:(UIButton *)button
{
    [self touchView:button.currentTitle];
}

- (void)onClickRigisterButton:(UIButton *)button {
     [self touchView:button.currentTitle];
}

#pragma mark - Getters and Setters
- (UILabel *)leftTitle {
    if (_leftTitle == nil) {
        _leftTitle = [[UILabel alloc] init];
        _leftTitle.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        _leftTitle.textColor = HEX_COLOR(0x666666);
        _leftTitle.userInteractionEnabled = YES;
        
        [self addSubview:_leftTitle];
    }
    return _leftTitle;
}

- (UILabel *)rightTitle {
    if (_rightTitle == nil) {
        _rightTitle = [[UILabel alloc] init];
        _rightTitle.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        _rightTitle.textColor = HEX_COLOR(0x666666);
        _rightTitle.userInteractionEnabled = YES;
        [self addSubview:_rightTitle];
    }
    return _rightTitle;
}

- (UIButton *)rigisterBtn {
    if (_rigisterBtn == nil) {
        _rigisterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rigisterBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        [_rigisterBtn setTitleColor:HEX_COLOR(0xFFFFFF) forState:UIControlStateNormal];
        [_rigisterBtn addTarget:self action:@selector(onClickRigisterButton:) forControlEvents:UIControlEventTouchUpInside];
        [_rigisterBtn setBackgroundImage:[UIImage imageNamed:@"rw_login_user"] forState:UIControlStateNormal];
        [_rigisterBtn setTitleEdgeInsets:UIEdgeInsetsMake(-5, 0, 0, 0)];
        [self addSubview:_rigisterBtn];
    }
    return _rigisterBtn;
}

- (UIButton *)underButton {
    if (_underButton == nil) {
        _underButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _underButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        [_underButton setTitleColor:HEX_COLOR(0xFFFFFF) forState:UIControlStateNormal];
        [_underButton addTarget:self action:@selector(onClickUnderButton:) forControlEvents:UIControlEventTouchUpInside];
        [_underButton setBackgroundImage:[UIImage imageNamed:@"rw_login_noUser"] forState:UIControlStateNormal];
        [_underButton setTitleEdgeInsets:UIEdgeInsetsMake(-5, 0, 0, 0)];
        _underButton.alpha = 0.5;
        [self addSubview:_underButton];
    }
    return _underButton;
}

@end
