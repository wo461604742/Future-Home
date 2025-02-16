//
//  FHHousingRentOrSaleController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2019/9/6.
//  Copyright © 2019 同熙传媒. All rights reserved.
//  房屋出售/出租界面

#import "FHHousingRentOrSaleController.h"
#import "FHAccountApplicationTFView.h"
#import "BRPlaceholderTextView.h"

@interface FHHousingRentOrSaleController () <UITextFieldDelegate,UIScrollViewDelegate>
/** 大的滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollView;
/** 标题View */
@property (nonatomic, strong) FHAccountApplicationTFView *titleView;
/** 房屋户型View */
@property (nonatomic, strong) FHAccountApplicationTFView *houseTypeView;
/** 出售价格 */
@property (nonatomic, strong) FHAccountApplicationTFView *salePriceView;
/** 付款要求 */
@property (nonatomic, strong) FHAccountApplicationTFView *priceSugmentView;
/** 装修情况 */
@property (nonatomic, strong) FHAccountApplicationTFView *fixturesView;
/** 建筑面积 */
@property (nonatomic, strong) FHAccountApplicationTFView *areaView;
/** 房屋朝向View */
@property (nonatomic, strong) FHAccountApplicationTFView *houseDirectionView;
/** 房屋类型View */
@property (nonatomic, strong) FHAccountApplicationTFView *houseingTypeView;
/** 楼房房号 */
@property (nonatomic, strong) FHAccountApplicationTFView *houseNumberView;
/** 产权年限 */
@property (nonatomic, strong) FHAccountApplicationTFView *yearView;
/** 建筑时间 */
@property (nonatomic, strong) FHAccountApplicationTFView *buildTimeView;
/** 手机号 */
@property (nonatomic, strong) FHAccountApplicationTFView *phoneNumberView;
/** 接听时段 */
@property (nonatomic, strong) FHAccountApplicationTFView *callPhoneNumberView;
/** 其它补充信息 */
@property (nonatomic, strong) FHAccountApplicationTFView *otherInfoView;
/** 投诉建议textView */
@property (nonatomic, strong) BRPlaceholderTextView *suggestionsTextView;
/** 图片选择数组 */
@property (nonatomic, strong) NSMutableArray *imgSelectArrs;
/** 服务器返回的图片数组 */
@property (nonatomic, strong) NSMutableArray *selectImgArrays;
/** 房屋类型 */
@property (nonatomic, copy) NSArray *houseTypeArrs;


@end

@implementation FHHousingRentOrSaleController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.houseTypeArrs = @[@"商品房住宅",
                           @"商品房公寓",
                           @"房改房",
                           @"集资房",
                           @"经济适用房",
                           @"廉租房",
                           @"公租房",
                           @"安置房",
                           @"小产权房"];
    [self fh_creatNav];
    [self fh_creatUI];
    [self fh_layoutSubViews];
    [self creatBottomBtn];
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

- (void)fh_creatUI {
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    self.showInView = self.scrollView;
    /** 初始化collectionView */
    [self initPickerView];
    
    [self.scrollView addSubview:self.titleView];
    [self.scrollView addSubview:self.houseTypeView];
    [self.scrollView addSubview:self.salePriceView];
    [self.scrollView addSubview:self.priceSugmentView];
    [self.scrollView addSubview:self.fixturesView];
    [self.scrollView addSubview:self.areaView];
    [self.scrollView addSubview:self.houseDirectionView];
    [self.scrollView addSubview:self.houseingTypeView];
    [self.scrollView addSubview:self.houseNumberView];
    [self.scrollView addSubview:self.yearView];
    [self.scrollView addSubview:self.buildTimeView];
    [self.scrollView addSubview:self.phoneNumberView];
    [self.scrollView addSubview:self.callPhoneNumberView];
    [self.scrollView addSubview:self.otherInfoView];
    [self.scrollView addSubview:self.suggestionsTextView];
    
}


