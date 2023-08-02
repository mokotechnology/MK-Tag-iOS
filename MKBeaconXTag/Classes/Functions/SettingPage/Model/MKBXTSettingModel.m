//
//  MKBXTSettingModel.m
//  MKBeaconXTag_Example
//
//  Created by aa on 2023/6/2.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKBXTSettingModel.h"

#import "MKMacroDefines.h"

#import "MKBXTInterface.h"

@interface MKBXTSettingModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKBXTSettingModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
//        if (![self readBatteryMode]) {
//            [self operationFailedBlockWithMsg:@"Read Battery Mode Error" block:failedBlock];
//            return;
//        }
        if (![self readHallSensorState]) {
            [self operationFailedBlockWithMsg:@"Read Hall Error" block:failedBlock];
            return;
        }
        if (![self readSensorType]) {
            [self operationFailedBlockWithMsg:@"Read Sensor Type Error" block:failedBlock];
            return;
        }
        [self readBatteryMode];
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

#pragma mark - interface
- (BOOL)readBatteryMode {
    __block BOOL success = NO;
    [MKBXTInterface bxt_readBatteryModeWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.supportBatteryReset = ([returnData[@"result"][@"mode"] integerValue] == 1);
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readHallSensorState {
    __block BOOL success = NO;
    [MKBXTInterface bxt_readPowerOffByHallSensorWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.hallStatus = [returnData[@"result"][@"isOn"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readSensorType {
    __block BOOL success = NO;
    [MKBXTInterface bxt_readSensorStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.supportThreeAcc = [returnData[@"result"][@"threeAxisAccelerometer"] boolValue];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}


#pragma mark - private method
- (void)operationFailedBlockWithMsg:(NSString *)msg block:(void (^)(NSError *error))block {
    moko_dispatch_main_safe(^{
        NSError *error = [[NSError alloc] initWithDomain:@"settingPage"
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
        _readQueue = dispatch_queue_create("settingsQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
