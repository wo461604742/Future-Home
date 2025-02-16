//
//  ZFDouYinViewController.m
//  ZFPlayer_Example
//
//  Created by 紫枫 on 2018/6/4.
//  Copyright © 2018年 紫枫. All rights reserved.
//

#import "ZFDouYinViewController.h"
#import "ZFPlayer.h"
#import "ZFAVPlayerManager.h"
#import "ZFIJKPlayerManager.h"
#import "KSMediaPlayerManager.h"
#import "ZFPlayerControlView.h"
#import "ZFTableViewCellLayout.h"
#import "ZFTableData.h"
#import "ZFDouYinCell.h"
#import "ZFDouYinControlView.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "MJRefresh.h"
#import "ZMCusCommentView.h"
#import "FHAppDelegate.h"
#import "FHCommentListModel.h"
#import "FHSharingDynamicsController.h"

static NSString *kIdentifier = @"kIdentifier";

@interface ZFDouYinViewController ()  <UITableViewDelegate,UITableViewDataSource,ZFDouYinCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) ZFDouYinControlView *controlView;
@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, strong) NSMutableArray *urls;
@property (nonatomic, strong) UIButton *backBtn;
/** <#strong属性注释#> */
@property (nonatomic, strong) ZMCusCommentView *commentView;
/** <#strong属性注释#> */
@property (nonatomic, strong) NSMutableArray *commentListArrs;


@end

@implementation ZFDouYinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.backBtn];
    self.fd_prefersNavigationBarHidden = YES;
    [self requestData];
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_header = header;

    /// playerManager
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
//    KSMediaPlayerManager *playerManager = [[KSMediaPlayerManager alloc] init];
//    ZFIJKPlayerManager *playerManager = [[ZFIJKPlayerManager alloc] init];

    /// player,tag值必须在cell里设置
    self.player = [ZFPlayerController playerWithScrollView:self.tableView playerManager:playerManager containerViewTag:100];
    self.player.assetURLs = self.urls;
    self.player.disableGestureTypes = ZFPlayerDisableGestureTypesDoubleTap | ZFPlayerDisableGestureTypesPan | ZFPlayerDisableGestureTypesPinch;
    self.player.controlView = self.controlView;
    self.player.allowOrentitaionRotation = NO;
    self.player.WWANAutoPlay = YES;
    /// 1.0是完全消失时候
    self.player.playerDisapperaPercent = 1.0;
    
    @weakify(self)
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @strongify(self)
        [self.player.currentPlayerManager replay];
    };
    
    self.player.presentationSizeChanged = ^(id<ZFPlayerMediaPlayback>  _Nonnull asset, CGSize size) {
        @strongify(self)
        if (size.width >= size.height) {
            self.player.currentPlayerManager.scalingMode = ZFPlayerScalingModeAspectFit;
        } else {
            self.player.currentPlayerManager.scalingMode = ZFPlayerScalingModeAspectFill;
        }
    };
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.backBtn.frame = CGRectMake(15, CGRectGetMaxY([UIApplication sharedApplication].statusBarFrame), 36, 36);
}

- (void)loadNewData {
    [self.dataSource removeAllObjects];
    [self.urls removeAllObjects];
    @weakify(self)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        /// 下拉时候一定要停止当前播放，不然有新数据，播放位置会错位。
        [self.player stopCurrentPlayingCell];
        [self requestData];
        [self.tableView reloadData];
        /// 找到可以播放的视频并播放
        [self.tableView zf_filterShouldPlayCellWhileScrolled:^(NSIndexPath *indexPath) {
            @strongify(self)
            [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
        }];
    });
}

- (void)setVideoListDataArrs:(NSArray *)videoListDataArrs {
    _videoListDataArrs = videoListDataArrs;
}

