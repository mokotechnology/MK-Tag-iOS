//
//  MKBXTInterface+MKBXTConfig.m
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/7/13.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXTInterface+MKBXTConfig.h"

#import "MKBLEBaseSDKDefines.h"
#import "MKBLEBaseSDKAdopter.h"

#import "MKBXTCentralManager.h"
#import "MKBXTOperationID.h"
#import "MKBXTOperation.h"
#import "CBPeripheral+MKBXTAdd.h"
#import "MKBXTSDKDataAdopter.h"

#define centralManager [MKBXTCentralManager shared]
#define peripheral ([MKBXTCentralManager shared].peripheral)

@implementation MKBXTInterface (MKBXTConfig)

#pragma mark - AA01 自定义

+ (void)bxt_configThreeAxisDataParams:(mk_bxt_threeAxisDataRate)dataRate
                         acceleration:(mk_bxt_threeAxisDataAG)acceleration
                      motionThreshold:(NSInteger)motionThreshold
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    if (motionThreshold < 1 || motionThreshold > 255) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *rate = [MKBXTSDKDataAdopter fetchThreeAxisDataRate:dataRate];
    NSString *ag = [MKBXTSDKDataAdopter fetchThreeAxisDataAG:acceleration];
    NSString *threshold = [MKBLEBaseSDKAdopter fetchHexValue:motionThreshold byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@",@"ea012103",rate,ag,threshold];
    [self configDataWithTaskID:mk_bxt_taskConfigThreeAxisDataParamsOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxt_configSlotParamWithIndex:(NSInteger)index
                         advInterval:(NSInteger)advInterval
                         advDuration:(NSInteger)advDuration
                     standbyDuration:(NSInteger)standbyDuration
                                rssi:(NSInteger)rssi
                             txPower:(mk_bxt_txPower)txPower
                            sucBlock:(void (^)(void))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    if (index < 0 || index > 5 || advInterval < 1 || advInterval > 100
        || advDuration < 1 || advDuration > 65535 || standbyDuration < 0
        || standbyDuration > 65535 || rssi < -127 || rssi > 0) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *indexValue = [MKBLEBaseSDKAdopter fetchHexValue:index byteLen:1];
    NSString *advIntervalValue = [MKBLEBaseSDKAdopter fetchHexValue:advInterval byteLen:1];
    NSString *advDurationValue = [MKBLEBaseSDKAdopter fetchHexValue:advDuration byteLen:2];
    NSString *standbyDurationValue = [MKBLEBaseSDKAdopter fetchHexValue:standbyDuration byteLen:2];
    NSString *rssiValue = [MKBLEBaseSDKAdopter hexStringFromSignedNumber:rssi];
    NSString *txPowerValue = [MKBXTSDKDataAdopter fetchTxPower:txPower];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",@"ea012208",indexValue,advIntervalValue,advDurationValue,standbyDurationValue,rssiValue,txPowerValue];
    [self configDataWithTaskID:mk_bxt_taskConfigSlotParamOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxt_configSlotNoDataWithIndex:(NSInteger)index
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    if (index < 0 || index > 5) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *indexValue = [MKBLEBaseSDKAdopter fetchHexValue:index byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ea012302",indexValue,@"ff"];
    [self configDataWithTaskID:mk_bxt_taskConfigSlotDataOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxt_configSlotUIDWithIndex:(NSInteger)index
                       namespaceID:(NSString *)namespaceID
                        instanceID:(NSString *)instanceID
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    if (index < 0 || index > 5) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    if (namespaceID.length != 20 || ![MKBLEBaseSDKAdopter checkHexCharacter:namespaceID]
        || instanceID.length != 12 || ![MKBLEBaseSDKAdopter checkHexCharacter:instanceID]) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *indexValue = [MKBLEBaseSDKAdopter fetchHexValue:index byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@",@"ea012312",indexValue,@"00",namespaceID,instanceID];
    [self configDataWithTaskID:mk_bxt_taskConfigSlotDataOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxt_configSlotURLWithIndex:(NSInteger)index
                           urlType:(mk_bxt_urlHeaderType)urlType
                        urlContent:(NSString *)urlContent
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    if (index < 0 || index > 5) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *urlString = [MKBXTSDKDataAdopter fetchUrlString:urlType urlContent:urlContent];
    if (!MKValidStr(urlString)) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *indexValue = [MKBLEBaseSDKAdopter fetchHexValue:index byteLen:1];
    
    NSString *totalLen = [MKBLEBaseSDKAdopter fetchHexValue:(urlString.length / 2 + 2) byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@",@"ea0123",totalLen,indexValue,@"10",urlString];
    [self configDataWithTaskID:mk_bxt_taskConfigSlotDataOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxt_configSlotTLMWithIndex:(NSInteger)index
                          sucBlock:(void (^)(void))sucBlock
                       failedBlock:(void (^)(NSError *error))failedBlock {
    if (index < 0 || index > 5) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *indexValue = [MKBLEBaseSDKAdopter fetchHexValue:index byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ea012302",indexValue,@"20"];
    [self configDataWithTaskID:mk_bxt_taskConfigSlotDataOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxt_configSlotBeaconWithIndex:(NSInteger)index
                                major:(NSInteger)major
                                minor:(NSInteger)minor
                                 uuid:(NSString *)uuid
                             sucBlock:(void (^)(void))sucBlock
                          failedBlock:(void (^)(NSError *error))failedBlock {
    if (index < 0 || index > 5 || major < 0 || major > 65535
        || minor < 0 || minor > 65535 || !MKValidStr(uuid) || uuid.length != 32
        || ![MKBLEBaseSDKAdopter checkHexCharacter:uuid]) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *indexValue = [MKBLEBaseSDKAdopter fetchHexValue:index byteLen:1];
    NSString *majorValue = [MKBLEBaseSDKAdopter fetchHexValue:major byteLen:2];
    NSString *minorValue = [MKBLEBaseSDKAdopter fetchHexValue:minor byteLen:2];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@%@",@"ea012316",indexValue,@"50",majorValue,minorValue,uuid];
    [self configDataWithTaskID:mk_bxt_taskConfigSlotDataOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxt_configSlotTagInfoWithIndex:(NSInteger)index
                            deviceName:(NSString *)deviceName
                                 tagID:(NSString *)tagID
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    if (index < 0 || index > 5 || !MKValidStr(deviceName) || deviceName.length > 20) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    if (!MKValidStr(tagID) || tagID.length > 12 || (tagID.length % 2 != 0)) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *indexValue = [MKBLEBaseSDKAdopter fetchHexValue:index byteLen:1];
    NSString *tempString = @"";
    for (NSInteger i = 0; i < deviceName.length; i ++) {
        int asciiCode = [deviceName characterAtIndex:i];
        tempString = [tempString stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
    }
    NSString *nameLen = [MKBLEBaseSDKAdopter fetchHexValue:(deviceName.length) byteLen:1];
    NSString *tagIDLen = [MKBLEBaseSDKAdopter fetchHexValue:(tagID.length / 2) byteLen:1];
    NSInteger totalLen = deviceName.length + (tagID.length / 2) + 4;
    NSString *totalLenValue = [MKBLEBaseSDKAdopter fetchHexValue:totalLen byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",@"ea0123",totalLenValue,indexValue,@"80",nameLen,tempString,tagIDLen,tagID];
    [self configDataWithTaskID:mk_bxt_taskConfigSlotDataOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxt_configSlotTriggerCloseWithIndex:(NSInteger)index
                                   sucBlock:(void (^)(void))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    if (index < 0 || index > 5) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *indexValue = [MKBLEBaseSDKAdopter fetchHexValue:index byteLen:1];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ea012402",indexValue,@"00"];
    [self configDataWithTaskID:mk_bxt_taskConfigSlotTriggerParamsOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxt_configSlotTriggerMotionDetectionWithIndex:(NSInteger)index
                                                start:(BOOL)start
                                          advInterval:(NSInteger)advInterval
                                       staticInterval:(NSInteger)staticInterval
                                             sucBlock:(void (^)(void))sucBlock
                                          failedBlock:(void (^)(NSError *error))failedBlock {
    if (index < 0 || index > 5 || advInterval < 0 || advInterval > 65535 || staticInterval < 1 || staticInterval > 65535) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *indexValue = [MKBLEBaseSDKAdopter fetchHexValue:index byteLen:1];
    NSString *startValue = (start ? @"01" : @"00");
    NSString *advIntervalValue = [MKBLEBaseSDKAdopter fetchHexValue:advInterval byteLen:2];
    NSString *staticIntervalValue = [MKBLEBaseSDKAdopter fetchHexValue:staticInterval byteLen:2];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@%@",@"ea012407",indexValue,@"05",startValue,advIntervalValue,staticIntervalValue];
    [self configDataWithTaskID:mk_bxt_taskConfigSlotTriggerParamsOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxt_configSlotTriggerMagneticDetectionWithIndex:(NSInteger)index
                                                  start:(BOOL)start
                                            advInterval:(NSInteger)advInterval
                                               sucBlock:(void (^)(void))sucBlock
                                            failedBlock:(void (^)(NSError *error))failedBlock {
    if (index < 0 || index > 5 || advInterval < 0 || advInterval > 65535 ) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *indexValue = [MKBLEBaseSDKAdopter fetchHexValue:index byteLen:1];
    NSString *startValue = (start ? @"01" : @"00");
    NSString *advIntervalValue = [MKBLEBaseSDKAdopter fetchHexValue:advInterval byteLen:2];
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@%@%@",@"ea012405",indexValue,@"06",startValue,advIntervalValue];
    [self configDataWithTaskID:mk_bxt_taskConfigSlotTriggerParamsOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxt_configConnectable:(BOOL)connectable
                     sucBlock:(void (^)(void))sucBlock
                  failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (connectable ? @"ea01250101" : @"ea01250100");
    [self configDataWithTaskID:mk_bxt_taskConfigConnectableOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxt_configPowerOffWithSucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ea012600";
    [self configDataWithTaskID:mk_bxt_taskPowerOffOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxt_factoryResetWithSucBlock:(void (^)(void))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ea012800";
    [self configDataWithTaskID:mk_bxt_taskFactoryResetOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxt_configPowerOffByHallSensor:(BOOL)isOn
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ea01290101" : @"ea01290100");
    [self configDataWithTaskID:mk_bxt_taskConfigPowerOffByHallSensorOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxt_configTriggerLEDIndicatorStatus:(BOOL)isOn
                                   sucBlock:(void (^)(void))sucBlock
                                failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ea01320101" : @"ea01320100");
    [self configDataWithTaskID:mk_bxt_taskConfigTriggerLEDIndicatorStatusOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxt_clearMotionTriggerCountWithSucBlock:(void (^)(void))sucBlock
                                    failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ea014d00";
    [self configDataWithTaskID:mk_bxt_taskClearMotionTriggerCountOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

+ (void)bxt_clearHallTriggerCountWithSucBlock:(void (^)(void))sucBlock
                                  failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = @"ea014e00";
    [self configDataWithTaskID:mk_bxt_taskClearHallTriggerCountOperation
                          data:commandString
                      sucBlock:sucBlock
                   failedBlock:failedBlock];
}

#pragma mark - AA07 密码相关

+ (void)bxt_configConnectPassword:(NSString *)password
                         sucBlock:(void (^)(void))sucBlock
                      failedBlock:(void (^)(NSError *error))failedBlock {
    if (!MKValidStr(password) || password.length > 16) {
        [MKBLEBaseSDKAdopter operationParamsErrorBlock:failedBlock];
        return;
    }
    NSString *commandData = @"";
    for (NSInteger i = 0; i < password.length; i ++) {
        int asciiCode = [password characterAtIndex:i];
        commandData = [commandData stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
    }
    NSString *lenString = [NSString stringWithFormat:@"%1lx",(long)password.length];
    if (lenString.length == 1) {
        lenString = [@"0" stringByAppendingString:lenString];
    }
    NSString *commandString = [NSString stringWithFormat:@"%@%@%@",@"ea0152",lenString,commandData];
    [self configPasswordDataWithTaskID:mk_bxt_taskConfigConnectPasswordOperation
                                  data:commandString
                              sucBlock:sucBlock
                           failedBlock:failedBlock];
}

+ (void)bxt_configPasswordVerification:(BOOL)isOn
                              sucBlock:(void (^)(void))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    NSString *commandString = (isOn ? @"ea01530101" : @"ea01530100");
    [self configPasswordDataWithTaskID:mk_bxt_taskConfigPasswordVerificationOperation
                                  data:commandString
                              sucBlock:sucBlock
                           failedBlock:failedBlock];
}

#pragma mark - private method
+ (void)configDataWithTaskID:(mk_bxt_taskOperationID)taskID
                        data:(NSString *)data
                    sucBlock:(void (^)(void))sucBlock
                 failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:taskID characteristic:peripheral.bxt_custom commandData:data successBlock:^(id  _Nonnull returnData) {
        BOOL success = [returnData[@"result"][@"success"] boolValue];
        if (!success) {
            [MKBLEBaseSDKAdopter operationSetParamsErrorBlock:failedBlock];
            return ;
        }
        if (sucBlock) {
            sucBlock();
        }
    } failureBlock:failedBlock];
}

+ (void)configPasswordDataWithTaskID:(mk_bxt_taskOperationID)taskID
                                data:(NSString *)data
                            sucBlock:(void (^)(void))sucBlock
                         failedBlock:(void (^)(NSError *error))failedBlock {
    [centralManager addTaskWithTaskID:taskID characteristic:peripheral.bxt_password commandData:data successBlock:^(id  _Nonnull returnData) {
        BOOL success = [returnData[@"result"][@"success"] boolValue];
        if (!success) {
            [MKBLEBaseSDKAdopter operationSetParamsErrorBlock:failedBlock];
            return ;
        }
        if (sucBlock) {
            sucBlock();
        }
    } failureBlock:failedBlock];
}

@end
