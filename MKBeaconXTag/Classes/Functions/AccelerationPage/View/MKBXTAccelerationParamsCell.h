//
//  MKBXTAccelerationParamsCell.h
//  MKBeaconXTag_Example
//
//  Created by aa on 2021/3/3.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXTAccelerationParamsCellModel : NSObject

/// 0:1hz,1:10hz,2:25hz,3:50hz,4:100hz
@property (nonatomic, assign)NSInteger samplingRate;

/// 0:±2g,1:±4g,2:±8g,3:±16g
@property (nonatomic, assign)NSInteger scale;

@property (nonatomic, copy)NSString *threshold;

@end

@protocol MKBXTAccelerationParamsCellDelegate <NSObject>

/// 用户改变了scale.
/// @param scale 0:±2g,1:±4g,2:±8g,3:±16g
- (void)bxt_accelerationParamsScaleChanged:(NSInteger)scale;

/// 用户改变了samplingRate
/// @param samplingRate 0:1hz,1:10hz,2:25hz,3:50hz,4:100hz
- (void)bxt_accelerationParamsSamplingRateChanged:(NSInteger)samplingRate;

/// 用户改变了Motion threshold
/// @param threshold threshold
- (void)bxt_accelerationMotionThresholdChanged:(NSString *)threshold;

@end

@interface MKBXTAccelerationParamsCell : MKBaseCell

@property (nonatomic, weak)id <MKBXTAccelerationParamsCellDelegate>delegate;

@property (nonatomic, strong)MKBXTAccelerationParamsCellModel *dataModel;

+ (MKBXTAccelerationParamsCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
