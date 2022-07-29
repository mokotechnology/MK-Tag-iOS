//
//  MKBXTSlotUIDCell.m
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/7/23.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXTSlotUIDCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"

#import "MKTextField.h"
#import "MKCustomUIAdopter.h"

@implementation MKBXTSlotUIDCellModel
@end

@interface MKBXTSlotUIDCell ()

@property (nonatomic, strong)UIView *backView;

@property (nonatomic, strong)UIImageView *leftIcon;

@property (nonatomic, strong)UILabel *typeLabel;

@property (nonatomic, strong)UILabel *nameLabel;

@property (nonatomic, strong)UILabel *hexNameLabel;

@property (nonatomic, strong)MKTextField *nameTextField;

@property (nonatomic, strong)UILabel *instanceLabel;

@property (nonatomic, strong)UILabel *hexInstanceLabel;

@property (nonatomic, strong)MKTextField *instanceTextField;

@end

@implementation MKBXTSlotUIDCell

+ (MKBXTSlotUIDCell *)initCellWithTableView:(UITableView *)tableView {
    MKBXTSlotUIDCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKBXTSlotUIDCellIdenty"];
    if (!cell) {
        cell = [[MKBXTSlotUIDCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKBXTSlotUIDCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.backView];
        
        [self.backView addSubview:self.leftIcon];
        [self.backView addSubview:self.typeLabel];
        
        [self.backView addSubview:self.nameLabel];
        [self.backView addSubview:self.nameTextField];
        [self.backView addSubview:self.hexNameLabel];
        
        [self.backView addSubview:self.instanceLabel];
        [self.backView addSubview:self.instanceTextField];
        [self.backView addSubview:self.hexInstanceLabel];
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
    
    [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(120.f);
        make.centerY.mas_equalTo(self.nameTextField.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.hexNameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nameLabel.mas_right).mas_offset(5.f);
        make.width.mas_equalTo(30.f);
        make.centerY.mas_equalTo(self.nameTextField.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.nameTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.hexNameLabel.mas_right).mas_offset(5.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.leftIcon.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(30.f);
    }];
    
    [self.instanceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(120.f);
        make.centerY.mas_equalTo(self.instanceTextField.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.hexInstanceLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.instanceLabel.mas_right).mas_offset(5.f);
        make.width.mas_equalTo(30.f);
        make.centerY.mas_equalTo(self.instanceTextField.mas_centerY);
        make.height.mas_equalTo(MKFont(12.f).lineHeight);
    }];
    [self.instanceTextField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.hexInstanceLabel.mas_right).mas_offset(5.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.nameTextField.mas_bottom).mas_offset(10.f);
        make.height.mas_equalTo(30.f);
    }];
}

#pragma mark - setter
- (void)setDataModel:(MKBXTSlotUIDCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKBXTSlotUIDCellModel.class]) {
        return;
    }
    self.nameTextField.text = SafeStr(_dataModel.namespaceID);
    self.instanceTextField.text = SafeStr(_dataModel.instanceID);
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
        _leftIcon.image = LOADICON(@"MKBeaconXTag", @"MKBXTSlotUIDCell", @"bxt_slotAdvContent.png");
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

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = DEFAULT_TEXT_COLOR;
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.font = MKFont(15.f);
        _nameLabel.text = @"Namespace ID";
    }
    return _nameLabel;
}

- (UILabel *)hexNameLabel {
    if (!_hexNameLabel) {
        _hexNameLabel = [[UILabel alloc] init];
        _hexNameLabel.textColor = DEFAULT_TEXT_COLOR;
        _hexNameLabel.font = MKFont(12.f);
        _hexNameLabel.textAlignment = NSTextAlignmentRight;
        _hexNameLabel.text = @"0x";
    }
    return _hexNameLabel;
}

- (MKTextField *)nameTextField {
    if (!_nameTextField) {
        _nameTextField = [MKCustomUIAdopter customNormalTextFieldWithText:@""
                                                              placeHolder:@"10bytes"
                                                                 textType:mk_hexCharOnly];
        _nameTextField.maxLength = 20;
        @weakify(self);
        _nameTextField.textChangedBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(bxt_advContent_namespaceIDChanged:)]) {
                [self.delegate bxt_advContent_namespaceIDChanged:text];
            }
        };
    }
    return _nameTextField;
}

- (UILabel *)instanceLabel {
    if (!_instanceLabel) {
        _instanceLabel = [[UILabel alloc] init];
        _instanceLabel.textColor = DEFAULT_TEXT_COLOR;
        _instanceLabel.textAlignment = NSTextAlignmentLeft;
        _instanceLabel.font = MKFont(15.f);
        _instanceLabel.text = @"Instance ID";
    }
    return _instanceLabel;
}

- (UILabel *)hexInstanceLabel {
    if (!_hexInstanceLabel) {
        _hexInstanceLabel = [[UILabel alloc] init];
        _hexInstanceLabel.textColor = DEFAULT_TEXT_COLOR;
        _hexInstanceLabel.font = MKFont(12.f);
        _hexInstanceLabel.textAlignment = NSTextAlignmentRight;
        _hexInstanceLabel.text = @"0x";
    }
    return _hexInstanceLabel;
}

- (MKTextField *)instanceTextField {
    if (!_instanceTextField) {
        _instanceTextField = [MKCustomUIAdopter customNormalTextFieldWithText:@""
                                                                  placeHolder:@"6bytes"
                                                                     textType:mk_hexCharOnly];
        _instanceTextField.maxLength = 12;
        @weakify(self);
        _instanceTextField.textChangedBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(bxt_advContent_instanceIDChanged:)]) {
                [self.delegate bxt_advContent_instanceIDChanged:text];
            }
        };
    }
    return _instanceTextField;
}

@end
