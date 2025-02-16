//
//  ZMCusCommentListContentCell.m
//  ZMZX
//
//  Created by Kennith.Zeng on 2018/8/29.
//  Copyright © 2018年 齐家网. All rights reserved.
//

#import "ZMCusCommentListContentCell.h"
#import "NSString+Size.h"
@interface ZMCusCommentListContentCell()
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UIImageView *designerImageView;
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *contentLab;
@property (nonatomic, strong) UILabel *timeLab;
@end

@implementation ZMCusCommentListContentCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self layoutUI];
    }
    return self;
}

- (void)tapClick {
    if (_delegate != nil && [_delegate respondsToSelector:@selector(fh_ZMCusCommentListContentCellDelegateSelectHeaderModel:)]) {
        [_delegate fh_ZMCusCommentListContentCellDelegateSelectHeaderModel:self.commentListModel];
    }
}

- (void)layoutUI{
    if (!_headImageView) {
        _headImageView = [[UIImageView alloc] init];
        [_headImageView setImage:[UIImage imageNamed:@"head_list_small"]];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
        _headImageView.userInteractionEnabled = YES;
        [_headImageView addGestureRecognizer:tap];
        
        [self.contentView addSubview:_headImageView];
        [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(14);
            make.top.mas_equalTo(16);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
    }
    
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] init];
        _timeLab.textColor = RGBHexColor(0x999999, 1);
        _timeLab.font = [UIFont systemFontOfSize:11];
        _timeLab.textAlignment = NSTextAlignmentRight;
        _timeLab.numberOfLines = 1;
        _timeLab.backgroundColor = [UIColor clearColor];
        [_timeLab sizeToFit];
        [self.contentView addSubview:_timeLab];
        [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-14);
            make.top.mas_equalTo(15);
            make.width.mas_offset(200);
            
        }];
    }
    
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] init];
        _titleLab.textColor = RGBHexColor(0x333333, 1);
        _titleLab.font = [UIFont boldSystemFontOfSize:15];
        _titleLab.numberOfLines = 1;
        _titleLab.textAlignment = NSTextAlignmentLeft;
        _titleLab.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_titleLab];
        [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self->_headImageView.mas_right).mas_offset(18);
            make.top.mas_equalTo(15);
            make.height.mas_offset(20);
            make.width.mas_equalTo(200);
            
        }];
    }
    
//    if (!_designerImageView) {
//        _designerImageView = [[UIImageView alloc] init];
//        [_designerImageView setBackgroundColor:[UIColor redColor]];
//        _designerImageView.hidden = YES;
//        _designerImageView.layer.masksToBounds = YES;
//
//        _designerImageView.layer.cornerRadius = 3;
//        [self.contentView addSubview:_designerImageView];
//        [_designerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(_titleLab.mas_right).mas_offset(7);
//            make.centerY.mas_equalTo(_headImageView);
//            make.size.mas_equalTo(CGSizeMake(31, 10));
//        }];
//    }
    
    if (!_contentLab) {
        _contentLab = [[UILabel alloc] init];
        _contentLab.textColor = RGBHexColor(0x333333, 1);
        _contentLab.font = [UIFont systemFontOfSize:15];
        _contentLab.numberOfLines = 0;
        _contentLab.backgroundColor = [UIColor clearColor];
        [_contentLab sizeToFit];
        [self.contentView addSubview:_contentLab];
        [_contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_titleLab);
            make.top.mas_equalTo(_titleLab.mas_bottom).mas_offset(10);
            make.right.mas_equalTo(-14);
            make.bottom.mas_equalTo(-10);
            
        }];
    }
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configData:(id)data{
//    self.titleLab.text = @"愤怒的小栗子";
//    self.timeLab.text = @"11分钟前";
//    self.contentLab.text = @"不错挺好的，现在开始还来得及。只不过从某种意上讲事情没有这么简单。";
//    CGFloat titleWidth = [self.titleLab.text widthWithFont:[UIFont boldSystemFontOfSize:15] constrainedToHeight:20]+5;
//    if (titleWidth>100) {
//        titleWidth = 100;
//    }
//    [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_offset(titleWidth);
//    }];
}

- (void)setCommentListModel:(FHCommentListModel *)commentListModel {
    _commentListModel = commentListModel;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:_commentListModel.form_pic]];
    self.titleLab.text = _commentListModel.from_name;
    self.timeLab.text = _commentListModel.add_time;
    self.contentLab.text = _commentListModel.content;
//    CGFloat titleWidth = [self.titleLab.text widthWithFont:[UIFont boldSystemFontOfSize:15] constrainedToHeight:20]+5;
//    if (titleWidth>100) {
//        titleWidth = 100;
//    }
//    [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_offset(titleWidth);
//    }];
    
//    self.titleLab.text = @"";
//    self.timeLab.text = @"11分钟前";
//    self.contentLab.text = @"不错挺好的，现在开始还来得及。只不过从某种意上讲事情没有这么简单。";
//    CGFloat titleWidth = [self.titleLab.text widthWithFont:[UIFont boldSystemFontOfSize:14] constrainedToHeight:20]+5;
//    if (titleWidth>100) {
//        titleWidth = 100;
//    }
//    [self.titleLab mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_offset(titleWidth);
//    }];
}

@end
