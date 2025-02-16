//
//  FHCommonPaySelectView.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/11/13.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHCommonPaySelectView.h"
#import "MoneyButton.h"
#define payViewHeight 260
#define CLColor(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]
#define titleColor  CLColor(240.0f, 130.0f, 0.0f)
#define BOUNDS   [[UIScreen mainScreen] bounds]

@interface FHCommonPaySelectView ()
/**现价  */
@property (nonatomic, copy) NSString *nowPrice;
/** 原价 */
@property (nonatomic, copy) NSString *oldPrice;
/** <#copy属性注释#> */
@property (nonatomic, copy) NSString *discountedString;



@end

@implementation FHCommonPaySelectView

//-(UIView *)initWithFrame:(CGRect )frame andNSString:(NSString *)title {
//    self = [super initWithFrame:frame];
//    if (self) {
//        self.backgroundColor = [UIColor clearColor];
//        [self layOutUIWith:title];
//    }
//    return self;
//}

-(UIView *)initWithFrame:(CGRect )frame
                nowPrice:(NSString *)nowPrice
                oldPrice:(NSString *)oldPrice
              discounted:(NSString *)discounted {
    self = [super initWithFrame:frame];
    if (self) {
        self.nowPrice = nowPrice;
        self.oldPrice = oldPrice;
        self.discountedString = discounted;
        self.backgroundColor = [UIColor clearColor];
        
    }
     return self;
}

- (void)setShowType:(NSString *)showType {
    _showType = showType;
    [self layOutUIWithSubViews];
}

#pragma mark - LayoutUIs
- (void)layOutUIWithSubViews {
    self.backgroungView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-payViewHeight, SCREEN_WIDTH, payViewHeight)];//层
    _backgroungView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_backgroungView];
    
    self.headTitleLabel = [[UILabel alloc] init];
    _headTitleLabel.textColor = [UIColor blackColor];
    if ([self.showType isEqualToString:@"shopShow"]) {
        _headTitleLabel.font = [UIFont systemFontOfSize:20.0f];
        _headTitleLabel.text = [NSString stringWithFormat:@"%@\n%@%@",self.oldPrice,self.discountedString,self.nowPrice];
    } else {
        _headTitleLabel.font = [UIFont systemFontOfSize:14.0f];
        NSString *titleString = [NSString stringWithFormat:@"账户开通审核服务费原价:￥%@\n\n%@￥%@",self.oldPrice,self.discountedString,self.nowPrice];
        NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc]initWithString:titleString];
        NSInteger legth1 = 1 + self.oldPrice.length;
        [attributedTitle changeColor:[UIColor blackColor] rang:[attributedTitle changeBoldFontFloat:14 from:12 legth:legth1]];
         [attributedTitle changeColor:[UIColor redColor] rang:[attributedTitle changeBoldFontFloat:14 from:12 + legth1 + self.discountedString.length + 2 legth:1 + self.nowPrice.length]];
        _headTitleLabel.attributedText = attributedTitle;
    }
    _headTitleLabel.textAlignment = NSTextAlignmentLeft;
    _headTitleLabel.numberOfLines = 0;
    _headTitleLabel.backgroundColor = [UIColor whiteColor];
    [_backgroungView addSubview:_headTitleLabel];
    
    /**
     分割线
     */
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = CLColor(234, 236, 235);
    [_backgroungView addSubview:line];

    /**
     *  微信支付
     */
    _creditBtn = [[MoneyButton alloc] init];
    [_creditBtn setTitle:@"微信支付" forState:UIControlStateNormal];
    [_creditBtn setTitleColor:CLColor(102, 102, 102) forState:UIControlStateNormal];
    _creditBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [_backgroungView addSubview:_creditBtn];
    
    _topLogoImgView = [[UIImageView alloc] init];
    _topLogoImgView.image = [UIImage imageNamed:@"微信logo320*320"];
    [_backgroungView addSubview:_topLogoImgView];
    
    _topSelectBtn = [[MoneyButton alloc] init];
    [_topSelectBtn setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    _topSelectBtn.tag = 2;
    [_topSelectBtn addTarget:self action:@selector(creditBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    _topSelectBtn.param = @"fales";
    [_backgroungView addSubview:_topSelectBtn];
    
    //支付宝支付
    _walltBtn = [[MoneyButton alloc]init];
    [_walltBtn setTitle:@"支付宝支付" forState:UIControlStateNormal];
    [_walltBtn setTitleColor:CLColor(102, 102, 102) forState:UIControlStateNormal];
    _walltBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    [_backgroungView addSubview:_walltBtn];
    
    _bottomLogoImgView = [[UIImageView alloc] init];
    _bottomLogoImgView.image = [UIImage imageNamed:@"支付宝logo320*320"];
    [_backgroungView addSubview:_bottomLogoImgView];
    
    _bottomSelectBtn = [[MoneyButton alloc] init];
    _bottomSelectBtn.tag = 1;
    [_bottomSelectBtn setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    [_bottomSelectBtn addTarget:self action:@selector(creditBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    _bottomSelectBtn.param = @"fales";
    [_backgroungView addSubview:_bottomSelectBtn];

    //在线支付按钮
    self.online = [UIButton buttonWithType:UIButtonTypeCustom];
    _online.backgroundColor = HEX_COLOR(0x1296db);
    self.online.layer.cornerRadius = 2.0f;
    self.online.clipsToBounds = YES;
    [_online setTitle:@"确认" forState:UIControlStateNormal];
    [_online addTarget:self action:@selector(onlineBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_backgroungView addSubview:_online];
    
    /*
     *  X 号按钮
     */
    UIButton *closeBtn = [[UIButton alloc] init];
    [closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [closeBtn setImage:[UIImage imageNamed:@"t_close"] forState:UIControlStateNormal];
    [_backgroungView addSubview:closeBtn];
    
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self->_backgroungView.mas_right).offset(-10);
        make.top.mas_equalTo(self->_backgroungView.mas_top).offset(10);
        make.width.mas_equalTo(25);
        make.height.mas_equalTo(25);
    }];
    
    
    [_headTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (self->_backgroungView.mas_top).offset (0*BOUNDS.size.height/667);
        make.left.mas_equalTo(self->_backgroungView.mas_left).offset(20);
        make.height.mas_equalTo (50*BOUNDS.size.height/667);
    }];

    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo (self->_headTitleLabel.mas_bottom).offset (5);
        make.width.mas_equalTo (self->_backgroungView.mas_width);
        make.height.mas_equalTo (1);
        make.left.mas_equalTo (self->_backgroungView.mas_left);
    }];
    
    //微信支付logo
    [_topLogoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo (20);
        make.width.mas_equalTo (20*BOUNDS.size.height/667);
        make.bottom.mas_equalTo (self->_walltBtn.mas_top).offset(-26);
        make.height.mas_equalTo(20*BOUNDS.size.height/667);
    }];

    //微信支付btn
    [_creditBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo (self->_backgroungView.mas_left).offset(30);
        make.width.mas_equalTo (140);
        make.bottom.mas_equalTo (self->_walltBtn.mas_top).offset(-20);
        make.height.mas_equalTo(30*BOUNDS.size.height/667);
    }];
    
    //选择微信框
    [_topSelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo (self->_backgroungView.mas_right).offset(-100);
        make.width.mas_equalTo (20*BOUNDS.size.height/667);
        make.bottom.mas_equalTo (self->_walltBtn.mas_top).offset(-20);
        make.height.mas_equalTo(20*BOUNDS.size.height/667);
    }];
    
    //支付宝支付logo
    [_bottomLogoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo (self->_backgroungView.mas_left).offset(20);
        make.width.mas_equalTo (20*BOUNDS.size.height/667);
        make.bottom.mas_equalTo (self->_online.mas_top).offset(-25);
        make.height.mas_equalTo(20*BOUNDS.size.height/667);
    }];

    //支付宝支付
    [_walltBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo (self->_backgroungView.mas_left).offset(40);
        make.bottom.mas_equalTo (self->_online.mas_top).offset (-20);
        make.width.mas_equalTo (140);
        make.height.mas_equalTo(30*BOUNDS.size.height/667);
    }];
    
    //选择支付宝框
    [_bottomSelectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo (self->_backgroungView.mas_right).offset(-100);
        make.width.mas_equalTo (20*BOUNDS.size.height/667);
        make.bottom.mas_equalTo (self->_online.mas_top).offset(-20);
        make.height.mas_equalTo(20*BOUNDS.size.height/667);
    }];

    [_online mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo (self->_backgroungView.mas_left).offset (10);
        make.bottom.mas_equalTo (self->_backgroungView.mas_bottom).offset (-10);
        make.right.mas_equalTo (self->_backgroungView.mas_right).offset (-10);
        make.height.mas_equalTo (46*BOUNDS.size.height/667);

    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    // 判断当前是否是空白处的高度范围，或是支付方式的视图，是则下移弹窗，不是则不作任何处理
    if (touch.view.frame.origin.y < payViewHeight) {
        [self upDownSelf];
    }
}

