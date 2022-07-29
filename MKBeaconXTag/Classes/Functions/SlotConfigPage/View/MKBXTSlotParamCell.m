//
//  MKBXTSlotParamCell.m
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/7/25.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXTSlotParamCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"
#import "NSString+MKAdd.h"

#import "MKTextField.h"
#import "MKSlider.h"
#import "MKCustomUIAdopter.h"

@implementation MKBXTSlotParamCellModel
@end

@interface MKBXTSlotParamCell ()

@property (nonatomic, strong)UIView *backView;

@property (nonatomic, strong)UIImageView *leftIcon;

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UILabel *intervalLabel;

@property (nonatomic, strong)MKTextField *intervalField;

@property (nonatomic, strong)UILabel *intervalUnitLabel;

@property (nonatomic, strong)UILabel *advDurationLabel;

@property (nonatomic, strong)MKTextField *advDurationField;

@property (nonatomic, strong)UILabel *advDurationUnitLabel;

@property (nonatomic, strong)UILabel *standbyDurationLabel;

@property (nonatomic, strong)MKTextField *standbyDurationField;

@property (nonatomic, strong)UILabel *standbyDurationUnitLabel;

@property (nonatomic, strong)UILabel *rssiLabel;

@property (nonatomic, strong)MKSlider *rssiSlider;

@property (nonatomic, strong)UILabel *rssiValueLabel;

@property (nonatomic, strong)UILabel *txPowerLabel;

@property (nonatomic, strong)MKSlider *txPowerSlider;

@property (nonatomic, strong)UILabel *txPowerValueLabel;

@end

@implementation MKBXTSlotParamCell

