//
//  MKBXTSlotConfigController.m
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/7/23.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXTSlotConfigController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKBaseTableView.h"
#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"
#import "UITableView+MKAdd.h"

#import "MKHudManager.h"
#import "MKTableSectionLineHeader.h"

#import "MKBXTSlotConfigDataModel.h"

#import "MKBXTSlotFrameTypePickView.h"

#import "MKBXTSlotBeaconCell.h"
#import "MKBXTSlotTagInfoCell.h"
#import "MKBXTSlotUIDCell.h"
#import "MKBXTSlotURLCell.h"

#import "MKBXTSlotParamCell.h"

#import "MKBXTSlotTriggerCell.h"

static CGFloat const mk_triggerOpenHeight = 280.f;
static CGFloat const mk_triggerCloseHeight = 50.f;

@interface MKBXTSlotConfigController ()<UITableViewDelegate,
UITableViewDataSource,
MKBXTSlotFrameTypePickViewDelegate,
MKBXTSlotBeaconCellDelegate,
MKBXTSlotTagInfoCellDelegate,
MKBXTSlotUIDCellDelegate,
MKBXTSlotURLCellDelegate,
MKBXTSlotParamCellDelegate,
MKBXTSlotTriggerCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)MKBXTSlotFrameTypePickView *headerView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *section2List;

@property (nonatomic, strong)NSMutableArray *headerList;

@property (nonatomic, strong)MKBXTSlotConfigDataModel *dataModel;

@end

@implementation MKBXTSlotConfigController

- (void)dealloc {
    NSLog(@"MKBXTSlotConfigController销毁");
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
    //本页面禁止右划退出手势
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readDataFromDevice];
}

#pragma mark - super method
- (void)rightButtonMethod {
    [self saveDataToDevice];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        if (self.dataModel.slotType == bxt_slotType_uid) {
            return 120.f;
        }
        if (self.dataModel.slotType == bxt_slotType_url) {
            return 100.f;
        }
        if (self.dataModel.slotType == bxt_slotType_beacon) {
            return 160.f;
        }
        if (self.dataModel.slotType == bxt_slotType_tagInfo) {
            return 120.f;
        }
        return 0.f;
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        if (self.dataModel.slotType == bxt_slotType_tlm) {
            return 200.f;
        }
        if (self.dataModel.slotType == bxt_slotType_uid || self.dataModel.slotType == bxt_slotType_url
            || self.dataModel.slotType == bxt_slotType_beacon || self.dataModel.slotType == bxt_slotType_tagInfo) {
            return 260.f;
        }
        return 0.f;
    }
    if (indexPath.section == 2 && indexPath.row == 0) {
        if (self.dataModel.slotType == bxt_slotType_null) {
            return 0.f;
        }
        return (self.dataModel.triggerIsOn ? 280.f : 50.f);
    }
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MKTableSectionLineHeader *headerView = [MKTableSectionLineHeader initHeaderViewWithTableView:tableView];
    headerView.headerModel = self.headerList[section];
    return headerView;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.headerList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return (self.dataModel.slotType == bxt_slotType_tlm || self.dataModel.slotType == bxt_slotType_null) ? 0 : self.section0List.count;
    }
    if (section == 1) {
        return (self.dataModel.slotType == bxt_slotType_null ? 0 : self.section1List.count);
    }
    if (section == 2) {
        return (self.dataModel.slotType == bxt_slotType_null ? 0 : self.section2List.count);
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [self loadSection0Cell:indexPath.row];
    }
    if (indexPath.section == 1) {
        return [self loadSection1Cell:indexPath.row];
    }
    return [self loadSection2Cell:indexPath.row];
}

#pragma mark - MKBXTSlotFrameTypePickViewDelegate
- (void)bxt_slotFrameTypeChanged:(bxt_slotType)frameType {
    self.dataModel.slotType = frameType;
    [self loadSectionDatas];
}

#pragma mark - MKBXTSlotBeaconCellDelegate
- (void)bxt_advContent_majorChanged:(NSString *)major {
    self.dataModel.major = major;
}

- (void)bxt_advContent_minorChanged:(NSString *)minor {
    self.dataModel.minor = minor;
}

- (void)bxt_advContent_uuidChanged:(NSString *)uuid {
    self.dataModel.uuid = uuid;
}

#pragma mark - MKBXTSlotTagInfoCellDelegate
- (void)bxt_advContent_tagInfo_deviceNameChanged:(NSString *)text {
    self.dataModel.deviceName = text;
}

- (void)bxt_advContent_tagInfo_tagIDChanged:(NSString *)text {
    self.dataModel.tagID = text;
}

#pragma mark - MKBXTSlotUIDCellDelegate
- (void)bxt_advContent_namespaceIDChanged:(NSString *)text {
    self.dataModel.namespaceID = text;
}

- (void)bxt_advContent_instanceIDChanged:(NSString *)text {
    self.dataModel.instanceID = text;
}

