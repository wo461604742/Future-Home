//
//  ZJHavePhotoCell.h
//  ZJKitTool
//
//  Created by 同熙传媒 on 2019/11/1.
//  Copyright © 2019 kapokcloud. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class ZJCommit;

@protocol ZJNoHavePhotoCellDelegate <NSObject>

@required // 必须实现的方法 默认

@optional
// 可选实现的方法
- (void)fh_ZJNoHavePhotoCellSelectModel:(ZJCommit *)model;

- (void)fh_ZJNoHavePhotoCellSelecLiketModel:(ZJCommit *)model
                                    withBtn:(UIButton *)btn;

@end

@interface ZJNoHavePhotoCell : UITableViewCell

@property(nonatomic ,strong) ZJCommit           *model;

@property(nonatomic, weak) id<ZJNoHavePhotoCellDelegate> delegate;
/** 没有点赞按钮 */
@property (nonatomic, assign) BOOL isNoUpdateBtn;

@end

NS_ASSUME_NONNULL_END
