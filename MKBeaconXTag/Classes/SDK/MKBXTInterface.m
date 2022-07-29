//
//  MKBXTInterface.m
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/7/13.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXTInterface.h"

#import "MKBLEBaseSDKDefines.h"
#import "MKBLEBaseSDKAdopter.h"

#import "MKBXTCentralManager.h"
#import "MKBXTOperationID.h"
#import "MKBXTOperation.h"
#import "CBPeripheral+MKBXTAdd.h"

#define centralManager [MKBXTCentralManager shared]
#define peripheral ([MKBXTCentralManager shared].peripheral)

@implementation MKBXTInterface

#pragma mark ***********************************Device Information****************************************

+ (void)bxt_readDeviceModelWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_bxt_taskReadDeviceModelOperation
                           characteristic:peripheral.bxt_deviceModel
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)bxt_readProductionDateWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_bxt_taskReadProductDateOperation
                           characteristic:peripheral.bxt_productDate
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)bxt_readFirmwareWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_bxt_taskReadFirmwareOperation
                           characteristic:peripheral.bxt_firmware
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)bxt_readHardwareWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_bxt_taskReadHardwareOperation
                           characteristic:peripheral.bxt_hardware
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)bxt_readSoftwareWithSucBlock:(void (^)(id returnData))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_bxt_taskReadSoftwareOperation
                           characteristic:peripheral.bxt_software
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

+ (void)bxt_readManufacturerWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_bxt_taskReadManufacturerOperation
                           characteristic:peripheral.bxt_manufacturer
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

#pragma mark ***********************************Custom****************************************

+ (void)bxt_readMacAddressWithSucBlock:(void (^)(id returnData))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxt_taskReadMacAddressOperation
                     cmdFlag:@"20"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxt_readThreeAxisDataParamsWithSucBlock:(void (^)(id returnData))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxt_taskReadThreeAxisDataParamsOperation
                     cmdFlag:@"21"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxt_readSlotParamsWithIndex:(NSInteger)index
                           sucBlock:(void (^)(id returnData))sucBlock
                        failedBlock:(void (^)(NSError *error))failedBlock {
    if (index < 0 || index > 5) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *indexString = [MKBLEBaseSDKAdopter fetchHexValue:index byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ea002201",indexString];
    [centralManager addTaskWithTaskID:mk_bxt_taskReadSlotParamsOperation
                       characteristic:peripheral.bxt_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)bxt_readSlotDataWithIndex:(NSInteger)index
                         sucBlock:(void (^)(id returnData))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock {
    if (index < 0 || index > 5) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *indexString = [MKBLEBaseSDKAdopter fetchHexValue:index byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ea002301",indexString];
    [centralManager addTaskWithTaskID:mk_bxt_taskReadSlotDataOperation
                       characteristic:peripheral.bxt_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)bxt_readSlotTriggerParamsWithIndex:(NSInteger)index
                                  sucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    if (index < 0 || index > 5) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *indexString = [MKBLEBaseSDKAdopter fetchHexValue:index byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@",@"ea002401",indexString];
    [centralManager addTaskWithTaskID:mk_bxt_taskReadSlotTriggerParamsOperation
                       characteristic:peripheral.bxt_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)bxt_readConnectableWithSucBlock:(void (^)(id returnData))sucBlock
                            failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxt_taskReadConnectableOperation
                     cmdFlag:@"25"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxt_readPowerOffByHallSensorWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxt_taskReadPowerOffByHallSensorOperation
                     cmdFlag:@"29"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxt_readSlotDataTypeWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxt_taskReadSlotDataTypeOperation
                     cmdFlag:@"31"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxt_readTriggerLEDIndicatorStatusWithSucBlock:(void (^)(id returnData))sucBlock
                                          failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxt_taskReadTriggerLEDIndicatorStatusOperation
                     cmdFlag:@"32"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxt_readBatteryVoltageWithSucBlock:(void (^)(id returnData))sucBlock
                               failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxt_taskReadBatteryVoltageOperation
                     cmdFlag:@"4a"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxt_readMotionTriggerCountWithSucBlock:(void (^)(id returnData))sucBlock
                                   failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxt_taskReadMotionTriggerCountOperation
                     cmdFlag:@"4d"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxt_readHallTriggerCountWithSucBlock:(void (^)(id returnData))sucBlock
                                 failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxt_taskReadHallTriggerCountOperation
                     cmdFlag:@"4e"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

+ (void)bxt_readSensorStatusWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    [self readDataWithTaskID:mk_bxt_taskReadSensorStatusOperation
                     cmdFlag:@"4f"
                    sucBlock:sucBlock
                 failedBlock:failedBlock];
}

#pragma mark - AA07 密码相关

+ (void)bxt_readPasswordVerificationWithSucBlock:(void (^)(id returnData))sucBlock
                                     failedBlock:(void (^)(NSError *error))failedBlock {
    [self readPasswordDataWithTaskID:mk_bxt_taskReadNeedPasswordOperation
                             cmdFlag:@"53"
                            sucBlock:^(id returnData) {
        BOOL isOn = [returnData[@"result"][@"state"] isEqualToString:@"01"];
        NSDictionary *dic = @{
            @"msg":@"success",
            @"code":@"1",
            @"result":@{
                @"isOn":@(isOn)
            },
        };
        if (sucBlock) {
            sucBlock(dic);
        }
    } failedBlock:failedBlock];
}

#pragma mark - AA08 霍尔传感器数据

+ (void)bxt_readMagnetStatusWithSucBlock:(void (^)(id returnData))sucBlock
                             failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addReadTaskWithTaskID:mk_bxt_taskReadMagnetStatusOperation
                           characteristic:peripheral.bxt_hallSensor
                             successBlock:sucBlock
                             failureBlock:failedBlock];
}

#pragma mark - private method
+ (void)readDataWithTaskID:(mk_bxt_taskOperationID)taskID
                   cmdFlag:(NSString *)flag
                  sucBlock:(void (^)(id returnData))sucBlock
               failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ea00",flag,@"00"];
    [centralManager addTaskWithTaskID:taskID
                       characteristic:peripheral.bxt_custom
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

+ (void)readPasswordDataWithTaskID:(mk_bxt_taskOperationID)taskID
                           cmdFlag:(NSString *)flag
                          sucBlock:(void (^)(id returnData))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ea00",flag,@"00"];
    [centralManager addTaskWithTaskID:taskID
                       characteristic:peripheral.bxt_password
                          commandData:commandString
                         successBlock:sucBlock
                         failureBlock:failedBlock];
}

@end
