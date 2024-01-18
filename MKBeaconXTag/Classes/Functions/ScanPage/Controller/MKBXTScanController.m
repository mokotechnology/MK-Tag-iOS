//
//  MKBXTScanController.m
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/7/17.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXTScanController.h"

#import <objc/runtime.h>

#import <CoreBluetooth/CoreBluetooth.h>

#import "Masonry.h"

#import "UIViewController+HHTransition.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "NSObject+MKModel.h"

#import "MKHudManager.h"
#import "MKCustomUIAdopter.h"
#import "MKProgressView.h"
#import "MKTableSectionLineHeader.h"
#import "MKAlertView.h"

#import "MKBXScanSearchButton.h"

#import "MKBLEBaseCentralManager.h"

#import "MKBXTSDK.h"

#import "MKBXTConnectManager.h"

#import "MKBXTScanPageAdopter.h"

#import "MKBXTScanInfoCellModel.h"

#import "MKBXTScanDeviceInfoCell.h"
#import "MKBXTScanFilterView.h"

#import "MKBXTTabBarController.h"
#import "MKBXTAboutController.h"

static NSString *const localPasswordKey = @"mk_bxt_passwordKey";

static CGFloat const offset_X = 15.f;
static CGFloat const searchButtonHeight = 40.f;
static CGFloat const headerViewHeight = 90.f;

static NSTimeInterval const kRefreshInterval = 0.5f;

@interface MKBXTScanController ()<UITableViewDelegate,
UITableViewDataSource,
MKBXScanSearchButtonDelegate,
mk_bxt_centralManagerScanDelegate,
MKBXTScanDeviceInfoCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)MKBXScanSearchButtonModel *buttonModel;

@property (nonatomic, strong)MKBXScanSearchButton *searchButton;

@property (nonatomic, strong)UIImageView *refreshIcon;

@property (nonatomic, strong)UIButton *refreshButton;

@property (nonatomic, strong)dispatch_source_t scanTimer;

/// 定时刷新
@property (nonatomic, assign)CFRunLoopObserverRef observerRef;
//扫描到新的设备不能立即刷新列表，降低刷新频率
@property (nonatomic, assign)BOOL isNeedRefresh;

/// 保存当前密码输入框ascii字符部分
@property (nonatomic, copy)NSString *asciiText;

@end

@implementation MKBXTScanController

- (void)dealloc {
    NSLog(@"MKBXTScanController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    //移除runloop的监听
    CFRunLoopRemoveObserver(CFRunLoopGetCurrent(), self.observerRef, kCFRunLoopCommonModes);
    [[MKBXTCentralManager shared] stopScan];
    [MKBXTCentralManager removeFromCentralList];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self startRefresh];
}

#pragma mark - super method
- (void)rightButtonMethod {
    MKBXTAboutController *vc = [[MKBXTAboutController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    MKBXTScanInfoCellModel *model = self.dataList[section];
    return (model.advertiseList.count + 1);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        //第一个row固定为设备信息帧
        MKBXTScanDeviceInfoCell *cell = [MKBXTScanDeviceInfoCell initCellWithTableView:tableView];
        cell.dataModel = self.dataList[indexPath.section];
        cell.delegate = self;
        return cell;
    }
    MKBXTScanInfoCellModel *model = self.dataList[indexPath.section];
    return [MKBXTScanPageAdopter loadCellWithTableView:tableView dataModel:model.advertiseList[indexPath.row - 1]];
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return headerViewHeight;
    }
    MKBXTScanInfoCellModel *model = self.dataList[indexPath.section];
    return [MKBXTScanPageAdopter loadCellHeightWithDataModel:model.advertiseList[indexPath.row - 1]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.f;
    }
    return 5.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MKTableSectionLineHeader *headerView = [MKTableSectionLineHeader initHeaderViewWithTableView:tableView];
    MKTableSectionLineHeaderModel *sectionData = [[MKTableSectionLineHeaderModel alloc] init];
    sectionData.contentColor = RGBCOLOR(237, 243, 250);
    headerView.headerModel = sectionData;
    return headerView;
}