#pragma mark- 勾选微信还是支付宝
// 选中微信
- (void)creditBtnAction:(MoneyButton *)sender {
    if (sender.tag == 2) {
        /** 微信 */
        [self.topSelectBtn setBackgroundImage:[UIImage imageNamed:@"dhao"] forState:UIControlStateNormal];
        [self.bottomSelectBtn setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        [self.online setTitle:@"微信支付" forState:UIControlStateNormal];
    } else {
        /** 支付宝 */
        [self.topSelectBtn setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
        [self.bottomSelectBtn setBackgroundImage:[UIImage imageNamed:@"dhao"] forState:UIControlStateNormal];
        [self.online setTitle:@"支付宝支付" forState:UIControlStateNormal];
    }
    self.selectType = sender.tag;
    
}

#pragma mark - 在线支付按钮点击事件
-(void)onlineBtnAction:(UIButton *)sender {
    if (self.selectType == 0) {
        [self makeToast:@"请选择支付方式类型"];
        return;
    }
    [self upDownSelf];
    if (self.delegate && [self.delegate respondsToSelector:@selector(fh_selectPayTypeWIthTag:)]) {
        [self.delegate fh_selectPayTypeWIthTag:self.selectType];
    }
}


- (void)upDownSelf {
    self.backgroundColor = [UIColor clearColor];
    __weak FHCommonPaySelectView *weakSelf = self;
    [UIView animateWithDuration:0.5 animations:^{
        weakSelf.frame = CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        
    }];
}

#pragma mark - 关闭弹窗按钮点击事件
- (void)closeBtnClick:(UIButton *)sender {
    [self upDownSelf];
}

@end
