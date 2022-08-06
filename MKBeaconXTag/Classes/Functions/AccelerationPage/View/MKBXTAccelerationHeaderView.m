//
//  MKBXTAccelerationHeaderView.m
//  MKBeaconXTag_Example
//
//  Created by aa on 2021/3/3.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXTAccelerationHeaderView.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

#import "MKCustomUIAdopter.h"

@interface MKBXTAccelerationHeaderView ()

@property (nonatomic, strong)UIView *backView;

@property (nonatomic, strong)UIButton *syncButton;

@property (nonatomic, strong)UIImageView *synIcon;

@property (nonatomic, strong)UILabel *syncLabel;

@property (nonatomic, strong)UILabel *dataLabel;

@property (nonatomic, strong)UIView *bottomView;

@property (nonatomic, strong)UILabel *mtCountLabel;

@property (nonatomic, strong)UILabel *mtCountValueLabel;

@property (nonatomic, strong)UIButton *clearButton;

@end

@implementation MKBXTAccelerationHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGBCOLOR(242, 242, 242);
        [self addSubview:self.backView];
        [self.backView addSubview:self.syncButton];
        [self.syncButton addSubview:self.synIcon];
        [self.backView addSubview:self.syncLabel];
        [self.backView addSubview:self.dataLabel];
        [self addSubview:self.bottomView];
        [self.bottomView addSubview:self.mtCountLabel];
        [self.bottomView addSubview:self.mtCountValueLabel];
        [self.bottomView addSubview:self.clearButton];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5.f);
        make.right.mas_equalTo(-5.f);
        make.top.mas_equalTo(15.f);
        make.height.mas_equalTo(60.f);
    }];
    [self.syncButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(30.f);
        make.top.mas_equalTo(5.f);
        make.height.mas_equalTo(30.f);
    }];
    [self.synIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.syncButton.mas_centerX);
        make.centerY.mas_equalTo(self.syncButton.mas_centerY);
        make.width.mas_equalTo(25.f);
        make.height.mas_equalTo(25.f);
    }];
    [self.syncLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(25.f);
        make.top.mas_equalTo(self.syncButton.mas_bottom).mas_offset(2.f);
        make.height.mas_equalTo(MKFont(10.f).lineHeight);
    }];
    CGFloat width = (kViewWidth - 6 * 15.f) / 3;
    [self.dataLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.syncButton.mas_right).mas_offset(5.f);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.syncButton.mas_centerY).mas_offset(2.f);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5.f);
        make.right.mas_equalTo(-5.f);
        make.top.mas_equalTo(self.backView.mas_bottom).mas_offset(15.f);
        make.bottom.mas_equalTo(-20.f);
    }];
    [self.clearButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15.f);
        make.width.mas_equalTo(45.f);
        make.centerY.mas_equalTo(self.bottomView.mas_centerY);
        make.height.mas_equalTo(30.f);
    }];
    [self.mtCountLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(150.f);
        make.centerY.mas_equalTo(self.bottomView.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.mtCountValueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mtCountLabel.mas_right).mas_offset(10.f);
        make.right.mas_equalTo(self.clearButton.mas_left).mas_offset(-5.f);
        make.centerY.mas_equalTo(self.bottomView.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
}

#pragma mark - event method
- (void)syncButtonPressed {
    self.syncButton.selected = !self.syncButton.selected;
    [self.synIcon.layer removeAnimationForKey:@"bxt_synIconAnimationKey"];
    if ([self.delegate respondsToSelector:@selector(bxt_updateThreeAxisNotifyStatus:)]) {
        [self.delegate bxt_updateThreeAxisNotifyStatus:self.syncButton.selected];
    }
    if (self.syncButton.selected) {
        //开始旋转
        [self.synIcon.layer addAnimation:[MKCustomUIAdopter refreshAnimation:2.f] forKey:@"bxt_synIconAnimationKey"];
        self.syncLabel.text = @"Stop";
        return;
    }
    self.syncLabel.text = @"Sync";
}

- (void)clearButtonPressed {
    if ([self.delegate respondsToSelector:@selector(bxt_clearMotionTriggerCountButtonPressed)]) {
        [self.delegate bxt_clearMotionTriggerCountButtonPressed];
    }
}

#pragma mark - public method
- (void)updateTriggerCount:(NSString *)count {
    self.mtCountValueLabel.text = count;
}

- (void)updateDataWithXData:(NSString *)xData yData:(NSString *)yData zData:(NSString *)zData {
    NSString *xDataString = [NSString stringWithFormat:@"X-axis:%@%@",xData,@"mg"];
    NSString *yDataString = [NSString stringWithFormat:@"Y-axis:%@%@",yData,@"mg"];
    NSString *zDataString = [NSString stringWithFormat:@"Z-axis:%@%@",zData,@"mg"];
    self.dataLabel.text = [NSString stringWithFormat:@"%@;%@;%@",xDataString,yDataString,zDataString];
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

- (UIButton *)syncButton {
    if (!_syncButton) {
        _syncButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_syncButton addTarget:self
                        action:@selector(syncButtonPressed)
              forControlEvents:UIControlEventTouchUpInside];
    }
    return _syncButton;
}

- (UIImageView *)synIcon {
    if (!_synIcon) {
        _synIcon = [[UIImageView alloc] init];
        _synIcon.image = LOADICON(@"MKBeaconXTag", @"MKBXTAccelerationHeaderView", @"bxt_threeAxisAcceLoadingIcon.png");
    }
    return _synIcon;
}

- (UILabel *)syncLabel {
    if (!_syncLabel) {
        _syncLabel = [[UILabel alloc] init];
        _syncLabel.textColor = DEFAULT_TEXT_COLOR;
        _syncLabel.textAlignment = NSTextAlignmentCenter;
        _syncLabel.font = MKFont(10.f);
        _syncLabel.text = @"Sync";
    }
    return _syncLabel;
}

- (UILabel *)dataLabel {
    if (!_dataLabel) {
        _dataLabel = [[UILabel alloc] init];
        _dataLabel.textColor = DEFAULT_TEXT_COLOR;
        _dataLabel.textAlignment = NSTextAlignmentLeft;
        _dataLabel.font = MKFont(12.f);
        _dataLabel.text = @"X-axis:N/A;Y-axis:N/A;Z-axis:N/A";
    }
    return _dataLabel;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = COLOR_WHITE_MACROS;
        
        _bottomView.layer.masksToBounds = YES;
        _bottomView.layer.cornerRadius = 8.f;
    }
    return _bottomView;
}

- (UILabel *)mtCountLabel {
    if (!_mtCountLabel) {
        _mtCountLabel = [[UILabel alloc] init];
        _mtCountLabel.textColor = DEFAULT_TEXT_COLOR;
        _mtCountLabel.textAlignment = NSTextAlignmentLeft;
        _mtCountLabel.font = MKFont(15.f);
        _mtCountLabel.text = @"Motion trigger count";
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
