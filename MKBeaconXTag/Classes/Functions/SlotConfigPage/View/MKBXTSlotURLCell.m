//
//  MKBXTSlotURLCell.m
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/7/23.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXTSlotURLCell.h"

#import "Masonry.h"

#import "MKMacroDefines.h"
#import "UIView+MKAdd.h"
#import "NSString+MKAdd.h"

#import "MKTextField.h"
#import "MKPickerView.h"
#import "MKCustomUIAdopter.h"

#import "MKBXSlotDataAdopter.h"

@implementation MKBXTSlotURLCellModel
@end

@interface MKBXTSlotURLCell ()

@property (nonatomic, strong)UIView *backView;

@property (nonatomic, strong)UIImageView *leftIcon;

@property (nonatomic, strong)UILabel *typeLabel;

@property (nonatomic, strong)UILabel *msgLabel;

@property (nonatomic, strong)UILabel *urlTypeLabel;

@property (nonatomic, strong)MKTextField *textField;

@property (nonatomic, strong)NSArray *urlTypeList;

@end

@implementation MKBXTSlotURLCell

+ (MKBXTSlotURLCell *)initCellWithTableView:(UITableView *)tableView {
    MKBXTSlotURLCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MKBXTSlotURLCellIdenty"];
    if (!cell) {
        cell = [[MKBXTSlotURLCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKBXTSlotURLCellIdenty"];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.backView];
        
        [self.backView addSubview:self.leftIcon];
        [self.backView addSubview:self.typeLabel];
        
        [self.backView addSubview:self.msgLabel];
        [self.backView addSubview:self.urlTypeLabel];
        [self.backView addSubview:self.textField];
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
    
    [self.msgLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15.f);
        make.width.mas_equalTo(40.f);
        make.centerY.mas_equalTo(self.textField.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.urlTypeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.msgLabel.mas_right).mas_offset(15.f);
        make.width.mas_equalTo(80.f);
        make.centerY.mas_equalTo(self.textField.mas_centerY);
        make.height.mas_equalTo(MKFont(15.f).lineHeight);
    }];
    [self.textField mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.urlTypeLabel.mas_right).mas_offset(5.f);
        make.right.mas_equalTo(-15.f);
        make.top.mas_equalTo(self.leftIcon.mas_bottom).mas_offset(15.f);
        make.height.mas_equalTo(30.f);
    }];
}

#pragma mark - event method
- (void)urlTypeLabelPressed {
    NSInteger index = 0;
    for (NSInteger i = 0; i < self.urlTypeList.count; i ++) {
        if ([self.urlTypeLabel.text isEqualToString:self.urlTypeList[i]]) {
            index = i;
            break;
        }
    }
    
    MKPickerView *pickView = [[MKPickerView alloc] init];
    [pickView showPickViewWithDataList:self.urlTypeList selectedRow:index block:^(NSInteger currentRow) {
        self.urlTypeLabel.text = self.urlTypeList[currentRow];
        if ([self.delegate respondsToSelector:@selector(bxt_advContent_urlTypeChanged:)]) {
            [self.delegate bxt_advContent_urlTypeChanged:currentRow];
        }
    }];
}

#pragma mark - setter
- (void)setDataModel:(MKBXTSlotURLCellModel *)dataModel {
    _dataModel = nil;
    _dataModel = dataModel;
    if (!_dataModel || ![_dataModel isKindOfClass:MKBXTSlotURLCellModel.class]) {
        return;
    }
    
    self.urlTypeLabel.text = self.urlTypeList[_dataModel.urlType];
    self.textField.text = SafeStr(_dataModel.urlContent);
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
        _leftIcon.image = LOADICON(@"MKBeaconXTag", @"MKBXTSlotURLCell", @"bxt_slotAdvContent.png");
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

- (UILabel *)msgLabel {
    if (!_msgLabel) {
        _msgLabel = [[UILabel alloc] init];
        _msgLabel.textColor = DEFAULT_TEXT_COLOR;
        _msgLabel.font = MKFont(14.f);
        _msgLabel.textAlignment = NSTextAlignmentLeft;
        _msgLabel.text = @"URL";
    }
    return _msgLabel;
}

- (UILabel *)urlTypeLabel{
    if (!_urlTypeLabel) {
        _urlTypeLabel = [[UILabel alloc] init];
        _urlTypeLabel.textAlignment = NSTextAlignmentLeft;
        _urlTypeLabel.textColor = RGBCOLOR(111, 111, 111);
        _urlTypeLabel.font = MKFont(12.f);
        _urlTypeLabel.text = @"http://www.";
        
        _urlTypeLabel.layer.masksToBounds = YES;
        _urlTypeLabel.layer.borderWidth = 0.5f;
        _urlTypeLabel.layer.borderColor = CUTTING_LINE_COLOR.CGColor;
        _urlTypeLabel.layer.cornerRadius = 2.f;
        
        [_urlTypeLabel addTapAction:self selector:@selector(urlTypeLabelPressed)];
    }
    return _urlTypeLabel;
}

- (MKTextField *)textField {
    if (!_textField) {
        _textField = [MKCustomUIAdopter customNormalTextFieldWithText:@""
                                                          placeHolder:@"mokoblue.com/"
                                                             textType:mk_normal];
        _textField.maxLength = 17;
        @weakify(self);
        _textField.textChangedBlock = ^(NSString * _Nonnull text) {
            @strongify(self);
            if ([self.delegate respondsToSelector:@selector(bxt_advContent_urlContentChanged:)]) {
                [self.delegate bxt_advContent_urlContentChanged:text];
            }
        };
    }
    return _textField;
}

- (NSArray *)urlTypeList {
    if (!_urlTypeList) {
        _urlTypeList = @[@"http://www.",@"https://www.",@"http://",@"https://"];
    }
    return _urlTypeList;
}

@end
