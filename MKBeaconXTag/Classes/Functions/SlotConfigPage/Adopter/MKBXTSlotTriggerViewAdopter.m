//
//  MKBXTSlotTriggerViewAdopter.m
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/7/26.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXTSlotTriggerViewAdopter.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "NSString+MKAdd.h"

#import "MKTextField.h"
#import "MKCustomUIAdopter.h"

static CGFloat textFieldWidth = 55.f;
static CGFloat textFieldHeight = 20.f;

#pragma mark - *********************Motion Detection Start**********************

@implementation MKBXTSlotMotionDetectionStartViewModel
@end

@interface MKBXTSlotMotionDetectionStartView ()

@property (nonatomic, strong)UIImageView *leftIcon;

@property (nonatomic, strong)UILabel *msgLabel1;

@property (nonatomic, strong)MKTextField *textField1;

@property (nonatomic, strong)UILabel *unitLabel1;

@property (nonatomic, strong)UILabel *msgLabel2;

@property (nonatomic, strong)MKTextField *textField2;

@property (nonatomic, strong)UILabel *unitLabel2;

@end

@implementation MKBXTSlotMotionDetectionStartView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.leftIcon];
        [self addSubview:self.msgLabel1];
        [self addSubview:self.textField1];
        [self addSubview:self.unitLabel1];
        [self addSubview:self.msgLabel2];
        [self addSubview:self.textField2];
        [self addSubview:self.unitLabel2];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.leftIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(10.f);
        make.centerY.mas_equalTo(self.textField1.mas_centerY);
        make.height.mas_equalTo(10.f);
    }];
    [self.msgLabel1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftIcon.mas_right).mas_offset(5.f);
        make.width.mas_equalTo(110.f);
        make.centerY.mas_equalTo(self.textField1.mas_centerY);
        make.height.mas_equalTo(10.f);
    }];
    [self.textField1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.msgLabel1.mas_right).mas_offset(2.f);
        make.width.mas_equalTo(textFieldWidth);
        make.top.mas_equalTo(5.f);
        make.height.mas_equalTo(textFieldHeight);
    }];
    [self.unitLabel1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.textField1.mas_right).mas_offset(2.f);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.textField1.mas_centerY);
        make.height.mas_equalTo(10.f);
    }];
    [self.msgLabel2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftIcon.mas_right).mas_offset(5.f);
        make.width.mas_equalTo(50.f);
        make.centerY.mas_equalTo(self.textField2.mas_centerY);
        make.height.mas_equalTo(10.f);
    }];
    [self.textField2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.msgLabel2.mas_right).mas_offset(2.f);
        make.width.mas_equalTo(textFieldWidth);
        make.top.mas_equalTo(self.textField1.mas_bottom).mas_offset(5.f);
        make.height.mas_equalTo(textFieldHeight);
    }];
    [self.unitLabel2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.textField2.mas_right).mas_offset(2.f);
        make.width.mas_equalTo(20.f);
        make.centerY.mas_equalTo(self.textField2.mas_centerY);
        make.height.mas_equalTo(10.f);
    }];
}

#pragma mark - event method
- (void)startFieldValueChanged:(NSString *)text {
    if (!ValidStr(text)) {
        if ([self.delegate respondsToSelector:@selector(bxt_motionDetectionStartView_startIntervalChanged:)]) {
            [self.delegate bxt_motionDetectionStartView_startIntervalChanged:@""];
        }
        return;
    }
    NSInteger number = [text integerValue];
    NSString *value = [NSString stringWithFormat:@"%ld",(long)number];
    self.textField1.text = value;
    if ([self.delegate respondsToSelector:@selector(bxt_motionDetectionStartView_startIntervalChanged:)]) {
        [self.delegate bxt_motionDetectionStartView_startIntervalChanged:value];
    }
}