#pragma mark — request
- (void)requestData {
    /** 获取视频列表 */
    for (NSDictionary *dataDic in self.videoListDataArrs) {
        ZFTableData *data = [[ZFTableData alloc] init];
        data.cover = [dataDic objectForKey:@"cover"];
        data.dataID = [dataDic objectForKey:@"video_id"];
        data.aid = [[dataDic objectForKey:@"aid"] integerValue];
        data.pid = [[dataDic objectForKey:@"pid"] integerValue];
        data.video_url = [dataDic objectForKey:@"path"];
        data.title = [dataDic objectForKey:@"videoname"];
        data.thumbnail_url = [dataDic objectForKey:@"logo"];
        data.video_width = [[dataDic objectForKey:@"videoWidth"] floatValue];
        data.video_height = [[dataDic objectForKey:@"videoHeight"] floatValue];
        data.islike = [[dataDic objectForKey:@"islike"] integerValue];
        data.isconnection = [[dataDic objectForKey:@"is_collect"] integerValue];
        data.comment = [dataDic objectForKey:@"comment"];
        data.like = [dataDic objectForKey:@"like"];
        data.video_type = [dataDic objectForKey:@"video_type"];
        data.topic_type = [dataDic objectForKey:@"topic_type"];
        data.forwarder = [dataDic objectForKey:@"forwarder"];
        data.ordertype = [[dataDic objectForKey:@"ordertype"] integerValue];
        [self.dataSource addObject:data];
        NSString *URLString = [data.video_url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURL *url = [NSURL URLWithString:URLString];
        [self.urls addObject:url];
    }
    
    [self.tableView.mj_header endRefreshing];
}

- (void)playTheIndex:(NSInteger)index {
    @weakify(self)
    /// 指定到某一行播放
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:NO];
    [self.tableView zf_filterShouldPlayCellWhileScrolled:^(NSIndexPath *indexPath) {
        @strongify(self)
        [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
    }];
    /// 如果是最后一行，去请求新数据
    if (index == self.dataSource.count - 1) {
        /// 加载下一页数据
        [self requestData];
        self.player.assetURLs = self.urls;
        [self.tableView reloadData];
    }
}


- (BOOL)shouldAutorotate {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (BOOL)prefersStatusBarHidden {
    return self.player.isStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

#pragma mark - UIScrollViewDelegate  列表播放必须实现

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidEndDecelerating];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [scrollView zf_scrollViewDidEndDraggingWillDecelerate:decelerate];
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidScrollToTop];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewDidScroll];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [scrollView zf_scrollViewWillBeginDragging];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZFDouYinCell *cell = [tableView dequeueReusableCellWithIdentifier:kIdentifier];
    cell.data = self.dataSource[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
}

#pragma mark - ZFTableViewCellDelegate

- (void)zf_playTheVideoAtIndexPath:(NSIndexPath *)indexPath {
    [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
}


#pragma mark - ZFDouYinCellDelegate
/** 点赞视频 */
- (void)fh_ZFDouYinCellDelegateSelectLikeClicck:(ZFTableData *)data
                                        withBtn:(UIButton *)btn
                                 withCountLabel:(UILabel *)label {
        /** 生鲜 社交 商业 朋友圈视频 点赞*/
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               data.topic_type,@"topic_type",
                               data.dataID,@"id",
                               @(data.ordertype),@"ordertype",
                               nil];
    [AFNetWorkTool post:@"shop/giveLike" params:paramsDic success:^(id responseObj) {
        NSInteger count = [label.text integerValue];
        if ([responseObj[@"code"] integerValue] == 1) {
            if (btn.tag == 0) {
                /** 未点赞 */
                [btn setImage:[UIImage imageNamed:@"评论点赞后"] forState:UIControlStateNormal];
                btn.tag = 1;
                count ++;
                label.text = [NSString stringWithFormat:@"%ld",(long)count];
            } else if (btn.tag == 1) {
                /** 已经点赞 */
                [btn setImage:[UIImage imageNamed:@"点赞前 空心"] forState:UIControlStateNormal];
                btn.tag = 0;
                count --;
                label.text = [NSString stringWithFormat:@"%ld",(long)count];
            }
        } else {
            [weakSelf.view makeToast:responseObj[@"msg"]];
        }
    } failure:^(NSError *error) {
    }];
}


