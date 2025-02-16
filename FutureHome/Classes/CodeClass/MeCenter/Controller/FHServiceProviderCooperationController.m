//
//  FHServiceProviderCooperationController.m
//  FutureHome
//
//  Created by 同熙传媒 on 2020/3/5.
//  Copyright © 2020 同熙传媒. All rights reserved.
//

#import "FHServiceProviderCooperationController.h"
#import "FHAdvertisingCooperationController.h"
#import "FHBuinessAccountApplicationController.h"
#import "FHAccountApplicationTFView.h"
#import "FHPersonCodeView.h"
#import "FHCertificationImgView.h"
#import "FHUserAgreementView.h"
#import "FHDetailAddressView.h"
#import "FHProofOfOwnershipView.h"
#import "NSArray+JSON.h"
#import "FHAddressPickerView.h"
#import "FHCommonPaySelectView.h"
#import "FHAppDelegate.h"
#import "FHWebViewController.h"
#import "LeoPayManager.h"

@interface FHServiceProviderCooperationController ()
<UITextFieldDelegate,UIScrollViewDelegate,FHCertificationImgViewDelegate,FHUserAgreementViewDelegate,FDActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,FHCommonPaySelectViewDelegate>

/** 大的滚动视图 */
@property (nonatomic, strong) UIScrollView *scrollView;
/** 代理u区域View */
@property (nonatomic, strong) FHAccountApplicationTFView *delegateWhereView;
/** 单位名称View */
@property (nonatomic, strong) FHAccountApplicationTFView *applicantNameView;
/** 联系人姓名View */
@property (nonatomic, strong) FHAccountApplicationTFView *personNameView;
/** 联系人身份证View */
@property (nonatomic, strong) FHAccountApplicationTFView *applicantCardView;
/** 联系人手机号View */
@property (nonatomic, strong) FHAccountApplicationTFView *phoneNumberView;
/** 手机号View */
@property (nonatomic, strong) FHAccountApplicationTFView *phoneView;
/** 接收邮箱 */
@property (nonatomic, strong) FHAccountApplicationTFView *mailView;
//* 地址选择View
//@property (nonatomic, strong) FHDetailAddressView *detailAddressView;
/** 区域View */
@property (nonatomic, strong) FHAccountApplicationTFView *areaView;
/** 地址View */
@property (nonatomic, strong) FHAccountApplicationTFView *addressView;
/** 申请人身份证 */
@property (nonatomic, strong) FHPersonCodeView *personCodeView;
/** 身份证图标 */
@property (nonatomic, strong) FHCertificationImgView *certificationView;
/** 公司营业执照照片View */
@property (nonatomic, strong) FHProofOfOwnershipView *shipView;
/** 提示label */
@property (nonatomic, strong) UILabel *logoLabel;
/** 同意协议 *//** 下面的线 */
@property (nonatomic, strong) UIView *bottomLineView;
/** 用户协议 */
@property (nonatomic, strong) FHUserAgreementView *agreementView;
/** 确认并提交 */
@property (nonatomic, strong) UIButton *submitBtn;


@property (nonatomic, strong) FHAddressPickerView *addressPickerView;
/** 省的ID */
@property (nonatomic, copy) NSString *province_id;
/** 市的ID */
@property (nonatomic, copy) NSString *city_id;
/** 区的ID */
@property (nonatomic, copy) NSString *area_id;

/** 代理区域的地址选择 */
//@property (nonatomic, strong) FHAddressPickerView *delegateAddressPickerView;
/** 代理省的ID */
@property (nonatomic, copy) NSString *delegateProvince_id;
/** 代理市的ID */
@property (nonatomic, copy) NSString *delegateCity_id;
/** 代理区的ID */
@property (nonatomic, copy) NSString *delegateArea_id;

/** 选择的是第几个 */
@property (nonatomic, assign) NSInteger selectIndex;
/** 选择的ID cards 图片数组 */
@property (nonatomic, strong) NSMutableArray *selectIDCardsImgArrs;

@property (nonatomic, strong) FHCommonPaySelectView *payView;
/** 1支付宝  2 微信 */
@property (nonatomic, assign) NSInteger payType;
/** <#assign属性注释#> */
@property (nonatomic, assign) NSInteger selectCount;
/** <#assign属性注释#> */
@property (nonatomic, assign) BOOL isSelectDelegateAddress;

