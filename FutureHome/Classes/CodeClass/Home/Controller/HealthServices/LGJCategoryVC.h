//
//  LGJCategoryVC.h
//  TableViewTwoLevelLinkageDemo
//
//  Created by 劉光軍 on 16/5/30.
//  Copyright © 2016年 [SinaWeibo:劉光軍_Shine    简书:劉光軍_   ]. All rights reserved.
//一级分类界面

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface LGJCategoryVC : BaseViewController
/** 标题 */
@property (nonatomic, copy) NSString *titleString;
/** 文章分类 */
@property (nonatomic, copy) NSString *type;


@end