#pragma mark - MKBXScanSearchButtonDelegate
- (void)mk_bx_scanSearchButtonMethod {
    [MKBXTScanFilterView showSearchName:self.buttonModel.searchName
                                   rssi:self.buttonModel.searchRssi
                            searchBlock:^(NSString * _Nonnull searchName, NSInteger searchRssi) {
        self.buttonModel.searchRssi = searchRssi;
        self.buttonModel.searchName = searchName;
        self.searchButton.dataModel = self.buttonModel;
        
        self.refreshButton.selected = NO;
        [self refreshButtonPressed];
    }];
}

- (void)mk_bx_scanSearchButtonClearMethod {
    self.buttonModel.searchRssi = -100;
    self.buttonModel.searchMac = @"";
    self.buttonModel.searchName = @"";
    self.refreshButton.selected = NO;
    [self refreshButtonPressed];
}

#pragma mark - mk_bxt_centralManagerScanDelegate
- (void)mk_bxt_receiveBeacon:(NSArray <MKBXTBaseBeacon *>*)beaconList {
    for (MKBXTBaseBeacon *beacon in beaconList) {
        [self updateDataWithBeacon:beacon];
    }
}

- (void)mk_bxt_stopScan {
    //如果是左上角在动画，则停止动画
    if (self.refreshButton.isSelected) {
        [self.refreshIcon.layer removeAnimationForKey:@"mk_refreshAnimationKey"];
        [self.refreshButton setSelected:NO];
    }
}

#pragma mark - MKBXTScanDeviceInfoCellDelegate
- (void)mk_bxt_connectPeripheral:(CBPeripheral *)peripheral {
    [self connectPeripheral:peripheral];
}

#pragma mark - MKBXTTabBarControllerDelegate
- (void)mk_bxt_needResetScanDelegate:(BOOL)need {
    if (need) {
        [MKBXTCentralManager shared].delegate = self;
    }
    [self performSelector:@selector(startScanDevice) withObject:nil afterDelay:(need ? 1.f : 0.1f)];
}

#pragma mark - event method
- (void)refreshButtonPressed {
    if ([MKBLEBaseCentralManager shared].centralManager.state == CBManagerStateUnauthorized) {
        //用户未授权
        [self showAuthorizationAlert];
        return;
    }
    if ([MKBLEBaseCentralManager shared].centralManager.state == CBManagerStatePoweredOff) {
        //用户关闭了系统蓝牙
        [self showBLEDisable];
        return;
    }
    self.refreshButton.selected = !self.refreshButton.selected;
    [self.refreshIcon.layer removeAnimationForKey:@"mk_refreshAnimationKey"];
    if (!self.refreshButton.isSelected) {
        //停止扫描
        [[MKBXTCentralManager shared] stopScan];
        return;
    }
    [self.dataList removeAllObjects];
    [self.tableView reloadData];
    //刷新顶部设备数量
    [self.titleLabel setText:[NSString stringWithFormat:@"DEVICE(%@)",[NSString stringWithFormat:@"%ld",(long)self.dataList.count]]];
    [self.refreshIcon.layer addAnimation:[MKCustomUIAdopter refreshAnimation:2.f] forKey:@"mk_refreshAnimationKey"];
    [[MKBXTCentralManager shared] startScan];
}

#pragma mark - 刷新
- (void)startScanDevice {
    self.refreshButton.selected = NO;
    [self refreshButtonPressed];
}

- (void)needRefreshList {
    //标记需要刷新
    self.isNeedRefresh = YES;
    //唤醒runloop
    CFRunLoopWakeUp(CFRunLoopGetMain());
}