@property (nonatomic, strong) MBProgressHUD *lodingHud;

@end

@implementation FHServiceProviderCooperationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.selectCount = 0;
    [self fh_creatNav];
    [self fh_creatUI];
    [self fh_layoutSubViews];
    [self creatAleat];
}

#pragma mark — 通用导航栏
#pragma mark — privite
- (void)fh_creatNav {
    self.isHaveNavgationView = YES;
    self.navgationView.userInteractionEnabled = YES;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, MainStatusBarHeight, SCREEN_WIDTH, MainNavgationBarHeight)];
    titleLabel.text = @"服务商合作";
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


- (void)creatAleat {
    NSArray *buttonTitleColorArray = @[[UIColor blackColor], [UIColor blueColor]] ;
    
    [UIAlertController ba_alertShowInViewController:self
                                              title:@"温馨提示"
                                            message:self.tips2
                                   buttonTitleArray:@[@"取 消", @"确 定"]
                              buttonTitleColorArray:buttonTitleColorArray
                                              block:^(UIAlertController * _Nonnull alertController, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                                                  if (buttonIndex == 0) {
                                                      [self.navigationController popViewControllerAnimated:YES];
                                                  }
                                                  
                                              }];
}


- (void)fh_creatUI {
    self.scrollView.delegate = self;
    [self.view addSubview:self.scrollView];
    self.showInView = self.scrollView;
    /** 初始化collectionView */
    [self initPickerView];
    
    [self.scrollView addSubview:self.delegateWhereView];
    [self.scrollView addSubview:self.applicantNameView];
    
    [self.scrollView addSubview:self.personNameView];
    [self.scrollView addSubview:self.applicantCardView];
    [self.scrollView addSubview:self.phoneNumberView];
    [self.scrollView addSubview:self.phoneView];
    [self.scrollView addSubview:self.mailView];
//    [self fh_creatDetailAddressView];
    [self.scrollView addSubview:self.areaView];
    [self.scrollView addSubview:self.addressView];
    /** 申请人身份证 */
    self.certificationView = [[FHCertificationImgView alloc] initWithFrame:CGRectMake(0, 75, SCREEN_WIDTH, 100)];
    self.certificationView.delegate = self;
    [self.personCodeView addSubview:self.certificationView];
    [self.scrollView addSubview:self.personCodeView];
    /** 建筑物业权属证明 */
    [self.scrollView addSubview:self.shipView];
    [self.scrollView addSubview:self.logoLabel];
    [self.scrollView addSubview:self.bottomLineView];
    /** 确定授权View */
    [self.scrollView addSubview:self.agreementView];
    /** 确认并提交按钮 */
    [self.scrollView addSubview:self.submitBtn];
    
    [self creatAddressPickerView];
}