#pragma mark -- layout
- (void)fh_layoutSubViews {
    CGFloat commonCellHeight = 50.0f;
    self.scrollView.frame = CGRectMake(0, MainSizeHeight, SCREEN_WIDTH, SCREEN_HEIGHT - ZH_SCALE_SCREEN_Width(50));
    self.titleView.frame = CGRectMake(0, 0, SCREEN_WIDTH, commonCellHeight);
    self.houseTypeView.frame = CGRectMake(0, MaxY(self.titleView), SCREEN_WIDTH, commonCellHeight);
    self.salePriceView.frame = CGRectMake(0, MaxY(self.houseTypeView), SCREEN_WIDTH, commonCellHeight);
    self.priceSugmentView.frame = CGRectMake(0, MaxY(self.salePriceView), SCREEN_WIDTH, commonCellHeight);
    self.fixturesView.frame = CGRectMake(0, MaxY(self.priceSugmentView), SCREEN_WIDTH, commonCellHeight);
    self.areaView.frame = CGRectMake(0, MaxY(self.fixturesView), SCREEN_WIDTH, commonCellHeight);
    self.houseDirectionView.frame = CGRectMake(0, MaxY(self.areaView), SCREEN_WIDTH, commonCellHeight);
    self.houseingTypeView.frame = CGRectMake(0, MaxY(self.houseDirectionView), SCREEN_WIDTH, commonCellHeight);
    self.houseNumberView.frame = CGRectMake(0, MaxY(self.houseingTypeView), SCREEN_WIDTH, commonCellHeight);
    self.yearView.frame = CGRectMake(0, MaxY(self.houseNumberView), SCREEN_WIDTH, commonCellHeight);
    self.buildTimeView.frame = CGRectMake(0, MaxY(self.yearView), SCREEN_WIDTH, commonCellHeight);
    self.phoneNumberView.frame = CGRectMake(0, MaxY(self.buildTimeView), SCREEN_WIDTH, commonCellHeight);
    self.callPhoneNumberView.frame = CGRectMake(0, MaxY(self.phoneNumberView), SCREEN_WIDTH, commonCellHeight);
    self.otherInfoView.frame = CGRectMake(0, MaxY(self.callPhoneNumberView), SCREEN_WIDTH, commonCellHeight);
    self.suggestionsTextView.frame = CGRectMake(0, MaxY(self.otherInfoView), SCREEN_WIDTH, 150);
    [self updateViewsFrame];
}

- (void)pickerViewFrameChanged {
    [self updateViewsFrame];
}

