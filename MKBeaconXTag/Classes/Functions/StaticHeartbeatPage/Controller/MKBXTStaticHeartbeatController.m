//
//  MKBXTStaticHeartbeatController.m
//  MKBeaconXTag_Example
//
//  Created by aa on 2023/5/8.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKBXTStaticHeartbeatController.h"

#import "Masonry.h"

#import "MLInputDodger.h"

#import "MKMacroDefines.h"
#import "MKBaseTableView.h"
#import "UIView+MKAdd.h"
#import "NSString+MKAdd.h"

#import "MKHudManager.h"
#import "MKTextSwitchCell.h"
#import "MKTextFieldCell.h"

#import "MKBXTStaticHeartbeatModel.h"

static NSString *noteMsg1 = @"*Before enabling the static heartbeat function, please ensure that all active SLOTs have enabled the Motion detection trigger function.";
static NSString *noteMsg2 = @"*Please ensure that all active SLOTs have enabled the Motion detection trigger function.";
static NSString *noteMsg3 = @"*Please ensure that the configured static cycle time value is greater than the maximum keep static time value parameter configured for all enabled SLOTs' Motion detection trigger function parameters.";

@interface MKBXTStaticHeartbeatController ()<UITableViewDelegate,
UITableViewDataSource,
mk_textSwitchCellDelegate,
MKTextFieldCellDelegate>

@property (nonatomic, strong)MKBaseTableView *tableView;

@property (nonatomic, strong)NSMutableArray *section0List;

@property (nonatomic, strong)NSMutableArray *section1List;

@property (nonatomic, strong)UILabel *noteLabel1;

@property (nonatomic, strong)UILabel *noteLabel2;

@property (nonatomic, strong)UILabel *noteLabel3;

@property (nonatomic, strong)MKBXTStaticHeartbeatModel *dataModel;

@end

@implementation MKBXTStaticHeartbeatController