- (void)creatAddressPickerView {
    @weakify(self)
    //调用方法(核心)根据后面的枚举,传入不同的枚举,展示不同的模式
    _addressPickerView = [[FHAddressPickerView alloc] initWithkAddressPickerViewModel:kAddressPickerViewModelAll];
    //默认为NO
    //_addressPickerView.showLastSelect = YES;
    _addressPickerView.cancelBtnBlock = ^() {
        @strongify(self)
        //移除掉地址选择器
        [self.addressPickerView hiddenInView];
    };
    
    _addressPickerView.sureBtnBlock = ^(NSString *province,
                                        NSString *city,
                                        NSString *district,
                                        NSString *addressCode,
                                        NSString *parentCode,
                                        NSString *provienceCode) {
        //返回过来的信息在后面的这四个参数中,使用的时候要做非空判断,(province和addressCode为必返回参数,可以不做非空判断)
        @strongify(self)
        NSString *showString;
        if (city != nil) {
            showString = [NSString stringWithFormat:@"%@",city];
        }else{
            showString = province;
        }
        
        if (district != nil) {
            showString = [NSString stringWithFormat:@"%@%@", showString, district];
        }
        if (self.isSelectDelegateAddress) {
            self.delegateWhereView.contentTF.text = [NSString stringWithFormat:@"%@ %@ %@",province,city,district];
            self.delegateProvince_id = provienceCode;
            self.delegateCity_id = parentCode;
            self.delegateArea_id = addressCode;
        } else {
            self.areaView.contentTF.text = [NSString stringWithFormat:@"%@ %@ %@",province,city,district];
//            self.detailAddressView.leftProvinceDataLabel.text = province;
//            self.detailAddressView.centerProvinceDataLabel.text = city;
//            self.detailAddressView.rightProvinceDataLabel.text = district;
            self.province_id = provienceCode;
            self.city_id = parentCode;
            self.area_id = addressCode;
        }
        //移除掉地址选择器
        [self.addressPickerView hiddenInView];
        
    };
    
////    @weakify(self)
//    //调用方法(核心)根据后面的枚举,传入不同的枚举,展示不同的模式
//    _delegateAddressPickerView = [[FHAddressPickerView alloc] initWithkAddressPickerViewModel:kAddressPickerViewModelAll];
//    //默认为NO
//    //_addressPickerView.showLastSelect = YES;
//    _delegateAddressPickerView.cancelBtnBlock = ^() {
//        @strongify(self)
//        //移除掉地址选择器
//        [self.delegateAddressPickerView hiddenInView];
//    };
//
//    _delegateAddressPickerView.sureBtnBlock = ^(NSString *province,
//                                        NSString *city,
//                                        NSString *district,
//                                        NSString *addressCode,
//                                        NSString *parentCode,
//                                        NSString *provienceCode) {
//        //返回过来的信息在后面的这四个参数中,使用的时候要做非空判断,(province和addressCode为必返回参数,可以不做非空判断)
//        @strongify(self)
//        NSString *showString;
//        if (city != nil) {
//            showString = [NSString stringWithFormat:@"%@",city];
//        }else{
//            showString = province;
//        }
//
//        if (district != nil) {
//            showString = [NSString stringWithFormat:@"%@%@", showString, district];
//        }
//         self.delegateWhereView.contentTF.text = [NSString stringWithFormat:@"%@ %@ %@",province,city,district];
//        self.delegateProvince_id = provienceCode;
//        self.delegateCity_id = parentCode;
//        self.delegateArea_id = addressCode;
//        //移除掉地址选择器
//        [self.delegateAddressPickerView hiddenInView];
//
//    };
}

- (void)fh_layoutSubViews {
    self.scrollView.frame = CGRectMake(0, MainSizeHeight, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.delegateWhereView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
    self.applicantNameView.frame = CGRectMake(0, CGRectGetMaxY(self.delegateWhereView.frame), SCREEN_WIDTH, 50);
    self.personNameView.frame = CGRectMake(0, CGRectGetMaxY(self.applicantNameView.frame), SCREEN_WIDTH, 50);
    self.applicantCardView.frame = CGRectMake(0, CGRectGetMaxY(self.personNameView.frame), SCREEN_WIDTH, 50);
    self.phoneNumberView.frame = CGRectMake(0, CGRectGetMaxY(self.applicantCardView.frame), SCREEN_WIDTH, 50);
    self.phoneView.frame = CGRectMake(0, CGRectGetMaxY(self.phoneNumberView.frame), SCREEN_WIDTH, 50);
    self.mailView.frame = CGRectMake(0, CGRectGetMaxY(self.phoneView.frame), SCREEN_WIDTH, 50);
    self.areaView.frame =  CGRectMake(0, CGRectGetMaxY(self.mailView.frame), SCREEN_WIDTH, 50);
    self.addressView.frame = CGRectMake(0, CGRectGetMaxY(self.areaView.frame),SCREEN_WIDTH , 50);
    self.personCodeView.frame = CGRectMake(0, CGRectGetMaxY(self.addressView.frame), SCREEN_WIDTH, 180);
    self.shipView.frame = CGRectMake(0, CGRectGetMaxY(self.personCodeView.frame), SCREEN_WIDTH, 60);
    [self updateViewsFrame];
}

- (void)pickerViewFrameChanged {
    [self updateViewsFrame];
}

- (void)updateViewsFrame {
    [self updatePickerViewFrameY:CGRectGetMaxY(self.shipView.frame)];
    self.logoLabel.frame = CGRectMake(15, (CGRectGetMaxY(self.shipView.frame) + [self getPickerViewFrame].size.height), SCREEN_WIDTH, 12);
    self.bottomLineView.frame = CGRectMake(0, CGRectGetMaxY(self.logoLabel.frame) + 2.5, SCREEN_WIDTH, 0.5);
    self.agreementView.frame = CGRectMake(0, (CGRectGetMaxY(self.shipView.frame) + [self getPickerViewFrame].size.height) + 100, SCREEN_WIDTH, 15);
    self.submitBtn.frame = CGRectMake(0, CGRectGetMaxY(self.agreementView.frame) + 100, 160, 55);
    self.submitBtn.centerX = self.view.width / 2;
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.submitBtn.frame) + MainSizeHeight + 20);
}