- (void)updateViewsFrame {
    [self updatePickerViewFrameY:MaxY(self.suggestionsTextView)];
    self.scrollView.contentSize = CGSizeMake(0, MaxY(self.suggestionsTextView) + [self getPickerViewFrame].size.height + MainSizeHeight + 20);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint point = scrollView.contentOffset;
    // 限制y轴不动
    point.x = 0.f;
    scrollView.contentOffset = point;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (void)creatBottomBtn{
    UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sureBtn.frame = CGRectMake(0,SCREEN_HEIGHT - ZH_SCALE_SCREEN_Height(50), SCREEN_WIDTH, ZH_SCALE_SCREEN_Height(50));
    sureBtn.backgroundColor = HEX_COLOR(0x1296db);
    [sureBtn setTitle:@"提交发布" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sureBtn];
}

#pragma mark — event
- (void)sureBtnClick {
    if (self.titleView.contentTF.text.length <= 0) {
        [self.view makeToast:@"请输入标题"];
        return;
    }
    if (self.houseTypeView.contentTF.text.length <= 0) {
        [self.view makeToast:self.houseTypeView.contentTF.placeholder];
        return;
    }
    if (self.salePriceView.contentTF.text.length <= 0) {
        [self.view makeToast:self.salePriceView.contentTF.placeholder];
        return;
    }
    if (self.priceSugmentView.contentTF.text.length <= 0) {
        [self.view makeToast:self.priceSugmentView.contentTF.placeholder];
        return;
    }
    if (self.fixturesView.contentTF.text.length <= 0) {
        [self.view makeToast:self.fixturesView.contentTF.placeholder];
        return;
    }
    if (self.areaView.contentTF.text.length <= 0) {
        [self.view makeToast:self.areaView.contentTF.placeholder];
        return;
    }
    if (self.houseDirectionView.contentTF.text.length <= 0) {
        [self.view makeToast:self.houseDirectionView.contentTF.placeholder];
        return;
    }
    if (self.houseingTypeView.contentTF.text.length <= 0) {
        [self.view makeToast:self.houseingTypeView.contentTF.placeholder];
        return;
    }
    if (self.houseNumberView.contentTF.text.length <= 0) {
        [self.view makeToast:self.houseNumberView.contentTF.placeholder];
        return;
    }
    if (self.yearView.contentTF.text.length <= 0) {
        [self.view makeToast:self.yearView.contentTF.placeholder];
        return;
    }
    if (self.buildTimeView.contentTF.text.length <= 0) {
        [self.view makeToast:self.buildTimeView.contentTF.placeholder];
        return;
    }
    if (self.phoneNumberView.contentTF.text.length <= 0) {
        [self.view makeToast:self.phoneNumberView.contentTF.placeholder];
        return;
    }
    if (self.callPhoneNumberView.contentTF.text.length <= 0) {
        [self.view makeToast:self.callPhoneNumberView.contentTF.placeholder];
        return;
    }
    
    /** 提交发布信息 */
    self.imgSelectArrs = [[NSMutableArray alloc] init];
    [self.imgSelectArrs addObjectsFromArray:[self getSmallImageArray]];
    if (self.imgSelectArrs <= 0) {
        [self.view makeToast:@"请上传房屋信息图片"];
    } else {
         [[UIApplication sharedApplication].keyWindow addSubview:self.loadingHud];
        self.selectImgArrays = [[NSMutableArray alloc] init];
        /** 先上传多张图片*/
        Account *account = [AccountStorage readAccount];
        NSString *string = [self getCurrentTimes];
        NSArray *arr = @[string];
        NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                                   @(account.user_id),@"user_id",
                                   @"property",@"path",
                                   arr,@"file[]",
                                   nil];
        for (int i = 0; i< self.imgSelectArrs.count; i++) {
            NSData *imageData = UIImageJPEGRepresentation(self.imgSelectArrs[i],1);
            [AFNetWorkTool updateImageWithUrl:@"img/uploads" parameter:paramsDic imageData:imageData success:^(id responseObj) {
                NSArray *arr = responseObj[@"data"];
                if (!IS_NULL_ARRAY(arr)) {
                    NSString *imgID = [arr objectAtIndex:0];
                    [self.selectImgArrays addObject:imgID];
                    if (self.selectImgArrays.count == self.imgSelectArrs.count) {
                        /** 图片获取完毕 */
                        [self commitInfo];
                    }
                }
            } failure:^(NSError *error) {
                
            }];
        }
    }
}

//获取当前的时间

- (NSString*)getCurrentTimes{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    
    //现在时间,你可以输出来看下是什么格式
    
    NSDate *datenow = [NSDate date];
    
    //----------将nsdate按formatter格式转成nsstring
    
    NSString *currentTimeString = [formatter stringFromDate:datenow];
    
    NSLog(@"currentTimeString =  %@",currentTimeString);
    
    return currentTimeString;
    
}