- (void)runloopObserver {
    @weakify(self);
    __block NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    self.observerRef = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        @strongify(self);
        if (activity == kCFRunLoopBeforeWaiting) {
            //runloop空闲的时候刷新需要处理的列表,但是需要控制刷新频率
            NSTimeInterval currentInterval = [[NSDate date] timeIntervalSince1970];
            if (currentInterval - timeInterval < kRefreshInterval) {
                return;
            }
            timeInterval = currentInterval;
            if (self.isNeedRefresh) {
                [self.tableView reloadData];
                [self.titleLabel setText:[NSString stringWithFormat:@"DEVICE(%@)",[NSString stringWithFormat:@"%ld",(long)self.dataList.count]]];
                self.isNeedRefresh = NO;
            }
        }
    });
    //添加监听，模式为kCFRunLoopCommonModes
    CFRunLoopAddObserver(CFRunLoopGetCurrent(), self.observerRef, kCFRunLoopCommonModes);
}

- (void)updateDataWithBeacon:(MKBXTBaseBeacon *)beacon{
    if (!beacon || beacon.frameType == MKBXTUnknownFrameType) {
        return;
    }
    if (ValidStr(self.buttonModel.searchMac) || ValidStr(self.buttonModel.searchName)) {
        //如果打开了过滤，先看是否需要过滤设备名字
        //如果是设备信息帧,判断名字是否符合要求
        if ([beacon.rssi integerValue] >= self.buttonModel.searchRssi) {
            [self filterBeaconWithSearchName:beacon];
        }
        return;
    }
    if (self.buttonModel.searchRssi > self.buttonModel.minSearchRssi) {
        //开启rssi过滤
        if ([beacon.rssi integerValue] >= self.buttonModel.searchRssi) {
            [self processBeacon:beacon];
        }
        return;
    }
    [self processBeacon:beacon];
}

/**
 通过设备名称过滤设备，这个时候肯定开启了rssi
 
 @param beacon 设备
 */
- (void)filterBeaconWithSearchName:(MKBXTBaseBeacon *)beacon{
    if (beacon.frameType == MKBXTTagInfoFrameType) {
        //如果是设备信息帧
        MKBXTTagInfoBeacon *tempBeacon = (MKBXTTagInfoBeacon *)beacon;
        if ([[tempBeacon.deviceName uppercaseString] containsString:[self.buttonModel.searchName uppercaseString]]) {
            //如果设备名称包含搜索条件，则加入
            [self processBeacon:beacon];
        }
        return;
    }
    //如果不是设备信息帧，则判断对应的有没有设备信息帧在当前数据源，如果没有直接舍弃，如果存在，则加入
    NSString *identy = beacon.peripheral.identifier.UUIDString;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier == %@", identy];
    NSArray *array = [self.dataList filteredArrayUsingPredicate:predicate];
    BOOL contain = ValidArray(array);
    if (!contain) {
        return;
    }
    [MKBXTScanPageAdopter updateInfoCellModel:array[0] beaconData:beacon];
    [self needRefreshList];
}

- (void)processBeacon:(MKBXTBaseBeacon *)beacon{
    //查看数据源中是否已经存在相关设备
    NSString *identy = beacon.peripheral.identifier.UUIDString;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier == %@", identy];
    NSArray *array = [self.dataList filteredArrayUsingPredicate:predicate];
    BOOL contain = ValidArray(array);
    if (contain) {
        //如果是已经存在了，如果是设备信息帧和TLM帧，直接替换，如果是URL、iBeacon、UID中的一种，则判断数据内容是否和已经存在的信息一致，如果一致，不处理，如果不一致，则直接加入到MKBXTScanBeaconModel的dataArray里面去
        [MKBXTScanPageAdopter updateInfoCellModel:array[0] beaconData:beacon];
        [self needRefreshList];
        return;
    }
    //不存在，则加入到dataList里面去
    MKBXTScanInfoCellModel *deviceModel = [MKBXTScanPageAdopter parseBaseBeaconToInfoModel:beacon];
    [self.dataList addObject:deviceModel];
    [self needRefreshList];
}

