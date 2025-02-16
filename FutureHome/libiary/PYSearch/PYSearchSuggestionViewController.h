// 
//  代码地址: https://github.com/iphone5solo/PYSearch
//  代码地址: http://www.code4app.com/thread-11175-1-1.html
//  Created by CoderKo1o.
//  Copyright © 2016年 iphone5solo. All rights reserved.
//  搜索建议控制器

#import <UIKit/UIKit.h>

typedef void(^PYSearchSuggestionDidSelectCellBlock)(UITableViewCell *selectedCell);

@interface PYSearchSuggestionViewController : UITableViewController

/** 搜索建议 */
@property (nonatomic, copy) NSArray<NSString *> *searchSuggestions;
/** 搜索关键词 */
@property (nonatomic, copy) NSString *searchText;
/** 选中cell时调用此Block  */
@property (nonatomic, copy) PYSearchSuggestionDidSelectCellBlock didSelectCellBlock;
/** wolfKill的搜索是蓝色结果 */
@property (nonatomic,copy)NSString *wolfKill;

+ (instancetype)searchSuggestionViewControllerWithDidSelectCellBlock:(PYSearchSuggestionDidSelectCellBlock)didSelectCellBlock;

@end
