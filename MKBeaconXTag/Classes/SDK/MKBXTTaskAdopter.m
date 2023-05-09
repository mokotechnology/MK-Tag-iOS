//
//  MKBXTTaskAdopter.m
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/7/13.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXTTaskAdopter.h"

#import <CoreBluetooth/CoreBluetooth.h>

#import "MKBLEBaseSDKAdopter.h"
#import "MKBLEBaseSDKDefines.h"

#import "MKBXTOperationID.h"
#import "MKBXTSDKDataAdopter.h"

@implementation MKBXTTaskAdopter

+ (NSDictionary *)parseReadDataWithCharacteristic:(CBCharacteristic *)characteristic {
    NSData *readData = characteristic.value;
    NSLog(@"+++++%@-----%@",characteristic.UUID.UUIDString,readData);
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A24"]]) {
        //产品型号
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"modeID":tempString} operationID:mk_bxt_taskReadDeviceModelOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A25"]]) {
        //生产日期
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"productionDate":tempString} operationID:mk_bxt_taskReadProductDateOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A26"]]) {
        //firmware
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"firmware":tempString} operationID:mk_bxt_taskReadFirmwareOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A27"]]) {
        //hardware
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"hardware":tempString} operationID:mk_bxt_taskReadHardwareOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A28"]]) {
        //soft ware
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"software":tempString} operationID:mk_bxt_taskReadSoftwareOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A29"]]) {
        //manufacturerKey
        NSString *tempString = [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding];
        return [self dataParserGetDataSuccess:@{@"manufacturer":tempString} operationID:mk_bxt_taskReadManufacturerOperation];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA01"]]) {
        return [self parseCustomData:readData];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA07"]]) {
        //密码相关
        return [self parsePasswordData:readData];
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA08"]]) {
        //霍尔传感器相关
        return [self parseHallSensorData:readData];
    }
    
    return @{};
}

+ (NSDictionary *)parseWriteDataWithCharacteristic:(CBCharacteristic *)characteristic {
    return @{};
}

