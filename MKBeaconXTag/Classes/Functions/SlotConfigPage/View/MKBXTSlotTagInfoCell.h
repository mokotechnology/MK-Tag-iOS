//
//  MKBXTSlotTagInfoCell.h
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/7/23.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXTSlotTagInfoCellModel : NSObject

@property (nonatomic, copy)NSString *deviceName;

@property (nonatomic, copy)NSString *tagID;

@end

@protocol MKBXTSlotTagInfoCellDelegate <NSObject>

- (void)bxt_advContent_tagInfo_deviceNameChanged:(NSString *)text;

- (void)bxt_advContent_tagInfo_tagIDChanged:(NSString *)text;

@end

@interface MKBXTSlotTagInfoCell : MKBaseCell

@property (nonatomic, strong)MKBXTSlotTagInfoCellModel *dataModel;

@property (nonatomic, weak)id <MKBXTSlotTagInfoCellDelegate>delegate;

+ (MKBXTSlotTagInfoCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
