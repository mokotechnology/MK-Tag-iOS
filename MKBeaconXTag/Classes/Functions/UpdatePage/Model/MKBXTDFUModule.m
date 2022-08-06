//
//  MKBXTDFUModule.m
//  MKBeaconXTag_Example
//
//  Created by aa on 2021/6/18.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import "MKBXTDFUModule.h"

#import <CoreBluetooth/CoreBluetooth.h>

#import "MKMacroDefines.h"

#import "MKBXTCentralManager.h"

static NSInteger const kBXTOTAByteAlignment = 4;
static unsigned char kBXTOTAByteAlignmentPadding[] = {0xFF, 0xFF, 0xFF, 0xFF};
static char const kBXTInitiateDFUData = 0x00;
static char const kBXTTerminateFimwareUpdateData = 0x03;
static NSInteger const kBXTOTAMaxMtuLen = 100;

typedef NS_ENUM(NSInteger, bxt_ota_process) {
    bxt_ota_process_start,
    bxt_ota_process_reconnect,
    bxt_ota_process_updating,
    bxt_ota_process_complete,
};

@interface MKBXTDFUModule()

@property (nonatomic, strong)CBPeripheral *peripheral;

@property (nonatomic, copy) void (^sucBlock)(void);
@property (nonatomic, copy) void (^failedBlock)(NSError *error);
@property (nonatomic, assign) NSInteger location;
@property (nonatomic, assign) NSInteger length;
@property (nonatomic, strong) NSData *fileData;
@property (nonatomic, assign) bxt_ota_process otaProcess;

@end

@implementation MKBXTDFUModule

- (void)dealloc{
    NSLog(@"MKBXTDFUModule销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - note
- (void)deviceConnectTypeChanged {
    if ([MKBXTCentralManager shared].connectStatus != mk_bxt_centralConnectStatusConnected && self.otaProcess != bxt_ota_process_complete) {
        [self operationFailedBlockWithMsg:@"Dfu Failed!" block:self.failedBlock];
        return;
    }
}

#pragma mark - public method

- (void)updateWithFileUrl:(NSString *)url
                 sucBlock:(void (^)(void))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock{
    if (!ValidStr(url)) {
        [self operationFailedBlockWithMsg:@"The url is invalid!" block:failedBlock];
        return;
    }
    NSData *zipData = [NSData dataWithContentsOfFile:url];
    if (!ValidData(zipData)) {
        [self operationFailedBlockWithMsg:@"Dfu upgrade failure!" block:failedBlock];
        return;
    }
    if ([MKBXTCentralManager shared].connectStatus != mk_bxt_centralConnectStatusConnected) {
        [self operationFailedBlockWithMsg:@"Device is disconnected!" block:failedBlock];
        return;
    }
    if (![[MKBXTCentralManager shared] otaContralCharacteristic]) {
        //Do not support ota.
        [self operationFailedBlockWithMsg:@"The current device does not support OTA" block:failedBlock];
        return;
    }
    self.fileData = nil;
    self.fileData = zipData;
    self.sucBlock = nil;
    self.sucBlock = sucBlock;
    self.failedBlock = nil;
    self.failedBlock = failedBlock;
    self.peripheral = [MKBXTCentralManager shared].peripheral;
    self.location = 0;
    self.length = kBXTOTAMaxMtuLen;
    [[MKBXTCentralManager shared] addCharacteristicWriteBlock:nil];
    self.otaProcess = bxt_ota_process_reconnect;
    [self writeSingleByteValue:kBXTInitiateDFUData
              toCharacteristic:[[MKBXTCentralManager shared] otaContralCharacteristic]];
    
    [[MKBXTCentralManager shared] addCharacteristicWriteBlock:^(CBPeripheral * _Nonnull peripheral, CBCharacteristic * _Nonnull characteristic, NSError * _Nullable error) {
        if (error) {
            if (self.failedBlock) {
                moko_dispatch_main_safe(^{
                    self.failedBlock(error);
                });
            }
            return;
        }
        [self peripheral:peripheral didWriteValueForCharacteristic:characteristic];
    }];
}

#pragma mark - dfu method
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic {
    if ([characteristic isEqual:[[MKBXTCentralManager shared] otaContralCharacteristic]]) {
        if (self.otaProcess == bxt_ota_process_reconnect) {
            if ([[MKBXTCentralManager shared] otaDataCharacteristic]) {
                //当前设备不需要重连
                [[NSNotificationCenter defaultCenter] addObserver:self
                                                         selector:@selector(deviceConnectTypeChanged)
                                                             name:mk_bxt_peripheralConnectStateChangedNotification
                                                           object:nil];
                [self writeFileDataToCharacteristic:[[MKBXTCentralManager shared] otaDataCharacteristic]];
                return;
            }
            [self reconnectDevice];
            return;
        }
        //设备刚进入dfu模式，重连接之后的操作。刚发送完00，设备启动dfu
        if (self.otaProcess == bxt_ota_process_updating) {
            [self writeFileDataToCharacteristic:[[MKBXTCentralManager shared] otaDataCharacteristic]];
            return;
        }
        if (self.otaProcess == bxt_ota_process_complete) {
            if (self.sucBlock) {
                moko_dispatch_main_safe(^{
                    self.sucBlock();
                });
            }
            return;
        }
        return;
    }
    if ([characteristic isEqual:[[MKBXTCentralManager shared] otaDataCharacteristic]]) {
        if (self.location < self.fileData.length) {
            NSLog(@"发送中");
            [self writeFileDataToCharacteristic:characteristic];
            return;
        }
        //需要发送结束标志
        NSLog(@"发送最后一帧升级数据");
        self.otaProcess = bxt_ota_process_complete;
        [self writeSingleByteValue:kBXTTerminateFimwareUpdateData
                  toCharacteristic:[[MKBXTCentralManager shared] otaContralCharacteristic]];
        return;
    }
}

- (void)startDFUProcess {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceConnectTypeChanged)
                                                 name:mk_bxt_peripheralConnectStateChangedNotification
                                               object:nil];
    [self writeSingleByteValue:kBXTInitiateDFUData
              toCharacteristic:[[MKBXTCentralManager shared] otaContralCharacteristic]];
}