#pragma mark - MKBXTSlotURLCellDelegate
/// 用户选择了URL类型
/// @param urlType 0:@"http://www.",1:@"https://www.",2:@"http://",3:@"https://"
- (void)bxt_advContent_urlTypeChanged:(NSInteger)urlType {
    self.dataModel.urlType = urlType;
}

- (void)bxt_advContent_urlContentChanged:(NSString *)content {
    self.dataModel.urlContent = content;
}

#pragma mark - MKBXTSlotParamCellDelegate
- (void)bxt_slotParam_advIntervalChanged:(NSString *)interval {
    self.dataModel.advInterval = interval;
}

- (void)bxt_slotParam_advDurationChanged:(NSString *)duration {
    self.dataModel.advDuration = duration;
}

- (void)bxt_slotParam_standbyDurationChanged:(NSString *)duration {
    self.dataModel.standbyDuration = duration;
}

- (void)bxt_slotParam_rssiChanged:(NSInteger)rssi {
    self.dataModel.rssi = rssi;
}

- (void)bxt_slotParam_txPowerChanged:(NSInteger)txPower {
    self.dataModel.txPower = txPower;
}

#pragma mark - MKBXTSlotTriggerCellDelegate
- (void)bxt_trigger_statusChanged:(BOOL)isOn {
    self.dataModel.triggerIsOn = isOn;
    [self.tableView mk_reloadSection:2 withRowAnimation:UITableViewRowAnimationNone];
}

/// 触发类型改变
/// @param triggerType 0:Motion detection   1:Magnetic detection
- (void)bxt_trigger_triggerTypeChanged:(NSInteger)triggerType {
    self.dataModel.triggerType = triggerType;
}

#pragma mark - Motion Trigger(triggerType = 0)
- (void)bxt_trigger_motion_startStatusChanged:(BOOL)start {
    self.dataModel.motionStart = start;
}

- (void)bxt_trigger_motion_startIntervalChanged:(NSString *)startInterval {
    self.dataModel.motionStartInterval = startInterval;
}

- (void)bxt_trigger_motion_startStaticIntervalChanged:(NSString *)staticInterval {
    self.dataModel.motionStartStaticInterval = staticInterval;
}

- (void)bxt_trigger_motion_stopStaticIntervalChanged:(NSString *)staticInterval {
    self.dataModel.motionStopStaticInterval = staticInterval;
}

#pragma mark - Magnetic Trigger(triggerType = 1)
- (void)bxt_trigger_magnetic_startStatusChanged:(BOOL)start {
    self.dataModel.magneticStart = start;
}

- (void)bxt_trigger_magnetic_startIntervalChanged:(NSString *)startInterval {
    self.dataModel.magneticInterval = startInterval;
}