//- (void)fh_creatDetailAddressView {
//    if (!self.detailAddressView) {
//        self.detailAddressView = [[FHDetailAddressView alloc] init];
//        self.view.userInteractionEnabled = YES;
//        self.scrollView.userInteractionEnabled = YES;
//        self.detailAddressView.userInteractionEnabled = YES;
//
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addressClick)];
//        [self.detailAddressView addGestureRecognizer:tap];
//        [self.scrollView addSubview:self.detailAddressView];
//    }
//}


#pragma mark — event
/** 地址选择 */
//- (void)addressClick {

//}

- (void)FHCertificationImgViewDelegateSelectIndex:(NSInteger )index {
    /** 选取图片 */
    self.selectIndex = index;
    FDActionSheet *actionSheet = [[FDActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从相册选择", nil];
    [actionSheet setCancelButtonTitleColor:COLOR_1 bgColor:nil fontSize:SCREEN_HEIGHT/667 *15];
    [actionSheet setButtonTitleColor:COLOR_1 bgColor:nil fontSize:SCREEN_HEIGHT/667 *15 atIndex:0];
    [actionSheet setButtonTitleColor:COLOR_1 bgColor:nil fontSize:SCREEN_HEIGHT/667 *15 atIndex:1];
    [actionSheet addAnimation];
    [actionSheet show];
}


#pragma mark - <FDActionSheetDelegate>
- (void)actionSheet:(FDActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex{
    switch (buttonIndex)
    {
        case 0:
        {
            [self addCamera];
            break;
        }
        case 1:
        {
            [self addPhotoClick];
            break;
        }
        case 2:
        {
            ZHLog(@"取消");
            break;
        }
        default:
            
            break;
    }
}

//调用系统相机
- (void)addCamera {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController * cameraPicker = [[UIImagePickerController alloc]init];
        cameraPicker.delegate = self;
        cameraPicker.allowsEditing = NO;  //是否可编辑
        //摄像头
        cameraPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:cameraPicker animated:YES completion:nil];
    }
}

/**
 *  跳转相册页面
 */
- (void)addPhotoClick {
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
    imagePickerVc.showSelectBtn = YES;
    imagePickerVc.naviBgColor = HEX_COLOR(0x1296db);
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        for (UIImage *image in photos) {
            if (self.selectIndex == 1) {
                self.certificationView.leftImgView.image = image;
                
            } else if (self.selectIndex == 2) {
                self.certificationView.centerImgView.image = image;
                
            } else {
                self.certificationView.rightImgView.image = image;
                
            }
        }
    }];
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

