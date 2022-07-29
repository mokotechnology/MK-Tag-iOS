//
//  MKBXTInterface.h
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/7/13.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXTInterface : NSObject

#pragma mark ***********************************Device Information****************************************

/// Read product model
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxt_readDeviceModelWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock;

/**
 Reading the production date of device
 
 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxt_readProductionDateWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock;

/// Read device firmware information
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxt_readFirmwareWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Read device hardware information
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxt_readHardwareWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Read device software information
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxt_readSoftwareWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock;

/// Read device manufacturer information
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxt_readManufacturerWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark ***********************************Custom****************************************

/// Read the mac address of the device.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxt_readMacAddressWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock;

/**
 Read the sampling rate, scale and sensitivity of the 3-axis accelerometer sensor
 
 @{
 @"samplingRate":The 3-axis accelerometer sampling rate is 5 levels in total, 00--1hz，01--10hz，02--25hz，03--50hz，04--100hz
 @"gravityReference": The 3-axis accelerometer scale is 4 levels, which are 00--±2g；01--±4g；02--±8g；03--±16g
 @"motionThreshold":
 ±2g----->Unit:3.91mg
 ±4g----->Unit:7.81mg
 ±8g----->Unit:15.63mg
 ±16g----->Unit:31.25mg
 }

 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxt_readThreeAxisDataParamsWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the broadcast parameters of the specified channel.
/*
 @{
     @"slotIndex":@"1",         //Number of the channel.
     @"advInterval":@"10",      //Adv Interval.(Unit:100ms)
     @"advDuration":@"10",      //Adv Duration.(Unit:s)
     @"standbyDuration":@"0",   //Standby Duration.(Unit:s)
     @"rssi":@"-10",            //Rssi,dBm
     @"txPower":@"0dBm",           //Tx Power
 };
 */
/// @param index 0~5.Number of the channel.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxt_readSlotParamsWithIndex:(NSInteger)index
                           sucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock;

/// Read channel broadcast content.
/*
 //
 No Data:
 @{
     @"slotIndex":@"0",
     @"slotType":@"ff",
 };
 
 UID:
 @{
     @"slotIndex":@"1",
     @"slotType":@"00",
     @"namespaceID":@"00112233445566778899",
     @"instanceID":@"112233445566"
 };
 
 URL:
 @{
     @"slotIndex":@"2",
     @"slotType":@"10",
     @"urlType":@"1",       //@"0":http://www.   @"1":https://www.  @"2":http://   @"3":https://
     @"urlContent":@"moko.com"
 };
 
 TLM:
 @{
     @"slotIndex":@"3",
     @"slotType":@"20",
 };
 
 iBeacon:
 @{
     @"slotIndex":@"4",
     @"slotType":@"50",
     @"major":@"123",
     @"minor":@"456",
     @"uuid":@"111111111111111111111111111111111"
 };
 
 Tag Info:
 @{
     @"slotIndex":@"5",
     @"slotType":@"80",
     @"deviceName":@"MK Tag",
     @"tagID":@"0001"
 };
 */
/// @param index 0~5.Number of the channel.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxt_readSlotDataWithIndex:(NSInteger)index
                         sucBlock:(void (^)(id returnData))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock;

/// Read channel trigger parameters.
/*
 Close:
 @{
     @"slotIndex":@"0",
     @"triggerType":@"00",
 };
 Motion detection:
 @{
     @"slotIndex":@"1",
     @"triggerType":@"05",
     @"start":@(YES),   //YES:Start broadcasting  NO:Stop broadcasting
     @"advInterval":@"10",  //The length of time to broadcast after the trigger condition. (When set to stop broadcasting, this parameter is invalid)
     @"staticInterval":@"20",   //Determine the length of time the device has been in a stationary state.
 };
 Magnetic detection:
 @{
     @"slotIndex":@"2",
     @"triggerType":@"06",
     @"start":@(YES),   //YES:Start broadcasting  NO:Stop broadcasting
     @"advInterval":@"10",  //The length of time to broadcast after the trigger condition. (When set to stop broadcasting, this parameter is invalid)
 };
 */
/// @param index 0~5.Number of the channel.
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxt_readSlotTriggerParamsWithIndex:(NSInteger)index
                                  sucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the connectable status of the device.
/*
 @{
 @"connectable":@(YES)
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxt_readConnectableWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock;

/// Power off by hall sensor.
/*
 @{
 @"isOn":@(YES)
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxt_readPowerOffByHallSensorWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock;

/**
 Reading current frame types of the 6 SLOTs,
 eg:@"001020405080":
 @[@"00",@"10",@"20",@"40",@"50",@"80"]
 
 @"00":UID,
 @"10":URL,
 @"20":TLM,
 @"50":iBeacon,
 @"80":Tag info,
 @"FF":NO DATA

 @param sucBlock success callback
 @param failedBlock failed callback
 */
+ (void)bxt_readSlotDataTypeWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the trigger LED indicator light reminder status.
/*
 @{
    @"isOn":@(YES)
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxt_readTriggerLEDIndicatorStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the Voltage of the device.
/*
 @{
 @"voltage":@"3330",        //mV
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxt_readBatteryVoltageWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock;

/// Motion trigger count.
/*
 @{
 @"count":@"100",
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxt_readMotionTriggerCountWithSucBlock:(void (^)(id returnData))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock;

/// Magnetic trigger count.
/*
 @{
 @"count":@"100",
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxt_readHallTriggerCountWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock;

/// Read the type of sensor the device.
/*
 @{
    
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxt_readSensorStatusWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;


#pragma mark - AA07 密码相关
/// Whether the device has enabled password verification when connecting. When the device has disabled password verification, no password is required to connect to the device, otherwise a connection password is required.
/*
 @{
 @"isOn":@(YES)
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxt_readPasswordVerificationWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock;

#pragma mark - AA08 霍尔传感器数据
/// Read Hall Sensor Status.
/*
 @{
 @"moved":@(YES)    //YES:Absent   NO:Present
 }
 */
/// @param sucBlock Success callback
/// @param failedBlock Failure callback
+ (void)bxt_readMagnetStatusWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