- (void)staticFieldValueChanged:(NSString *)text {
    if (!ValidStr(text)) {
        if ([self.delegate respondsToSelector:@selector(bxt_motionDetectionStartView_staticIntervalChanged:)]) {
            [self.delegate bxt_motionDetectionStartView_staticIntervalChanged:@""];
        }
        return;
    }
    NSInteger number = [text integerValue];
    NSString *value = [NSString stringWithFormat:@"%ld",(long)number];
    self.textField2.text = value;
    if ([self.delegate respondsToSelector:@selector(bxt_motionDetectionStartView_staticIntervalChanged:)]) {
        [self.delegate bxt_motionDetectionStartView_staticIntervalChanged:value];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKBXTSlotMotionDetectionStartViewModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKBXTSlotMotionDetectionStartViewModel.class]) {
        return;
    }
    UIImage *icon = (_dataModel.selected ? LOADICON(@"MKBeaconXTag", @"MKBXTSlotMotionDetectionStartView", @"bxt_slotConfigSelectedIcon.png") : LOADICON(@"MKBeaconXTag", @"MKBXTSlotMotionDetectionStartView", @"bxt_slotConfigUnselectedIcon.png"));
    self.leftIcon.image = icon;
    self.selected = _dataModel.selected;
    self.textField1.text = SafeStr(_dataModel.startInterval);
    self.textField2.text = SafeStr(_dataModel.staticInterval);
}

#pragma mark - getter
- (UIImageView *)leftIcon {
    if (!_leftIcon) {
        _leftIcon = [[UIImageView alloc] init];
        _leftIcon.image = LOADICON(@"MKBeaconXTag", @"MKBXTSlotMotionDetectionStartView", @"bxt_slotConfigUnselectedIcon.png");
    }
    return _leftIcon;
}

- (UILabel *)msgLabel1 {
    if (!_msgLabel1) {
        _msgLabel1 = [MKBXTSlotTriggerViewAdopter loadMsgLabelWithMsg:@"Start advertising for"];
    }
    return _msgLabel1;
}

- (MKTextField *)textField1 {
    if (!_textField1) {
        _textField1 = [MKCustomUIAdopter customNormalTextFieldWithText:@""
                                                           placeHolder:@""
                                                              textType:mk_realNumberOnly];
        _textField1.attributedPlaceholder = [MKCustomUIAdopter attributedString:@[@"0~65535"]
                                                                          fonts:@[MKFont(12.f)]
                                                                         colors:@[CUTTING_LINE_COLOR]];
        _textField1.maxLength = 5;
        _textField1.font = MKFont(12.f);
        @weakify(self);
        _textField1.textChangedBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
            [self startFieldValueChanged:text];
        };
    }
    return _textField1;
}

- (UILabel *)unitLabel1 {
    if (!_unitLabel1) {
        _unitLabel1 = [MKBXTSlotTriggerViewAdopter loadMsgLabelWithMsg:@"s after device keep"];
    }
    return _unitLabel1;
}

- (UILabel *)msgLabel2 {
    if (!_msgLabel2) {
        _msgLabel2 = [MKBXTSlotTriggerViewAdopter loadMsgLabelWithMsg:@"static for"];
    }
    return _msgLabel2;
}

- (MKTextField *)textField2 {
    if (!_textField2) {
        _textField2 = [MKCustomUIAdopter customNormalTextFieldWithText:@""
                                                           placeHolder:@""
                                                              textType:mk_realNumberOnly];
        _textField2.attributedPlaceholder = [MKCustomUIAdopter attributedString:@[@"1~65535"]
                                                                          fonts:@[MKFont(12.f)]
                                                                         colors:@[CUTTING_LINE_COLOR]];
        _textField2.maxLength = 5;
        _textField2.font = MKFont(12.f);
        @weakify(self);
        _textField2.textChangedBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
            [self staticFieldValueChanged:text];
        };
    }
    return _textField2;
}

- (UILabel *)unitLabel2 {
    if (!_unitLabel2) {
        _unitLabel2 = [MKBXTSlotTriggerViewAdopter loadMsgLabelWithMsg:@"s"];
    }
    return _unitLabel2;
}

@end


#pragma mark - *********************Motion Detection Stop**********************

@implementation MKBXTSlotMotionDetectionStopViewModel
@end

@interface MKBXTSlotMotionDetectionStopView ()

@property (nonatomic, strong)UIImageView *leftIcon;

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)MKTextField *textField;

@property (nonatomic, strong)UILabel *unitLabel;

@end

@implementation MKBXTSlotMotionDetectionStopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.leftIcon];
        [self addSubview:self.msgLabel];
        [self addSubview:self.textField];
        [self addSubview:self.unitLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.leftIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(10.f);
        make.centerY.mas_equalTo(self.textField.mas_centerY);
        make.height.mas_equalTo(10.f);
    }];
    CGFloat unitLabelWidth = 20.f;
    CGFloat textFieldHeight = 20.f;
    CGFloat msgLabelWidth = self.frame.size.width - 10.f - 15.f - 5.f - unitLabelWidth - textFieldWidth - 20.f;
    CGSize msgLabelSize = [NSString sizeWithText:self.msgLabel.text
                                         andFont:self.msgLabel.font
                                      andMaxSize:CGSizeMake(msgLabelWidth, MAXFLOAT)];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftIcon.mas_right).mas_offset(5.f);
        make.right.mas_equalTo(self.textField.mas_left).mas_offset(-5.f);
        make.centerY.mas_equalTo(self.textField.mas_centerY);
        make.height.mas_equalTo(msgLabelSize.height);
    }];
    [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.msgLabel.mas_right).mas_offset(5.f);
        make.width.mas_equalTo(textFieldWidth);
        make.centerY.mas_equalTo(self.textField.mas_centerY);
        make.height.mas_equalTo(textFieldHeight);
    }];
    [self.unitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.textField.mas_right).mas_offset(3.f);
        make.width.mas_equalTo(unitLabelWidth);
        make.centerY.mas_equalTo(self.textField.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
}

#pragma mark - event method
- (void)textFieldValueChanged:(NSString *)text {
    if (!ValidStr(text)) {
        if ([self.delegate respondsToSelector:@selector(bxt_motionDetectionStopView_staticIntervalChanged:)]) {
            [self.delegate bxt_motionDetectionStopView_staticIntervalChanged:@""];
        }
        return;
    }
    NSInteger number = [text integerValue];
    NSString *value = [NSString stringWithFormat:@"%ld",(long)number];
    self.textField.text = value;
    if ([self.delegate respondsToSelector:@selector(bxt_motionDetectionStopView_staticIntervalChanged:)]) {
        [self.delegate bxt_motionDetectionStopView_staticIntervalChanged:value];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKBXTSlotMotionDetectionStopViewModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKBXTSlotMotionDetectionStopViewModel.class]) {
        return;
    }
    UIImage *icon = (_dataModel.selected ? LOADICON(@"MKBeaconXTag", @"MKBXTSlotMotionDetectionStopView", @"bxt_slotConfigSelectedIcon.png") : LOADICON(@"MKBeaconXTag", @"MKBXTSlotMotionDetectionStopView", @"bxt_slotConfigUnselectedIcon.png"));
    self.leftIcon.image = icon;
    self.selected = _dataModel.selected;
    self.textField.text = SafeStr(_dataModel.staticInterval);
}

#pragma mark - getter
- (UIImageView *)leftIcon {
    if (!_leftIcon) {
        _leftIcon = [[UIImageView alloc] init];
        _leftIcon.image = LOADICON(@"MKBeaconXTag", @"MKBXTSlotMotionDetectionStopView", @"bxt_slotConfigUnselectedIcon.png");
    }
    return _leftIcon;
}

- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [MKBXTSlotTriggerViewAdopter loadMsgLabelWithMsg:@"Stop advertising after device keep static for"];
        _msgLabel.numberOfLines = 0;
    }
    return _msgLabel;
}

- (MKTextField *)textField {
    if (!_textField) {
        _textField = [MKCustomUIAdopter customNormalTextFieldWithText:@""
                                                          placeHolder:@""
                                                             textType:mk_realNumberOnly];
        _textField.attributedPlaceholder = [MKCustomUIAdopter attributedString:@[@"1~65535"]
                                                                         fonts:@[MKFont(12.f)]
                                                                        colors:@[CUTTING_LINE_COLOR]];
        _textField.maxLength = 5;
        _textField.font = MKFont(12.f);
        @weakify(self);
        _textField.textChangedBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
            [self textFieldValueChanged:text];
        };
    }
    return _textField;
}

- (UILabel *)unitLabel {
    if (!_unitLabel) {
        _unitLabel = [MKBXTSlotTriggerViewAdopter loadMsgLabelWithMsg:@"s"];
    }
    return _unitLabel;
}

@end

#pragma mark - *********************Magnetic Detection Start**********************

@implementation MKBXTSlotMagneticDetectionStartViewModel
@end

@interface MKBXTSlotMagneticDetectionStartView ()

@property (nonatomic, strong)UIImageView *leftIcon;

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)MKTextField *textField;

@property (nonatomic, strong)UILabel *unitLabel;

@end