#pragma mark - <相册处理区域>
/**
 *  拍摄完成后要执行的方法
 */
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage * image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (self.selectIndex == 1) {
        self.certificationView.leftImgView.image = image;
        
    } else if (self.selectIndex == 2) {
        self.certificationView.centerImgView.image = image;
        
    } else {
        self.certificationView.rightImgView.image = image;
        
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint point = scrollView.contentOffset;
    // 限制y轴不动
    point.x = 0.f;
    scrollView.contentOffset = point;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

/** 跳转协议 */
- (void)FHUserAgreementViewClick {
    FHWebViewController *web = [[FHWebViewController alloc] init];
    web.urlString = self.protocol;
    web.typeString = @"information";
    web.hidesBottomBarWhenPushed = YES;
    web.type = @"noShow";
    web.titleString = @"用户协议";
    [self.navigationController pushViewController:web animated:YES];
}

/** 确认协议 */
- (void)fh_fhuserAgreementWithBtn:(UIButton *)sender {
    if (self.selectCount % 2 == 0) {
        [sender setBackgroundImage:[UIImage imageNamed:@"dhao"] forState:UIControlStateNormal];
    } else {
        [sender setBackgroundImage:[UIImage imageNamed:@"check"] forState:UIControlStateNormal];
    }
    self.selectCount++;
}

- (void)submitBtnClick {
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"BUYSUCCESS" object:nil];
//    [self.navigationController popViewControllerAnimated:YES];
//    return;
    
    [self payView];
//    weakSelf.submitBtn.userInteractionEnabled = NO;
    [self showPayView];
    return;
    
    if (self.selectCount % 2 == 0) {
        [self.view makeToast:@"请同意用户信息授权协议"];
        return;
    }
    
    /** 先加一个弹框提示 */
    WS(weakSelf);
    [UIAlertController ba_alertShowInViewController:self title:@"提示" message:@"确定提交信息么?已经提交无法修改" buttonTitleArray:@[@"取消",@"确定"] buttonTitleColorArray:@[[UIColor blackColor],[UIColor blueColor]] block:^(UIAlertController * _Nonnull alertController, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            [weakSelf payView];
            weakSelf.submitBtn.userInteractionEnabled = NO;
            [weakSelf showPayView];
        }
    }];
}