- (void)reconnectDevice {
    //重连设备
    [[MKBXTCentralManager shared] disconnect];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[MKBXTCentralManager shared] connectPeripheral:self.peripheral sucBlock:^(CBPeripheral * _Nonnull peripheral) {
            self.otaProcess = bxt_ota_process_updating;
            [self startDFUProcess];
        } failedBlock:^(NSError * _Nonnull error) {
            if (self.failedBlock) {
                self.failedBlock(error);
            }
        }];
    });
}

#pragma mark - Private method

- (void)writeFileDataToCharacteristic:(CBCharacteristic *)characteristic {
    NSData *data;
    if (self.location + self.length > self.fileData.length) {
        NSInteger currentLength = self.fileData.length - self.location;
        NSMutableData *mutableData = [[NSMutableData alloc] initWithData:[self.fileData subdataWithRange:NSMakeRange(self.location, currentLength)]];
        NSInteger lengthPastByteAlignmentBoundary = currentLength % kBXTOTAByteAlignment;
        if (lengthPastByteAlignmentBoundary > 0) {
            NSInteger requiredAdditionalLength = kBXTOTAByteAlignment - lengthPastByteAlignmentBoundary;
            [mutableData appendBytes:kBXTOTAByteAlignmentPadding length:requiredAdditionalLength];
        }
        data = [[NSData alloc] initWithData:mutableData];
        self.location = self.location + currentLength;
    } else {
        data = [self.fileData subdataWithRange:NSMakeRange(self.location, self.length)];
        self.location = self.location + self.length;
    }
    
    [self.peripheral writeValue:data
              forCharacteristic:characteristic
                           type:CBCharacteristicWriteWithResponse];
}

- (void)writeSingleByteValue:(char)value toCharacteristic:(CBCharacteristic *)characteristic {
    NSData *data = [NSData dataWithBytes:&value length:1];
    [[MKBXTCentralManager shared].peripheral writeValue:data
                                      forCharacteristic:characteristic
                                                   type:CBCharacteristicWriteWithResponse];
}

- (void)operationFailedBlockWithMsg:(NSString *)msg block:(void (^)(NSError *error))block {
    moko_dispatch_main_safe(^{
        NSError *error = [[NSError alloc] initWithDomain:@"com.moko.ota"
                                                    code:-999
                                                userInfo:@{@"errorInfo":msg}];
        block(error);
    });
}

@end
