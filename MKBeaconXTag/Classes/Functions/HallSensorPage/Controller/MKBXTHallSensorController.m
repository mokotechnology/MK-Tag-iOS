//
//  MKBXTHallSensorController.m
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/7/21.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXTHallSensorController.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"

#import "MKBXTCentralManager.h"
#import "MKBXTInterface+MKBXTConfig.h"

#import "MKBXTHallSensorModel.h"

#import "MKBXTHallSensorHeaderView.h"
#import "MKBXTHallSensorStatusCell.h"

@interface MKBXTHallSensorController ()<UITableViewDelegate,
UITableViewDataSource,
MKBXTHallSensorHeaderViewDelegate,
MKBXTHallSensorStatusCellDelegate>

@property (nonatomic, strong)MKBXTHallSensorHeaderView *headerView;

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *dataList;

@property (nonatomic, strong)MKBXTHallSensorModel *dataModel;

@end

@implementation MKBXTHallSensorController

- (void)dealloc {
    NSLog(@"MKBXTHallSensorController销毁");
    [[MKBXTCentralManager shared] notifyHallSensorData:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self readDataFromDevice];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60.f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MKBXTHallSensorStatusCell *cell = [MKBXTHallSensorStatusCell initCellWithTableView:tableView];
    cell.dataModel = self.dataList[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - MKBXTHallSensorHeaderViewDelegate

- (void)bxt_clearMagneticTriggerCountButtonPressed {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    [MKBXTInterface bxt_clearHallTriggerCountWithSucBlock:^{
        [[MKHudManager share] hide];
        self.dataModel.count = @"0";
        [self.headerView updateTriggerCount:self.dataModel.count];
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - MKBXTHallSensorStatusCellDelegate
- (void)bxt_hallSensorStatusChanged:(BOOL)isOn {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    [MKBXTInterface bxt_configPowerOffByHallSensor:isOn sucBlock:^{
        [[MKHudManager share] hide];
        self.dataModel.isOn = isOn;
        MKBXTHallSensorStatusCellModel *cellModel = self.dataList[0];
        cellModel.isOn = isOn;
    } failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
        [self.tableView reloadData];
    }];
}

#pragma mark - 通知
- (void)receiveHallSensorDatas:(NSNotification *)note {
    NSDictionary *dic = note.userInfo;
    if (!ValidDict(dic)) {
        return;
    }
    BOOL moved = [dic[@"moved"] boolValue];
    self.dataModel.status = (moved ? @"Absent" : @"Present");
    [self.headerView updateMagnetStatus:self.dataModel.status];
}

#pragma mark - 读取数据
- (void)readDataFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel readWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self loadSectionDatas];
        [self.headerView updateTriggerCount:self.dataModel.count];
        [self.headerView updateMagnetStatus:self.dataModel.status];
        [[MKBXTCentralManager shared] notifyHallSensorData:YES];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(receiveHallSensorDatas:)
                                                     name:mk_bxt_receiveHallSensorStatusChangedNotification
                                                   object:nil];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - 列表加载
- (void)loadSectionDatas {
    MKBXTHallSensorStatusCellModel *cellModel = [[MKBXTHallSensorStatusCellModel alloc] init];
    cellModel.isOn = self.dataModel.isOn;
    [self.dataList addObject:cellModel];
    
    [self.tableView reloadData];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Hall sensor";
    self.view.backgroundColor = RGBCOLOR(242, 242, 242);
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5.f);
        make.right.mas_equalTo(-5.f);
        make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
        make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
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

- (MKBXTHallSensorHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[MKBXTHallSensorHeaderView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 100.f)];
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

- (MKBXTHallSensorModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKBXTHallSensorModel alloc] init];
    }
    return _dataModel;
}

@end
