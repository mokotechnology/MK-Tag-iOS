//
//  MKBXTSlotTriggerCell.m
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/7/25.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXTSlotTriggerCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"

#import "MKTextField.h"
#import "MKPickerView.h"
#import "MKCustomUIAdopter.h"

#import "MKBXTSlotTriggerViewAdopter.h"

@implementation MKBXTSlotTriggerCellModel
@end

@interface MKBXTSlotTriggerCell ()<MKBXTSlotMotionDetectionViewDelegate,
MKBXTSlotMagneticDetectionViewDelegate>

@property (nonatomic, strong)UIView *backView;

@property (nonatomic, strong)UIImageView *icon;

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UIButton *switchButton;

@property (nonatomic, strong)UILabel *triggerTypeLabel;

@property (nonatomic, strong)UIButton *typeButton;

@property (nonatomic, strong)MKBXTSlotMotionDetectionView *motionView;

@property (nonatomic, strong)MKBXTSlotMotionDetectionViewModel *motionModel;

@property (nonatomic, strong)MKBXTSlotMagneticDetectionView *magneticView;

@property (nonatomic, strong)MKBXTSlotMagneticDetectionViewModel *magneticModel;

@property (nonatomic, strong)NSMutableArray *typeList;

@end

@implementation MKBXTSlotTriggerCell

+ (MKBXTSlotTriggerCell *)initCellWithTableView:(UITableView *)tableView {
    MKBXTSlotTriggerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKBXTSlotTriggerCellIdenty"];
    if (!cell) {
        cell = [[MKBXTSlotTriggerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.backView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5.f);
        make.right.mas_equalTo(-5.f);
        make.top.mas_equalTo(5.f);
        make.bottom.mas_equalTo(-5.f);
    }];
}

#pragma mark - MKBXTSlotMotionDetectionViewDelegate
- (void)bxt_motionDetectionView_startChanged:(BOOL)start {
    self.dataModel.motionStart = start;
    self.motionModel.start = start;
    self.motionView.dataModel = self.motionModel;
    if ([self.delegate respondsToSelector:@selector(bxt_trigger_motion_startStatusChanged:)]) {
        [self.delegate bxt_trigger_motion_startStatusChanged:start];
    }
}

- (void)bxt_motionDetectionView_startAdvIntervalChanged:(NSString *)startInterval {
    self.dataModel.motionStartInterval = startInterval;
    self.motionModel.startAdvInterval = startInterval;
    self.motionView.dataModel = self.motionModel;
    if ([self.delegate respondsToSelector:@selector(bxt_trigger_motion_startIntervalChanged:)]) {
        [self.delegate bxt_trigger_motion_startIntervalChanged:startInterval];
    }
}

- (void)bxt_motionDetectionView_startStaticIntervalChanged:(NSString *)staticInterval {
    self.dataModel.motionStartStaticInterval = staticInterval;
    self.motionModel.startStaticInterval = staticInterval;
    self.motionView.dataModel = self.motionModel;
    if ([self.delegate respondsToSelector:@selector(bxt_trigger_motion_startStaticIntervalChanged:)]) {
        [self.delegate bxt_trigger_motion_startStaticIntervalChanged:staticInterval];
    }
}

- (void)bxt_motionDetectionView_stopStaticIntervalChanged:(NSString *)staticInterval {
    self.dataModel.motionStopStaticInterval = staticInterval;
    self.motionModel.stopStaticInterval = staticInterval;
    self.motionView.dataModel = self.motionModel;
    if ([self.delegate respondsToSelector:@selector(bxt_trigger_motion_stopStaticIntervalChanged:)]) {
        [self.delegate bxt_trigger_motion_stopStaticIntervalChanged:staticInterval];
    }
}

#pragma mark - MKBXTSlotMagneticDetectionViewDelegate
- (void)bxt_magneticDetectionView_startChanged:(BOOL)start {
    self.dataModel.magneticStart = start;
    self.magneticModel.start = start;
    self.magneticView.dataModel = self.magneticModel;
    if ([self.delegate respondsToSelector:@selector(bxt_trigger_magnetic_startStatusChanged:)]) {
        [self.delegate bxt_trigger_magnetic_startStatusChanged:start];
    }
}

