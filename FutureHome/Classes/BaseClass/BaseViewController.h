//
//  BaseViewController.h
//  WMPlayer
//
//  Created by 郑文明 on 16/3/15.
//  Copyright © 2016年 郑文明. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FHCommonNavView.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "NSMutableAttributedString+XZCategory.h"
#import "AFNetWorkTool.h"
#import "FDActionSheet.h"
#import "SingleManager.h"
#import "MJExtension.h"
#import "UIColor+Extend.h"
#import "CreatNavViewController.h"
#import "ZJPickerView.h"
#import "FHLoginTool.h"
#import "BAAlertController.h"
#import "HZPhotoBrowser.h"
#import "MSImagePickerController.h"
#import "TZImagePickerController.h"
#import "CQRouteManager.h"

//#define TableViewRegisterClassCell(Instance,ClassName) \
//[Instance registerClass:[ClassName class] forCellReuseIdentifier:[NSStringFromClass([ClassName class])]]

@interface BaseViewController : UIViewController
<
DZNEmptyDataSetSource,
DZNEmptyDataSetDelegate,
TZImagePickerControllerDelegate
>
/**
 用了自定义的手势返回，则系统的手势返回屏蔽
 不用自定义的手势返回，则系统的手势返回启用
 */
@property (nonatomic, assign) BOOL enablePanGesture;//是否支持自定义拖动pop手势，默认yes,支持手势
/** 是否需要导航栏View */
@property (nonatomic, assign) BOOL isHaveNavgationView;
/** 是否需要搜索View */
@property (nonatomic, assign) BOOL isHaveNav;
/** 自定义导航栏视图 */
@property (nonatomic, strong) UIView *navgationView;

@property (nonatomic, strong) MBProgressHUD *loadingHud;

@property (nonatomic,retain) MBProgressHUD* hud;
- (void)addHud;
- (void)addHudWithMessage:(NSString*)message;
- (void)removeHud;

/**获取tabbar的高度*/
- (CGFloat)getTabbarHeight;
/** 搜索事件 */
- (void)searchClick;
/** 收藏事件 */
- (void)collectClick;

/**
 *  从 A 控制器跳转到 B 控制器
 *
 *  @param nameVC B 控制器名称
 */
- (void)viewControllerPushOther:(NSString *)nameVC;

//- (NSMutableArray *)getTopBannersImgArrysWithType:(NSInteger )type;

//- (NSMutableArray *)getBottomBannersImgArrysWithType:(NSInteger )type;

- (void)loadInit;
- (void)loadNext;
- (void)headerReload;
- (void)footerReload;
/**
 *  结束刷新
 */
- (void)delayEndRefresh:(MJRefreshComponent *)cmp;

@end
