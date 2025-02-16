//
//  LGJCategoryVC.m
//  TableViewTwoLevelLinkageDemo
//
//  Created by 劉光軍 on 16/5/30.
//  Copyright © 2016年 [SinaWeibo:劉光軍_Shine    简书:劉光軍_   ]. All rights reserved.
//一级分类界面

#import "LGJCategoryVC.h"
#import "LGJProductsVC.h"
#import "FHHealthCategoryModel.h"
#import "FHCategoryCell.h"

@interface LGJCategoryVC ()<UITableViewDelegate, UITableViewDataSource, ProductsDelegate>

@property (nonatomic, strong) UITableView *categoryTableView;
@property (nonatomic, strong) NSMutableArray *categoryArr;
@property (nonatomic, strong)  LGJProductsVC *productsVC;
/** <#strong属性注释#> */
@property (nonatomic, strong) UILabel *oldSelectLabel;
/** <#assign属性注释#> */
@property (nonatomic, assign) NSInteger selectIndex;


@end

@implementation LGJCategoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectIndex = 0;
    [self fh_creatNav];
    [self configData];
    [self createTableView];
    
}

#pragma mark — 通用导航栏
#pragma mark — privite
- (void)fh_creatNav {
    self.isHaveNavgationView = YES;
    self.navgationView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    titleLabel.text = self.titleString;
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

- (void)configData {
    WS(weakSelf);
    self.categoryArr = [[NSMutableArray alloc] init];
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               self.type,@"type", nil];
    [AFNetWorkTool get:@"health/cateMenu" params:paramsDic success:^(id responseObj) {
        if ([responseObj[@"code"] integerValue] == 1) {
            /** 获取成功 */
            weakSelf.categoryArr = [FHHealthCategoryModel mj_objectArrayWithKeyValuesArray:responseObj[@"data"]];
            [self.categoryTableView reloadData];
            [weakSelf createProductsVC];
            NSArray *arr = responseObj[@"data"];
            NSDictionary *dic = arr[0];
            NSDictionary *healthDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                       dic[@"category_id"],@"category_id",nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"REFRESHHEALTH" object:nil userInfo:healthDic];
        } else {
            NSString *msg = responseObj[@"msg"];
            [weakSelf.view makeToast:msg];
        }
    } failure:^(NSError *error) {

    }];
}

- (void)createTableView {
    self.categoryTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, MainSizeHeight, self.view.frame.size.width * 0.26, self.view.frame.size.height - MainSizeHeight) style:UITableViewStylePlain];
    self.categoryTableView.delegate = self;
    self.categoryTableView.dataSource = self;
    self.categoryTableView.showsVerticalScrollIndicator = NO;
    self.categoryTableView.backgroundColor = HEX_COLOR(0xCCCCCC);
    self.categoryTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.categoryTableView registerClass:[FHCategoryCell class] forCellReuseIdentifier:NSStringFromClass([FHCategoryCell class])];
    [self.view addSubview:self.categoryTableView];
}

- (void)createProductsVC {
    _productsVC = [[LGJProductsVC alloc] init];
    _productsVC.delegate = self;
    _productsVC.sectionCount = self.categoryArr.count;
    [self addChildViewController:_productsVC];
    [self.view addSubview:_productsVC.view];
}

//MARK:-tableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.categoryArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FHCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FHCategoryCell class])];
    FHHealthCategoryModel *model = [self.categoryArr objectAtIndex:indexPath.row];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@",model.name];
    if (indexPath.row == self.selectIndex) {
        cell.nameLabel.textColor = [UIColor blueColor];
        self.oldSelectLabel = cell.nameLabel;
        NSIndexPath *selectedIndex = [NSIndexPath indexPathForRow:self.selectIndex inSection:0];
        [self.categoryTableView selectRowAtIndexPath:selectedIndex animated:YES scrollPosition:UITableViewScrollPositionTop];
    } else {
        cell.nameLabel.textColor = [UIColor blackColor];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectIndex = indexPath.row;
    FHCategoryCell *cell = (FHCategoryCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (self.oldSelectLabel == cell.nameLabel) {
        
    } else {
        cell.nameLabel.textColor = [UIColor blueColor];
        self.oldSelectLabel.textColor = [UIColor blackColor];
    }
    self.oldSelectLabel = cell.nameLabel;
    FHHealthCategoryModel *model = self.categoryArr[indexPath.row];
    if (_productsVC) {
//        [_productsVC scrollToSelectedIndexPath:indexPath];
        [_productsVC resreshDataWithPid:model.category_id];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