+ (MKBXTSlotParamCell *)initCellWithTableView:(UITableView *)tableView {
    MKBXTSlotParamCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKBXTSlotParamCellIdenty"];
    if (!cell) {
        cell = [[MKBXTSlotParamCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKBXTSlotParamCellIdenty"];
    }
    return cell;
}

#pragma mark - event method
- (void)rssiSliderValueChanged {
    NSString *value = [NSString stringWithFormat:@"%.f",self.rssiSlider.value];
    if ([value isEqualToString:@"-0"]) {
        value = @"0";
    }
    self.rssiValueLabel.text = [value stringByAppendingString:@"dBm"];
    if ([self.delegate respondsToSelector:@selector(bxt_slotParam_rssiChanged:)]) {
        [self.delegate bxt_slotParam_rssiChanged:[value integerValue]];
    }
}

- (void)txPowerSliderValueChanged {
    NSString *value = [NSString stringWithFormat:@"%.f",self.txPowerSlider.value];
    self.txPowerValueLabel.text = [self txPowerValueText:[value integerValue]];
    if ([self.delegate respondsToSelector:@selector(bxt_slotParam_txPowerChanged:)]) {
        [self.delegate bxt_slotParam_txPowerChanged:[value integerValue]];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKBXTSlotParamCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKBXTSlotParamCellModel.class]) {
        return;
    }
    [self.backView mk_removeAllSubviews];
    if (self.backView.superview) {
        [self.backView removeFromSuperview];
    }
    if (_dataModel.cellType == bxt_slotType_null) {
        //NO Data
        return;
    }
    [self.contentView addSubview:self.backView];
    [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    if (_dataModel.cellType == bxt_slotType_tlm) {
        //TLM
        [self addTLMSubViews];
        self.intervalField.text = SafeStr(_dataModel.interval);
        self.advDurationField.text = SafeStr(_dataModel.advDuration);
        self.standbyDurationField.text = SafeStr(_dataModel.standbyDuration);
        self.txPowerSlider.value = _dataModel.txPower;
        [self setupTopViews];
        [self setupTLMSliderUI];
        return;
    }
    [self addNormalSubViews];
    [self setupTopViews];
    [self setupNormalSliderUI];
    self.intervalField.text = SafeStr(_dataModel.interval);
    self.advDurationField.text = SafeStr(_dataModel.advDuration);
    self.standbyDurationField.text = SafeStr(_dataModel.standbyDuration);
    self.rssiSlider.value = _dataModel.rssi;
    NSString *value = [NSString stringWithFormat:@"%.f",self.rssiSlider.value];
    self.rssiValueLabel.text = [value stringByAppendingString:@"dBm"];
    self.txPowerSlider.value = _dataModel.txPower;
    self.txPowerValueLabel.text = [self txPowerValueText:_dataModel.txPower];
    [self updateRssiMsg];
}

#pragma mark - private method
- (NSString *)txPowerValueText:(NSInteger)value{
    if (value == 0) {
        return @"-40dBm";
    }
    if (value == 1){
        return @"-20dBm";
    }
    if (value == 2){
        return @"-16dBm";
    }
    if (value == 3){
        return @"-12dBm";
    }
    if (value == 4){
        return @"-8dBm";
    }
    if (value == 5){
        return @"-4dBm";
    }
    if (value == 6){
        return @"0dBm";
    }
    if (value == 7) {
        return @"3dBm";
    }
    return @"4dBm";
}

- (void)updateRssiMsg {
    if (self.dataModel.cellType == bxt_slotType_null || self.dataModel.cellType == bxt_slotType_tlm) {
        return;
    }
    if (self.dataModel.cellType == bxt_slotType_uid || self.dataModel.cellType == bxt_slotType_url) {
        self.rssiLabel.attributedText = [MKCustomUIAdopter attributedString:@[@"RSSI@0m",@"   (-100dBm ~ 0dBm)"] fonts:@[MKFont(13.f),MKFont(12.f)] colors:@[DEFAULT_TEXT_COLOR,RGBCOLOR(223, 223, 223)]];
        return;
    }
    if (self.dataModel.cellType == bxt_slotType_beacon) {
        self.rssiLabel.attributedText = [MKCustomUIAdopter attributedString:@[@"RSSI@1m",@"   (-100dBm ~ 0dBm)"] fonts:@[MKFont(13.f),MKFont(12.f)] colors:@[DEFAULT_TEXT_COLOR,RGBCOLOR(223, 223, 223)]];
        return;
    }
    if (self.dataModel.cellType == bxt_slotType_tagInfo) {
        self.rssiLabel.attributedText = [MKCustomUIAdopter attributedString:@[@"Ranging data",@"   (-100dBm ~ 0dBm)"] fonts:@[MKFont(13.f),MKFont(12.f)] colors:@[DEFAULT_TEXT_COLOR,RGBCOLOR(223, 223, 223)]];
        return;
    }
}

- (void)addNormalSubViews {
    [self.backView addSubview:self.leftIcon];
    [self.backView addSubview:self.msgLabel];
    [self.backView addSubview:self.intervalLabel];
    [self.backView addSubview:self.intervalField];
    [self.backView addSubview:self.intervalUnitLabel];
    [self.backView addSubview:self.advDurationLabel];
    [self.backView addSubview:self.advDurationField];
    [self.backView addSubview:self.advDurationUnitLabel];
    [self.backView addSubview:self.standbyDurationLabel];
    [self.backView addSubview:self.standbyDurationField];
    [self.backView addSubview:self.standbyDurationUnitLabel];
    [self.backView addSubview:self.rssiLabel];
    [self.backView addSubview:self.rssiSlider];
    [self.backView addSubview:self.rssiValueLabel];
    [self.backView addSubview:self.txPowerLabel];
    [self.backView addSubview:self.txPowerSlider];
    [self.backView addSubview:self.txPowerValueLabel];
}

- (void)addTLMSubViews {
    [self.backView addSubview:self.leftIcon];
    [self.backView addSubview:self.msgLabel];
    [self.backView addSubview:self.intervalLabel];
    [self.backView addSubview:self.intervalField];
    [self.backView addSubview:self.intervalUnitLabel];
    [self.backView addSubview:self.advDurationLabel];
    [self.backView addSubview:self.advDurationField];
    [self.backView addSubview:self.advDurationUnitLabel];
    [self.backView addSubview:self.standbyDurationLabel];
    [self.backView addSubview:self.standbyDurationField];
    [self.backView addSubview:self.standbyDurationUnitLabel];
//    [self.backView addSubview:self.rssiLabel];
//    [self.backView addSubview:self.rssiSlider];
//    [self.backView addSubview:self.rssiValueLabel];
    [self.backView addSubview:self.txPowerLabel];
    [self.backView addSubview:self.txPowerSlider];
    [self.backView addSubview:self.txPowerValueLabel];
}

- (void)setupTopViews {
    [self.leftIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(22.f);
        make.top.mas_equalTo(10.f);
        make.height.mas_equalTo(22.f);
    }];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftIcon.mas_right).mas_offset(15.f);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.leftIcon.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.intervalUnitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(50.f);
        make.centerY.mas_equalTo(self.intervalField.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.intervalField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.intervalUnitLabel.mas_left).mas_offset(-5.f);
        make.width.mas_equalTo(60.f);
        make.top.mas_equalTo(self.leftIcon.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(25.f);
    }];
    [self.intervalLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftIcon.mas_left);
        make.right.mas_equalTo(self.intervalField.mas_left).mas_offset(-10.f);
        make.centerY.mas_equalTo(self.intervalField.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.advDurationUnitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(50.f);
        make.centerY.mas_equalTo(self.advDurationField.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.advDurationField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.advDurationUnitLabel.mas_left).mas_offset(-5.f);
        make.width.mas_equalTo(60.f);
        make.top.mas_equalTo(self.intervalField.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(25.f);
    }];
    [self.advDurationLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftIcon.mas_left);
        make.right.mas_equalTo(self.advDurationField.mas_left).mas_offset(-10.f);
        make.centerY.mas_equalTo(self.advDurationField.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.standbyDurationUnitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(50.f);
        make.centerY.mas_equalTo(self.standbyDurationField.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.standbyDurationField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.standbyDurationUnitLabel.mas_left).mas_offset(-5.f);
        make.width.mas_equalTo(60.f);
        make.top.mas_equalTo(self.advDurationField.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(25.f);
    }];
    [self.standbyDurationLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftIcon.mas_left);
        make.right.mas_equalTo(self.standbyDurationField.mas_left).mas_offset(-10.f);
        make.centerY.mas_equalTo(self.standbyDurationField.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
}

