//
//  MKBXTInterface+MKBXTConfig.h
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/7/13.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXTInterface.h"

#import "MKBXTSDKNormalDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKBXTInterface (MKBXTConfig)

#pragma mark - AA01 自定义

/**
 Setting the sampling rate, scale and sensitivity of the 3-axis accelerometer sensor

 @param dataRate sampling rate
 @param acceleration acceleration
 @param motionThreshold  1~255.
 mk_bxt_threeAxisDataAG0(±2g)----->Unit:3.91mg
 mk_bxt_threeAxisDataAG1(±4g)------>Unit:7.81mg
 mk_bxt_threeAxisDataAG2(±8g)------>Unit:15.63mg
 mk_bxt_threeAxisDataAG3(±16g)------>Unit:31.25mg
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxt_configThreeAxisDataParams:(mk_bxt_threeAxisDataRate)dataRate
                         acceleration:(mk_bxt_threeAxisDataAG)acceleration
                      motionThreshold:(NSInteger)motionThreshold
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the connectable state of the device.
/// @param connectable connectable
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxt_configConnectable:(BOOL)connectable
                     sucBlock:(void (^)(void))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock;

/**
 Setting device power off

 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxt_configPowerOffWithSucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Reset.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxt_factoryResetWithSucBlock:(void (^)(void))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Power off by hall sensor.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxt_configPowerOffByHallSensor:(BOOL)isOn
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the trigger LED indicator light reminder status.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxt_configTriggerLEDIndicatorStatus:(BOOL)isOn
                                   sucBlock:(void (^)(void))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;

/// Clear the count of the motion trigger.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxt_clearMotionTriggerCountWithSucBlock:(void (^)(void))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock;

/// Clear the count of the Magnetic trigger.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxt_clearHallTriggerCountWithSucBlock:(void (^)(void))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark - AA07 密码相关

/// Configure the current connection password of the device.
/// @param password 1~16 ascii characters.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxt_configConnectPassword:(NSString *)password
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock;

/// Whether the device has enabled password verification when connecting. When the device has disabled password verification, no password is required to connect to the device, otherwise a connection password is required.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxt_configPasswordVerification:(BOOL)isOn
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