- (void)commitAccountDataRequest {
    self.selectIDCardsImgArrs = [[NSMutableArray alloc] init];
    if (self.certificationView.leftImgView.image) {
        [self.selectIDCardsImgArrs addObject:self.certificationView.leftImgView.image];
    }
    if (self.certificationView.centerImgView.image) {
        [self.selectIDCardsImgArrs addObject:self.certificationView.centerImgView.image];
    }
    if (self.certificationView.rightImgView.image) {
        [self.selectIDCardsImgArrs addObject:self.certificationView.rightImgView.image];
    }
    
    if (self.selectIDCardsImgArrs.count < 3) {
        [self.view makeToast:@"请上传证件相关的照片"];
        return;
    }
    /** 判空 */
    if (self.delegateWhereView.contentTF.text.length <= 0) {
        [self.view makeToast:self.delegateWhereView.contentTF.placeholder];
        return;
    }
    if (self.applicantNameView.contentTF.text.length <= 0) {
        [self.view makeToast:self.applicantNameView.contentTF.placeholder];
        return;
    }
    if (self.personNameView.contentTF.text.length <= 0) {
        [self.view makeToast:self.personNameView.contentTF.placeholder];
        return;
    }
    if (self.applicantCardView.contentTF.text.length <= 0) {
        [self.view makeToast:self.applicantCardView.contentTF.placeholder];
        return;
    }
    if (self.applicantCardView.contentTF.text.length < 18) {
        [self.view makeToast:@"身份证格式不正确,请重新填写"];
        return;
    }
    if (self.phoneNumberView.contentTF.text.length <= 0) {
        [self.view makeToast:self.phoneNumberView.contentTF.placeholder];
        return;
    }
    if (self.phoneNumberView.contentTF.text.length < 11) {
        [self.view makeToast:@"手机号码格式不正确,请重新填写"];
        return;
    }
    if (self.phoneView.contentTF.text.length <= 0) {
        [self.view makeToast:self.phoneView.contentTF.placeholder];
        return;
    }
    if (self.mailView.contentTF.text.length <= 0) {
        [self.view makeToast:self.mailView.contentTF.placeholder];
        return;
    }
    if (self.areaView.contentTF.text.length <= 0) {
        [self.view makeToast:self.areaView.contentTF.placeholder];
        return;
    }
    if (self.addressView.contentTF.text.length <= 0) {
        [self.view makeToast:self.addressView.contentTF.placeholder];
        return;
    }
    
    WS(weakSelf);
     [[UIApplication sharedApplication].keyWindow addSubview:self.lodingHud];
    Account *account = [AccountStorage readAccount];
    NSDictionary *paramsDic = [NSDictionary dictionaryWithObjectsAndKeys:
                               @(account.user_id),@"user_id",
                               self.delegateProvince_id,@"province_id",
                               self.delegateCity_id,@"city_id",
                               self.delegateArea_id,@"area_id",
                               self.applicantNameView.contentTF.text,@"unitname",
                               self.personNameView.contentTF.text,@"contactname",
                               self.applicantCardView.contentTF.text,@"idcard",
                               self.phoneNumberView.contentTF.text,@"phone",
                               self.phoneView.contentTF.text,@"landline",
                               self.mailView.contentTF.text,@"email",
                               self.province_id,@"unitprovince",
                               self.city_id,@"unitcity",
                               self.area_id,@"unitarea",
                               self.addressView.contentTF.text,@"companyaddress",
                               self.price,@"total",
                               @(self.payType),@"type",
                               @"6",@"ordertype",
                               self.selectIDCardsImgArrs,@"idCardFile[]",
                               [self getSmallImageArray],@"businesslicense[]",
                               nil];
    [AFNetWorkTool openBussinessUploadImagesWithUrl:@"provider/cooperation" parameters:paramsDic image:[self getSmallImageArray] otherImage:self.selectIDCardsImgArrs success:^(id responseObj) {
        
        if ([responseObj[@"code"] integerValue] == 1) {
            if (self.payType == 1) {
                /** 支付宝支付 */
                if ([responseObj[@"code"] integerValue] == 1) {
                    if (weakSelf.payType == 1) {
                        /** 支付宝支付 */
                        [ZHProgressHUD hide];
                        LeoPayManager *manager = [LeoPayManager getInstance];
                        [manager aliPayOrder: responseObj[@"data"] scheme:@"alisdkdemo" respBlock:^(NSInteger respCode, NSString *respMsg) {
                            [weakSelf.lodingHud hideAnimated:YES];
                            weakSelf.lodingHud = nil;
                            if (respCode == 0) {
                                /** 支付成功 */
                                WS(weakSelf);
                                [UIAlertController ba_alertShowInViewController:self title:@"提示" message:@"亲爱的用户您好：您的申请已经成功提交，社云平台会在1-3个工作日内完成审核，审核通过后将账号信息，以短信的形式发送到您的手机，请注意查收，谢谢。" buttonTitleArray:@[@"确定"] buttonTitleColorArray:@[[UIColor blueColor]] block:^(UIAlertController * _Nonnull alertController, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                                    if (buttonIndex == 0) {
                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"BUYSUCCESS" object:nil];
                                        [weakSelf.navigationController popViewControllerAnimated:YES];
                                    }
                                }];
                            } else {
                                [weakSelf.loadingHud hideAnimated:YES];
                                weakSelf.loadingHud = nil;
                                [weakSelf.view makeToast:respMsg];
                            }
                        }];
                    }
                } else {
                    [weakSelf.loadingHud hideAnimated:YES];
                    weakSelf.loadingHud = nil;
                    [weakSelf.view makeToast:responseObj[@"data"][@"msg"]];
                }
            } else if (self.payType == 2) {
                /** 微信支付 */
                if ([responseObj[@"code"] integerValue] == 1) {
                    [ZHProgressHUD hide];
                    LeoPayManager *manager = [LeoPayManager getInstance];
                    [manager wechatPayWithAppId:responseObj[@"data"][@"appid"] partnerId:responseObj[@"data"][@"partnerid"] prepayId:responseObj[@"data"][@"prepay_id"] package:responseObj[@"data"][@"package"] nonceStr:responseObj[@"data"][@"nonce_str"] timeStamp:responseObj[@"data"][@"timestamp"] sign:responseObj[@"data"][@"sign"] respBlock:^(NSInteger respCode, NSString *respMsg) {
                        [weakSelf.lodingHud hideAnimated:YES];
                        weakSelf.lodingHud = nil;
                        //处理支付结果
                        if (respCode == 0) {
                            /** 支付成功 */
                            WS(weakSelf);
                            [UIAlertController ba_alertShowInViewController:self title:@"提示" message:@"亲爱的用户您好：您的申请已经成功提交，社云平台会在1-3个工作日内完成审核，审核通过后将账号信息，以短信的形式发送到您的手机，请注意查收，谢谢。" buttonTitleArray:@[@"确定"] buttonTitleColorArray:@[[UIColor blueColor]] block:^(UIAlertController * _Nonnull alertController, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                                if (buttonIndex == 0) {
                                    [[NSNotificationCenter defaultCenter] postNotificationName:@"BUYSUCCESS" object:nil];
                                    [weakSelf.navigationController popViewControllerAnimated:YES];
                                }
                            }];
                        } else {
                            [weakSelf.loadingHud hideAnimated:YES];
                            weakSelf.loadingHud = nil;
                            [weakSelf.view makeToast:respMsg];
                        }
                    }];
                } else {
                    [weakSelf.loadingHud hideAnimated:YES];
                    weakSelf.loadingHud = nil;
                    [weakSelf.view makeToast:responseObj[@"data"][@"msg"]];
                }
            }
        } else {
            [weakSelf.loadingHud hideAnimated:YES];
            weakSelf.loadingHud = nil;
            [weakSelf.view makeToast:responseObj[@"msg"]];
        }
    } failure:^(NSError *error) {
        [weakSelf.loadingHud hideAnimated:YES];
        weakSelf.loadingHud = nil;
    }];
}