/** 提交信息 */
- (void)commitInfo {
    WS(weakSelf);
    Account *account = [AccountStorage readAccount];
    NSString *imgArrsString = [self.selectImgArrays componentsJoinedByString:@","];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               @(weakSelf.property_id),@"property_id",
                               self.titleView.contentTF.text,@"community",
                               self.areaView.contentTF.text,@"area",
                               self.houseTypeView.contentTF.text,@"hall",
                               self.houseDirectionView.contentTF.text,@"toward",
                               self.houseNumberView.contentTF.text,@"l_floor",
                               @(1),@"park_space",
                               @(2),@"elevator",
                               @(self.type),@"type",
                               self.salePriceView.contentTF.text,@"rent",
                               self.suggestionsTextView.text,@"describe",
                               self.fixturesView.contentTF.text,@"decoration",
//                               @(2.45),@"fee",
                               self.priceSugmentView.contentTF.text,@"require",
                               self.yearView.contentTF.text,@"years",
                               self.buildTimeView.contentTF.text,@"times",
                               self.phoneNumberView.contentTF.text,@"mobile",
                               self.callPhoneNumberView.contentTF.text,@"time_slot",
                               imgArrsString,@"img_ids",
                               self.houseingTypeView.contentTF.text,@"house_type",
                               nil];
    
    [AFNetWorkTool post:@"property/releaseRentSale" params:paramsDic success:^(id responseObj) {
        NSInteger code = [responseObj[@"code"] integerValue];
        if (code == 1) {
            [weakSelf.loadingHud hideAnimated:YES];
            weakSelf.loadingHud = nil;
            [weakSelf.view makeToast:@"资料已经提交成功"];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } else {
            [weakSelf.loadingHud hideAnimated:YES];
            weakSelf.loadingHud = nil;
            [self.view makeToast:responseObj[@"msg"]];
        }
    } failure:^(NSError *error) {
        [weakSelf.loadingHud hideAnimated:YES];
        weakSelf.loadingHud = nil;
        [self.view makeToast:@"所填信息有误"];
    }];
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.houseingTypeView.contentTF) {
        [self.houseingTypeView.contentTF resignFirstResponder];
        /** 选择房屋类型 */
        [ZJNormalPickerView zj_showStringPickerWithTitle:@"选择房屋类型" dataSource:self.houseTypeArrs defaultSelValue:@"" isAutoSelect: NO resultBlock:^(id selectValue, NSInteger index) {
            NSLog(@"index---%ld",index);
            self.houseingTypeView.contentTF.text = selectValue;
        } cancelBlock:^{
            
        }];
    } else if (textField == self.buildTimeView.contentTF) {
        [self.buildTimeView.contentTF resignFirstResponder];
        /** 选择结建筑时间 */
        [ZJDatePickerView zj_showDatePickerWithTitle:@"选择建筑时间" dateType:ZJDatePickerModeYMD defaultSelValue:@"" resultBlock:^(NSString *selectValue) {
            self.buildTimeView.contentTF.text = selectValue;
        } ];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.titleView.contentTF) {
        // 这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }  else if (self.titleView.contentTF.text.length >= 40) {
            self.titleView.contentTF.text = [textField.text substringToIndex:40];
            [self.view makeToast:@"标题不能超过40个字"];
            return NO;
        }
    }
    return YES;
}

#pragma mark - Getters and Setters
- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
    }
    return _scrollView;
}

- (FHAccountApplicationTFView *)titleView {
    if (!_titleView) {
        _titleView = [[FHAccountApplicationTFView alloc] init];
        _titleView.titleLabel.text = @"标题信息";
        _titleView.contentTF.placeholder = @"限40字";
        _titleView.contentTF.delegate = self;
    }
    return _titleView;
}

- (FHAccountApplicationTFView *)houseTypeView {
    if (!_houseTypeView) {
        _houseTypeView = [[FHAccountApplicationTFView alloc] init];
        _houseTypeView.titleLabel.text = @"房屋户型";
        _houseTypeView.contentTF.delegate = self;
        _houseTypeView.contentTF.placeholder = @"请输入房屋户型";
    }
    return _houseTypeView;
}

