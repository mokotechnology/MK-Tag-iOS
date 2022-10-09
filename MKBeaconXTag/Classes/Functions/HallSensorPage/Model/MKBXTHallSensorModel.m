//
//  MKBXTHallSensorModel.m
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/7/21.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXTHallSensorModel.h"

#import "MKMacroDefines.h"

#import "MKBXTInterface.h"
#import "MKBXTInterface+MKBXTConfig.h"

@interface MKBXTHallSensorModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKBXTHallSensorModel

- (void)readWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readMagnetStatus]) {
            [self operationFailedBlockWithMsg:@"Read Magnet Status Error" block:failedBlock];
            return;
        }
        if (![self readTriggerCount]) {
            [self operationFailedBlockWithMsg:@"Read Motion trigger count Error" block:failedBlock];
            return;
        }
        if (![self readHallSensorStatus]) {
            [self operationFailedBlockWithMsg:@"Read Power off by hall sensor Error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

#pragma mark - interface

- (BOOL)readMagnetStatus {
    __block BOOL success = NO;
    [MKBXTInterface bxt_readMagnetStatusWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        BOOL moved = [returnData[@"result"][@"moved"] boolValue];
        self.status = (moved ? @"Absent" : @"Present");
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readTriggerCount {
    __block BOOL success = NO;
    [MKBXTInterface bxt_readHallTriggerCountWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.count = returnData[@"result"][@"count"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readHallSensorStatus {
    __block BOOL success = NO;
    [MKBXTInterface bxt_readPowerOffByHallSensorWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.isOn = [returnData[@"result"][@"isOn"] boolValue];
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
        NSError *error = [[NSError alloc] initWithDomain:@"hallSensor"
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
        _readQueue = dispatch_queue_create("hallSensorQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
