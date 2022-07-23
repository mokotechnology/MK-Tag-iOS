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

#import "MKBXTCentralManager.h"
#import "MKBXTInterface+MKBXTConfig.h"

#import "MKBXTAccelerationModel.h"

#import "MKBXTAccelerationHeaderView.h"
#import "MKBXTAccelerationParamsCell.h"

@interface MKBXTAccelerationController ()<UITableViewDelegate,
UITableViewDataSource,
MKBXTAccelerationHeaderViewDelegate,
MKBXTAccelerationParamsCellDelegate>

@property (nonatomic, strong)MKBXTAccelerationHeaderView *headerView;

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)MKBXTAccelerationModel *dataModel;

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
    return 160.f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKBXTAccelerationParamsCell *cell = [MKBXTAccelerationParamsCell initCellWithTableView:tableView];
    cell.dataModel = self.dataList[indexPath.row];
    cell.delegate = self;
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
    MKBXTAccelerationParamsCellModel *cellModel = self.dataList[0];
    cellModel.scale = scale;
}

/// 用户改变了samplingRate
/// @param samplingRate 0:1hz,1:10hz,2:25hz,3:50hz,4:100hz
- (void)bxt_accelerationParamsSamplingRateChanged:(NSInteger)samplingRate {
    self.dataModel.samplingRate = samplingRate;
    MKBXTAccelerationParamsCellModel *cellModel = self.dataList[0];
    cellModel.samplingRate = samplingRate;
}

/// 用户改变了Motion threshold
/// @param threshold threshold
- (void)bxt_accelerationMotionThresholdChanged:(NSString *)threshold {
    self.dataModel.threshold = threshold;
    MKBXTAccelerationParamsCellModel *cellModel = self.dataList[0];
    cellModel.threshold = threshold;
}

#pragma mark - 通知
- (void)receiveAxisDatas:(NSNotification *)note {
    NSDictionary *dic = note.userInfo;
    if (!ValidDict(dic)) {
        return;
    }
    NSArray *tempList = dic[@"axisData"];
    if (!ValidArray(tempList)) {
        return;
    }
    NSDictionary *axisData = [tempList lastObject];
    [self.headerView updateDataWithXData:axisData[@"xData"] yData:axisData[@"yData"] zData:axisData[@"zData"]];
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
    MKBXTAccelerationParamsCellModel *cellModel = [[MKBXTAccelerationParamsCellModel alloc] init];
    cellModel.scale = self.dataModel.scale;
    cellModel.samplingRate = self.dataModel.samplingRate;
    cellModel.threshold = self.dataModel.threshold;
    [self.dataList addObject:cellModel];
    
    [self.tableView reloadData];
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

- (NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [NSMutableArray array];
    }
    return _dataList;
}

- (MKBXTAccelerationModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKBXTAccelerationModel alloc] init];
    }
    return _dataModel;
}

@end
