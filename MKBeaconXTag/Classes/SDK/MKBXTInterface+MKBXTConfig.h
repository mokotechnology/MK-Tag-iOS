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
 @param sucBlock Success callback
 @param failedBlock Failure callback
 */
+ (void)bxt_configThreeAxisDataParams:(mk_bxt_threeAxisDataRate)dataRate
                         acceleration:(mk_bxt_threeAxisDataAG)acceleration
                      motionThreshold:(NSInteger)motionThreshold
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure the broadcast parameters of the specified channel.
/// @param index Number of the channel.(0~5)
/// @param advInterval Adv Interval.1~100(Unit:100ms)
/// @param advDuration Adv Duration.1s~65535s.
/// @param standbyDuration Standby Duration.0~65535s
/// @param rssi -127dBm~0dBm.
/// @param txPower Tx Power.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxt_configSlotParamWithIndex:(NSInteger)index
                         advInterval:(NSInteger)advInterval
                         advDuration:(NSInteger)advDuration
                     standbyDuration:(NSInteger)standbyDuration
                                rssi:(NSInteger)rssi
                             txPower:(mk_bxt_txPower)txPower
                            sucBlock:(void (^)(void))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure channel data as NO DATA.
/// @param index Number of the channel.(0~5)
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxt_configSlotNoDataWithIndex:(NSInteger)index
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure channel data as UID.
/// @param index Number of the channel.(0~5)
/// @param namespaceID 10 Bytes.
/// @param instanceID 6 Bytes.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxt_configSlotUIDWithIndex:(NSInteger)index
                       namespaceID:(NSString *)namespaceID
                        instanceID:(NSString *)instanceID
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure channel data as URL
/// @param index Number of the channel.(0~5)
/// @param urlType urlType
/// @param urlContent 1~17 ascii characters.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxt_configSlotURLWithIndex:(NSInteger)index
                           urlType:(mk_bxt_urlHeaderType)urlType
                        urlContent:(NSString *)urlContent
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure channel data as TLM.
/// @param index Number of the channel.(0~5)
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxt_configSlotTLMWithIndex:(NSInteger)index
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure channel data as iBeacon.
/// @param index Number of the channel.(0~5)
/// @param major 0~65535
/// @param minor 0~65535
/// @param uuid 16 Bytes.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxt_configSlotBeaconWithIndex:(NSInteger)index
                                major:(NSInteger)major
                                minor:(NSInteger)minor
                                 uuid:(NSString *)uuid
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure channel data as Tag Info.
/// @param index Number of the channel.(0~5)
/// @param deviceName 1~20 ascii characters.
/// @param tagID 1~6 Bytes.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxt_configSlotTagInfoWithIndex:(NSInteger)index
                            deviceName:(NSString *)deviceName
                                 tagID:(NSString *)tagID
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/// Close channel broadcast.
/// @param index Number of the channel.(0~5)
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxt_configSlotTriggerCloseWithIndex:(NSInteger)index
                                   sucBlock:(void (^)(void))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure channel broadcast content as motion trigger.
/// @param index Number of the channel.(0~5)
/// @param start YES:Start broadcasting  NO:Stop broadcasting
/// @param advInterval The length of time to broadcast after the trigger condition. (When set to stop broadcasting, this parameter is invalid).0~65535s.
/// @param staticInterval Determine the length of time the device has been in a stationary state.1~65535s.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxt_configSlotTriggerMotionDetectionWithIndex:(NSInteger)index
                                                start:(BOOL)start
                                          advInterval:(NSInteger)advInterval
                                       staticInterval:(NSInteger)staticInterval
                                             sucBlock:(void (^)(void))sucBlock
                                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Configure channel broadcast content as hall trigger.
/// @param index Number of the channel.(0~5)
/// @param start YES:Start broadcasting  NO:Stop broadcasting
/// @param advInterval The length of time to broadcast after the trigger condition. (When set to stop broadcasting, this parameter is invalid).0~65535s.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxt_configSlotTriggerMagneticDetectionWithIndex:(NSInteger)index
                                                  start:(BOOL)start
                                            advInterval:(NSInteger)advInterval
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

 @param sucBlock Success callback
 @param failedBlock Failure callback
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

/// Scan response packet.
/// @param isOn isOn
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxt_configScanResponsePacket:(BOOL)isOn
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

/// Remote LED reminder parameters.
/// @param blinkingTime Blinking time.1s ~ 600s(Unit:100ms)
/// @param blinkingInterval Blinking interval.1 ~ 100(Unit:100ms)
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxt_configRemoteReminderLEDNotiParams:(NSInteger)blinkingTime
                             blinkingInterval:(NSInteger)blinkingInterval
                                     sucBlock:(void (^)(void))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock;

/// Static heartbeat params.
/// @param isOn isOn.
/// @param cycleTime Static cycle time.(1 Min ~ 65535 Mins.)
/// @param advDuration Adv duration.(1s ~ 65535s.)
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxt_configStaticHeartbeat:(BOOL)isOn
                        cycleTime:(NSInteger)cycleTime
                      advDuration:(NSInteger)advDuration
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock;

/// Battery Reset.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxt_resetBatteryWithSucBlock:(void (^)(void))sucBlock
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