@implementation MKBXTSlotMagneticDetectionStartView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.leftIcon];
        [self addSubview:self.msgLabel];
        [self addSubview:self.textField];
        [self addSubview:self.unitLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.leftIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(10.f);
        make.centerY.mas_equalTo(self.textField.mas_centerY);
        make.height.mas_equalTo(10.f);
    }];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftIcon.mas_right).mas_offset(5.f);
        make.width.mas_equalTo(110.f);
        make.centerY.mas_equalTo(self.textField.mas_centerY);
        make.height.mas_equalTo(MKFont(11.f).lineHeight);
    }];
    [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.msgLabel.mas_right).mas_offset(2.f);
        make.width.mas_equalTo(textFieldWidth);
        make.centerY.mas_equalTo(self.textField.mas_centerY);
        make.height.mas_equalTo(textFieldHeight);
    }];
    [self.unitLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.textField.mas_right).mas_offset(3.f);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.textField.mas_centerY);
        make.height.mas_equalTo(MKFont(11.f).lineHeight);
    }];
}

#pragma mark - event method
- (void)textFieldValueChanged:(NSString *)text {
    if (!ValidStr(text)) {
        if ([self.delegate respondsToSelector:@selector(bxt_magneticDetectionStartView_startIntervalChanged:)]) {
            [self.delegate bxt_magneticDetectionStartView_startIntervalChanged:@""];
        }
        return;
    }
    NSInteger number = [text integerValue];
    NSString *value = [NSString stringWithFormat:@"%ld",(long)number];
    self.textField.text = value;
    if ([self.delegate respondsToSelector:@selector(bxt_magneticDetectionStartView_startIntervalChanged:)]) {
        [self.delegate bxt_magneticDetectionStartView_startIntervalChanged:value];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKBXTSlotMagneticDetectionStartViewModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKBXTSlotMagneticDetectionStartViewModel.class]) {
        return;
    }
    UIImage *icon = (_dataModel.selected ? LOADICON(@"MKBeaconXTag", @"MKBXTSlotMagneticDetectionStartView", @"bxt_slotConfigSelectedIcon.png") : LOADICON(@"MKBeaconXTag", @"MKBXTSlotMagneticDetectionStartView", @"bxt_slotConfigUnselectedIcon.png"));
    self.leftIcon.image = icon;
    self.selected = _dataModel.selected;
    self.textField.text = SafeStr(_dataModel.startInterval);
}

#pragma mark - getter
- (UIImageView *)leftIcon {
    if (!_leftIcon) {
        _leftIcon = [[UIImageView alloc] init];
        _leftIcon.image = LOADICON(@"MKBeaconXTag", @"MKBXTSlotMagneticDetectionStartView", @"bxt_slotConfigUnselectedIcon.png");
    }
    return _leftIcon;
}

- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [MKBXTSlotTriggerViewAdopter loadMsgLabelWithMsg:@"Start advertising for"];
        _msgLabel.numberOfLines = 0;
    }
    return _msgLabel;
}

- (MKTextField *)textField {
    if (!_textField) {
        _textField = [MKCustomUIAdopter customNormalTextFieldWithText:@""
                                                          placeHolder:@""
                                                             textType:mk_realNumberOnly];
        _textField.attributedPlaceholder = [MKCustomUIAdopter attributedString:@[@"0~65535"]
                                                                         fonts:@[MKFont(12.f)]
                                                                        colors:@[CUTTING_LINE_COLOR]];
        _textField.maxLength = 5;
        _textField.font = MKFont(12.f);
        @weakify(self);
        _textField.textChangedBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
            [self textFieldValueChanged:text];
        };
    }
    return _textField;
}

- (UILabel *)unitLabel {
    if (!_unitLabel) {
        _unitLabel = [MKBXTSlotTriggerViewAdopter loadMsgLabelWithMsg:@"s when magnet is absent."];
    }
    return _unitLabel;
}

@end

#pragma mark - *********************Magnetic Detection Stop**********************

@implementation MKBXTSlotMagneticDetectionStopViewModel
@end

@interface MKBXTSlotMagneticDetectionStopView ()

@property (nonatomic, strong)UIImageView *leftIcon;

@property (nonatomic, strong)UILabel *msgLabel;

@end

@implementation MKBXTSlotMagneticDetectionStopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.leftIcon];
        [self addSubview:self.msgLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.leftIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(10.f);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(10.f);
    }];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftIcon.mas_right).mas_offset(5.f);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.mas_centerY);
        make.height.mas_equalTo(MKFont(11.f).lineHeight);
    }];
}

