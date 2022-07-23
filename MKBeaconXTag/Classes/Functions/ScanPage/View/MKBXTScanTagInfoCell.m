//
//  MKBXTScanTagInfoCell.m
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/7/18.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXTScanTagInfoCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

@implementation MKBXTScanTagInfoCellModel
@end

@interface MKBXTScanTagInfoCell ()

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UILabel *msLabel;

@property (nonatomic, strong)UILabel *msValueLabel;

@property (nonatomic, strong)UILabel *mtcLabel;

@property (nonatomic, strong)UILabel *mtcValueLabel;

@property (nonatomic, strong)UILabel *mosLabel;

@property (nonatomic, strong)UILabel *mosValueLabel;

@property (nonatomic, strong)UILabel *motcLabel;

@property (nonatomic, strong)UILabel *motcValueLabel;

@property (nonatomic, strong)UILabel *accLabel;

@property (nonatomic, strong)UILabel *accValueLabel;

@end

@implementation MKBXTScanTagInfoCell

+ (MKBXTScanTagInfoCell *)initCellWithTableView:(UITableView *)tableView {
    MKBXTScanTagInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKBXTScanTagInfoCellIdenty"];
    if (!cell) {
        cell = [[MKBXTScanTagInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKBXTScanTagInfoCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.msgLabel];
        [self.contentView addSubview:self.msLabel];
        [self.contentView addSubview:self.msValueLabel];
        [self.contentView addSubview:self.mtcLabel];
        [self.contentView addSubview:self.mtcValueLabel];
        [self.contentView addSubview:self.mosLabel];
        [self.contentView addSubview:self.mosValueLabel];
        [self.contentView addSubview:self.motcLabel];
        [self.contentView addSubview:self.motcValueLabel];
        [self.contentView addSubview:self.accLabel];
        [self.contentView addSubview:self.accValueLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(22.f);
        make.right.mas_equalTo(-10.f);
        make.top.mas_equalTo(10.f);
        make.height.mas_equalTo(MKFont(15).lineHeight);
    }];
    [self.msLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.msgLabel.mas_left);
        make.right.mas_equalTo(self.contentView.mas_centerX).mas_offset(-2.f);
        make.top.mas_equalTo(self.msgLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.msValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_centerX).mas_offset(5.f);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.msLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.mtcLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.msgLabel.mas_left);
        make.right.mas_equalTo(self.contentView.mas_centerX).mas_offset(-2.f);
        make.top.mas_equalTo(self.msLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.mtcValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_centerX).mas_offset(5.f);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.mtcLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.mosLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.msgLabel.mas_left);
        make.right.mas_equalTo(self.contentView.mas_centerX).mas_offset(-2.f);
        make.top.mas_equalTo(self.mtcLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.mosValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_centerX).mas_offset(5.f);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.mosLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.motcLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.msgLabel.mas_left);
        make.right.mas_equalTo(self.contentView.mas_centerX).mas_offset(-2.f);
        make.top.mas_equalTo(self.mosLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.motcValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_centerX).mas_offset(5.f);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.motcLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.accLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.msgLabel.mas_left);
        make.right.mas_equalTo(self.contentView.mas_centerX).mas_offset(-2.f);
        make.top.mas_equalTo(self.motcLabel.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.accValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.mas_centerX).mas_offset(5.f);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.accLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
}

#pragma mark - setter
- (void)setDataModel:(MKBXTScanTagInfoCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKBXTScanTagInfoCellModel.class]) {
        return;
    }
    self.msValueLabel.text = (_dataModel.magneticStatus ? @"Absent" : @"Present");
    self.mtcValueLabel.text = SafeStr(_dataModel.magneticCount);
    self.mosValueLabel.text = (_dataModel.motionStatus ? @"In progress" : @"No Movement");
    self.motcValueLabel.text = SafeStr(_dataModel.motionCount);
    self.accValueLabel.text = [NSString stringWithFormat:@"X: %@mg;Y: %@mg;Z: %@mg",SafeStr(_dataModel.xData),SafeStr(_dataModel.yData),SafeStr(_dataModel.zData)];
}

#pragma mark - getter
- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.font = MKFont(15.f);
        _msgLabel.text = @"Tag info";
    }
    return _msgLabel;
}

- (UILabel *)msLabel {
    if (!_msLabel) {
        _msLabel = [self createLabel];
        _msLabel.text = @"Magnetic status";
    }
    return _msLabel;
}

- (UILabel *)msValueLabel {
    if (!_msValueLabel) {
        _msValueLabel = [self createLabel];
    }
    return _msValueLabel;
}

- (UILabel *)mtcLabel {
    if (!_mtcLabel) {
        _mtcLabel = [self createLabel];
        _mtcLabel.text = @"Magnetic trigger count";
    }
    return _mtcLabel;
}

- (UILabel *)mtcValueLabel {
    if (!_mtcValueLabel) {
        _mtcValueLabel = [self createLabel];
    }
    return _mtcValueLabel;
}

- (UILabel *)mosLabel {
    if (!_mosLabel) {
        _mosLabel = [self createLabel];
        _mosLabel.text = @"Motion status";
    }
    return _mosLabel;
}

- (UILabel *)mosValueLabel {
    if (!_mosValueLabel) {
        _mosValueLabel = [self createLabel];
    }
    return _mosValueLabel;
}

- (UILabel *)motcLabel {
    if (!_motcLabel) {
        _motcLabel = [self createLabel];
        _motcLabel.text = @"Motion trigger count";
    }
    return _motcLabel;
}

- (UILabel *)motcValueLabel {
    if (!_motcValueLabel) {
        _motcValueLabel = [self createLabel];
    }
    return _motcValueLabel;
}

- (UILabel *)accLabel {
    if (!_accLabel) {
        _accLabel = [self createLabel];
        _accLabel.text = @"Acceleration";
    }
    return _accLabel;
}

- (UILabel *)accValueLabel {
    if (!_accValueLabel) {
        _accValueLabel = [self createLabel];
    }
    return _accValueLabel;
}

- (UILabel *)createLabel {
    UILabel *label = [[UILabel alloc] init];
    label.textColor = RGBCOLOR(184, 184, 184);
    label.textAlignment = NSTextAlignmentLeft;
    label.font = MKFont(12.f);
    return label;
}

@end
