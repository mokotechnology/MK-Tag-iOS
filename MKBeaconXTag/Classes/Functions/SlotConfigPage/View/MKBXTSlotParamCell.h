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
 0:-40dBm
 1:-20dBm
 2:-16dBm
 3:-12dBm
 4:-8dBm
 5:-4dBm
 6:0dBm
 7:3dBm
 8:4dBm
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