#pragma mark - setter
- (void)setDataModel:(MKBXTSlotMagneticDetectionStopViewModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKBXTSlotMagneticDetectionStopViewModel.class]) {
        return;
    }
    UIImage *icon = (_dataModel.selected ? LOADICON(@"MKBeaconXTag", @"MKBXTSlotMagneticDetectionStopView", @"bxt_slotConfigSelectedIcon.png") : LOADICON(@"MKBeaconXTag", @"MKBXTSlotMagneticDetectionStopView", @"bxt_slotConfigUnselectedIcon.png"));
    self.leftIcon.image = icon;
    self.selected = _dataModel.selected;
}

#pragma mark - getter
- (UIImageView *)leftIcon {
    if (!_leftIcon) {
        _leftIcon = [[UIImageView alloc] init];
        _leftIcon.image = LOADICON(@"MKBeaconXTag", @"MKBXTSlotMagneticDetectionStopView", @"bxt_slotConfigUnselectedIcon.png");
    }
    return _leftIcon;
}

- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [MKBXTSlotTriggerViewAdopter loadMsgLabelWithMsg:@"Stop advertising when magnet is absent."];
    }
    return _msgLabel;
}

@end

#pragma mark - *********************Motion Detection View**********************

@implementation MKBXTSlotMotionDetectionViewModel
@end

static NSString *const slotMotionDetectionViewMsg = @"*The Beacon will start advertising for 65535s after device keep static for 65535s, and stop advertising immediately after device moves.";

@interface MKBXTSlotMotionDetectionView ()<MKBXTSlotMotionDetectionStartViewDelegate,
MKBXTSlotMotionDetectionStopViewDelegate>

@property (nonatomic, strong)MKBXTSlotMotionDetectionStartView *startView;

@property (nonatomic, strong)MKBXTSlotMotionDetectionStartViewModel *startModel;

@property (nonatomic, strong)MKBXTSlotMotionDetectionStopView *stopView;

@property (nonatomic, strong)MKBXTSlotMotionDetectionStopViewModel *stopModel;

@property (nonatomic, strong)UILabel *noteLabel;

@end

@implementation MKBXTSlotMotionDetectionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.startView];
        [self addSubview:self.stopView];
        [self addSubview:self.noteLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.startView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(50.f);
    }];
    [self.stopView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.startView.mas_bottom).mas_offset(20.f);
        make.height.mas_equalTo(50.f);
    }];
    CGSize size = [NSString sizeWithText:slotMotionDetectionViewMsg
                                 andFont:MKFont(11.f)
                              andMaxSize:CGSizeMake(self.frame.size.width - 2 * 15.f, MAXFLOAT)];
    [self.noteLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.stopView.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(size.height);
    }];
}

#pragma mark - MKBXTSlotMotionDetectionStartViewDelegate
- (void)bxt_motionDetectionStartView_startIntervalChanged:(NSString *)startInterval {
    if ([self.delegate respondsToSelector:@selector(bxt_motionDetectionView_startAdvIntervalChanged:)]) {
        [self.delegate bxt_motionDetectionView_startAdvIntervalChanged:startInterval];
    }
}

- (void)bxt_motionDetectionStartView_staticIntervalChanged:(NSString *)staticInterval {
    if ([self.delegate respondsToSelector:@selector(bxt_motionDetectionView_startStaticIntervalChanged:)]) {
        [self.delegate bxt_motionDetectionView_startStaticIntervalChanged:staticInterval];
    }
}

#pragma mark - MKBXTSlotMotionDetectionStopViewDelegate
- (void)bxt_motionDetectionStopView_staticIntervalChanged:(NSString *)staticInterval {
    if ([self.delegate respondsToSelector:@selector(bxt_motionDetectionView_stopStaticIntervalChanged:)]) {
        [self.delegate bxt_motionDetectionView_stopStaticIntervalChanged:staticInterval];
    }
}

#pragma mark - event method
- (void)startViewPressed {
    if ([self.delegate respondsToSelector:@selector(bxt_motionDetectionView_startChanged:)]) {
        [self.delegate bxt_motionDetectionView_startChanged:YES];
    }
}

