//
//  FHPersonCommitListCell.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/11/30.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHPersonCommitListCell.h"
#import "ZJCommit.h"
#import "ZJCommitPhotoView.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "ZJCategory.h"
#import "ZJUIMasonsyKit.h"

#define kBlackColor       [UIColor blackColor]
#define kDarkGrayColor    [UIColor darkGrayColor]
#define kLightGrayColor   [UIColor lightGrayColor]
#define kWhiteColor       [UIColor whiteColor]
#define kRedColor         [UIColor redColor]
#define kBlueColor        [UIColor blueColor]
#define kGreenColor       [UIColor greenColor]
#define kCyanColor        [UIColor cyanColor]
#define kYellowColor      [UIColor yellowColor]
#define kMagentaColor     [UIColor magentaColor]
#define kOrangeColor      [UIColor orangeColor]
#define kPurpleColor      [UIColor purpleColor]
#define kBrownColor       [UIColor brownColor]
#define kClearColor       [UIColor clearColor]

@interface FHPersonCommitListCell ()
// 头像
@property(nonatomic ,strong) UIImageView    *avatar;
// 昵称
@property(nonatomic ,strong) UILabel        *nameLab;
// 时间
@property(nonatomic ,strong) UILabel        *timeLab;
// 内容
@property(nonatomic ,strong) UILabel        *contentLab;
// 图片
@property(nonatomic ,strong) ZJCommitPhotoView *photosView;

/** 底部View */
@property (nonatomic, strong) UIView         *bottomView;
@end

@implementation FHPersonCommitListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpAllView];
    }
    return self;
}

-(void)setModel:(ZJCommit *)model{
    _model = model;
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:_model.avatar] placeholderImage:nil];
    
    self.nameLab.text = [self tranlateStrWithString:_model.nickname];
    
    self.timeLab.text = _model.add_time;
    self.contentLab.text = _model.content;
    
    CGSize size = [UIlabelTool sizeWithString:self.contentLab.text font:self.contentLab.font width:SCREEN_WIDTH - (MaxX(self.avatar) + 15) - 15];
    NSInteger count = model.pic_urls.count;
    self.photosView.pic_urls = model.pic_urls;
    self.photosView.selfVc = _weakSelf;
    //重新更新约束
    CGFloat oneheight = (kScreenWidth - MaxX(self.avatar) - 15 - 15 - 20 ) / 3;
    // 三目运算符 小于或等于3张 显示一行的高度 ,大于3张小于或等于6行，显示2行的高度 ，大于6行，显示3行的高度
    CGFloat photoHeight = count<=3 ? oneheight : (count<=6 ? 2 * oneheight + 10 : oneheight *3+20);
    
    self.contentLab.frame = CGRectMake(MaxX(self.avatar) + 15, MaxY(self.avatar) + 5, SCREEN_WIDTH - (MaxX(self.avatar) + 15) - 15, size.height);
    
    CGFloat top = MaxY(self.contentLab) + 5;
    CGFloat leftX = MaxX(self.avatar) + 15;
    [_photosView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(top);
        make.left.mas_equalTo(leftX);
        make.width.mas_equalTo(SCREEN_WIDTH - (MaxX(self.avatar) + 15) - 15);
        make.height.mas_equalTo(photoHeight);
    }];
    
    self.bottomView.frame = CGRectMake(0, MaxY(self.contentLab) + 10 + photoHeight + 10, SCREEN_WIDTH, 0.5);
    
    [SingleManager shareManager].cellPicHeight = MaxY(self.bottomView) + 5;
    
}

- (NSString *)tranlateStrWithString:(NSString *)str {
    
    NSMutableString * newStr = [NSMutableString stringWithString:str];
    for(int i = 0; i < str.length; i++){
        if (i > 0) {
            [newStr replaceCharactersInRange:NSMakeRange(i, 1) withString:@"*"];
        }
    }
    
    return newStr;
    
}

// 添加所子控件
- (void)setUpAllView {
    // 头像
    if (!self.avatar) {
        self.avatar = [[UIImageView alloc] init];
        self.avatar.image = nil;
        [self.contentView addSubview:self.avatar];
        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarClick)];
//        self.avatar.userInteractionEnabled = YES;
//        [self.avatar addGestureRecognizer:tap];
    }
    
    // 昵称
    if (!self.nameLab) {
        self.nameLab = [[UILabel alloc] init];
        self.nameLab.font = [UIFont systemFontOfSize:15];
        self.nameLab.textColor = kBlueColor;
        self.nameLab.numberOfLines = 1;
        [self.contentView addSubview:self.nameLab];
    }
    
    // 时间
    if (!self.timeLab) {
        self.timeLab = [[UILabel alloc] init];
        self.timeLab.font = [UIFont systemFontOfSize:13];
        self.timeLab.textColor = kLightGrayColor;
        self.timeLab.numberOfLines = 1;
        self.timeLab.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.timeLab];
    }
    
    // 内容
    if (!self.contentLab) {
        self.contentLab = [[UILabel alloc] init];
        self.contentLab.font = [UIFont systemFontOfSize:16];
        self.contentLab.textColor = kBlackColor;
        self.contentLab.numberOfLines = 0;
        self.contentLab.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.contentLab];
    }
    
    // 图片
    if (!self.photosView) {
        self.photosView = [[ZJCommitPhotoView alloc]init];
        [self.contentView addSubview:self.photosView];
        CGFloat top = MaxY(self.contentLab) + 5;
        CGFloat leftX = MaxX(self.avatar) + 15;
        [_photosView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(top);
            make.left.mas_equalTo(leftX);
            make.width.mas_equalTo(SCREEN_WIDTH - (MaxX(self.avatar) + 15) - 15);
            make.height.mas_equalTo(0.001);
        }];
    }
    //下面的 浏览量 点赞 评论数
    if (!self.bottomView) {
        self.bottomView = [[UIView alloc] init];
        [self.contentView addSubview:self.bottomView];
    }
    /** 设置frame */
    [self fh_layoutSubviews];
}

- (void)fh_layoutSubviews {
    self.avatar.frame = CGRectMake(15, 15, 40, 40);
    self.nameLab.frame = CGRectMake(MaxX(self.avatar) + 15, 0, SCREEN_WIDTH - (MaxX(self.avatar) + 15) - 100, 20);
    self.nameLab.centerY = self.avatar.centerY;
    self.timeLab.frame = CGRectMake(0, 0, SCREEN_WIDTH - 15, 20);
    self.timeLab.centerY = self.avatar.centerY;
    self.bottomView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0.5);
}

@end
