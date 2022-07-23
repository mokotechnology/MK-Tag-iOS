//
//  MKBXTAccelerationParamsCell.m
//  MKBeaconXTag_Example
//
//  Created by aa on 2021/3/3.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXTAccelerationParamsCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "MKCustomUIAdopter.h"

#import "MKPickerView.h"
#import "MKTextField.h"

#import "MKBXTConnectManager.h"

@implementation MKBXTAccelerationParamsCellModel
@end

@interface MKBXTAccelerationParamsCell ()

@property (nonatomic, strong)UIView *backView;

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UILabel *scaleLabel;

@property (nonatomic, strong)UIButton *scaleButton;

@property (nonatomic, strong)NSMutableArray *scaleList;

@property (nonatomic, strong)UILabel *sampleRateLabel;

@property (nonatomic, strong)UIButton *sampleRateButton;

@property (nonatomic, strong)NSMutableArray *sampleRateList;

@property (nonatomic, strong)UILabel *thresholdLabel;

@property (nonatomic, strong)MKTextField *textField;

@property (nonatomic, strong)UILabel *thresholdUnitLabel;

@property (nonatomic, assign)NSInteger sampleRate;

@end

@implementation MKBXTAccelerationParamsCell

+ (MKBXTAccelerationParamsCell *)initCellWithTableView:(UITableView *)tableView {
    MKBXTAccelerationParamsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKBXTAccelerationParamsCellIdenty"];
    if (!cell) {
        cell = [[MKBXTAccelerationParamsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKBXTAccelerationParamsCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.backView];
        
        [self.backView addSubview:self.msgLabel];
        [self.backView addSubview:self.scaleLabel];
        [self.backView addSubview:self.scaleButton];
        [self.backView addSubview:self.sampleRateLabel];
        [self.backView addSubview:self.sampleRateButton];
        [self.backView addSubview:self.thresholdLabel];
        [self.backView addSubview:self.textField];
        [self.backView addSubview:self.thresholdUnitLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(5.f);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.scaleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(120.f);
        make.centerY.mas_equalTo(self.scaleButton.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.scaleButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.scaleLabel.mas_right).mas_offset(15.f);
        make.width.mas_equalTo(50.f);
        make.top.mas_equalTo(self.msgLabel.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(30.f);
    }];
    
    [self.sampleRateLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(120.f);
        make.centerY.mas_equalTo(self.sampleRateButton.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.sampleRateButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.sampleRateLabel.mas_right).mas_offset(15.f);
        make.width.mas_equalTo(50.f);
        make.top.mas_equalTo(self.scaleButton.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.thresholdLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(120.f);
        make.centerY.mas_equalTo(self.textField.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.thresholdLabel.mas_right).mas_offset(20.f);
        make.width.mas_equalTo(50.f);
        make.top.mas_equalTo(self.sampleRateButton.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(35.f);
    }];
    [self.thresholdUnitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(50.f);
        make.centerY.mas_equalTo(self.textField.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
}

#pragma mark - event method
- (void)scaleButtonPressed {
    NSInteger index = 0;
    for (NSInteger i = 0; i < self.scaleList.count; i ++) {
        if ([self.scaleButton.titleLabel.text isEqualToString:self.scaleList[i]]) {
            index = i;
            break;
        }
    }
    MKPickerView *pickView = [[MKPickerView alloc] init];
    [pickView showPickViewWithDataList:self.scaleList selectedRow:index block:^(NSInteger currentRow) {
        self.sampleRate = currentRow;
        [self updateThresholdUnit];
        if ([self.delegate respondsToSelector:@selector(bxt_accelerationParamsScaleChanged:)]) {
            [self.delegate bxt_accelerationParamsScaleChanged:currentRow];
        }
    }];
}

- (void)sampleRateButtonPressed {
    NSInteger index = 0;
    for (NSInteger i = 0; i < self.sampleRateList.count; i ++) {
        if ([self.sampleRateButton.titleLabel.text isEqualToString:self.sampleRateList[i]]) {
            index = i;
            break;
        }
    }
    MKPickerView *pickView = [[MKPickerView alloc] init];
    [pickView showPickViewWithDataList:self.sampleRateList selectedRow:index block:^(NSInteger currentRow) {
        [self.sampleRateButton setTitle:self.sampleRateList[currentRow] forState:UIControlStateNormal];
        if ([self.delegate respondsToSelector:@selector(bxt_accelerationParamsSamplingRateChanged:)]) {
            [self.delegate bxt_accelerationParamsSamplingRateChanged:currentRow];
        }
    }];
}

#pragma mark - setter
- (void)setDataModel:(MKBXTAccelerationParamsCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel) {
        return;
    }
    [self.scaleButton setTitle:self.scaleList[_dataModel.scale] forState:UIControlStateNormal];
    [self.sampleRateButton setTitle:self.sampleRateList[_dataModel.samplingRate] forState:UIControlStateNormal];
    self.sampleRate = _dataModel.samplingRate;
    self.textField.text = SafeStr(_dataModel.threshold);
    [self updateThresholdUnit];
}

#pragma mark - private method
- (void)updateThresholdUnit {
    if (self.sampleRate == 0) {
        //2g
        self.thresholdUnitLabel.text = @"x3.91mg";
        return;
    }
    if (self.sampleRate == 1) {
        //4g
        self.thresholdUnitLabel.text = @"x7.81mg";
        return;
    }
    if (self.sampleRate == 2) {
        //8g
        self.thresholdUnitLabel.text = @"x15.63mg";
        return;
    }
    if (self.sampleRate == 3) {
        //16g
        self.thresholdUnitLabel.text = @"x31.25mg";
        return;
    }
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

- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.font= MKFont(15.f);
        _msgLabel.text = @"Sensor parameters";
    }
    return _msgLabel;
}

- (UILabel *)scaleLabel {
    if (!_scaleLabel) {
        _scaleLabel = [[UILabel alloc] init];
        _scaleLabel.textColor = DEFAULT_TEXT_COLOR;
        _scaleLabel.textAlignment = NSTextAlignmentLeft;
        _scaleLabel.font = MKFont(13.f);
        _scaleLabel.text = @"Full-scale";
    }
    return _scaleLabel;
}

- (UIButton *)scaleButton {
    if (!_scaleButton) {
        _scaleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_scaleButton.titleLabel setFont:MKFont(12.f)];
        [_scaleButton setTitleColor:DEFAULT_TEXT_COLOR forState:UIControlStateNormal];
        [_scaleButton addTarget:self
                         action:@selector(scaleButtonPressed)
               forControlEvents:UIControlEventTouchUpInside];
        
        _scaleButton.layer.masksToBounds = YES;
        _scaleButton.layer.borderColor = NAVBAR_COLOR_MACROS.CGColor;
        _scaleButton.layer.borderWidth = 0.5f;
        _scaleButton.layer.cornerRadius = 6.f;
    }
    return _scaleButton;
}

- (NSMutableArray *)scaleList {
    if (!_scaleList) {
        _scaleList = [NSMutableArray arrayWithObjects:@"±2g",@"±4g",@"±8g",@"±16g", nil];
    }
    return _scaleList;
}

- (UILabel *)sampleRateLabel {
    if (!_sampleRateLabel) {
        _sampleRateLabel = [[UILabel alloc] init];
        _sampleRateLabel.textAlignment = NSTextAlignmentLeft;
        _sampleRateLabel.textColor = DEFAULT_TEXT_COLOR;
        _sampleRateLabel.font = MKFont(13.f);
        _sampleRateLabel.text = @"Sampling rate";
    }
    return _sampleRateLabel;
}

- (UIButton *)sampleRateButton {
    if (!_sampleRateButton) {
        _sampleRateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sampleRateButton.titleLabel setFont:MKFont(12.f)];
        [_sampleRateButton setTitleColor:DEFAULT_TEXT_COLOR forState:UIControlStateNormal];
        [_sampleRateButton addTarget:self
                              action:@selector(sampleRateButtonPressed)
                    forControlEvents:UIControlEventTouchUpInside];
        
        _sampleRateButton.layer.masksToBounds = YES;
        _sampleRateButton.layer.borderColor = NAVBAR_COLOR_MACROS.CGColor;
        _sampleRateButton.layer.borderWidth = 0.5f;
        _sampleRateButton.layer.cornerRadius = 6.f;
    }
    return _sampleRateButton;
}

- (NSMutableArray *)sampleRateList {
    if (!_sampleRateList) {
        _sampleRateList = [NSMutableArray arrayWithObjects:@"1hz",@"10hz",@"25hz",@"50hz",@"100hz", nil];
    }
    return _sampleRateList;
}

- (UILabel *)thresholdLabel {
    if (!_thresholdLabel) {
        _thresholdLabel = [[UILabel alloc] init];
        _thresholdLabel.textAlignment = NSTextAlignmentLeft;
        _thresholdLabel.textColor = DEFAULT_TEXT_COLOR;
        _thresholdLabel.font = MKFont(13.f);
        _thresholdLabel.text = @"Motion threshold";
    }
    return _thresholdLabel;
}

- (MKTextField *)textField {
    if (!_textField) {
        _textField = [MKCustomUIAdopter customNormalTextFieldWithText:@""
                                                          placeHolder:@"1~255"
                                                             textType:mk_realNumberOnly];
        _textField.maxLength = 3;
        @weakify(self);
        _textField.textChangedBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(bxt_accelerationMotionThresholdChanged:)]) {
                [self.delegate bxt_accelerationMotionThresholdChanged:text];
            }
        };
    }
    return _textField;
}

- (UILabel *)thresholdUnitLabel {
    if (!_thresholdUnitLabel) {
        _thresholdUnitLabel = [[UILabel alloc] init];
        _thresholdUnitLabel.textColor = DEFAULT_TEXT_COLOR;
        _thresholdUnitLabel.font = MKFont(12.f);
        _thresholdUnitLabel.textAlignment = NSTextAlignmentLeft;
        _thresholdUnitLabel.text = @"x3.91mg";
    }
    return _thresholdUnitLabel;
}

@end