- (void)stopViewPressed {
    if ([self.delegate respondsToSelector:@selector(bxt_motionDetectionView_startChanged:)]) {
        [self.delegate bxt_motionDetectionView_startChanged:NO];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKBXTSlotMotionDetectionViewModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKBXTSlotMotionDetectionViewModel.class]) {
        return;
    }
    self.startModel.selected = _dataModel.start;
    self.startModel.startInterval = SafeStr(_dataModel.startAdvInterval);
    self.startModel.staticInterval = SafeStr(_dataModel.startStaticInterval);
    self.startView.dataModel = self.startModel;
    
    self.stopModel.selected = !_dataModel.start;
    self.stopModel.staticInterval = SafeStr(_dataModel.stopStaticInterval);
    self.stopView.dataModel = self.stopModel;
    
    if (!_dataModel.start) {
        //Stop
        self.noteLabel.text = [NSString stringWithFormat:@"*The Beacon will stop advertising after device keep static for %@s, and start advertising immediately after device moves.",SafeStr(_dataModel.stopStaticInterval)];
        return;
    }
    //Start
    if ([self.dataModel.startAdvInterval integerValue] == 0) {
        //Start为0
        self.noteLabel.text = [NSString stringWithFormat:@"*The Beacon will start advertising after device keep static for %@s, and stop advertising immediately after device moves.",SafeStr(_dataModel.startStaticInterval)];
        return;
    }
    //Start大于0
    self.noteLabel.text = [NSString stringWithFormat:@"*The Beacon will start advertising for %@s after device keep static for %@s, and stop advertising immediately after device moves.",SafeStr(_dataModel.startAdvInterval),SafeStr(_dataModel.startStaticInterval)];
}

#pragma mark - getter
- (MKBXTSlotMotionDetectionStartView *)startView {
    if (!_startView) {
        _startView = [[MKBXTSlotMotionDetectionStartView alloc] init];
        _startView.delegate = self;
        [_startView addTarget:self
                       action:@selector(startViewPressed)
             forControlEvents:UIControlEventTouchUpInside];
    }
    return _startView;
}

- (MKBXTSlotMotionDetectionStartViewModel *)startModel {
    if (!_startModel) {
        _startModel = [[MKBXTSlotMotionDetectionStartViewModel alloc] init];
    }
    return _startModel;
}

- (MKBXTSlotMotionDetectionStopView *)stopView {
    if (!_stopView) {
        _stopView = [[MKBXTSlotMotionDetectionStopView alloc] init];
        _stopView.delegate = self;
        [_stopView addTarget:self
                      action:@selector(stopViewPressed)
            forControlEvents:UIControlEventTouchUpInside];
    }
    return _stopView;
}

- (MKBXTSlotMotionDetectionStopViewModel *)stopModel {
    if (!_stopModel) {
        _stopModel = [[MKBXTSlotMotionDetectionStopViewModel alloc] init];
    }
    return _stopModel;
}

- (UILabel *)noteLabel {
    if (!_noteLabel) {
        _noteLabel = [[UILabel alloc] init];
        _noteLabel.textColor = RGBCOLOR(229, 173, 140);
        _noteLabel.textAlignment = NSTextAlignmentLeft;
        _noteLabel.font = MKFont(11.f);
        _noteLabel.numberOfLines = 0;
    }
    return _noteLabel;
}

@end

#pragma mark - *********************Magnetic Detection View**********************

@implementation MKBXTSlotMagneticDetectionViewModel
@end

static NSString *const slotMagneticDetectionViewMsg = @"*The Beacon will start advertising for 65535s when magnet is absent, and stop advertising immediately when magnet is present.";

@interface MKBXTSlotMagneticDetectionView ()<MKBXTSlotMagneticDetectionStartViewDelegate>

@property (nonatomic, strong)MKBXTSlotMagneticDetectionStartView *startView;

@property (nonatomic, strong)MKBXTSlotMagneticDetectionStartViewModel *startModel;

@property (nonatomic, strong)MKBXTSlotMagneticDetectionStopView *stopView;

@property (nonatomic, strong)MKBXTSlotMagneticDetectionStopViewModel *stopModel;

@property (nonatomic, strong)UILabel *noteLabel;

@end

@implementation MKBXTSlotMagneticDetectionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.startView];
        [self addSubview:self.stopView];
        [self addSubview:self.noteLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.startView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(30.f);
    }];
    [self.stopView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(self.startView.mas_bottom).mas_offset(15.f);
        make.height.mas_equalTo(30.f);
    }];
    CGSize size = [NSString sizeWithText:slotMagneticDetectionViewMsg
                                 andFont:MKFont(11.f)
                              andMaxSize:CGSizeMake(self.frame.size.width - 2 * 15.f, MAXFLOAT)];
    [self.noteLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.stopView.mas_bottom).mas_offset(20.f);
        make.height.mas_equalTo(size.height);
    }];
}