- (void)fh_selectPayTypeWIthTag:(NSInteger)selectType {
    /** 请求支付宝签名 */
    self.payType = selectType;
    [self commitAccountDataRequest];
}

#pragma mark - 显示支付弹窗
- (void)showPayView{
    __weak FHServiceProviderCooperationController *weakSelf = self;
    self.payView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    [UIView animateWithDuration:0.5 animations:^{
        [weakSelf.payView setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    } completion:^(BOOL finished) {
        weakSelf.payView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        self.submitBtn.userInteractionEnabled = YES;
    }];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.delegateWhereView.contentTF) {
        [self.delegateWhereView.contentTF resignFirstResponder];
        self.isSelectDelegateAddress = YES;
        [self.addressPickerView showInView:self.view];
    } else if (textField == self.areaView.contentTF) {
        [self.areaView.contentTF resignFirstResponder];
        self.isSelectDelegateAddress = NO;
        [self.addressPickerView showInView:self.view];
    }
}


#pragma mark - Getters and Setters
- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
    }
    return _scrollView;
}

- (FHAccountApplicationTFView *)delegateWhereView {
    if (!_delegateWhereView) {
        _delegateWhereView = [[FHAccountApplicationTFView alloc] init];
        _delegateWhereView.titleLabel.text = @"代理区域";
        _delegateWhereView.contentTF.delegate = self;
        _delegateWhereView.contentTF.placeholder = @"请选择代理区域 >";
    }
    return _delegateWhereView;
}


- (FHAccountApplicationTFView *)applicantNameView {
    if (!_applicantNameView) {
        _applicantNameView = [[FHAccountApplicationTFView alloc] init];
        _applicantNameView.titleLabel.text = @"单位名称";
        _applicantNameView.contentTF.delegate = self;
        _applicantNameView.contentTF.placeholder = @"请输入单位名称";
    }
    return _applicantNameView;
}

- (FHAccountApplicationTFView *)personNameView {
    if (!_personNameView) {
        _personNameView = [[FHAccountApplicationTFView alloc] init];
        _personNameView.titleLabel.text = @"联系人姓名";
        _personNameView.contentTF.delegate = self;
        _personNameView.contentTF.placeholder = @"请输入联系人姓名";
    }
    return _personNameView;
}

- (FHAccountApplicationTFView *)applicantCardView {
    if (!_applicantCardView) {
        _applicantCardView = [[FHAccountApplicationTFView alloc] init];
        _applicantCardView.titleLabel.text = @"联系人身份证";
        _applicantCardView.contentTF.delegate = self;
        _applicantCardView.contentTF.placeholder = @"请输入联系人身份证";
    }
    return _applicantCardView;
}

- (FHAccountApplicationTFView *)phoneNumberView {
    if (!_phoneNumberView) {
        _phoneNumberView = [[FHAccountApplicationTFView alloc] init];
        _phoneNumberView.titleLabel.text = @"手机号码";
        _phoneNumberView.contentTF.delegate = self;
        _phoneNumberView.contentTF.placeholder = @"请输入手机号码";
    }
    return _phoneNumberView;
}

