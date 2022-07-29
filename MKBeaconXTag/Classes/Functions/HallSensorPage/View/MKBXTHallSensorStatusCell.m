//
//  MKBXTHallSensorStatusCell.m
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/7/22.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXTHallSensorStatusCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

@implementation MKBXTHallSensorStatusCellModel
@end

@interface MKBXTHallSensorStatusCell ()

@property (nonatomic, strong)UIView *backView;

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UIButton *switchButton;

@end

@implementation MKBXTHallSensorStatusCell

+ (MKBXTHallSensorStatusCell *)initCellWithTableView:(UITableView *)tableView {
    MKBXTHallSensorStatusCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKBXTHallSensorStatusCellIdenty"];
    if (!cell) {
        cell = [[MKBXTHallSensorStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKBXTHallSensorStatusCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView setBackgroundColor:RGBCOLOR(242, 242, 242)];
        [self.contentView addSubview:self.backView];
        [self.backView addSubview:self.msgLabel];
        [self.backView addSubview:self.switchButton];
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
    [self.switchButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(40.f);
        make.centerY.mas_equalTo(self.backView.mas_centerY);
        make.height.mas_equalTo(30.f);
    }];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(self.switchButton.mas_left).mas_offset(-15.f);
        make.centerY.mas_equalTo(self.backView.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
}

#pragma mark - event method
- (void)switchButtonPressed {
    self.switchButton.selected = !self.switchButton.selected;
    UIImage *icon = (self.switchButton.selected ? LOADICON(@"MKBeaconXTag", @"MKBXTHallSensorStatusCell", @"bxt_switchSelectedIcon.png") : LOADICON(@"MKBeaconXTag", @"MKBXTHallSensorStatusCell", @"bxt_switchUnselectedIcon.png"));
    [self.switchButton setImage:icon forState:UIControlStateNormal];
    if ([self.delegate respondsToSelector:@selector(bxt_hallSensorStatusChanged:)]) {
        [self.delegate bxt_hallSensorStatusChanged:self.switchButton.selected];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKBXTHallSensorStatusCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKBXTHallSensorStatusCellModel.class]) {
        return;
    }
    self.switchButton.selected = _dataModel.isOn;
    UIImage *icon = (self.switchButton.selected ? LOADICON(@"MKBeaconXTag", @"MKBXTHallSensorStatusCell", @"bxt_switchSelectedIcon.png") : LOADICON(@"MKBeaconXTag", @"MKBXTHallSensorStatusCell", @"bxt_switchUnselectedIcon.png"));
    [self.switchButton setImage:icon forState:UIControlStateNormal];
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
        _msgLabel.font = MKFont(15.f);
        _msgLabel.text = @"Power off by hall sensor";
    }
    return _msgLabel;
}

- (UIButton *)switchButton {
    if (!_switchButton) {
        _switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_switchButton addTarget:self
                          action:@selector(switchButtonPressed)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchButton;
}

@end