#pragma mark - 连接部分
- (void)connectPeripheral:(CBPeripheral *)peripheral {
    //停止扫描
    [self.refreshIcon.layer removeAnimationForKey:@"mk_refreshAnimationKey"];
    [[MKBXTCentralManager shared] stopScan];
    if (self.scanTimer) {
        dispatch_cancel(self.scanTimer);
    }
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    [[MKBXTCentralManager shared] readNeedPasswordWithPeripheral:peripheral sucBlock:^(NSDictionary * _Nonnull result) {
        [[MKHudManager share] hide];
        if ([result[@"state"] isEqualToString:@"00"]) {
            //免密登录
            [self connectDeviceWithoutPassword:peripheral];
            return;
        }
        [self connectDeviceWithPassword:peripheral];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        [self connectFailed];
    }];
}

- (void)connectDeviceWithPassword:(CBPeripheral *)peripheral {
    @weakify(self);
    MKAlertViewAction *cancelAction = [[MKAlertViewAction alloc] initWithTitle:@"Cancel" handler:^{
        @strongify(self);
        self.refreshButton.selected = NO;
        [self refreshButtonPressed];
    }];
    
    MKAlertViewAction *confirmAction = [[MKAlertViewAction alloc] initWithTitle:@"OK" handler:^{
        @strongify(self);
        [self startConnectPeripheral:peripheral needPassword:YES];
    }];
    NSString *localPassword = [[NSUserDefaults standardUserDefaults] objectForKey:localPasswordKey];
    self.asciiText = localPassword;
    MKAlertViewTextField *textField = [[MKAlertViewTextField alloc] initWithTextValue:SafeStr(localPassword)
                                                                          placeholder:@"No more than 16 characters."
                                                                        textFieldType:mk_normal
                                                                            maxLength:16
                                                                              handler:^(NSString * _Nonnull text) {
        @strongify(self);
        self.asciiText = text;
    }];
    
    NSString *msg = @"Please enter connection password.";
    MKAlertView *alertView = [[MKAlertView alloc] init];
    [alertView addAction:cancelAction];
    [alertView addAction:confirmAction];
    [alertView addTextField:textField];
    [alertView showAlertWithTitle:@"Enter password" message:msg notificationName:@"mk_bxt_needDismissAlert"];
}

- (void)connectDeviceWithoutPassword:(CBPeripheral *)peripheral {
    [self startConnectPeripheral:peripheral needPassword:NO];
}

- (void)startConnectPeripheral:(CBPeripheral *)peripheral needPassword:(BOOL)needPassword {
    if (needPassword) {
        NSString *password = self.asciiText;
        if (!ValidStr(password)) {
            [self.view showCentralToast:@"Password cannot be empty."];
            return;
        }
        if (password.length > 16) {
            [self.view showCentralToast:@"No more than 16 characters."];
            return;
        }
    }
    [[MKHudManager share] showHUDWithTitle:@"Connecting..." inView:self.view isPenetration:NO];
    [[MKBXTConnectManager shared] connectDevice:peripheral password:(needPassword ? self.asciiText : @"") sucBlock:^{
        if (ValidStr(self.asciiText) && self.asciiText.length <= 16) {
            [[NSUserDefaults standardUserDefaults] setObject:self.asciiText forKey:localPasswordKey];
        }
        [[MKHudManager share] hide];
        [self performSelector:@selector(pushTabBarPage) withObject:nil afterDelay:0.6f];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        [self connectFailed];
    }];
}

- (void)pushTabBarPage {
    MKBXTTabBarController *vc = [[MKBXTTabBarController alloc] init];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    @weakify(self);
    [self hh_presentViewController:vc presentStyle:HHPresentStyleErected completion:^{
        @strongify(self);
        vc.delegate = self;
    }];
}

