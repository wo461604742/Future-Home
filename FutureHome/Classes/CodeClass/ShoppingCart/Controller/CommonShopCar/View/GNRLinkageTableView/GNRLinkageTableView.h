//
//  GNRLinkageTableView.h
//  外卖
//
//  Created by LvYuan on 2017/5/2.
//  Copyright © 2017年 BattlePetal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GNRGoodsListCell.h"

@protocol GNRLinkageTableViewDelegate <NSObject>

- (void)scrollViewDidScrollForPositionY:(CGFloat)y;

- (void)fh_selectIndexModel:(GNRGoodsModel *)goods
                       cell:(GNRGoodsListCell *)cell;

@end

@interface GNRLinkageTableView : UIView
/** 商店ID */
@property (nonatomic, copy) NSString *shopID;

@property (nonatomic, weak) id target;
@property (nonatomic, weak) id <GNRLinkageTableViewDelegate>delegate;
@property (nonatomic, strong)UITableView * leftTbView;
@property (nonatomic, strong)UITableView * rightTbView;
@property (nonatomic, strong)GNRGoodsListModel * goodsList;
- (void)reloadData;
@end