/** 收藏视频 */
- (void)fh_ZFDouYinCellDelegateSelectFollowClick:(ZFTableData *)data
                                         withBtn:(UIButton *)btn {
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic;
    paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                     @(account.user_id),@"user_id",
                     data.topic_type,@"type",
                     data.dataID,@"aid",
                     nil];
    /** 视频收藏 */
    WS(weakSelf);
    [AFNetWorkTool post:@"sheyun/doVideoCollect" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            if (btn.tag == 0) {
                /** 没有收藏 */
                [weakSelf.view makeToast:@"收藏成功"];
                [btn setImage:[UIImage imageNamed:@"收藏后"] forState:UIControlStateNormal];
                btn.tag = 1;
            } else if (btn.tag == 1) {
                [weakSelf.view makeToast:@"取消收藏"];
                [btn setImage:[UIImage imageNamed:@"收藏"] forState:UIControlStateNormal];
                btn.tag = 0;
            }
        } else {
            [weakSelf.view makeToast:responseObj[@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}

/** 评论 */
- (void)fh_ZFDouYinCellDelegateSelectCommontent:(ZFTableData *)data {
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               data.dataID,@"id",
                               @(1),@"page",
                               data.topic_type,@"topic_type",
                               @(data.ordertype),@"ordertype",
                               nil];
    
    [AFNetWorkTool get:@"shop/getComments" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            weakSelf.commentListArrs = [[NSMutableArray alloc] init];
            NSArray *arr = responseObj[@"data"][@"list"];
            [weakSelf.commentListArrs addObjectsFromArray:arr];
            /** 展示评论列表 */
            [[ZMCusCommentManager shareManager] showCommentWithSourceId:@"" dataArrs:weakSelf.commentListArrs tableData:data tpye:@"video"];
        } else {
            [weakSelf.view makeToast:responseObj[@"msg"]];
        }
    } failure:^(NSError *error) {
        
    }];
}

/** 分享按钮 */
- (void)fh_ZFDouYinCellDelegateShareClick:(ZFTableData *)data {
    FHSharingDynamicsController *vc = [[FHSharingDynamicsController alloc] init];
    vc.type = @"视频";
    vc.data = data;
    vc.video_type = self.type;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - private method
- (void)backClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/// play the video
- (void)playTheVideoAtIndexPath:(NSIndexPath *)indexPath scrollToTop:(BOOL)scrollToTop {
    [self.player playTheIndexPath:indexPath scrollToTop:scrollToTop];
    [self.controlView resetControlView];
    
//    ZFTableData *data = self.dataSource[indexPath.row];
//    UIViewContentMode imageMode;
//    if (data.video_width >= data.video_height) {
//        imageMode = UIViewContentModeScaleAspectFit;
//    } else {
//        imageMode = UIViewContentModeScaleAspectFill;
//    }
    
//    [self.controlView showCoverViewWithUrl:data.thumbnail_url withImageMode:imageMode];
    
}

#pragma mark - getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.pagingEnabled = YES;
        [_tableView registerClass:[ZFDouYinCell class] forCellReuseIdentifier:kIdentifier];
        _tableView.backgroundColor = [UIColor lightGrayColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.scrollsToTop = NO;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.frame = self.view.bounds;
        _tableView.rowHeight = _tableView.frame.size.height;
        _tableView.scrollsToTop = NO;
        
        /// 停止的时候找出最合适的播放
        @weakify(self)
        _tableView.zf_scrollViewDidStopScrollCallback = ^(NSIndexPath * _Nonnull indexPath) {
            @strongify(self)
            if (self.player.playingIndexPath) return;
            if (indexPath.row == self.dataSource.count - 1) {
                /// 加载下一页数据
                [self requestData];
                self.player.assetURLs = self.urls;
                [self.tableView reloadData];
            }
            [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
        };
    }
    return _tableView;
}

- (ZFDouYinControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFDouYinControlView new];
    }
    return _controlView;
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = @[].mutableCopy;
    }
    return _dataSource;
}

- (NSMutableArray *)urls {
    if (!_urls) {
        _urls = @[].mutableCopy;
    }
    return _urls;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"icon_titlebar_whiteback"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

@end
