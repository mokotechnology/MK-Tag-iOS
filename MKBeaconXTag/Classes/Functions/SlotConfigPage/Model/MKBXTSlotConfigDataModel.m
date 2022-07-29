//
//  MKBXTSlotConfigDataModel.m
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/7/23.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXTSlotConfigDataModel.h"

#import "MKMacroDefines.h"

#import "MKBXTInterface.h"
#import "MKBXTInterface+MKBXTConfig.h"
#import "MKBXTSDKDataAdopter.h"

@interface MKBXTSlotConfigDataModel ()

@property (nonatomic, assign)NSInteger index;

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKBXTSlotConfigDataModel

- (instancetype)initWithSlotIndex:(NSInteger)index {
    if (self = [self init]) {
        self.index = index;
        self.motionStart = YES;
        self.motionStartInterval = @"50";
        self.motionStartStaticInterval = @"30";
        self.motionStopStaticInterval = @"30";
        self.magneticStart = YES;
        self.magneticInterval = @"50";
    }
    return self;
}

#pragma mark - public method
- (void)readWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readSlotParams]) {
            [self operationFailedBlockWithMsg:@"Read Slot Params Error" block:failedBlock];
            return;
        }
        if (![self readSlotDatas]) {
            [self operationFailedBlockWithMsg:@"Read Slot Datas Error" block:failedBlock];
            return;
        }
        if (![self readSlotTrigger]) {
            [self operationFailedBlockWithMsg:@"Read Slot Trigger Error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

- (void)configWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self validParams]) {
            [self operationFailedBlockWithMsg:@"Params Error" block:failedBlock];
            return;
        }
        if (![self configSlotParams]) {
            [self operationFailedBlockWithMsg:@"Config Slot Params Error" block:failedBlock];
            return;
        }
        if (self.slotType == bxt_slotType_tlm) {
            //TLM
            if (![self configTLM]) {
                [self operationFailedBlockWithMsg:@"Config Slot Data Error" block:failedBlock];
                return;
            }
        }else if (self.slotType == bxt_slotType_uid) {
            if (![self configUID]) {
                [self operationFailedBlockWithMsg:@"Config Slot Data Error" block:failedBlock];
                return;
            }
        }else if (self.slotType == bxt_slotType_url) {
            if (![self configURL]) {
                [self operationFailedBlockWithMsg:@"Config Slot Data Error" block:failedBlock];
                return;
            }
        }else if (self.slotType == bxt_slotType_beacon) {
            if (![self configBeacon]) {
                [self operationFailedBlockWithMsg:@"Config Slot Data Error" block:failedBlock];
                return;
            }
        }else if (self.slotType == bxt_slotType_tagInfo) {
            if (![self configTagInfo]) {
                [self operationFailedBlockWithMsg:@"Config Slot Data Error" block:failedBlock];
                return;
            }
        }
        if (self.triggerIsOn) {
            //打开了触发
            if (self.triggerType == 0) {
                //Motion Trigger
                if (![self configMotionTrigger]) {
                    [self operationFailedBlockWithMsg:@"Config Slot Trigger Error" block:failedBlock];
                    return;
                }
            }else if (self.triggerType == 1) {
                //Magnetic Trigger
                if (![self configMagneticTrigger]) {
                    [self operationFailedBlockWithMsg:@"Config Slot Trigger Error" block:failedBlock];
                    return;
                }
            }else {
                [self operationFailedBlockWithMsg:@"Config Slot Trigger Error" block:failedBlock];
                return;
            }
        }else {
            //关闭触发
            if (![self closeTrigger]) {
                [self operationFailedBlockWithMsg:@"Config Slot Trigger Error" block:failedBlock];
                return;
            }
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

#pragma mark - interface

- (BOOL)readSlotParams {
    __block BOOL success = NO;
    [MKBXTInterface bxt_readSlotParamsWithIndex:self.index sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.advInterval = returnData[@"result"][@"advInterval"];
        self.advDuration = returnData[@"result"][@"advDuration"];
        self.standbyDuration = returnData[@"result"][@"standbyDuration"];
        self.rssi = [returnData[@"result"][@"rssi"] integerValue];
        self.txPower = [self getTxPowerValue:returnData[@"result"][@"txPower"]];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configSlotParams {
    __block BOOL success = NO;
    [MKBXTInterface bxt_configSlotParamWithIndex:self.index
                                     advInterval:[self.advInterval integerValue]
                                     advDuration:[self.advDuration integerValue]
                                 standbyDuration:[self.standbyDuration integerValue]
                                            rssi:self.rssi
                                         txPower:self.txPower
                                        sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    }
                                     failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readSlotDatas {
    __block BOOL success = NO;
    [MKBXTInterface bxt_readSlotDataWithIndex:self.index sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        [self updateSlotDatas:returnData[@"result"]];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configTLM {
    __block BOOL success = NO;
    [MKBXTInterface bxt_configSlotTLMWithIndex:self.index sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configUID {
    __block BOOL success = NO;
    [MKBXTInterface bxt_configSlotUIDWithIndex:self.slotType namespaceID:self.namespaceID instanceID:self.instanceID sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configURL {
    __block BOOL success = NO;
    [MKBXTInterface bxt_configSlotURLWithIndex:self.index urlType:self.urlType urlContent:self.urlContent sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configBeacon {
    __block BOOL success = NO;
    [MKBXTInterface bxt_configSlotBeaconWithIndex:self.index major:[self.major integerValue] minor:[self.minor integerValue] uuid:self.uuid sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configTagInfo {
    __block BOOL success = NO;
    [MKBXTInterface bxt_configSlotTagInfoWithIndex:self.index deviceName:self.deviceName tagID:self.tagID sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readSlotTrigger {
    __block BOOL success = NO;
    [MKBXTInterface bxt_readSlotTriggerParamsWithIndex:self.index sucBlock:^(id  _Nonnull returnData) {
        success = YES;
        [self updateSlotTrigger:returnData[@"result"]];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)closeTrigger {
    __block BOOL success = NO;
    [MKBXTInterface bxt_configSlotTriggerCloseWithIndex:self.index sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configMotionTrigger {
    __block BOOL success = NO;
    NSString *tempValue = self.motionStartStaticInterval;
    if (!self.motionStart) {
        tempValue = self.motionStopStaticInterval;
    }
    [MKBXTInterface bxt_configSlotTriggerMotionDetectionWithIndex:self.index start:self.motionStart advInterval:[self.motionStartInterval integerValue] staticInterval:[tempValue integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configMagneticTrigger {
    __block BOOL success = NO;
    [MKBXTInterface bxt_configSlotTriggerMagneticDetectionWithIndex:self.index start:self.magneticStart advInterval:[self.magneticInterval integerValue] sucBlock:^{
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

#pragma mark - private method
- (void)updateSlotDatas:(NSDictionary *)dic {
    if (!ValidDict(dic)) {
        return;
    }
    NSString *slotType = dic[@"slotType"];
    if ([slotType isEqualToString:@"ff"]) {
        //No Data
        self.slotType = bxt_slotType_null;
        return;
    }
    if ([slotType isEqualToString:@"00"]) {
        //UID
        self.slotType = bxt_slotType_uid;
        self.namespaceID = dic[@"namespaceID"];
        self.instanceID = dic[@"instanceID"];
        return;
    }
    if ([slotType isEqualToString:@"10"]) {
        //URL
        self.slotType = bxt_slotType_url;
        self.urlType = [dic[@"urlType"] integerValue];
        self.urlContent = dic[@"urlContent"];
        return;
    }
    if ([slotType isEqualToString:@"20"]) {
        //TLM
        self.slotType = bxt_slotType_tlm;
        return;
    }
    if ([slotType isEqualToString:@"50"]) {
        //iBeacon
        self.slotType = bxt_slotType_beacon;
        self.major = dic[@"major"];
        self.minor = dic[@"minor"];
        self.uuid = dic[@"uuid"];
        return;
    }
    if ([slotType isEqualToString:@"80"]) {
        //Tag Info
        self.slotType = bxt_slotType_tagInfo;
        self.deviceName = dic[@"deviceName"];
        self.tagID = dic[@"tagID"];
        return;
    }
}

- (void)updateSlotTrigger:(NSDictionary *)dic {
    if (!ValidDict(dic)) {
        return;
    }
    NSString *triggerType = dic[@"triggerType"];
    if (!ValidStr(triggerType)) {
        return;
    }
    if ([triggerType isEqualToString:@"00"]) {
        //Close
        self.triggerIsOn = NO;
        return;
    }
    if ([triggerType isEqualToString:@"05"]) {
        //Motion detection:
        self.triggerIsOn = YES;
        self.triggerType = 0;
        self.motionStart = [dic[@"start"] boolValue];
        self.motionStartInterval = dic[@"advInterval"];
        self.motionStartStaticInterval = dic[@"staticInterval"];
        self.motionStopStaticInterval = dic[@"staticInterval"];
        return;
    }
    if ([triggerType isEqualToString:@"06"]) {
        //Magnetic detection:
        self.triggerIsOn = YES;
        self.triggerType = 1;
        self.magneticStart = [dic[@"start"] boolValue];
        self.magneticInterval = dic[@"advInterval"];
        return;
    }
}

- (NSInteger)getTxPowerValue:(NSString *)power {
    if ([power isEqualToString:@"-40dBm"]) {
        return 0;
    }
    if ([power isEqualToString:@"-20dBm"]) {
        return 1;
    }
    if ([power isEqualToString:@"-16dBm"]) {
        return 2;
    }
    if ([power isEqualToString:@"-12dBm"]) {
        return 3;
    }
    if ([power isEqualToString:@"-8dBm"]) {
        return 4;
    }
    if ([power isEqualToString:@"-4dBm"]) {
        return 5;
    }
    if ([power isEqualToString:@"0dBm"]) {
        return 6;
    }
    if ([power isEqualToString:@"3dBm"]) {
        return 7;
    }
    if ([power isEqualToString:@"4dBm"]) {
        return 8;
    }
    return 0;
}

- (BOOL)validParams {
    if (self.slotType == bxt_slotType_null) {
        //No Data
        return YES;
    }
    if (!ValidStr(self.advInterval) || [self.advInterval integerValue] < 1 || [self.advInterval integerValue] > 100) {
        return NO;
    }
    if (!ValidStr(self.advDuration) || [self.advDuration integerValue] < 1 || [self.advDuration integerValue] > 65535) {
        return NO;
    }
    if (!ValidStr(self.standbyDuration) || [self.standbyDuration integerValue] < 0 || [self.standbyDuration integerValue] > 65535) {
        return NO;
    }
    if (self.slotType != bxt_slotType_tlm) {
        if (self.rssi < -127 || self.rssi > 0) {
            return NO;
        }
    }
    if (self.slotType == bxt_slotType_uid) {
        if (!ValidStr(self.namespaceID) || self.namespaceID.length != 20 || !ValidStr(self.instanceID) || self.instanceID.length != 12) {
            return NO;
        }
    }else if (self.slotType == bxt_slotType_url) {
        NSString *result = [MKBXTSDKDataAdopter fetchUrlString:self.urlType urlContent:self.urlContent];
        if (!ValidStr(result)) {
            return NO;
        }
    }else if (self.slotType == bxt_slotType_beacon) {
        if (!ValidStr(self.major) || ![self.major integerValue] < 0 || [self.major integerValue] > 65535) {
            NO;
        }
        if (!ValidStr(self.minor) || ![self.minor integerValue] < 0 || [self.minor integerValue] > 65535) {
            NO;
        }
        if (!ValidStr(self.uuid) || self.uuid.length != 32) {
            NO;
        }
    }else if (self.slotType == bxt_slotType_tagInfo) {
        if (!ValidStr(self.deviceName) || self.deviceName.length > 20) {
            return NO;
        }
        if (!ValidStr(self.tagID) || self.tagID.length > 12 || (self.tagID.length % 2 != 0)) {
            return NO;
        }
    }
    if (!self.triggerIsOn) {
        return YES;
    }
    if (self.triggerType == 0) {
        //Motion Trigger
        if (self.motionStart) {
            //
            if (!ValidStr(self.motionStartInterval) || [self.motionStartInterval integerValue] < 0 || [self.motionStartInterval integerValue] > 65535) {
                return NO;
            }
            if (!ValidStr(self.motionStartStaticInterval) || [self.motionStartStaticInterval integerValue] < 1 || [self.motionStartStaticInterval integerValue] > 65535) {
                return NO;
            }
        }else {
            if (!ValidStr(self.motionStopStaticInterval) || [self.motionStopStaticInterval integerValue] < 1 || [self.motionStopStaticInterval integerValue] > 65535) {
                return NO;
            }
        }
    }else if (self.triggerType == 1) {
        //Magnetic Trigger
        if (self.magneticStart) {
            //
            if (!ValidStr(self.magneticInterval) || [self.magneticInterval integerValue] < 0 || [self.magneticInterval integerValue] > 65535) {
                return NO;
            }
        }
    }
    return YES;
}

- (void)operationFailedBlockWithMsg:(NSString *)msg block:(void (^)(NSError *error))block {
    moko_dispatch_main_safe(^{
        NSError *error = [[NSError alloc] initWithDomain:@"slotParams"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    });
}

#pragma mark - getter
- (dispatch_semaphore_t)semaphore {
    if (!_semaphore) {
        _semaphore = dispatch_semaphore_create(0);
    }
    return _semaphore;
}

- (dispatch_queue_t)readQueue {
    if (!_readQueue) {
        _readQueue = dispatch_queue_create("slotParamsQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