#pragma mark - 数据解析
+ (NSDictionary *)parsePasswordData:(NSData *)readData {
    NSString *readString = [MKBLEBaseSDKAdopter hexStringFromData:readData];
    if (![[readString substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"eb"]) {
        return @{};
    }
    NSInteger dataLen = [MKBLEBaseSDKAdopter getDecimalWithHex:readString range:NSMakeRange(6, 2)];
    if (readData.length != dataLen + 4) {
        return @{};
    }
    NSString *flag = [readString substringWithRange:NSMakeRange(2, 2)];
    NSString *cmd = [readString substringWithRange:NSMakeRange(4, 2)];
    NSString *content = [readString substringWithRange:NSMakeRange(8, dataLen * 2)];
    //不分包协议
    if ([flag isEqualToString:@"00"]) {
        //读取
        return [self parsePasswordReadData:content cmd:cmd data:readData];
    }
    if ([flag isEqualToString:@"01"]) {
        return [self parsePasswordConfigData:content cmd:cmd];
    }
    return @{};
}

+ (NSDictionary *)parsePasswordReadData:(NSString *)content cmd:(NSString *)cmd data:(NSData *)data {
    mk_bxt_taskOperationID operationID = mk_bxt_defaultTaskOperationID;
    NSDictionary *resultDic = @{};
    
    if ([cmd isEqualToString:@"53"]) {
        //读取设备连接是否需要密码
        operationID = mk_bxt_taskReadNeedPasswordOperation;
        resultDic = @{
            @"state":content
        };
    }
    
    return [self dataParserGetDataSuccess:resultDic operationID:operationID];
}

+ (NSDictionary *)parsePasswordConfigData:(NSString *)content cmd:(NSString *)cmd {
    mk_bxt_taskOperationID operationID = mk_bxt_defaultTaskOperationID;
    BOOL success = [content isEqualToString:@"aa"];
    
    if ([cmd isEqualToString:@"51"]) {
        //验证密码
        operationID = mk_bxt_connectPasswordOperation;
    }else if ([cmd isEqualToString:@"52"]) {
        //修改密码
        operationID = mk_bxt_taskConfigConnectPasswordOperation;
    }else if ([cmd isEqualToString:@"53"]) {
        //是否需要密码验证
        operationID = mk_bxt_taskConfigPasswordVerificationOperation;
    }
    
    return [self dataParserGetDataSuccess:@{@"success":@(success)} operationID:operationID];
}

+ (NSDictionary *)parseCustomData:(NSData *)readData {
    NSString *readString = [MKBLEBaseSDKAdopter hexStringFromData:readData];
    NSString *headerString = [readString substringWithRange:NSMakeRange(0, 2)];
    
    if (![headerString isEqualToString:@"eb"]) {
        return @{};
    }
    NSInteger dataLen = [MKBLEBaseSDKAdopter getDecimalWithHex:readString range:NSMakeRange(6, 2)];
    if (readData.length != dataLen + 4) {
        return @{};
    }
    NSString *flag = [readString substringWithRange:NSMakeRange(2, 2)];
    NSString *cmd = [readString substringWithRange:NSMakeRange(4, 2)];
    NSString *content = [readString substringWithRange:NSMakeRange(8, dataLen * 2)];
    //不分包协议
    if ([flag isEqualToString:@"00"]) {
        //读取
        return [self parseCustomReadData:content cmd:cmd data:readData];
    }
    if ([flag isEqualToString:@"01"]) {
        return [self parseCustomConfigData:content cmd:cmd];
    }
    return @{};
}

+ (NSDictionary *)parseCustomReadData:(NSString *)content cmd:(NSString *)cmd data:(NSData *)data {
    mk_bxt_taskOperationID operationID = mk_bxt_defaultTaskOperationID;
    NSDictionary *resultDic = @{};
    
    if ([cmd isEqualToString:@"20"]) {
        //读取MAC地址
        operationID = mk_bxt_taskReadMacAddressOperation;
        NSString *macAddress = [NSString stringWithFormat:@"%@:%@:%@:%@:%@:%@",[content substringWithRange:NSMakeRange(0, 2)],[content substringWithRange:NSMakeRange(2, 2)],[content substringWithRange:NSMakeRange(4, 2)],[content substringWithRange:NSMakeRange(6, 2)],[content substringWithRange:NSMakeRange(8, 2)],[content substringWithRange:NSMakeRange(10, 2)]];
        resultDic = @{@"macAddress":[macAddress uppercaseString]};
    }else if ([cmd isEqualToString:@"21"]){
        //读取三轴传感器参数
        operationID = mk_bxt_taskReadThreeAxisDataParamsOperation;
        resultDic = @{
                      @"samplingRate":[content substringWithRange:NSMakeRange(0, 2)],
                      @"gravityReference":[content substringWithRange:NSMakeRange(2, 2)],
                      @"motionThreshold":[MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(4, 2)],
                      };
    }else if ([cmd isEqualToString:@"22"]){
        //读取通道广播参数
        operationID = mk_bxt_taskReadSlotParamsOperation;
        NSString *slotIndex = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)];
        NSString *advInterval = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 2)];
        NSString *advDuration = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(4, 4)];
        NSString *standbyDuration = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(8, 4)];
        NSNumber *rssi = [MKBLEBaseSDKAdopter signedHexTurnString:[content substringWithRange:NSMakeRange(12, 2)]];
        NSString *txPower = [MKBXTSDKDataAdopter fetchTxPowerValueString:[content substringWithRange:NSMakeRange(14, 2)]];
        resultDic = @{
            @"slotIndex":slotIndex,
            @"advInterval":advInterval,
            @"advDuration":advDuration,
            @"standbyDuration":standbyDuration,
            @"rssi":[NSString stringWithFormat:@"%@",rssi],
            @"txPower":txPower,
        };
    }else if ([cmd isEqualToString:@"23"]) {
        //读取通道广播内容
        operationID = mk_bxt_taskReadSlotDataOperation;
        resultDic = [MKBXTSDKDataAdopter parseSlotData:content advData:data];
    }else if ([cmd isEqualToString:@"24"]) {
        //读取通道触发条件
        operationID = mk_bxt_taskReadSlotTriggerParamsOperation;
        resultDic = [MKBXTSDKDataAdopter parseSlotTriggerParam:content];
    }else if ([cmd isEqualToString:@"25"]) {
        //读取可连接状态
        operationID = mk_bxt_taskReadConnectableOperation;
        BOOL connectable = [content isEqualToString:@"01"];
        resultDic = @{
            @"connectable":@(connectable)
        };
    }else if ([cmd isEqualToString:@"29"]) {
        //读取霍尔开关机状态
        operationID = mk_bxt_taskReadPowerOffByHallSensorOperation;
        BOOL isOn = [content isEqualToString:@"01"];
        resultDic = @{
            @"isOn":@(isOn)
        };
    }else if ([cmd isEqualToString:@"2f"]) {
        //读取回应包开关
        operationID = mk_bxt_taskReadScanResponsePacketOperation;
        BOOL isOn = [content isEqualToString:@"01"];
        resultDic = @{
            @"isOn":@(isOn)
        };
    }else if ([cmd isEqualToString:@"31"]) {
        //读取全部通道类型
        operationID = mk_bxt_taskReadSlotDataTypeOperation;
        NSArray *typeList = @[[content substringWithRange:NSMakeRange(0, 2)],
                              [content substringWithRange:NSMakeRange(2, 2)],
                              [content substringWithRange:NSMakeRange(4, 2)],
                              [content substringWithRange:NSMakeRange(6, 2)],
                              [content substringWithRange:NSMakeRange(8, 2)],
                              [content substringWithRange:NSMakeRange(10, 2)]];
        resultDic = @{
            @"typeList":typeList,
        };
    }else if ([cmd isEqualToString:@"32"]) {
        //读取触发led提醒状态
        operationID = mk_bxt_taskReadTriggerLEDIndicatorStatusOperation;
        BOOL isOn = [content isEqualToString:@"01"];
        resultDic = @{
            @"isOn":@(isOn)
        };
    }else if ([cmd isEqualToString:@"4a"]) {
        //读取电池电压
        operationID = mk_bxt_taskReadBatteryVoltageOperation;
        NSString *voltage = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"voltage":voltage,
        };
    }else if ([cmd isEqualToString:@"4d"]) {
        //读取移动触发次数
        operationID = mk_bxt_taskReadMotionTriggerCountOperation;
        NSString *count = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"count":count,
        };
    }else if ([cmd isEqualToString:@"4e"]) {
        //读取霍尔传感器触发次数
        operationID = mk_bxt_taskReadHallTriggerCountOperation;
        NSString *count = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"count":count,
        };
    }else if ([cmd isEqualToString:@"4f"]) {
        //读取传感器类型
        operationID = mk_bxt_taskReadSensorStatusOperation;
        NSString *binary = [MKBLEBaseSDKAdopter binaryByhex:[content substringWithRange:NSMakeRange(2, 2)]];
        BOOL threeAxisAccelerometer = [[binary substringWithRange:NSMakeRange(7, 1)] isEqualToString:@"1"];
        BOOL htSensor = [[binary substringWithRange:NSMakeRange(6, 1)] isEqualToString:@"1"];
        resultDic = @{
            @"threeAxisAccelerometer":@(threeAxisAccelerometer),
            @"htSensor":@(htSensor),
        };
    }else if ([cmd isEqualToString:@"5a"]) {
        //读取心跳功能参数
        operationID = mk_bxt_taskReadStaticHeartbeatOperation;
        BOOL isOn = [[content substringWithRange:NSMakeRange(0, 2)] isEqualToString:@"01"];
        NSString *cycleTime = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 4)];
        NSString *advDuration = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(6, 4)];
        resultDic = @{
            @"isOn":@(isOn),
            @"cycleTime":cycleTime,
            @"advDuration":advDuration
        };
    }else if ([cmd isEqualToString:@"5d"]) {
        //读取电池模式
        operationID = mk_bxt_taskReadBatteryModeOperation;
        NSString *mode = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, content.length)];
        resultDic = @{
            @"mode":mode,
        };
    }
    
    return [self dataParserGetDataSuccess:resultDic operationID:operationID];
}