- (void)setupTLMSliderUI {
    [self.txPowerLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.top.mas_equalTo(self.standbyDurationField.mas_bottom).mas_offset(15.f);
        make.right.mas_equalTo(-15.f);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.txPowerSlider mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.txPowerValueLabel.mas_left).mas_offset(-5.f);
        make.top.mas_equalTo(self.txPowerLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(10.f);
    }];
    [self.txPowerValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(60.f);
        make.centerY.mas_equalTo(self.txPowerSlider.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
}

- (void)setupNormalSliderUI {
    [self.rssiLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.top.mas_equalTo(self.standbyDurationField.mas_bottom).mas_offset(15.f);
        make.right.mas_equalTo(-15.f);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.rssiSlider mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.rssiValueLabel.mas_left).mas_offset(-5.f);
        make.top.mas_equalTo(self.rssiLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(10.f);
    }];
    [self.rssiValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(60.f);
        make.centerY.mas_equalTo(self.rssiSlider.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.txPowerLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.top.mas_equalTo(self.rssiSlider.mas_bottom).mas_offset(15.f);
        make.right.mas_equalTo(-15.f);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.txPowerSlider mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.txPowerValueLabel.mas_left).mas_offset(-5.f);
        make.top.mas_equalTo(self.txPowerLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(10.f);
    }];
    [self.txPowerValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(60.f);
        make.centerY.mas_equalTo(self.txPowerSlider.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
}

#pragma mark - getter
- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = COLOR_WHITE_MACROS;
        
        _backView.layer.masksToBounds = YES;
        _backView.layer.cornerRadius = 8.f;
    }
    return _backView;
}

- (UIImageView *)leftIcon{
    if (!_leftIcon) {
        _leftIcon = [[UIImageView alloc] init];
        _leftIcon.image = LOADICON(@"MKBeaconXTag", @"MKBXTSlotParamCell", @"bxt_slot_baseParams.png");
    }
    return _leftIcon;
}

- (UILabel *)msgLabel{
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.font = MKFont(15.f);
        _msgLabel.text = @"Parameters";
    }
    return _msgLabel;
}

- (UILabel *)intervalLabel {
    if (!_intervalLabel) {
        _intervalLabel = [self loadLabelWithMsg:@"Adv interval"];
    }
    return _intervalLabel;
}

- (MKTextField *)intervalField {
    if (!_intervalField) {
        _intervalField = [MKCustomUIAdopter customNormalTextFieldWithText:@""
                                                              placeHolder:@"1~100"
                                                                 textType:mk_realNumberOnly];
        _intervalField.font = MKFont(12.f);
        _intervalField.maxLength = 3;
        @weakify(self);
        _intervalField.textChangedBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(bxt_slotParam_advIntervalChanged:)]) {
                [self.delegate bxt_slotParam_advIntervalChanged:text];
            }
        };
        
    }
    return _intervalField;
}

- (UILabel *)intervalUnitLabel {
    if (!_intervalUnitLabel) {
        _intervalUnitLabel = [self loadLabelWithMsg:@"x100ms"];
    }
    return _intervalUnitLabel;
}

- (UILabel *)advDurationLabel {
    if (!_advDurationLabel) {
        _advDurationLabel = [self loadLabelWithMsg:@"Adv duration"];
    }
    return _advDurationLabel;
}

