//
//  FHAboutFutureHomeController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/7/23.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  关于社云

#import "FHAboutFutureHomeController.h"

@interface FHAboutFutureHomeController () <UITableViewDelegate,UITableViewDataSource>
/** 头像 */
@property (nonatomic, strong) UIImageView *imgView;
/** label */
@property (nonatomic, strong) UILabel *logoLabel;
/** 主页列表数据 */
@property (nonatomic, strong) UITableView *homeTable;
/** 上面的logoName */
@property (nonatomic, copy) NSArray *topLogoNameArrs;
/** 底部的label */
@property (nonatomic, strong) UILabel *bottomLabel;


@end

@implementation FHAboutFutureHomeController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fh_creatNav];
    [self fh_setUpUI];
    self.topLogoNameArrs = @[@"社云官网",
                             @"平台协议",
                             @"版本号"];
}


#pragma mark — 通用导航栏
#pragma mark — privite
- (void)fh_creatNav {
    self.isHaveNavgationView = YES;
    self.navgationView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    titleLabel.text = @"关于社云";
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.userInteractionEnabled = YES;
    [self.navgationView addSubview:titleLabel];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(5, MainStatusBarHeight, MainNavgationBarHeight, MainNavgationBarHeight);
    [backBtn setImage:[UIImage imageNamed:@"nav_back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.navgationView addSubview:backBtn];
    
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.navgationView.height - 1, SCREEN_WIDTH, 1)];
    bottomLineView.backgroundColor = [UIColor lightGrayColor];
    [self.navgationView addSubview:bottomLineView];
}

- (void)backBtnClick {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)fh_setUpUI {
    self.imgView.centerX = self.view.width / 2;
    [self.view addSubview:self.imgView];
    self.logoLabel.frame = CGRectMake(0, CGRectGetMaxY(self.imgView.frame) + 10, SCREEN_WIDTH, 12);
    [self.view addSubview:self.logoLabel];
    [self.view addSubview:self.homeTable];
    self.bottomLabel.frame = CGRectMake(0, SCREEN_HEIGHT - 80, SCREEN_WIDTH, 40);
    [self.view addSubview:self.bottomLabel];
}


#pragma mark  -- tableViewDelagate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *ID = @"cell1";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@",self.topLogoNameArrs[indexPath.row]];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.detailTextLabel.text = @"http://tongximedia.com";
    }
    if (indexPath.row == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.row == 2) {
        cell.detailTextLabel.text = @"版本号1.0.1";
        cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        /** 用户平台协议 */
        [self viewControllerPushOther:@"FHPlatformProtocolViewController"];
    }
}

#pragma mark — setter && getter
- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, MainSizeHeight + 30, 120, 120)];
        _imgView.image = [UIImage imageNamed:@"rw_logo"];
    }
    return _imgView;
}

- (UILabel *)logoLabel {
    if (!_logoLabel) {
        _logoLabel = [[UILabel alloc] init];
        _logoLabel.text = @"社云 1.0.1";
        _logoLabel.textColor = [UIColor blackColor];
        _logoLabel.font = [UIFont systemFontOfSize:12];
        _logoLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _logoLabel;
}

- (UILabel *)bottomLabel {
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc] init];
        _bottomLabel.text = @"Copyright© 2019-2020 TongXi. All Rights Reserved.\n重庆同熙文化传媒有限公司 版权所有";
        _bottomLabel.textColor = [UIColor blackColor];
        _bottomLabel.font = [UIFont systemFontOfSize:14];
        _bottomLabel.textAlignment = NSTextAlignmentCenter;
        _bottomLabel.numberOfLines = 0;
    }
    return _bottomLabel;
}

- (UITableView *)homeTable {
    if (_homeTable == nil) {
        CGFloat tabbarH = [self getTabbarHeight];
        _homeTable = [[UITableView alloc]initWithFrame:CGRectMake(0, MaxY(self.logoLabel) , SCREEN_WIDTH, SCREEN_HEIGHT - MainSizeHeight - tabbarH) style:UITableViewStylePlain];
        _homeTable.dataSource = self;
        _homeTable.delegate = self;
        _homeTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _homeTable.showsVerticalScrollIndicator = NO;
        if (@available (iOS 11.0, *)) {
            _homeTable.estimatedSectionHeaderHeight = 0.01;
            _homeTable.estimatedSectionFooterHeight = 0.01;
            _homeTable.estimatedRowHeight = 0.01;
        }
    }
    return _homeTable;
}

@end