- (FHAccountApplicationTFView *)phoneView {
    if (!_phoneView) {
        _phoneView = [[FHAccountApplicationTFView alloc] init];
        _phoneView.titleLabel.text = @"联系电话";
        _phoneView.contentTF.delegate = self;
        _phoneView.contentTF.placeholder = @"座机选填";
    }
    return _phoneView;
}

- (FHAccountApplicationTFView *)mailView {
    if (!_mailView) {
        _mailView = [[FHAccountApplicationTFView alloc] init];
        _mailView.titleLabel.text = @"电子邮箱";
        _mailView.contentTF.delegate = self;
        _mailView.contentTF.placeholder = @"请输入电子邮箱";
    }
    return _mailView;
}

- (FHAccountApplicationTFView *)addressView {
    if (!_addressView) {
        _addressView = [[FHAccountApplicationTFView alloc] init];
        _addressView.titleLabel.text = @"具体地址";
        _addressView.contentTF.delegate = self;
        _addressView.contentTF.placeholder = @"请输入单位信息地址";
    }
    return _addressView;
}

- (FHPersonCodeView *)personCodeView {
    if (!_personCodeView) {
        _personCodeView = [[FHPersonCodeView alloc] init];
        _personCodeView.titleLabel.text = @"申请人身份证";
    }
    return _personCodeView;
}

- (FHProofOfOwnershipView *)shipView {
    if (!_shipView) {
        _shipView = [[FHProofOfOwnershipView alloc] init];
        NSString *titleString = @"公司营业执照照片";
//        NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc]initWithString:titleString];
//        [attributedTitle changeColor:[UIColor lightGrayColor] rang:[attributedTitle changeSystemFontFloat:13 from:8 legth:24]];
        _shipView.titleLabel.text = titleString;
    }
    return _shipView;
}

- (UILabel *)logoLabel {
    if (!_logoLabel) {
        _logoLabel = [[UILabel alloc] init];
        _logoLabel.textColor = [UIColor lightGrayColor];
        _logoLabel.textAlignment = NSTextAlignmentLeft;
        _logoLabel.font = [UIFont systemFontOfSize:12];
        _logoLabel.text = @"权属证件信息可上传9张";
    }
    return _logoLabel;
}

- (UIView *)bottomLineView {
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] init];
        _bottomLineView.backgroundColor = [UIColor lightGrayColor];
    }
    return _bottomLineView;
}


- (FHUserAgreementView *)agreementView {
    if (!_agreementView) {
        _agreementView = [[FHUserAgreementView alloc] init];
        _agreementView.delegate = self;
    }
    return _agreementView;
}


- (UIButton *)submitBtn {
    if (!_submitBtn) {
        _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _submitBtn.backgroundColor = HEX_COLOR(0x1296db);
        [_submitBtn setTitle:@"确认并提交" forState:UIControlStateNormal];
        [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitBtn addTarget:self action:@selector(submitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _submitBtn;
}

- (FHCommonPaySelectView *)payView {
    if (!_payView) {
        self.payView = [[FHCommonPaySelectView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 260) nowPrice:self.price oldPrice:self.open discounted:self.discount];
        _payView.delegate = self;
        self.payView.showType = @"";
    }
    FHAppDelegate *delegate  = (FHAppDelegate *)[UIApplication sharedApplication].delegate;
    [delegate.window addSubview:_payView];
    
    return _payView;
}


- (MBProgressHUD *)lodingHud{
    if (_lodingHud == nil) {
        _lodingHud = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
        _lodingHud.mode = MBProgressHUDModeIndeterminate;
        _lodingHud.removeFromSuperViewOnHide = YES;
        _lodingHud.label.text = @"资料提交中...";
        [_lodingHud showAnimated:YES];
    }
    return _lodingHud;
}

- (FHAccountApplicationTFView *)areaView {
    if (!_areaView) {
        _areaView = [[FHAccountApplicationTFView alloc] init];
        _areaView.titleLabel.text = @"服务商所在区域";
        _areaView.contentTF.delegate = self;
        _areaView.contentTF.placeholder = @"请选择服务商所在区域 >";
    }
    return _areaView;
}

@end
