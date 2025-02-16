//
//  FHInformationMesageCell.h
//  FutureHome
//
//  Created by 同熙传媒 on 2019/8/7.
//  Copyright © 2019 同熙传媒. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FHInformationModel.h"
NS_ASSUME_NONNULL_BEGIN

@class FHScrollNewsModel;

@interface FHInformationMesageCell : UITableViewCell
/** <#strong属性注释#> */
@property (nonatomic, strong) FHInformationModel *infoModel;
/** <#strong属性注释#> */
@property (nonatomic, strong) FHScrollNewsModel *newsModel;

@end

NS_ASSUME_NONNULL_END
