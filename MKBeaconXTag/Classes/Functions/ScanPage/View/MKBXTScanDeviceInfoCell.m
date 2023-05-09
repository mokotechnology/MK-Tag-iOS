//
//  MKBXTScanDeviceInfoCell.m
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/7/18.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXTScanDeviceInfoCell.h"

#import <CoreBluetooth/CoreBluetooth.h>

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKBXTScanInfoCellModel.h"

static CGFloat const offset_X = 15.f;
static CGFloat const rssiIconWidth = 22.f;
static CGFloat const rssiIconHeight = 11.f;
static CGFloat const connectButtonWidth = 80.f;
static CGFloat const connectButtonHeight = 30.f;
static CGFloat const batteryIconWidth = 25.f;
static CGFloat const batteryIconHeight = 25.f;

@interface MKBXTScanDeviceInfoCell ()

/**
 信号icon
 */
@property (nonatomic, strong)UIImageView *rssiIcon;

/**
 信号强度
 */
@property (nonatomic, strong)UILabel *rssiLabel;

/**
 设备名称
 */
@property (nonatomic, strong)UILabel *nameLabel;

/**
 连接按钮
 */
@property (nonatomic, strong)UIButton *connectButton;

/**
 电池图标
 */
@property (nonatomic, strong)UIImageView *batteryIcon;

@property (nonatomic, strong)UILabel *batteryLabel;

@property (nonatomic, strong)UILabel *devieIDLabel;

@property (nonatomic, strong)UILabel *macLabel;

@property (nonatomic, strong)UILabel *timeLabel;

@property (nonatomic, strong)UIView *topBackView;

@property (nonatomic, strong)UIView *centerBackView;

@property (nonatomic, strong)UIView *bottomBackView;

@end

@implementation MKBXTScanDeviceInfoCell

+ (MKBXTScanDeviceInfoCell *)initCellWithTableView:(UITableView *)tableView{
    MKBXTScanDeviceInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKBXTScanDeviceInfoCellIdenty"];
    if (!cell) {
        cell = [[MKBXTScanDeviceInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKBXTScanDeviceInfoCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.topBackView];
        [self.contentView addSubview:self.centerBackView];
        [self.contentView addSubview:self.bottomBackView];
        
        [self.topBackView addSubview:self.rssiIcon];
        [self.topBackView addSubview:self.rssiLabel];
        [self.topBackView addSubview:self.nameLabel];
        [self.topBackView addSubview:self.connectButton];
        
        [self.bottomBackView addSubview:self.devieIDLabel];
        [self.bottomBackView addSubview:self.macLabel];
        [self.centerBackView addSubview:self.batteryIcon];
        
        [self.bottomBackView addSubview:self.batteryLabel];
        [self.bottomBackView addSubview:self.timeLabel];
        
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:4.f];
    }
    return self;
}

#pragma mark - 父类方法
- (void)layoutSubviews{
    [super layoutSubviews];
    [self.topBackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(40.f);
    }];
    [self.rssiIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20.f);
        make.top.mas_equalTo(10.f);
        make.width.mas_equalTo(rssiIconWidth);
        make.height.mas_equalTo(rssiIconHeight);
    }];
    [self.rssiLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.rssiIcon.mas_centerX);
        make.width.mas_equalTo(40.f);
        make.top.mas_equalTo(self.rssiIcon.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(MKFont(10.f).lineHeight);
    }];
    CGFloat nameWidth = (self.contentView.frame.size.width - 2 * offset_X - rssiIconWidth - 10.f - 8.f - connectButtonWidth);
    CGSize nameSize = [NSString sizeWithText:self.nameLabel.text
                                     andFont:self.nameLabel.font
                                  andMaxSize:CGSizeMake(nameWidth, MAXFLOAT)];
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rssiIcon.mas_right).mas_offset(20.f);
        make.centerY.mas_equalTo(self.rssiIcon.mas_centerY);
        make.right.mas_equalTo(self.connectButton.mas_left).mas_offset(-8.f);
        make.height.mas_equalTo(nameSize.height);
    }];
    [self.connectButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-offset_X);
        make.width.mas_equalTo(connectButtonWidth);
        make.centerY.mas_equalTo(self.topBackView.mas_centerY);
        make.height.mas_equalTo(connectButtonHeight);
    }];
    [self.centerBackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.topBackView.mas_bottom);
        make.height.mas_equalTo(batteryIconHeight);
    }];
    [self.batteryIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offset_X);
        make.width.mas_equalTo(batteryIconWidth);
        make.centerY.mas_equalTo(self.centerBackView.mas_centerY);
        make.height.mas_equalTo(batteryIconHeight);
    }];
    [self.macLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.right.mas_equalTo(self.timeLabel.mas_left).mas_offset(-5.f);
        make.bottom.mas_equalTo(self.batteryIcon.mas_centerY).mas_offset(2.f);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.devieIDLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_left);
        make.right.mas_equalTo(self.timeLabel.mas_left).mas_offset(-5.f);
        make.top.mas_equalTo(self.batteryIcon.mas_centerY).mas_offset(2.f);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(70.f);
        make.centerY.mas_equalTo(self.devieIDLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(10.f).lineHeight);
    }];
    
    [self.bottomBackView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.centerBackView.mas_bottom);
        make.bottom.mas_equalTo(0);
    }];
    [self.batteryLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.batteryIcon.mas_centerX);
        make.width.mas_equalTo(45.f);
        make.top.mas_equalTo(3.f);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
}