- (MKTextField *)advDurationField {
    if (!_advDurationField) {
        _advDurationField = [MKCustomUIAdopter customNormalTextFieldWithText:@""
                                                                 placeHolder:@"1~65535"
                                                                    textType:mk_realNumberOnly];
        _advDurationField.font = MKFont(12.f);
        _advDurationField.maxLength = 5;
        @weakify(self);
        _advDurationField.textChangedBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(bxt_slotParam_advDurationChanged:)]) {
                [self.delegate bxt_slotParam_advDurationChanged:text];
            }
        };
        
    }
    return _advDurationField;
}

- (UILabel *)advDurationUnitLabel {
    if (!_advDurationUnitLabel) {
        _advDurationUnitLabel = [self loadLabelWithMsg:@"s"];
    }
    return _advDurationUnitLabel;
}

- (UILabel *)standbyDurationLabel {
    if (!_standbyDurationLabel) {
        _standbyDurationLabel = [self loadLabelWithMsg:@"Standby duration"];
    }
    return _standbyDurationLabel;
}

- (MKTextField *)standbyDurationField {
    if (!_standbyDurationField) {
        _standbyDurationField = [MKCustomUIAdopter customNormalTextFieldWithText:@""
                                                                     placeHolder:@"0~65535"
                                                                        textType:mk_realNumberOnly];
        _standbyDurationField.font = MKFont(12.f);
        _standbyDurationField.maxLength = 5;
        @weakify(self);
        _standbyDurationField.textChangedBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(bxt_slotParam_standbyDurationChanged:)]) {
                [self.delegate bxt_slotParam_standbyDurationChanged:text];
            }
        };
        
    }
    return _standbyDurationField;
}

- (UILabel *)standbyDurationUnitLabel {
    if (!_standbyDurationUnitLabel) {
        _standbyDurationUnitLabel = [self loadLabelWithMsg:@"s"];
    }
    return _standbyDurationUnitLabel;
}

- (UILabel *)rssiLabel {
    if (!_rssiLabel) {
        _rssiLabel = [[UILabel alloc] init];
        _rssiLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _rssiLabel;
}

- (MKSlider *)rssiSlider {
    if (!_rssiSlider) {
        _rssiSlider = [[MKSlider alloc] init];
        _rssiSlider.maximumValue = 0;
        _rssiSlider.minimumValue = -100;
        [_rssiSlider addTarget:self
                        action:@selector(rssiSliderValueChanged)
              forControlEvents:UIControlEventValueChanged];
    }
    return _rssiSlider;
}

- (UILabel *)rssiValueLabel {
    if (!_rssiValueLabel) {
        _rssiValueLabel = [[UILabel alloc] init];
        _rssiValueLabel.textColor = DEFAULT_TEXT_COLOR;
        _rssiValueLabel.textAlignment = NSTextAlignmentLeft;
        _rssiValueLabel.font = MKFont(11.f);
    }
    return _rssiValueLabel;
}

- (UILabel *)txPowerLabel {
    if (!_txPowerLabel) {
        _txPowerLabel = [[UILabel alloc] init];
        _txPowerLabel.textAlignment = NSTextAlignmentLeft;
        _txPowerLabel.attributedText = [MKCustomUIAdopter attributedString:@[@"Tx power",@"   (-40,-20,-16,-12,-8,-4,0,+3,+4)"] fonts:@[MKFont(13.f),MKFont(12.f)] colors:@[DEFAULT_TEXT_COLOR,RGBCOLOR(223, 223, 223)]];
    }
    return _txPowerLabel;
}

- (MKSlider *)txPowerSlider {
    if (!_txPowerSlider) {
        _txPowerSlider = [[MKSlider alloc] init];
        _txPowerSlider.maximumValue = 9.f;
        _txPowerSlider.minimumValue = 0.f;
        _txPowerSlider.value = 0.f;
        [_txPowerSlider addTarget:self
                           action:@selector(txPowerSliderValueChanged)
                 forControlEvents:UIControlEventValueChanged];
    }
    return _txPowerSlider;
}

- (UILabel *)txPowerValueLabel {
    if (!_txPowerValueLabel) {
        _txPowerValueLabel = [[UILabel alloc] init];
        _txPowerValueLabel.textColor = DEFAULT_TEXT_COLOR;
        _txPowerValueLabel.textAlignment = NSTextAlignmentLeft;
        _txPowerValueLabel.font = MKFont(11.f);
    }
    return _txPowerValueLabel;
}

- (UILabel *)loadLabelWithMsg:(NSString *)msg {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = DEFAULT_TEXT_COLOR;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = MKFont(12.f);
    label.text = msg;
    return label;
}

@end
