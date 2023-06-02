//
//  MKBXTAccelerationModel.m
//  MKBeaconXTag_Example
//
//  Created by aa on 2021/3/3.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXTAccelerationModel.h"

#import "MKMacroDefines.h"

#import "MKBXTInterface.h"
#import "MKBXTInterface+MKBXTConfig.h"

@interface MKBXTAccelerationModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKBXTAccelerationModel

- (void)readWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readThreeAccType]) {
            [self operationFailedBlockWithMsg:@"Read Three Acc Type Error" block:failedBlock];
            return;
        }
        if (![self readTriggerParams]) {
            [self operationFailedBlockWithMsg:@"Read Params Error" block:failedBlock];
            return;
        }
        if (![self readTriggerCount]) {
            [self operationFailedBlockWithMsg:@"Read Motion trigger count Error" block:failedBlock];
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
        if (![self configTriggerParams]) {
            [self operationFailedBlockWithMsg:@"Config Params Error" block:failedBlock];
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

- (BOOL)readTriggerParams {
    __block BOOL success = NO;
    [MKBXTInterface bxt_readThreeAxisDataParamsWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.scale = [returnData[@"result"][@"gravityReference"] integerValue];
        self.samplingRate = [returnData[@"result"][@"samplingRate"] integerValue];
        self.threshold = returnData[@"result"][@"motionThreshold"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readTriggerCount {
    __block BOOL success = NO;
    [MKBXTInterface bxt_readMotionTriggerCountWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.triggerCount = returnData[@"result"][@"count"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configTriggerParams {
    __block BOOL success = NO;
    [MKBXTInterface bxt_configThreeAxisDataParams:self.samplingRate acceleration:self.scale motionThreshold:[self.threshold integerValue] sucBlock:^ {
        success = YES;
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)readThreeAccType {
    __block BOOL success = NO;
    [MKBXTInterface bxt_readThreeAxisSensorTypeWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.threeAccType = [returnData[@"result"][@"type"] integerValue];
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
        NSError *error = [[NSError alloc] initWithDomain:@"acceleration"
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
        _readQueue = dispatch_queue_create("accelerationQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
