//
//  MKBXTRemoteReminderController.m
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/2/21.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXTRemoteReminderController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"
#import "MKTableSectionLineHeader.h"
#import "MKTextFieldCell.h"

#import "MKBXTInterface+MKBXTConfig.h"

#import "MKBXTRemoteReminderCell.h"

#import "MKBXTRemoteReminderModel.h"

@interface MKBXTRemoteReminderController ()<UITableViewDelegate,
UITableViewDataSource,
MKTextFieldCellDelegate,
MKBXTRemoteReminderCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)NSMutableArray *headerList;

@property (nonatomic, strong)MKBXTRemoteReminderModel *dataModel;

@end

@implementation MKBXTRemoteReminderController

- (void)dealloc {
    NSLog(@"MKBXTRemoteReminderController销毁");
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubViews];
    [self loadSectionDatas];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10.f;
    }
    return 0;
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
        return self.section0List.count;
    }
    if (section == 1) {
        return self.section1List.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        //LED notification
        MKBXTRemoteReminderCell *cell = [MKBXTRemoteReminderCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
    cell.dataModel = self.section1List[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - MKTextFieldCellDelegate
/// textField内容发送改变时的回调事件
/// @param index 当前cell所在的index
/// @param value 当前textField的值
- (void)mk_deviceTextCellValueChanged:(NSInteger)index textValue:(NSString *)value {
    if (index == 0) {
        self.dataModel.blinkingTime = value;
        MKTextFieldCellModel *cellModel = self.section1List[0];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 1) {
        self.dataModel.blinkingInterval = value;
        MKTextFieldCellModel *cellModel = self.section1List[1];
        cellModel.textFieldValue = value;
        return;
    }
}

#pragma mark - MKBXTRemoteReminderCellDelegate
- (void)bxt_remindButtonPressed:(NSInteger)index {
    if (index == 0) {
        [self reminderLED];
        return;
    }
}

#pragma mark - interface

- (void)reminderLED {
    if (!ValidStr(self.dataModel.blinkingTime) || [self.dataModel.blinkingTime integerValue] < 1 || [self.dataModel.blinkingTime integerValue] > 600) {
        [self.view showCentralToast:@"Blink Time Error"];
        return ;
    }
    if (!ValidStr(self.dataModel.blinkingInterval) || [self.dataModel.blinkingInterval integerValue] < 1 || [self.dataModel.blinkingInterval integerValue] > 100) {
        [self.view showCentralToast:@"Blink Interval Error"];
        return ;
    }
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    [MKBXTInterface bxt_configRemoteReminderLEDNotiParams:[self.dataModel.blinkingTime integerValue]
                                         blinkingInterval:[self.dataModel.blinkingInterval integerValue]
                                                 sucBlock:^{
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success"];
    }
                                              failedBlock:^(NSError * _Nonnull error) {
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - loadSectionDatas
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
    MKBXTRemoteReminderCellModel *cellModel = [[MKBXTRemoteReminderCellModel alloc] init];
    cellModel.msg = @"LED notification";
    cellModel.index = 0;
    [self.section0List addObject:cellModel];
}

- (void)loadSection1Datas {
    MKTextFieldCellModel *cellModel1 = [[MKTextFieldCellModel alloc] init];
    cellModel1.index = 0;
    cellModel1.msg = @"Blinking time";
    cellModel1.textPlaceholder = @"1~600";
    cellModel1.textFieldValue = self.dataModel.blinkingTime;
    cellModel1.textFieldType = mk_realNumberOnly;
    cellModel1.unit = @"x 1s";
    cellModel1.maxLength = 3;
    [self.section1List addObject:cellModel1];
    
    MKTextFieldCellModel *cellModel2 = [[MKTextFieldCellModel alloc] init];
    cellModel2.index = 1;
    cellModel2.msg = @"Blinking interval";
    cellModel2.textPlaceholder = @"1~100";
    cellModel2.textFieldValue = self.dataModel.blinkingInterval;
    cellModel2.textFieldType = mk_realNumberOnly;
    cellModel2.unit = @"x 100ms";
    cellModel2.maxLength = 3;
    [self.section1List addObject:cellModel2];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Remote reminder";
    self.view.backgroundColor = RGBCOLOR(242, 242, 242);
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
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.backgroundColor = RGBCOLOR(242, 242, 242);
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

- (NSMutableArray *)headerList {
    if (!_headerList) {
        _headerList = [NSMutableArray array];
    }
    return _headerList;
}

- (MKBXTRemoteReminderModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKBXTRemoteReminderModel alloc] init];
    }
    return _dataModel;
}

@end
