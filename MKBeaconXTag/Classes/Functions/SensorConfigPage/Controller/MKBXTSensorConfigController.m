//
//  MKBXTSensorConfigController.m
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/7/20.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXTSensorConfigController.h"

#import "Masonry.h"
#import "MKBaseTableView.h"
#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"

#import "MKHudManager.h"
#import "MKNormalTextCell.h"

#import "MKBXTInterface.h"

#import "MKBXTAccelerationController.h"
#import "MKBXTHallSensorController.h"

@interface MKBXTSensorConfigController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@end

@implementation MKBXTSensorConfigController

- (void)dealloc {
    NSLog(@"MKBXTSensorConfigController销毁");
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        //3-axis accelerometer
        MKBXTAccelerationController *vc = [[MKBXTAccelerationController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if (indexPath.section == 1 && indexPath.row == 0) {
        //Hall sensor
        MKBXTHallSensorController *vc = [[MKBXTHallSensorController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return (self.supportThreeAcc ? self.section0List.count : 0);
    }
    if (section == 1) {
        return (self.hallStatus ? 0 : self.section1List.count);
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        return cell;
    }
    MKNormalTextCell *cell = [MKNormalTextCell initCellWithTableView:tableView];
    cell.dataModel = self.section1List[indexPath.row];
    return cell;
}

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    MKNormalTextCellModel *cellModel1 = [[MKNormalTextCellModel alloc] init];
    cellModel1.leftMsg = @"3-axis accelerometer";
    cellModel1.showRightIcon = YES;
    [self.section0List addObject:cellModel1];
    
    MKNormalTextCellModel *cellModel2 = [[MKNormalTextCellModel alloc] init];
    cellModel2.leftMsg = @"Hall sensor";
    cellModel2.showRightIcon = YES;
    [self.section1List addObject:cellModel2];
    
    [self.tableView reloadData];
}

- (void)loadSubViews {
    self.defaultTitle = @"Sensor configurations";
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
        _tableView.backgroundColor = COLOR_WHITE_MACROS;
        _tableView.delegate = self;
        _tableView.dataSource = self;
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

@end