- (void)dealloc {
    NSLog(@"MKBXTStaticHeartbeatController销毁");
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.view.shiftHeightAsDodgeViewForMLInputDodger = 50.0f;
    [self.view registerAsDodgeViewForMLInputDodgerWithOriginalY:self.view.frame.origin.y];
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
    return 44.f;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.section0List.count;
    }
    if (section == 1) {
        return (self.dataModel.isOn ? self.section1List.count : 0);
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        //Static heartbeat
        MKTextSwitchCell *cell = [MKTextSwitchCell initCellWithTableView:tableView];
        cell.dataModel = self.section0List[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    MKTextFieldCell *cell = [MKTextFieldCell initCellWithTableView:tableView];
    cell.dataModel = self.section1List[indexPath.row];
    cell.delegate = self;
    return cell;
}

#pragma mark - mk_textSwitchCellDelegate
/// 开关状态发生改变了
/// @param isOn 当前开关状态
/// @param index 当前cell所在的index
- (void)mk_textSwitchCellStatusChanged:(BOOL)isOn index:(NSInteger)index {
    if (index == 0) {
        //Static heartbeat
        self.dataModel.isOn = isOn;
        MKTextSwitchCellModel *cellModel = self.section0List[0];
        cellModel.isOn = isOn;
        
        [self updateNoteMsg];
        
        [self.tableView reloadData];
        return;
    }
}

#pragma mark - MKTextFieldCellDelegate
/// textField内容发送改变时的回调事件
/// @param index 当前cell所在的index
/// @param value 当前textField的值
- (void)mk_deviceTextCellValueChanged:(NSInteger)index textValue:(NSString *)value {
    if (index == 0) {
        //Static cycle time
        self.dataModel.cycleTime = value;
        MKTextFieldCellModel *cellModel = self.section1List[0];
        cellModel.textFieldValue = value;
        return;
    }
    if (index == 1) {
        //Adv duration
        self.dataModel.advDuration = value;
        MKTextFieldCellModel *cellModel = self.section1List[1];
        cellModel.textFieldValue = value;
        return;
    }
}

#pragma mark - interface
- (void)saveDataToDevice {
    [[MKHudManager share] showHUDWithTitle:@"Config..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel configDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:@"Success"];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

- (void)readDataFromDevice {
    [[MKHudManager share] showHUDWithTitle:@"Reading..." inView:self.view isPenetration:NO];
    @weakify(self);
    [self.dataModel readDataWithSucBlock:^{
        @strongify(self);
        [[MKHudManager share] hide];
        [self loadSectionDatas];
    } failedBlock:^(NSError * _Nonnull error) {
        @strongify(self);
        [[MKHudManager share] hide];
        [self.view showCentralToast:error.userInfo[@"errorInfo"]];
    }];
}

#pragma mark - Private method
- (void)updateNoteMsg {
    self.noteLabel1.hidden = self.dataModel.isOn;
    self.noteLabel2.hidden = !self.dataModel.isOn;
    self.noteLabel3.hidden = !self.dataModel.isOn;
}

#pragma mark - loadSectionDatas
- (void)loadSectionDatas {
    [self loadSection0Datas];
    [self loadSection1Datas];
    
    [self updateNoteMsg];
    
    [self.tableView reloadData];
}

- (void)loadSection0Datas {
    MKTextSwitchCellModel *cellModel = [[MKTextSwitchCellModel alloc] init];
    cellModel.index = 0;
    cellModel.msg = @"Static heartbeat";
    cellModel.isOn = self.dataModel.isOn;
    [self.section0List addObject:cellModel];
}

- (void)loadSection1Datas {
    MKTextFieldCellModel *cellModel1 = [[MKTextFieldCellModel alloc] init];
    cellModel1.index = 0;
    cellModel1.msg = @"Static cycle time";
    cellModel1.textPlaceholder = @"1~65535";
    cellModel1.textFieldValue = self.dataModel.cycleTime;
    cellModel1.textFieldType = mk_realNumberOnly;
    cellModel1.unit = @"x 60s";
    cellModel1.maxLength = 5;
    [self.section1List addObject:cellModel1];
    
    MKTextFieldCellModel *cellModel2 = [[MKTextFieldCellModel alloc] init];
    cellModel2.index = 1;
    cellModel2.msg = @"Adv duration";
    cellModel2.textPlaceholder = @"1~65535";
    cellModel2.textFieldValue = self.dataModel.advDuration;
    cellModel2.textFieldType = mk_realNumberOnly;
    cellModel2.unit = @"x 1s";
    cellModel2.maxLength = 5;
    [self.section1List addObject:cellModel2];
}

#pragma mark - UI
- (void)loadSubViews {
    self.defaultTitle = @"Static heartbeat";
    self.view.backgroundColor = RGBCOLOR(242, 242, 242);
    [self.rightButton setImage:LOADICON(@"MKBeaconXTag", @"MKBXTStaticHeartbeatController", @"bxt_slotSaveIcon.png") forState:UIControlStateNormal];
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
        _tableView.tableFooterView = [self footView];
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

- (MKBXTStaticHeartbeatModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[MKBXTStaticHeartbeatModel alloc] init];
    }
    return _dataModel;
}

- (UILabel *)noteLabel1 {
    if (!_noteLabel1) {
        _noteLabel1 = [self noteLabelWithMsg:noteMsg1];
    }
    return _noteLabel1;
}

- (UILabel *)noteLabel2 {
    if (!_noteLabel2) {
        _noteLabel2 = [self noteLabelWithMsg:noteMsg2];
    }
    return _noteLabel2;
}

- (UILabel *)noteLabel3 {
    if (!_noteLabel3) {
        _noteLabel3 = [self noteLabelWithMsg:noteMsg3];
    }
    return _noteLabel3;
}

- (UIView *)footView {
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 150.f)];
    footView.backgroundColor = RGBCOLOR(242, 242, 242);
    
    CGSize noteSize1 = [NSString sizeWithText:self.noteLabel1.text
                                      andFont:self.noteLabel1.font
                                   andMaxSize:CGSizeMake(kViewWidth - 2 * 15.f, MAXFLOAT)];
    
    CGSize noteSize2 = [NSString sizeWithText:self.noteLabel2.text
                                      andFont:self.noteLabel2.font
                                   andMaxSize:CGSizeMake(kViewWidth - 2 * 15.f, MAXFLOAT)];
    
    CGSize noteSize3 = [NSString sizeWithText:self.noteLabel3.text
                                      andFont:self.noteLabel3.font
                                   andMaxSize:CGSizeMake(kViewWidth - 2 * 15.f, MAXFLOAT)];
    
    CGFloat noteHeight1 = MAX(noteSize1.height, noteSize2.height);
    CGRect noteRect1 = CGRectMake(15.f, 20.f, kViewWidth - 2 * 15.f, noteHeight1);
    [footView addSubview:self.noteLabel1];
    [self.noteLabel1 setFrame:noteRect1];
    [footView addSubview:self.noteLabel2];
    [self.noteLabel2 setFrame:noteRect1];
    
    CGRect noteRect3 = CGRectMake(15.f, 20.f + noteHeight1 + 15.f, kViewWidth - 2 * 15.f, noteSize3.height);
    [footView addSubview:self.noteLabel3];
    [self.noteLabel3 setFrame:noteRect3];
    
    return footView;
}

- (UILabel *)noteLabelWithMsg:(NSString *)msg {
    UILabel *noteLabel = [[UILabel alloc] init];
    noteLabel.textColor = RGBCOLOR(229, 173, 140);
    noteLabel.textAlignment = NSTextAlignmentLeft;
    noteLabel.numberOfLines = 0;
    noteLabel.font = MKFont(11.f);
    noteLabel.text = msg;
    return noteLabel;
}

@end
