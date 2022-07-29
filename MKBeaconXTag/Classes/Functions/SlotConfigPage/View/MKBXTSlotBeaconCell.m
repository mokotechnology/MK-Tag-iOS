//
//  MKBXTSlotBeaconCell.m
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/7/23.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXTSlotBeaconCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

#import "MKTextField.h"
#import "MKCustomUIAdopter.h"

@implementation MKBXTSlotBeaconCellModel
@end

@interface MKBXTSlotBeaconCell ()

@property (nonatomic, strong)UIView *backView;

@property (nonatomic, strong)UIImageView *leftIcon;

@property (nonatomic, strong)UILabel *typeLabel;

@property (nonatomic, strong)UILabel *majorLabel;

@property (nonatomic, strong)MKTextField *majorTextField;

@property (nonatomic, strong)UILabel *minorLabel;

@property (nonatomic, strong)MKTextField *minorTextField;

@property (nonatomic, strong)UILabel *uuidLabel;

@property (nonatomic, strong)UILabel *hexLabel;

@property (nonatomic, strong)MKTextField *uuidTextField;

@end

@implementation MKBXTSlotBeaconCell

+ (MKBXTSlotBeaconCell *)initCellWithTableView:(UITableView *)tableView {
    MKBXTSlotBeaconCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKBXTSlotBeaconCellIdenty"];
    if (!cell) {
        cell = [[MKBXTSlotBeaconCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKBXTSlotBeaconCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.backView];
        
        [self.backView addSubview:self.leftIcon];
        [self.backView addSubview:self.typeLabel];
        
        [self.backView addSubview:self.majorLabel];
        [self.backView addSubview:self.majorTextField];
        
        [self.backView addSubview:self.minorLabel];
        [self.backView addSubview:self.minorTextField];
        
        [self.backView addSubview:self.uuidLabel];
        [self.backView addSubview:self.hexLabel];
        [self.backView addSubview:self.uuidTextField];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.backView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [self.leftIcon mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(22.f);
        make.top.mas_equalTo(10.f);
        make.height.mas_equalTo(22.f);
    }];
    [self.typeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftIcon.mas_right).mas_offset(15.f);
        make.right.mas_equalTo(-15.f);
        make.centerY.mas_equalTo(self.leftIcon.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    
    [self.majorLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(80.f);
        make.centerY.mas_equalTo(self.majorTextField.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.majorTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.majorLabel.mas_right).mas_offset(40.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.leftIcon.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(30.f);
    }];
    
    [self.minorLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(80.f);
        make.centerY.mas_equalTo(self.minorTextField.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.minorTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.minorLabel.mas_right).mas_offset(40.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.majorTextField.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(30.f);
    }];
    
    [self.uuidLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(80.f);
        make.centerY.mas_equalTo(self.uuidTextField.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.hexLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.uuidTextField.mas_left).mas_offset(-2.f);
        make.width.mas_equalTo(30.f);
        make.centerY.mas_equalTo(self.uuidTextField.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.uuidTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.uuidLabel.mas_right).mas_offset(40.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.minorTextField.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(30.f);
    }];
}

#pragma mark - setter
- (void)setDataModel:(MKBXTSlotBeaconCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKBXTSlotBeaconCellModel.class]) {
        return;
    }
    self.majorTextField.text = SafeStr(_dataModel.major);
    self.minorTextField.text = SafeStr(_dataModel.minor);
    self.uuidTextField.text = SafeStr(_dataModel.uuid);
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
        _leftIcon.image = LOADICON(@"MKBeaconXTag", @"MKBXTSlotBeaconCell", @"bxt_slotAdvContent.png");
    }
    return _leftIcon;
}

- (UILabel *)typeLabel{
    if (!_typeLabel) {
        _typeLabel = [[UILabel alloc] init];
        _typeLabel.textColor = DEFAULT_TEXT_COLOR;
        _typeLabel.textAlignment = NSTextAlignmentLeft;
        _typeLabel.font = MKFont(15.f);
        _typeLabel.text = @"Adv content";
    }
    return _typeLabel;
}

- (UILabel *)majorLabel {
    if (!_majorLabel) {
        _majorLabel = [[UILabel alloc] init];
        _majorLabel.textColor = DEFAULT_TEXT_COLOR;
        _majorLabel.textAlignment = NSTextAlignmentLeft;
        _majorLabel.font = MKFont(15.f);
        _majorLabel.text = @"Major";
    }
    return _majorLabel;
}

- (MKTextField *)majorTextField {
    if (!_majorTextField) {
        _majorTextField = [MKCustomUIAdopter customNormalTextFieldWithText:@""
                                                               placeHolder:@"0~65535"
                                                                  textType:mk_realNumberOnly];
        _majorTextField.maxLength = 5;
        @weakify(self);
        _majorTextField.textChangedBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(bxt_advContent_majorChanged:)]) {
                [self.delegate bxt_advContent_majorChanged:text];
            }
        };
    }
    return _majorTextField;
}

- (UILabel *)minorLabel {
    if (!_minorLabel) {
        _minorLabel = [[UILabel alloc] init];
        _minorLabel.textColor = DEFAULT_TEXT_COLOR;
        _minorLabel.textAlignment = NSTextAlignmentLeft;
        _minorLabel.font = MKFont(15.f);
        _minorLabel.text = @"Minor";
    }
    return _minorLabel;
}

- (MKTextField *)minorTextField {
    if (!_minorTextField) {
        _minorTextField = [MKCustomUIAdopter customNormalTextFieldWithText:@""
                                                               placeHolder:@"0~65535"
                                                                  textType:mk_realNumberOnly];
        _minorTextField.maxLength = 5;
        @weakify(self);
        _minorTextField.textChangedBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(bxt_advContent_minorChanged:)]) {
                [self.delegate bxt_advContent_minorChanged:text];
            }
        };
    }
    return _minorTextField;
}

- (UILabel *)uuidLabel {
    if (!_uuidLabel) {
        _uuidLabel = [[UILabel alloc] init];
        _uuidLabel.textColor = DEFAULT_TEXT_COLOR;
        _uuidLabel.textAlignment = NSTextAlignmentLeft;
        _uuidLabel.font = MKFont(15.f);
        _uuidLabel.text = @"UUID";
    }
    return _uuidLabel;
}

- (UILabel *)hexLabel {
    if (!_hexLabel) {
        _hexLabel = [[UILabel alloc] init];
        _hexLabel.textColor = DEFAULT_TEXT_COLOR;
        _hexLabel.font = MKFont(12.f);
        _hexLabel.textAlignment = NSTextAlignmentRight;
        _hexLabel.text = @"0x";
    }
    return _hexLabel;
}

- (MKTextField *)uuidTextField {
    if (!_uuidTextField) {
        _uuidTextField = [MKCustomUIAdopter customNormalTextFieldWithText:@""
                                                              placeHolder:@"16bytes"
                                                                 textType:mk_hexCharOnly];
        _uuidTextField.maxLength = 32;
        @weakify(self);
        _uuidTextField.textChangedBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(bxt_advContent_uuidChanged:)]) {
                [self.delegate bxt_advContent_uuidChanged:text];
            }
        };
    }
    return _uuidTextField;
}

@end