- (void)connectFailed {
    self.refreshButton.selected = NO;
    [self refreshButtonPressed];
}

#pragma mark -
- (void)startRefresh {
    self.searchButton.dataModel = self.buttonModel;
    [self runloopObserver];
    [MKBXTCentralManager shared].delegate = self;
    
    NSNumber *firstInstall = [[NSUserDefaults standardUserDefaults] objectForKey:@"mk_bxt_firstInstall"];
    NSTimeInterval afterTime = 0.5f;
    if (!ValidNum(firstInstall)) {
        //第一次安装
        [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:@"mk_bxt_firstInstall"];
        afterTime = 3.5f;
    }
    [self performSelector:@selector(refreshButtonPressed) withObject:nil afterDelay:afterTime];
}

#pragma mark - private method
- (void)showAuthorizationAlert {
    NSString *promtpMessage = @"This function requires Bluetooth authorization, please enable MK Tag permission in Settings-Privacy-Bluetooth.";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
                                                                             message:promtpMessage
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:moreAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showBLEDisable {
    NSString *msg = @"The current system of bluetooth is not available!";
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
                                                                             message:msg
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *moreAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:moreAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

#pragma mark - UI
- (void)loadSubViews {
    [self.view setBackgroundColor:RGBCOLOR(237, 243, 250)];
    self.leftButton.hidden = YES;
    [self.rightButton setImage:LOADICON(@"MKBeaconXTag", @"MKBXTScanController", @"bxt_scanRightAboutIcon.png") forState:UIControlStateNormal];
    self.titleLabel.text = @"DEVICE(0)";
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = RGBCOLOR(237, 243, 250);
    [self.view addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.height.mas_equalTo(searchButtonHeight + 2 * 15.f);
    }];
    [self.refreshButton addSubview:self.refreshIcon];
    [topView addSubview:self.refreshButton];
    [self.refreshIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.refreshButton.mas_centerX);
        make.centerY.mas_equalTo(self.refreshButton.mas_centerY);
        make.width.mas_equalTo(22.f);
        make.height.mas_equalTo(22.f);
    }];
    [self.refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(40.f);
        make.top.mas_equalTo(15.f);
        make.height.mas_equalTo(40.f);
    }];
    [topView addSubview:self.searchButton];
    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.refreshButton.mas_left).mas_offset(-10.f);
        make.top.mas_equalTo(15.f);
        make.height.mas_equalTo(searchButtonHeight);
    }];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10.f);
        make.right.mas_equalTo(-10.f);
        make.top.mas_equalTo(topView.mas_bottom);
        make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom).mas_offset(-5.f);
    }];
}

#pragma mark - getter
- (MKBaseTableView *)tableView{
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = COLOR_WHITE_MACROS;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIImageView *)refreshIcon {
    if (!_refreshIcon) {
        _refreshIcon = [[UIImageView alloc] init];
        _refreshIcon.image = LOADICON(@"MKBeaconXTag", @"MKBXTScanController", @"bxt_scan_refreshIcon.png");
    }
    return _refreshIcon;
}

- (MKBXScanSearchButton *)searchButton {
    if (!_searchButton) {
        _searchButton = [[MKBXScanSearchButton alloc] init];
        _searchButton.delegate = self;
    }
    return _searchButton;
}

- (MKBXScanSearchButtonModel *)buttonModel {
    if (!_buttonModel) {
        _buttonModel = [[MKBXScanSearchButtonModel alloc] init];
        _buttonModel.placeholder = @"Edit Filter";
        _buttonModel.minSearchRssi = -100;
        _buttonModel.searchRssi = -100;
    }
    return _buttonModel;
}

- (NSMutableArray *)dataList{
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (UIButton *)refreshButton {
    if (!_refreshButton) {
        _refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_refreshButton addTarget:self
                           action:@selector(refreshButtonPressed)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    return _refreshButton;
}

@end
