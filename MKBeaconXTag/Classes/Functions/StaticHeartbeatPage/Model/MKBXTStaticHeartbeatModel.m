//
//  MKBXTStaticHeartbeatModel.m
//  MKBeaconXTag_Example
//
//  Created by aa on 2023/5/8.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import "MKBXTStaticHeartbeatModel.h"

#import "MKMacroDefines.h"

#import "MKBXTInterface.h"
#import "MKBXTInterface+MKBXTConfig.h"

@interface MKBXTStaticHeartbeatModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKBXTStaticHeartbeatModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readParams]) {
            [self operationFailedBlockWithMsg:@"Read Parmas Error" block:failedBlock];
            return;
        }
        moko_dispatch_main_safe(^{
            if (sucBlock) {
                sucBlock();
            }
        });
    });
}

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self validParams]) {
            [self operationFailedBlockWithMsg:@"Params Error" block:failedBlock];
            return;
        }
        if (![self configParams]) {
            [self operationFailedBlockWithMsg:@"Config Parmas Error" block:failedBlock];
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
- (BOOL)readParams {
    __block BOOL success = NO;
    [MKBXTInterface bxt_readStaticHeartbeatWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        self.isOn = [returnData[@"result"][@"isOn"] boolValue];
        self.cycleTime = returnData[@"result"][@"cycleTime"];
        self.advDuration = returnData[@"result"][@"advDuration"];
        dispatch_semaphore_signal(self.semaphore);
    } failedBlock:^(NSError * _Nonnull error) {
        dispatch_semaphore_signal(self.semaphore);
    }];
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    return success;
}

- (BOOL)configParams {
    __block BOOL success = NO;
    [MKBXTInterface bxt_configStaticHeartbeat:self.isOn cycleTime:[self.cycleTime integerValue] advDuration:[self.advDuration integerValue] sucBlock:^{
        success = YES;
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
        NSError *error = [[NSError alloc] initWithDomain:@"HeartbeatParams"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    })
}

- (BOOL)validParams {
    if (!ValidStr(self.cycleTime) || [self.cycleTime integerValue] < 1 || [self.cycleTime integerValue] > 65535) {
        return NO;
    }
    if (!ValidStr(self.advDuration) || [self.advDuration integerValue] < 1 || [self.advDuration integerValue] > 65535) {
        return NO;
    }
    return YES;
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
        _readQueue = dispatch_queue_create("HeartbeatQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