- (void)bxt_magneticDetectionView_startAdvIntervalChanged:(NSString *)startInterval {
    self.dataModel.magneticInterval = startInterval;
    self.magneticModel.startAdvInterval = startInterval;
    self.magneticView.dataModel = self.magneticModel;
    if ([self.delegate respondsToSelector:@selector(bxt_trigger_magnetic_startIntervalChanged:)]) {
        [self.delegate bxt_trigger_magnetic_startIntervalChanged:startInterval];
    }
}

#pragma mark - event method
- (void)switchButtonPressed {
    self.dataModel.isOn = !self.switchButton.selected;
    if ([self.delegate respondsToSelector:@selector(bxt_trigger_statusChanged:)]) {
        [self.delegate bxt_trigger_statusChanged:self.dataModel.isOn];
    }
}

- (void)typeButtonPressed {
    NSInteger index = 0;
    for (NSInteger i = 0; i < self.typeList.count; i ++) {
        if ([self.typeButton.titleLabel.text isEqualToString:self.typeList[i]]) {
            index = i;
            break;
        }
    }
    MKPickerView *pickView = [[MKPickerView alloc] init];
    [pickView showPickViewWithDataList:self.typeList selectedRow:index block:^(NSInteger currentRow) {
        [self triggerTypeChanged:currentRow];
    }];
}

#pragma mark - setter
- (void)setDataModel:(MKBXTSlotTriggerCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKBXTSlotTriggerCellModel.class]) {
        return;
    }
    self.switchButton.selected = _dataModel.isOn;
    UIImage *switchIcon = (_dataModel.isOn ? LOADICON(@"MKBeaconXTag", @"MKBXTSlotTriggerCell", @"bxt_switchSelectedIcon.png") : LOADICON(@"MKBeaconXTag", @"MKBXTSlotTriggerCell", @"bxt_switchUnselectedIcon.png"));
    [self.switchButton setImage:switchIcon forState:UIControlStateNormal];
    [self.backView mk_removeAllSubviews];
    [self addTopViews];
    if (!_dataModel.isOn) {
        //关闭触发
        [self setupTriggerClose];
        return;
    }
    //打开触发
    [self addBottomView];
    if (_dataModel.triggerType == 0) {
        //Motion detection
        [self.typeButton setTitle:self.typeList[1] forState:UIControlStateNormal];
        self.motionView.hidden = NO;
        self.magneticView.hidden = YES;
        self.motionModel.start = _dataModel.motionStart;
        self.motionModel.startAdvInterval = SafeStr(_dataModel.motionStartInterval);
        self.motionModel.startStaticInterval = SafeStr(_dataModel.motionStartStaticInterval);
        self.motionModel.stopStaticInterval = SafeStr(_dataModel.motionStopStaticInterval);
        self.motionView.dataModel = self.motionModel;
    }else {
        //Magnetic detection
        [self.typeButton setTitle:self.typeList[0] forState:UIControlStateNormal];
        self.motionView.hidden = YES;
        self.magneticView.hidden = NO;
        self.magneticModel.start = _dataModel.magneticStart;
        self.magneticModel.startAdvInterval = _dataModel.magneticInterval;
        self.magneticView.dataModel = self.magneticModel;
    }
    [self setupTriggerOpen];
}

#pragma mark - private method
- (void)triggerTypeChanged:(NSInteger)currentRow {
    [self.typeButton setTitle:self.typeList[currentRow] forState:UIControlStateNormal];
    NSInteger type = 0;
    if (currentRow == 0) {
        type = 1;
    }
    if (currentRow == 1) {
        //Motion Trigger
        self.motionView.dataModel = self.motionModel;
    }else {
        //Magnetic Trigger
        self.magneticView.dataModel = self.magneticModel;
    }
    self.motionView.hidden = (currentRow == 0);
    self.magneticView.hidden = (currentRow == 1);
    if ([self.delegate respondsToSelector:@selector(bxt_trigger_triggerTypeChanged:)]) {
        [self.delegate bxt_trigger_triggerTypeChanged:type];
    }
}

#pragma mark - UI
- (void)addTopViews {
    [self.backView addSubview:self.icon];
    [self.backView addSubview:self.msgLabel];
    [self.backView addSubview:self.switchButton];
}

- (void)setupTriggerClose {
    [self.icon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(25.f);
        make.centerY.mas_equalTo(self.backView.mas_centerY);
        make.height.mas_equalTo(25.f);
    }];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.icon.mas_right).mas_offset(10.f);
        make.width.mas_equalTo(100.f);
        make.centerY.mas_equalTo(self.backView.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.switchButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(40.f);
        make.centerY.mas_equalTo(self.backView.mas_centerY);
        make.height.mas_equalTo(30.f);
    }];
}