#pragma mark - interface
- (void)readDataFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel readWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self.headerView updateFrameType:self.dataModel.slotType];
        [self loadSectionDatas];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)saveDataToDevice {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel configWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success"];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - private method
- (UITableViewCell *)loadSection0Cell:(NSInteger)row {
    if (self.dataModel.slotType == bxt_slotType_uid) {
        MKBXTSlotUIDCell *cell = [MKBXTSlotUIDCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section0List[row];
        cell.delegate = self;
        return cell;
    }
    if (self.dataModel.slotType == bxt_slotType_url) {
        MKBXTSlotURLCell *cell = [MKBXTSlotURLCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section0List[row];
        cell.delegate = self;
        return cell;
    }
    if (self.dataModel.slotType == bxt_slotType_beacon) {
        MKBXTSlotBeaconCell *cell = [MKBXTSlotBeaconCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section0List[row];
        cell.delegate = self;
        return cell;
    }
    if (self.dataModel.slotType == bxt_slotType_tagInfo) {
        MKBXTSlotTagInfoCell *cell = [MKBXTSlotTagInfoCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section0List[row];
        cell.delegate = self;
        return cell;
    }
    MKBaseCell *cell = [[MKBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKBXTSlotConfigControllerCell"];
    return cell;
}

- (UITableViewCell *)loadSection1Cell:(NSInteger)row {
    if (self.dataModel.slotType != bxt_slotType_null) {
        MKBXTSlotParamCell *cell = [MKBXTSlotParamCell initCellWithTableView:self.tableView];
        cell.dataModel = self.section1List[row];
        cell.delegate = self;
        return cell;
    }
    MKBaseCell *cell = [[MKBaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKBXTSlotConfigControllerCell"];
    return cell;
}

- (UITableViewCell *)loadSection2Cell:(NSInteger)row {
    MKBXTSlotTriggerCell *cell = [MKBXTSlotTriggerCell initCellWithTableView:self.tableView];
    cell.dataModel = self.section2List[row];
    cell.delegate = self;
    return cell;
}

- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    [self loadSection2Datas];
    
    [self.headerList removeAllObjects];
    
    for (NSInteger i = 0; i < 3; i ++) {
        MKTableSectionLineHeaderModel *headerModel = [[MKTableSectionLineHeaderModel alloc] init];
        [self.headerList addObject:headerModel];
    }
    
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    [self.section0List removeAllObjects];
    
    if (self.dataModel.slotType == bxt_slotType_uid) {
        MKBXTSlotUIDCellModel *cellModel = [[MKBXTSlotUIDCellModel alloc] init];
        cellModel.namespaceID = self.dataModel.namespaceID;
        cellModel.instanceID = self.dataModel.instanceID;
        [self.section0List addObject:cellModel];
        return;
    }
    if (self.dataModel.slotType == bxt_slotType_url) {
        MKBXTSlotURLCellModel *cellModel = [[MKBXTSlotURLCellModel alloc] init];
        cellModel.urlType = self.dataModel.urlType;
        cellModel.urlContent = self.dataModel.urlContent;
        [self.section0List addObject:cellModel];
        return;
    }
    if (self.dataModel.slotType == bxt_slotType_beacon) {
        MKBXTSlotBeaconCellModel *cellModel = [[MKBXTSlotBeaconCellModel alloc] init];
        cellModel.major = self.dataModel.major;
        cellModel.minor = self.dataModel.minor;
        cellModel.uuid = self.dataModel.uuid;
        [self.section0List addObject:cellModel];
        return;
    }
    if (self.dataModel.slotType == bxt_slotType_tagInfo) {
        MKBXTSlotTagInfoCellModel *cell = [[MKBXTSlotTagInfoCellModel alloc] init];
        cell.deviceName = self.dataModel.deviceName;
        cell.tagID = self.dataModel.tagID;
        [self.section0List addObject:cell];
        return;
    }
}

- (void)loadSection1Datas {
    [self.section1List removeAllObjects];
    if (self.dataModel.slotType == bxt_slotType_null) {
        return;
    }
    MKBXTSlotParamCellModel *cellModel = [[MKBXTSlotParamCellModel alloc] init];
    cellModel.cellType = self.dataModel.slotType;
    cellModel.interval = self.dataModel.advInterval;
    cellModel.advDuration = self.dataModel.advDuration;
    cellModel.standbyDuration = self.dataModel.standbyDuration;
    cellModel.rssi = self.dataModel.rssi;
    cellModel.txPower = self.dataModel.txPower;
    [self.section1List addObject:cellModel];
}

- (void)loadSection2Datas {
    [self.section2List removeAllObjects];
    
    MKBXTSlotTriggerCellModel *cellModel = [[MKBXTSlotTriggerCellModel alloc] init];
    cellModel.isOn = self.dataModel.triggerIsOn;
    cellModel.triggerType = self.dataModel.triggerType;
    cellModel.motionStart = self.dataModel.motionStart;
    cellModel.motionStartInterval = self.dataModel.motionStartInterval;
    cellModel.motionStartStaticInterval = self.dataModel.motionStartStaticInterval;
    cellModel.motionStopStaticInterval = self.dataModel.motionStopStaticInterval;
    cellModel.magneticStart = self.dataModel.magneticStart;
    cellModel.magneticInterval = self.dataModel.magneticInterval;
    
    [self.section2List addObject:cellModel];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = [NSString stringWithFormat:@"SLOT%@",@(self.slotIndex + 1)];
    [self.rightButton setImage:LOADICON(@"MKBeaconXTag", @"MKBXTSlotConfigController", @"bxt_slotSaveIcon.png") forState:UIControlStateNormal];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(defaultTopInset);
        make.bottom.mas_equalTo(-VirtualHomeHeight);
    }];
}

#pragma mark - getter
- (MKBaseTableView *)tableView {
    if (!_tableView) {
        _tableView = [[MKBaseTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = RGBCOLOR(242, 242, 242);
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.headerView;
    }
    return _tableView;
}

- (NSMutableArray *)section0List {
    if (!_section0List) {
        _section0List = [NSMutableArray array];
    }
    return _section0List;
}

- (NSMutableArray *)section1List {
    if (!_section1List) {
        _section1List = [NSMutableArray array];
    }
    return _section1List;
}

- (NSMutableArray *)section2List {
    if (!_section2List) {
        _section2List = [NSMutableArray array];
    }
    return _section2List;
}

- (MKBXTSlotFrameTypePickView *)headerView {
    if (!_headerView) {
        _headerView = [[MKBXTSlotFrameTypePickView alloc] initWithFrame:CGRectMake(0.f, 20.f, kViewWidth , 130.f)];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (MKBXTSlotConfigDataModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKBXTSlotConfigDataModel alloc] initWithSlotIndex:self.slotIndex];
    }
    return _dataModel;
}

- (NSMutableArray *)headerList {
    if (!_headerList) {
        _headerList = [NSMutableArray array];
    }
    return _headerList;
}

@end