- (FHAccountApplicationTFView *)salePriceView {
    if (!_salePriceView) {
        _salePriceView = [[FHAccountApplicationTFView alloc] init];
        if (self.type == 1) {
            _salePriceView.titleLabel.text = @"出售价格(单位:万元/套)";
            _salePriceView.contentTF.placeholder = @"请输入出售价格(万元/套)";
        } else if (self.type == 2) {
            _salePriceView.titleLabel.text = @"出租价格(单位:元/月)";
            _salePriceView.contentTF.placeholder = @"请输入出租价格(元/月)";
        }
        _salePriceView.contentTF.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _salePriceView;
}

- (FHAccountApplicationTFView *)priceSugmentView {
    if (!_priceSugmentView) {
        _priceSugmentView = [[FHAccountApplicationTFView alloc] init];
        _priceSugmentView.titleLabel.text = @"付款要求";
        _priceSugmentView.contentTF.placeholder = @"请输入付款要求";
    }
    return _priceSugmentView;
}

- (FHAccountApplicationTFView *)fixturesView {
    if (!_fixturesView) {
        _fixturesView = [[FHAccountApplicationTFView alloc] init];
        _fixturesView.titleLabel.text = @"装修情况";
        _fixturesView.contentTF.placeholder = @"请输入装修情况";
    }
    return _fixturesView;
}

- (FHAccountApplicationTFView *)areaView {
    if (!_areaView) {
        _areaView = [[FHAccountApplicationTFView alloc] init];
        _areaView.titleLabel.text = @"建筑面积";
        _areaView.contentTF.placeholder = @"请输入建筑面积";
        _areaView.contentTF.keyboardType = UIKeyboardTypeNumberPad;
    }
    return _areaView;
}

- (FHAccountApplicationTFView *)houseDirectionView {
    if (!_houseDirectionView) {
        _houseDirectionView = [[FHAccountApplicationTFView alloc] init];
        _houseDirectionView.titleLabel.text = @"房屋朝向";
        _houseDirectionView.contentTF.placeholder = @"请输入房屋朝向";
    }
    return _houseDirectionView;
}

- (FHAccountApplicationTFView *)houseingTypeView {
    if (!_houseingTypeView) {
        _houseingTypeView = [[FHAccountApplicationTFView alloc] init];
        _houseingTypeView.titleLabel.text = @"房屋类型";
        _houseingTypeView.contentTF.delegate = self;
        _houseingTypeView.contentTF.placeholder = @"请选择房屋类型 >";
    }
    return _houseingTypeView;
}

- (FHAccountApplicationTFView *)houseNumberView {
    if (!_houseNumberView) {
        _houseNumberView = [[FHAccountApplicationTFView alloc] init];
        _houseNumberView.titleLabel.text = @"楼层房号";
        _houseNumberView.contentTF.placeholder = @"请输入楼层房号";
    }
    return _houseNumberView;
}

- (FHAccountApplicationTFView *)yearView {
    if (!_yearView) {
        _yearView = [[FHAccountApplicationTFView alloc] init];
        _yearView.titleLabel.text = @"产权年限";
        _yearView.contentTF.placeholder = @"请输入产权年限";
    }
    return _yearView;
}

- (FHAccountApplicationTFView *)buildTimeView {
    if (!_buildTimeView) {
        _buildTimeView = [[FHAccountApplicationTFView alloc] init];
        _buildTimeView.titleLabel.text = @"建筑时间";
        _buildTimeView.contentTF.delegate = self;
        _buildTimeView.contentTF.placeholder = @"请选择建筑时间(xxxx年xx月)>";
    }
    return _buildTimeView;
}

- (FHAccountApplicationTFView *)phoneNumberView {
    if (!_phoneNumberView) {
        _phoneNumberView = [[FHAccountApplicationTFView alloc] init];
        _phoneNumberView.titleLabel.text = @"联系电话";
        _phoneNumberView.contentTF.placeholder = @"请输入联系电话";
    }
    return _phoneNumberView;
}

- (FHAccountApplicationTFView *)callPhoneNumberView {
    if (!_callPhoneNumberView) {
        _callPhoneNumberView = [[FHAccountApplicationTFView alloc] init];
        _callPhoneNumberView.titleLabel.text = @"接听时段";
        _callPhoneNumberView.contentTF.placeholder = @"请输入接听时段(09:00-22:00)";
    }
    return _callPhoneNumberView;
}

- (FHAccountApplicationTFView *)otherInfoView {
    if (!_otherInfoView) {
        _otherInfoView = [[FHAccountApplicationTFView alloc] init];
        _otherInfoView.titleLabel.text = @"其它补充信息";
        _otherInfoView.contentTF.enabled = NO;
        _otherInfoView.bottomLineView.hidden = YES;
    }
    return _otherInfoView;
}

- (BRPlaceholderTextView *)suggestionsTextView {
    if (!_suggestionsTextView) {
        _suggestionsTextView = [[BRPlaceholderTextView alloc] init];
        _suggestionsTextView.layer.borderWidth = 1;
        _suggestionsTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _suggestionsTextView.PlaceholderLabel.font = [UIFont systemFontOfSize:15];
        _suggestionsTextView.PlaceholderLabel.textColor = [UIColor lightGrayColor];
        NSString *titleString = @"请输入其它需要补充的信息......";
        NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc]initWithString:titleString];
        _suggestionsTextView.PlaceholderLabel.attributedText = attributedTitle;
    }
    return _suggestionsTextView;
}

@end
