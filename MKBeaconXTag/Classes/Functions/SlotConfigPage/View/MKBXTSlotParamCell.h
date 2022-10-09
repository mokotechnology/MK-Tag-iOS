//
//  MKBXTSlotParamCell.h
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/7/25.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

#import "MKBXTSlotConfigDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKBXTSlotParamCellModel : NSObject

@property (nonatomic, assign)bxt_slotType cellType;

@property (nonatomic, copy)NSString *interval;

@property (nonatomic, copy)NSString *advDuration;

@property (nonatomic, copy)NSString *standbyDuration;

@property (nonatomic, assign)NSInteger rssi;

/*
 0:-20dBm
 1:-16dBm
 2:-12dBm
 3:-8dBm
 4:-4dBm
 5:0dBm
 6:3dBm
 7:4dBm
 8:6dBm
 */
@property (nonatomic, assign)NSInteger txPower;

@end

@protocol MKBXTSlotParamCellDelegate <NSObject>

- (void)bxt_slotParam_advIntervalChanged:(NSString *)interval;

- (void)bxt_slotParam_advDurationChanged:(NSString *)duration;

- (void)bxt_slotParam_standbyDurationChanged:(NSString *)duration;

- (void)bxt_slotParam_rssiChanged:(NSInteger)rssi;

- (void)bxt_slotParam_txPowerChanged:(NSInteger)txPower;

@end

@interface MKBXTSlotParamCell : MKBaseCell

@property (nonatomic, strong)MKBXTSlotParamCellModel *dataModel;

@property (nonatomic, weak)id <MKBXTSlotParamCellDelegate>delegate;

+ (MKBXTSlotParamCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
