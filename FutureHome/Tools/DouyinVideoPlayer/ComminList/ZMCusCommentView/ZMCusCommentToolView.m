//
//  ZMCusCommentToolView.m
//  ZMZX
//
//  Created by Kennith.Zeng on 2018/8/29.
//  Copyright © 2018年 齐家网. All rights reserved.
//

#import "ZMCusCommentToolView.h"
#import "UIView+Frame.h"
//#define MIN_TEXTVIEW_HEIGHT 36
//#define MAX_TEXTVIEW_HEIGHT 76

#define MIN_TEXTVIEW_HEIGHT 57
#define MAX_TEXTVIEW_HEIGHT 85
@interface ZMCusCommentToolView()<UITextViewDelegate>
@property (nonatomic, strong) UIView *contentBgView;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, assign) CGFloat defaultHeight;

@end

@implementation ZMCusCommentToolView
- (instancetype)initWithFrame:(CGRect)frame{
    
    if ([super initWithFrame:frame]) {
        self.backgroundColor = RGBHexColor(0xffffff, 1);
        self.layer.shadowColor = RGBHexColor(0x000000, 1).CGColor;
        self.layer.shadowOffset = CGSizeMake(0, -1);
        self.layer.shadowOpacity = 0.1;
        self.layer.shadowRadius = 4;
        self.defaultHeight = frame.size.height;
        [self layoutUI];
 
    }
    return self;
}
- (void)layoutUI{
    
    if (!_sendBtn) {
        _sendBtn = [[UIButton alloc] init];
        [_sendBtn setTitleColor:RGBA(204, 204, 204, 1) forState:UIControlStateNormal];
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        _sendBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_sendBtn addTarget:self action:@selector(sendBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_sendBtn];
        [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-9);
            make.top.mas_equalTo(7);
            make.width.mas_offset(50);
            make.height.mas_offset(45);
        }];
    }
    
    
    if (!_contentBgView) {
        _contentBgView = [[UIView alloc] init];
        _contentBgView.backgroundColor = RGBA(241, 242, 244, 1);
        _contentBgView.layer.masksToBounds = YES;
        _contentBgView.layer.cornerRadius = 0;
        [self addSubview:_contentBgView];
        [_contentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(14);
            make.right.mas_equalTo(self->_sendBtn.mas_left).mas_offset(-13);
            make.height.mas_offset(MIN_TEXTVIEW_HEIGHT);
            make.top.mas_equalTo(7);
        }];
    }
    
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        [_headImageView setImage:[UIImage imageNamed:@"head_list_small"]];
        [_contentBgView addSubview:_headImageView];
        [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(3);
            make.bottom.mas_equalTo(-2);
            make.size.mas_equalTo(CGSizeMake(31, 31));
        }];
    }
    
    if (!_textView) {
        _textView = [[ZMPlaceholderTextView alloc]init];
        _textView.textAlignment = NSTextAlignmentLeft;
        _textView.font = [UIFont systemFontOfSize:16];
        _textView.returnKeyType = UIReturnKeyDone;
        _textView.delegate = self;
        _textView.textColor = RGBHexColor(0x333333, 1);
        _textView.placeholder = @"你也来聊两句吧";
        _textView.backgroundColor = [UIColor clearColor];
        _textView.showsVerticalScrollIndicator = NO;
        [_contentBgView addSubview:_textView];
        [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(_headImageView.mas_right).mas_offset(3);
            
            make.left.mas_equalTo(3);
            make.top.mas_equalTo(0);
            make.right.mas_equalTo(-3);
            make.height.mas_offset(MIN_TEXTVIEW_HEIGHT);
        }];
    }

}
- (void)showTextView {
    [self.textView becomeFirstResponder];
}
- (void)hideTextView{
    [self.textView resignFirstResponder];
}

- (void)sendBtnAction{
    if (self.sendBtnBlock) {
        self.sendBtnBlock(self.textView.text);
    }
}
- (void)resetView {
    self.textView.text = @"";
    [self.sendBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-9);
        make.top.mas_equalTo(7);
        make.width.mas_offset(40);
        make.height.mas_offset(36);
    }];
    [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(MIN_TEXTVIEW_HEIGHT);
    }];
    [self.contentBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(MIN_TEXTVIEW_HEIGHT);
    }];
    self.sendBtn.userInteractionEnabled = NO;
    [self.sendBtn setTitleColor:RGBA(204, 204, 204, 1) forState:UIControlStateNormal];

}
#pragma mark - textviewDelegate

- (void)textViewDidChange:(UITextView *)textView{

    CGFloat width = CGRectGetWidth(textView.frame);
//    CGFloat height = CGRectGetHeight(textView.frame);
    CGSize newSize = [textView sizeThatFits:CGSizeMake(width,MAXFLOAT)];
    CGFloat newHeight = newSize.height;
    if (newHeight<MIN_TEXTVIEW_HEIGHT) {
        newHeight = MIN_TEXTVIEW_HEIGHT;
    }
    if (newHeight>=MAX_TEXTVIEW_HEIGHT) {
        newHeight = MAX_TEXTVIEW_HEIGHT;
    }
    self.height = newHeight + 15;
    
    if (self.height>self.defaultHeight) {
        CGFloat changeOffsetY = self.height- self.defaultHeight;
        self.y = - changeOffsetY;
        [self.sendBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-9);
            make.top.mas_equalTo(7);
            make.width.mas_offset(40);
            make.height.mas_offset(36);
        }];
    }else {
        self.y = 0;
        [self.sendBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-9);
            make.top.mas_equalTo(7);
            make.width.mas_offset(40);
            make.height.mas_offset(36);
        }];
    }
    [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(newHeight);
    }];
    [self.contentBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_offset(newHeight);
    }];

    if (textView.text.length>0) {
        self.sendBtn.userInteractionEnabled = YES;
        [self.sendBtn setTitleColor:HEX_COLOR(0x1296db) forState:UIControlStateNormal];
    }else{
        self.sendBtn.userInteractionEnabled = NO;
        [self.sendBtn setTitleColor:RGBA(204, 204, 204, 1) forState:UIControlStateNormal];
    }

    if (self.changeTextBlock) {
        self.changeTextBlock(@"",self.frame);
    }
}

@end