#pragma mark - event method
- (void)connectButtonPressed{
    if (!self.dataModel.peripheral || ![self.dataModel.peripheral isKindOfClass:CBPeripheral.class]) {
        return;
    }
    if ([self.delegate respondsToSelector:@selector(mk_bxt_connectPeripheral:)]) {
        [self.delegate mk_bxt_connectPeripheral:self.dataModel.peripheral];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKBXTScanInfoCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKBXTScanInfoCellModel.class]) {
        return;
    }
    self.connectButton.hidden = !_dataModel.connectEnable;
    
//    self.timeLabel.text = _dataModel.displayTime;
    self.rssiLabel.text = [SafeStr(_dataModel.rssi) stringByAppendingString:@"dBm"];
    self.nameLabel.text = (ValidStr(_dataModel.deviceName) ? _dataModel.deviceName : @"N/A");
    self.batteryLabel.text = (ValidStr(_dataModel.battery) ? [_dataModel.battery stringByAppendingString:@"mV"] : @"N/A");
    if (ValidStr(_dataModel.tagID)) {
        self.devieIDLabel.text = [NSString stringWithFormat:@"Tag ID:0x%@",_dataModel.tagID];
    }else {
        self.devieIDLabel.text = @"";
    }
    if (ValidStr(_dataModel.macAddress)) {
        self.macLabel.text = [NSString stringWithFormat:@"%@%@",@"MAC: ",_dataModel.macAddress];
    }else {
        self.macLabel.text = @"";
    }
    [self setNeedsLayout];
}

#pragma mark - getter
- (UIImageView *)rssiIcon{
    if (!_rssiIcon) {
        _rssiIcon = [[UIImageView alloc] init];
        _rssiIcon.image = LOADICON(@"MKBeaconXTag", @"MKBXTScanDeviceInfoCell", @"bxt_signalIcon.png");
    }
    return _rssiIcon;
}

- (UILabel *)rssiLabel{
    if (!_rssiLabel) {
        _rssiLabel = [self createLabelWithFont:MKFont(10)];
        _rssiLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _rssiLabel;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [self createLabelWithFont:MKFont(15.f)];
        _nameLabel.textColor = DEFAULT_TEXT_COLOR;
        _nameLabel.numberOfLines = 0;
    }
    return _nameLabel;
}

- (UIButton *)connectButton{
    if (!_connectButton) {
        _connectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_connectButton setBackgroundColor:NAVBAR_COLOR_MACROS];
        [_connectButton setTitle:@"CONNECT" forState:UIControlStateNormal];
        [_connectButton setTitleColor:COLOR_WHITE_MACROS forState:UIControlStateNormal];
        [_connectButton.titleLabel setFont:MKFont(15.f)];
        [_connectButton.layer setMasksToBounds:YES];
        [_connectButton.layer setCornerRadius:10.f];
        [_connectButton addTarget:self action:@selector(connectButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    }
    return _connectButton;
}

- (UIImageView *)batteryIcon{
    if (!_batteryIcon) {
        _batteryIcon = [[UIImageView alloc] init];
        _batteryIcon.image = LOADICON(@"MKBeaconXTag", @"MKBXTScanDeviceInfoCell", @"bxt_batteryHighest.png");
    }
    return _batteryIcon;
}

- (UILabel *)batteryLabel {
    if (!_batteryLabel) {
        _batteryLabel = [self createLabelWithFont:MKFont(10.f)];
        _batteryLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _batteryLabel;
}

- (UILabel *)macLabel {
    if (!_macLabel) {
        _macLabel = [self createLabelWithFont:MKFont(12.f)];
    }
    return _macLabel;
}

- (UILabel *)devieIDLabel {
    if (!_devieIDLabel) {
        _devieIDLabel = [self createLabelWithFont:MKFont(12.f)];
    }
    return _devieIDLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [self createLabelWithFont:MKFont(10.f)];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _timeLabel;
}

- (UIView *)topBackView {
    if (!_topBackView) {
        _topBackView = [[UIView alloc] init];
    }
    return _topBackView;
}

- (UIView *)centerBackView {
    if (!_centerBackView) {
        _centerBackView = [[UIView alloc] init];
    }
    return _centerBackView;
}

- (UIView *)bottomBackView {
    if (!_bottomBackView) {
        _bottomBackView = [[UIView alloc] init];
    }
    return _bottomBackView;
}

- (UILabel *)createLabelWithFont:(UIFont *)font{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = RGBCOLOR(184, 184, 184);
    label.textAlignment = NSTextAlignmentLeft;
    label.font = font;
    return label;
}

@end
