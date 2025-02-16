//
//  FHCommitDetaolCell.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/20.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import "FHCommitDetaolCell.h"

@interface FHCommitDetaolCell ()
/** 头像 */
@property (nonatomic, strong) UIImageView *headerImgView;
/** 昵称 */
@property (nonatomic, strong) UILabel *nickNameLabel;
/** 内容摘要 */
@property (nonatomic, strong) UILabel *contentLabel;
/** 时间label */
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation FHCommitDetaolCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self fh_setUpUI];
    }
    return self;
}

- (void)fh_setUpUI {
    self.headerImgView.frame = CGRectMake(10, 7.5, 55, 55);
    [self.contentView addSubview:self.headerImgView];
    self.nickNameLabel.frame = CGRectMake(MaxX(self.headerImgView) + 10, 15.5, SCREEN_WIDTH - 150, 15);
    [self.contentView addSubview:self.nickNameLabel];
    self.timeLabel.frame = CGRectMake(0, 15.5, SCREEN_WIDTH - 20, 13);
    [self.contentView addSubview:self.timeLabel];
    self.contentLabel.frame = CGRectMake(MaxX(self.headerImgView) + 10, MaxY(self.nickNameLabel) + 10, SCREEN_WIDTH - 100, 15);
    [self.contentView addSubview:self.contentLabel];
}


- (void)setCommitModel:(FHCommitModel *)commitModel {
    _commitModel = commitModel;
    [self.headerImgView sd_setImageWithURL:[NSURL URLWithString:_commitModel.avatar] placeholderImage:nil];
    self.nickNameLabel.text = _commitModel.nickname;
    self.timeLabel.text = _commitModel.create_time;
    self.contentLabel.text = _commitModel.content;
    CGSize size = [UIlabelTool sizeWithString:self.contentLabel.text font:self.contentLabel.font width:SCREEN_WIDTH - 100];
    self.contentLabel.frame = CGRectMake(MaxX(self.headerImgView) + 10, MaxY(self.nickNameLabel) + 10, SCREEN_WIDTH - 100, size.height);
    [SingleManager shareManager].commonCommitCellHeight = MaxY(self.contentLabel) + 15.5;
}

- (void)tapClick {
    if (_delegate != nil && [_delegate respondsToSelector:@selector(fh_FHCommitDetaolCellDelegateSelectHeaderViewModel:)]) {
        [_delegate fh_FHCommitDetaolCellDelegateSelectHeaderViewModel:self.commitModel];
    }
}

#pragma mark — setter && getter
#pragma mark - 懒加载
- (UIImageView *)headerImgView {
    if (!_headerImgView) {
        _headerImgView = [[UIImageView alloc] init];
        _headerImgView.image = [UIImage imageNamed:@"头像"];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
        _headerImgView.userInteractionEnabled = YES;
        [_headerImgView addGestureRecognizer:tap];
    }
    return _headerImgView;
}

- (UILabel *)nickNameLabel {
    if (!_nickNameLabel) {
        _nickNameLabel = [[UILabel alloc] init];
        _nickNameLabel.textAlignment = NSTextAlignmentLeft;
        _nickNameLabel.font = [UIFont systemFontOfSize:15];
        _nickNameLabel.textColor = [UIColor blueColor];
#warning message
        _nickNameLabel.text = @"物业服务";
    }
    return _nickNameLabel;
}

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.textColor = [UIColor blackColor];
        _contentLabel.numberOfLines = 0;
#warning message
        _contentLabel.text = @"物业服务业服务业服务业服务业服务业服务业服务业服务业服务业服务业服务业服务";
    }
    return _contentLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.font = [UIFont systemFontOfSize:13];
        _timeLabel.textColor = [UIColor lightGrayColor];
        _timeLabel.numberOfLines = 1;
#warning message
        _timeLabel.text = @"星期五";
    }
    return _timeLabel;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
