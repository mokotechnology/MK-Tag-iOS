//
//  MKBXTSensorConfigController.h
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/7/20.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseViewController.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXTSensorConfigController : MKBaseViewController

/// 霍尔开关机状态
@property (nonatomic, assign)BOOL hallStatus;

/// 是否支持三轴
@property (nonatomic, assign)BOOL supportThreeAcc;

@end

NS_ASSUME_NONNULL_END
