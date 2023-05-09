//
//  MKBXTAccelerationController.m
//  MKBeaconXTag_Example
//
//  Created by aa on 2021/3/3.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXTAccelerationController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"
#import "MKTableSectionLineHeader.h"
#import "MKSettingTextCell.h"

#import "MKBXTConnectManager.h"

#import "MKBXTCentralManager.h"
#import "MKBXTInterface+MKBXTConfig.h"

#import "MKBXTAccelerationModel.h"

#import "MKBXTAccelerationHeaderView.h"
#import "MKBXTAccelerationParamsCell.h"

#import "MKBXTStaticHeartbeatController.h"

@interface MKBXTAccelerationController ()<UITableViewDelegate,
UITableViewDataSource,
MKBXTAccelerationHeaderViewDelegate,
MKBXTAccelerationParamsCellDelegate>

@property (nonatomic, strong)MKBXTAccelerationHeaderView *headerView;

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)MKBXTAccelerationModel *dataModel;

@property (nonatomic, strong)NSMutableArray *headerList;

@end

@implementation MKBXTAccelerationController

- (void)dealloc {
    NSLog(@"MKBXTAccelerationController销毁");
    [[MKBXTCentralManager shared] notifyThreeAxisData:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readDataFromDevice];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveAxisDatas:)
                                                 name:mk_bxt_receiveThreeAxisDataNotification
                                               object:nil];
}

#pragma mark - super method
- (void)rightButtonMethod {
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

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 160.f;
    }
    if (indexPath.section == 1) {
        return 44.f;
    }
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MKTableSectionLineHeader *headerView = [MKTableSectionLineHeader initHeaderViewWithTableView:tableView];
    headerView.headerModel = self.headerList[section];
    return headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 0) {
        //Static heartbeat
        MKBXTStaticHeartbeatController *vc = [[MKBXTStaticHeartbeatController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.headerList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.section0List.count;
    }
    if (section == 1) {
        return ([MKBXTConnectManager shared].supportHeartbeat ? self.section1List.count : 0);
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKBXTAccelerationParamsCell *cell = [MKBXTAccelerationParamsCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKSettingTextCell *cell = [MKSettingTextCell initCellWithTableView:tableView];
    cell.dataModel = self.section1List[indexPath.row];
    return cell;
}

#pragma mark - MKBXTAccelerationHeaderViewDelegate
- (void)bxt_updateThreeAxisNotifyStatus:(BOOL)notify {
    [[MKBXTCentralManager shared] notifyThreeAxisData:notify];
}

- (void)bxt_clearMotionTriggerCountButtonPressed {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    [MKBXTInterface bxt_clearMotionTriggerCountWithSucBlock:^{
        [[MKHudManager share] hide];
        self.dataModel.triggerCount = @"0";
        [self.headerView updateTriggerCount:self.dataModel.triggerCount];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - MKBXTAccelerationParamsCellDelegate
/// 用户改变了scale.
/// @param scale 0:±2g,1:±4g,2:±8g,3:±16g
- (void)bxt_accelerationParamsScaleChanged:(NSInteger)scale {
    self.dataModel.scale = scale;
    MKBXTAccelerationParamsCellModel *cellModel = self.section0List[0];
    cellModel.scale = scale;
}

/// 用户改变了samplingRate
/// @param samplingRate 0:1hz,1:10hz,2:25hz,3:50hz,4:100hz
- (void)bxt_accelerationParamsSamplingRateChanged:(NSInteger)samplingRate {
    self.dataModel.samplingRate = samplingRate;
    MKBXTAccelerationParamsCellModel *cellModel = self.section0List[0];
    cellModel.samplingRate = samplingRate;
}

/// 用户改变了Motion threshold
/// @param threshold threshold
- (void)bxt_accelerationMotionThresholdChanged:(NSString *)threshold {
    self.dataModel.threshold = threshold;
    MKBXTAccelerationParamsCellModel *cellModel = self.section0List[0];
    cellModel.threshold = threshold;
}

#pragma mark - 通知
- (void)receiveAxisDatas:(NSNotification *)note {
    NSDictionary *dic = note.userInfo;
    if (!ValidDict(dic)) {
        return;
    }
    [self.headerView updateDataWithXData:dic[@"xData"] yData:dic[@"yData"] zData:dic[@"zData"]];
}

#pragma mark - 读取数据
- (void)readDataFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel readWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self loadSectionDatas];
        [self.headerView updateTriggerCount:self.dataModel.triggerCount];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - 列表加载
- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    
    for (NSInteger i = 0; i < 2; i ++) {
        MKTableSectionLineHeaderModel *headerModel = [[MKTableSectionLineHeaderModel alloc] init];
        [self.headerList addObject:headerModel];
    }
    
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKBXTAccelerationParamsCellModel *cellModel = [[MKBXTAccelerationParamsCellModel alloc] init];
    cellModel.scale = self.dataModel.scale;
    cellModel.samplingRate = self.dataModel.samplingRate;
    cellModel.threshold = self.dataModel.threshold;
    [self.section0List addObject:cellModel];
}

- (void)loadSection1Datas {
    MKSettingTextCellModel *cellModel = [[MKSettingTextCellModel alloc] init];
    cellModel.leftMsg = @"Static heartbeat";
    [self.section1List addObject:cellModel];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"3-axis accelerometer";
    [self.rightButton setImage:LOADICON(@"MKBeaconXTag", @"MKBXTAccelerationController", @"bxt_slotSaveIcon.png") forState:UIControlStateNormal];
    self.view.backgroundColor = RGBCOLOR(242, 242, 242);
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5.f);
        make.right.mas_equalTo(-5.f);
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

- (MKBXTAccelerationHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[MKBXTAccelerationHeaderView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 165.f)];
        _headerView.delegate = self;
    }
    return _headerView;
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

- (NSMutableArray *)headerList {
    if (!_headerList) {
        _headerList = [NSMutableArray array];
    }
    return _headerList;
}

- (MKBXTAccelerationModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKBXTAccelerationModel alloc] init];
    }
    return _dataModel;
}

@end
