//
//  MKBXTSlotTagInfoCell.m
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/7/23.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXTSlotTagInfoCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

#import "MKTextField.h"
#import "MKCustomUIAdopter.h"

static CGFloat const offsetX = 10.f;
static CGFloat const iconWidth = 22.f;
static CGFloat const iconHeight = 22.f;

@implementation MKBXTSlotTagInfoCellModel
@end

@interface MKBXTSlotTagInfoCell ()

@property (nonatomic, strong)UIView *backView;

@property (nonatomic, strong)UIImageView *icon;

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UILabel *deviceNameLabel;

@property (nonatomic, strong)MKTextField *nameTextField;

@property (nonatomic, strong)UILabel *tagIDLabel;

@property (nonatomic, strong)UILabel *xLabel;

@property (nonatomic, strong)MKTextField *tagIDTextField;

@end

@implementation MKBXTSlotTagInfoCell

+ (MKBXTSlotTagInfoCell *)initCellWithTableView:(UITableView *)tableView {
    MKBXTSlotTagInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKBXTSlotTagInfoCellIdenth"];
    if (!cell) {
        cell = [[MKBXTSlotTagInfoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKBXTSlotTagInfoCellIdenth"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.backView];
        [self.backView addSubview:self.icon];
        [self.backView addSubview:self.msgLabel];
        [self.backView addSubview:self.deviceNameLabel];
        [self.backView addSubview:self.nameTextField];
        [self.backView addSubview:self.tagIDLabel];
        [self.backView addSubview:self.xLabel];
        [self.backView addSubview:self.tagIDTextField];
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
    [self.icon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offsetX);
        make.width.mas_equalTo(iconWidth);
        make.top.mas_equalTo(5.f);
        make.height.mas_equalTo(iconHeight);
    }];
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.icon.mas_right).mas_offset(10.f);
        make.right.mas_equalTo(-offsetX);
        make.centerY.mas_equalTo(self.icon.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.deviceNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offsetX);
        make.width.mas_equalTo(110.f);
        make.centerY.mas_equalTo(self.nameTextField.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.nameTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.deviceNameLabel.mas_right).mas_offset(30.f);
        make.right.mas_equalTo(-offsetX);
        make.top.mas_equalTo(self.icon.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(25.f);
    }];
    [self.tagIDLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(offsetX);
        make.width.mas_equalTo(110.f);
        make.centerY.mas_equalTo(self.tagIDTextField.mas_centerY);
        make.height.mas_equalTo(MKFont(13.f).lineHeight);
    }];
    [self.xLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.tagIDLabel.mas_right).mas_offset(10.f);
        make.width.mas_equalTo(15.f);
        make.centerY.mas_equalTo(self.tagIDTextField.mas_centerY);
        make.height.mas_equalTo(MKFont(11.f).lineHeight);
    }];
    [self.tagIDTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.xLabel.mas_right).mas_offset(5.f);
        make.right.mas_equalTo(-offsetX);
        make.top.mas_equalTo(self.nameTextField.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(25.f);
    }];
}

#pragma mark - setter
- (void)setDataModel:(MKBXTSlotTagInfoCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKBXTSlotTagInfoCellModel.class]) {
        return;
    }
    self.nameTextField.text = SafeStr(_dataModel.deviceName);
    self.tagIDTextField.text = SafeStr(_dataModel.tagID);
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
        _icon.image = LOADICON(@"MKBeaconXTag", @"MKBXTSlotTagInfoCell", @"bxt_slotAdvContent.png");
    }
    return _icon;
}

- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.font = MKFont(15.f);
        _msgLabel.text = @"Adv content";
    }
    return _msgLabel;
}

- (UILabel *)deviceNameLabel {
    if (!_deviceNameLabel) {
        _deviceNameLabel = [[UILabel alloc] init];
        _deviceNameLabel.textColor = DEFAULT_TEXT_COLOR;
        _deviceNameLabel.textAlignment = NSTextAlignmentLeft;
        _deviceNameLabel.font = MKFont(13.f);
        _deviceNameLabel.text = @"Device name";
    }
    return _deviceNameLabel;
}

- (MKTextField *)nameTextField {
    if (!_nameTextField) {
        _nameTextField = [MKCustomUIAdopter customNormalTextFieldWithText:@""
                                                              placeHolder:@"1 - 20 characters."
                                                                 textType:mk_normal];
        _nameTextField.maxLength = 20;
        @weakify(self);
        _nameTextField.textChangedBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(bxt_advContent_tagInfo_deviceNameChanged:)]) {
                [self.delegate bxt_advContent_tagInfo_deviceNameChanged:text];
            }
        };
    }
    return _nameTextField;
}

- (UILabel *)tagIDLabel {
    if (!_tagIDLabel) {
        _tagIDLabel = [[UILabel alloc] init];
        _tagIDLabel.textColor = DEFAULT_TEXT_COLOR;
        _tagIDLabel.textAlignment = NSTextAlignmentLeft;
        _tagIDLabel.font = MKFont(13.f);
        _tagIDLabel.text = @"Tag ID";
    }
    return _tagIDLabel;
}

- (UILabel *)xLabel {
    if (!_xLabel) {
        _xLabel = [[UILabel alloc] init];
        _xLabel.textColor = DEFAULT_TEXT_COLOR;
        _xLabel.textAlignment = NSTextAlignmentRight;
        _xLabel.font = MKFont(11.f);
        _xLabel.text = @"0x";
    }
    return _xLabel;
}

- (MKTextField *)tagIDTextField {
    if (!_tagIDTextField) {
        _tagIDTextField = [MKCustomUIAdopter customNormalTextFieldWithText:@""
                                                               placeHolder:@"1-6 bytes"
                                                                  textType:mk_hexCharOnly];
        _tagIDTextField.maxLength = 12;
        @weakify(self);
        _tagIDTextField.textChangedBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(bxt_advContent_tagInfo_tagIDChanged:)]) {
                [self.delegate bxt_advContent_tagInfo_tagIDChanged:text];
            }
        };
    }
    return _tagIDTextField;
}

@end