+ (NSDictionary *)parseCustomConfigData:(NSString *)content cmd:(NSString *)cmd {
    mk_bxt_taskOperationID operationID = mk_bxt_defaultTaskOperationID;
    BOOL success = [content isEqualToString:@"aa"];
    
    if ([cmd isEqualToString:@"01"]) {
        //
    }else if ([cmd isEqualToString:@"21"]) {
        //配置三轴传感器参数
        operationID = mk_bxt_taskConfigThreeAxisDataParamsOperation;
    }else if ([cmd isEqualToString:@"22"]) {
        //配置通道广播参数
        operationID = mk_bxt_taskConfigSlotParamOperation;
    }else if ([cmd isEqualToString:@"23"]) {
        //配置通道广播内容
        operationID = mk_bxt_taskConfigSlotDataOperation;
    }else if ([cmd isEqualToString:@"24"]) {
        //配置通道广播触发方式
        operationID = mk_bxt_taskConfigSlotTriggerParamsOperation;
    }else if ([cmd isEqualToString:@"25"]) {
        //配置可连接状态
        operationID = mk_bxt_taskConfigConnectableOperation;
    }else if ([cmd isEqualToString:@"26"]) {
        //关机
        operationID = mk_bxt_taskPowerOffOperation;
    }else if ([cmd isEqualToString:@"28"]) {
        //恢复出厂设置
        operationID = mk_bxt_taskFactoryResetOperation;
    }else if ([cmd isEqualToString:@"29"]) {
        //配置霍尔传感器开关机状态
        operationID = mk_bxt_taskConfigPowerOffByHallSensorOperation;
    }else if ([cmd isEqualToString:@"2f"]) {
        //配置回应包开关状态
        operationID = mk_bxt_taskConfigScanResponsePacketOperation;
    }else if ([cmd isEqualToString:@"32"]) {
        //配置触发led提醒状态
        operationID = mk_bxt_taskConfigTriggerLEDIndicatorStatusOperation;
    }else if ([cmd isEqualToString:@"4d"]) {
        //清除移动触发次数
        operationID = mk_bxt_taskClearMotionTriggerCountOperation;
    }else if ([cmd isEqualToString:@"4e"]) {
        //清除霍尔传感器触发次数
        operationID = mk_bxt_taskClearHallTriggerCountOperation;
    }else if ([cmd isEqualToString:@"59"]) {
        //远程提醒
        operationID = mk_bxt_taskConfigRemoteReminderLEDNotiParamsOperation;
    }else if ([cmd isEqualToString:@"5a"]) {
        //配置心跳功能参数
        operationID = mk_bxt_taskConfigStaticHeartbeatOperation;
    }else if ([cmd isEqualToString:@"5e"]) {
        //重置设备电量
        operationID = mk_bxt_taskResetBatteryOperation;
    }
    
    return [self dataParserGetDataSuccess:@{@"success":@(success)} operationID:operationID];
}

