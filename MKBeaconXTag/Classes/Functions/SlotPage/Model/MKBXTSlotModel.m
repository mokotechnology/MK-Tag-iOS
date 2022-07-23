//
//  MKBXTSlotModel.m
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/7/19.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXTSlotModel.h"

#import "MKMacroDefines.h"

#import "MKBXTInterface.h"

@interface MKBXTSlotModel ()

@property (nonatomic, strong)dispatch_queue_t readQueue;

@property (nonatomic, strong)dispatch_semaphore_t semaphore;

@end

@implementation MKBXTSlotModel

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock {
    dispatch_async(self.readQueue, ^{
        if (![self readSlotType]) {
            [self operationFailedBlockWithMsg:@"Read Magnet Status Error" block:failedBlock];
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

- (BOOL)readSlotType {
    __block BOOL success = NO;
    [MKBXTInterface bxt_readSlotDataTypeWithSucBlock:^(id  _Nonnull returnData) {
        success = YES;
        NSArray *typeList = returnData[@"result"][@"typeList"];
        self.slot1 = [self fetchSlotType:typeList[0]];
        self.slot2 = [self fetchSlotType:typeList[1]];
        self.slot3 = [self fetchSlotType:typeList[2]];
        self.slot4 = [self fetchSlotType:typeList[3]];
        self.slot5 = [self fetchSlotType:typeList[4]];
        self.slot6 = [self fetchSlotType:typeList[5]];
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
        NSError *error = [[NSError alloc] initWithDomain:@"slotType"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    });
}

- (NSString *)fetchSlotType:(NSString *)type {
    if ([type isEqualToString:@"00"]) {
        return @"UID";
    }
    if ([type isEqualToString:@"10"]) {
        return @"URL";
    }
    if ([type isEqualToString:@"20"]) {
        return @"TLM";
    }
    if ([type isEqualToString:@"50"]) {
        return @"iBeacon";
    }
    if ([type isEqualToString:@"80"]) {
        return @"Tag info";
    }
    if ([type isEqualToString:@"ff"]) {
        return @"No data";
    }
    return @"";
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
        _readQueue = dispatch_queue_create("slotTypeQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _readQueue;
}

@end
