//
//  MKBXTHallSensorHeaderView.m
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/7/21.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXTHallSensorHeaderView.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

#import "MKCustomUIAdopter.h"

@interface MKBXTHallSensorHeaderView ()

@property (nonatomic, strong)UIView *backView;

@property (nonatomic, strong)UILabel *statusLabel;

@property (nonatomic, strong)UILabel *statusValueLabel;

@property (nonatomic, strong)UILabel *mtCountLabel;

@property (nonatomic, strong)UILabel *mtCountValueLabel;

@property (nonatomic, strong)UIButton *clearButton;

@end

@implementation MKBXTHallSensorHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGBCOLOR(242, 242, 242);
        [self addSubview:self.backView];
        [self.backView addSubview:self.statusLabel];
        [self.backView addSubview:self.statusValueLabel];
        [self.backView addSubview:self.mtCountLabel];
        [self.backView addSubview:self.mtCountValueLabel];
        [self.backView addSubview:self.clearButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5.f);
        make.right.mas_equalTo(-5.f);
        make.top.mas_equalTo(15.f);
        make.bottom.mas_equalTo(-15.f);
    }];
    [self.statusLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(150.f);
        make.top.mas_equalTo(5.f);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.statusValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.statusLabel.mas_right).mas_offset(10.f);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.statusLabel.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    
    [self.clearButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(45.f);
        make.top.mas_equalTo(self.statusLabel.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.mtCountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(160.f);
        make.centerY.mas_equalTo(self.clearButton.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.mtCountValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mtCountLabel.mas_right).mas_offset(10.f);
        make.right.mas_equalTo(self.clearButton.mas_left).mas_offset(-5.f);
        make.centerY.mas_equalTo(self.clearButton.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
}

#pragma mark - event method

- (void)clearButtonPressed {
    if ([self.delegate respondsToSelector:@selector(bxt_clearMagneticTriggerCountButtonPressed)]) {
        [self.delegate bxt_clearMagneticTriggerCountButtonPressed];
    }
}

#pragma mark - public method
- (void)updateTriggerCount:(NSString *)count {
    self.mtCountValueLabel.text = count;
}

- (void)updateMagnetStatus:(NSString *)status {
    self.statusValueLabel.text = status;
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

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] init];
        _statusLabel.textColor = DEFAULT_TEXT_COLOR;
        _statusLabel.textAlignment = NSTextAlignmentLeft;
        _statusLabel.font = MKFont(15.f);
        _statusLabel.text = @"Magnet status";
    }
    return _statusLabel;
}

- (UILabel *)statusValueLabel {
    if (!_statusValueLabel) {
        _statusValueLabel = [[UILabel alloc] init];
        _statusValueLabel.textColor = DEFAULT_TEXT_COLOR;
        _statusValueLabel.textAlignment = NSTextAlignmentRight;
        _statusValueLabel.font = MKFont(12.f);
        _statusValueLabel.text = @"Present";
    }
    return _statusValueLabel;
}

- (UILabel *)mtCountLabel {
    if (!_mtCountLabel) {
        _mtCountLabel = [[UILabel alloc] init];
        _mtCountLabel.textColor = DEFAULT_TEXT_COLOR;
        _mtCountLabel.textAlignment = NSTextAlignmentLeft;
        _mtCountLabel.font = MKFont(15.f);
        _mtCountLabel.text = @"Magnetic trigger count";
    }
    return _mtCountLabel;
}

- (UILabel *)mtCountValueLabel {
    if (!_mtCountValueLabel) {
        _mtCountValueLabel = [[UILabel alloc] init];
        _mtCountValueLabel.textColor = DEFAULT_TEXT_COLOR;
        _mtCountValueLabel.textAlignment = NSTextAlignmentCenter;
        _mtCountValueLabel.font = MKFont(12.f);
        _mtCountValueLabel.text = @"0";
    }
    return _mtCountValueLabel;
}

- (UIButton *)clearButton {
    if (!_clearButton) {
        _clearButton = [MKCustomUIAdopter customButtonWithTitle:@"Clear"
                                                         target:self
                                                         action:@selector(clearButtonPressed)];
    }
    return _clearButton;
}

@end
