//
//  MKBXTSettingModel.h
//  MKBeaconXTag_Example
//
//  Created by aa on 2023/6/2.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXTSettingModel : NSObject

@property (nonatomic, assign)BOOL supportBatteryReset;

/// 霍尔开关机状态
@property (nonatomic, assign)BOOL hallStatus;

/// 是否支持三轴
@property (nonatomic, assign)BOOL supportThreeAcc;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