- (void)addBottomView {
    [self.backView addSubview:self.triggerTypeLabel];
    [self.backView addSubview:self.typeButton];
    [self.backView addSubview:self.motionView];
    [self.backView addSubview:self.magneticView];
}

- (void)setupTriggerOpen {
    [self.icon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(25.f);
        make.centerY.mas_equalTo(self.switchButton.mas_centerY);
        make.height.mas_equalTo(25.f);
    }];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.icon.mas_right).mas_offset(10.f);
        make.width.mas_equalTo(100.f);
        make.centerY.mas_equalTo(self.switchButton.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.switchButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(40.f);
        make.top.mas_equalTo(10.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.triggerTypeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.typeButton.mas_left).mas_offset(-15.f);
        make.centerY.mas_equalTo(self.typeButton.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.typeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(120.f);
        make.top.mas_equalTo(self.switchButton.mas_bottom).mas_offset(15.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.motionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.typeButton.mas_bottom).mas_offset(10.f);
        make.bottom.mas_equalTo(-5.f);
    }];
    [self.magneticView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.typeButton.mas_bottom).mas_offset(10.f);
        make.bottom.mas_equalTo(-5.f);
    }];
}

#pragma mark - getter
- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = COLOR_WHITE_MACROS;
        
        _backView.layer.masksToBounds = YES;
        _backView.layer.cornerRadius = 8.f;
    }
    return _backView;
}

- (UIImageView *)icon {
    if (!_icon) {
        _icon = [[UIImageView alloc] init];
        _icon.image = LOADICON(@"MKBeaconXTag", @"MKBXTSlotTriggerCell", @"bxt_slotParamsTriggerIcon.png");
    }
    return _icon;
}

- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.font = MKFont(15.f);
        _msgLabel.text = @"Trigger";
    }
    return _msgLabel;
}

- (UIButton *)switchButton {
    if (!_switchButton) {
        _switchButton = [UIButton  buttonWithType:UIButtonTypeCustom];
        [_switchButton addTarget:self
                          action:@selector(switchButtonPressed)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchButton;
}

- (UILabel *)triggerTypeLabel {
    if (!_triggerTypeLabel) {
        _triggerTypeLabel = [[UILabel alloc] init];
        _triggerTypeLabel.textColor = DEFAULT_TEXT_COLOR;
        _triggerTypeLabel.textAlignment = NSTextAlignmentLeft;
        _triggerTypeLabel.font = MKFont(15.f);
        _triggerTypeLabel.text = @"Trigger type";
    }
    return _triggerTypeLabel;
}

- (UIButton *)typeButton {
    if (!_typeButton) {
        _typeButton = [MKCustomUIAdopter customButtonWithTitle:@"Magnetic detection"
                                                        target:self
                                                        action:@selector(typeButtonPressed)];
        _typeButton.titleLabel.font = MKFont(12.f);
    }
    return _typeButton;
}

- (MKBXTSlotMotionDetectionView *)motionView {
    if (!_motionView) {
        _motionView = [[MKBXTSlotMotionDetectionView alloc] init];
        _motionView.delegate = self;
    }
    return _motionView;
}

- (MKBXTSlotMotionDetectionViewModel *)motionModel {
    if (!_motionModel) {
        _motionModel = [[MKBXTSlotMotionDetectionViewModel alloc] init];
        _motionModel.start = YES;
        _motionModel.startAdvInterval = @"50";
        _motionModel.startStaticInterval = @"30";
        _motionModel.stopStaticInterval = @"30";
    }
    return _motionModel;
}

- (MKBXTSlotMagneticDetectionView *)magneticView {
    if (!_magneticView) {
        _magneticView = [[MKBXTSlotMagneticDetectionView alloc] init];
        _magneticView.delegate = self;
    }
    return _magneticView;
}

- (MKBXTSlotMagneticDetectionViewModel *)magneticModel {
    if (!_magneticModel) {
        _magneticModel = [[MKBXTSlotMagneticDetectionViewModel alloc] init];
        _magneticModel.start = YES;
        _magneticModel.startAdvInterval = @"50";
    }
    return _magneticModel;
}

- (NSMutableArray *)typeList {
    if (!_typeList) {
        _typeList = [NSMutableArray arrayWithObjects:@"Magnetic detection",@"Motion detection", nil];
    }
    return _typeList;
}

@end
