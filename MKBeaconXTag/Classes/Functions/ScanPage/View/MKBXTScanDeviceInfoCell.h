//
//  MKBXTScanDeviceInfoCell.h
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/7/18.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@class CBPeripheral;
@class MKBXTScanInfoCellModel;

@protocol MKBXTScanDeviceInfoCellDelegate <NSObject>

- (void)mk_bxt_connectPeripheral:(CBPeripheral *)peripheral;

@end

@interface MKBXTScanDeviceInfoCell : MKBaseCell

@property (nonatomic, strong)MKBXTScanInfoCellModel *dataModel;

@property (nonatomic, weak)id <MKBXTScanDeviceInfoCellDelegate>delegate;

+ (MKBXTScanDeviceInfoCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