#pragma mark - MKBXTSlotMagneticDetectionStartViewDelegate
- (void)bxt_magneticDetectionStartView_startIntervalChanged:(NSString *)startInterval {
    if ([self.delegate respondsToSelector:@selector(bxt_magneticDetectionView_startAdvIntervalChanged:)]) {
        [self.delegate bxt_magneticDetectionView_startAdvIntervalChanged:startInterval];
    }
}

#pragma mark - event method
- (void)startViewPressed {
    if ([self.delegate respondsToSelector:@selector(bxt_magneticDetectionView_startChanged:)]) {
        [self.delegate bxt_magneticDetectionView_startChanged:YES];
    }
}

- (void)stopViewPressed {
    if ([self.delegate respondsToSelector:@selector(bxt_magneticDetectionView_startChanged:)]) {
        [self.delegate bxt_magneticDetectionView_startChanged:NO];
    }
}

#pragma mark - setter
- (void)setDataModel:(MKBXTSlotMagneticDetectionViewModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKBXTSlotMagneticDetectionViewModel.class]) {
        return;
    }
    self.startModel.selected = _dataModel.start;
    self.startModel.startInterval = SafeStr(_dataModel.startAdvInterval);
    self.startView.dataModel = self.startModel;
    
    self.stopModel.selected = !_dataModel.start;
    self.stopView.dataModel = self.stopModel;
    
    if (!_dataModel.start) {
        //Stop
        self.noteLabel.text = @"*The Beacon will stop advertising when magnet is absent, and start advertising immediately when magnet is present.";
        return;
    }
    //Start
    if ([self.dataModel.startAdvInterval integerValue] == 0) {
        //Start为0
        self.noteLabel.text = @"*The Beacon will start advertising when magnet is absent, and stop advertising immediately when magnet is present.";
        return;
    }
    //Start大于0
    self.noteLabel.text = [NSString stringWithFormat:@"*The Beacon will start advertising for %@s when magnet is absent, and stop advertising immediately when magnet is present.",SafeStr(_dataModel.startAdvInterval)];
}

#pragma mark - getter
- (MKBXTSlotMagneticDetectionStartView *)startView {
    if (!_startView) {
        _startView = [[MKBXTSlotMagneticDetectionStartView alloc] init];
        _startView.delegate = self;
        [_startView addTarget:self
                       action:@selector(startViewPressed)
             forControlEvents:UIControlEventTouchUpInside];
    }
    return _startView;
}

- (MKBXTSlotMagneticDetectionStartViewModel *)startModel {
    if (!_startModel) {
        _startModel = [[MKBXTSlotMagneticDetectionStartViewModel alloc] init];
    }
    return _startModel;
}

- (MKBXTSlotMagneticDetectionStopView *)stopView {
    if (!_stopView) {
        _stopView = [[MKBXTSlotMagneticDetectionStopView alloc] init];
        [_stopView addTarget:self
                      action:@selector(stopViewPressed)
            forControlEvents:UIControlEventTouchUpInside];
    }
    return _stopView;
}

- (MKBXTSlotMagneticDetectionStopViewModel *)stopModel {
    if (!_stopModel) {
        _stopModel = [[MKBXTSlotMagneticDetectionStopViewModel alloc] init];
    }
    return _stopModel;
}

- (UILabel *)noteLabel {
    if (!_noteLabel) {
        _noteLabel = [[UILabel alloc] init];
        _noteLabel.textColor = RGBCOLOR(229, 173, 140);
        _noteLabel.textAlignment = NSTextAlignmentLeft;
        _noteLabel.font = MKFont(11.f);
        _noteLabel.numberOfLines = 0;
    }
    return _noteLabel;
}

@end

#pragma mark - *********************Slot Trigger View Adopter**********************

@implementation MKBXTSlotTriggerViewAdopter

+ (UILabel *)loadMsgLabelWithMsg:(NSString *)msg {
    UILabel *msgLabel = [[UILabel alloc] init];
    msgLabel.textColor = DEFAULT_TEXT_COLOR;
    msgLabel.textAlignment = NSTextAlignmentLeft;
    msgLabel.font = MKFont(11.f);
    msgLabel.text = msg;
    return msgLabel;
}

@end