+ (NSDictionary *)parseHallSensorData:(NSData *)readData {
    NSString *readString = [MKBLEBaseSDKAdopter hexStringFromData:readData];
    NSString *headerString = [readString substringWithRange:NSMakeRange(0, 2)];
    
    if (![headerString isEqualToString:@"eb"]) {
        return @{};
    }
    NSInteger dataLen = [MKBLEBaseSDKAdopter getDecimalWithHex:readString range:NSMakeRange(6, 2)];
    if (readData.length != dataLen + 4) {
        return @{};
    }
    NSString *flag = [readString substringWithRange:NSMakeRange(2, 2)];
    NSString *cmd = [readString substringWithRange:NSMakeRange(4, 2)];
    NSString *content = [readString substringWithRange:NSMakeRange(8, dataLen * 2)];
    //不分包协议
    if (![flag isEqualToString:@"00"]) {
        //读取
        return @{};
    }
    mk_bxt_taskOperationID operationID = mk_bxt_defaultTaskOperationID;
    NSDictionary *resultDic = @{};
    if ([cmd isEqualToString:@"05"]) {
        //读取霍尔传感器状态
        operationID = mk_bxt_taskReadMagnetStatusOperation;
        BOOL moved = [content isEqualToString:@"01"];
        resultDic = @{
            @"moved":@(moved)
        };
    }
    
    return [self dataParserGetDataSuccess:resultDic operationID:operationID];
}

#pragma mark -

+ (NSDictionary *)dataParserGetDataSuccess:(NSDictionary *)returnData operationID:(mk_bxt_taskOperationID)operationID{
    if (!returnData) {
        return @{};
    }
    return @{@"returnData":returnData,@"operationID":@(operationID)};
}

@end
