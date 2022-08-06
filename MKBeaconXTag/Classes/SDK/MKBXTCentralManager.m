//
//  MKBXTCentralManager.m
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/7/13.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXTCentralManager.h"

#import "MKBLEBaseCentralManager.h"
#import "MKBLEBaseSDKDefines.h"
#import "MKBLEBaseSDKAdopter.h"
#import "MKBLEBaseLogManager.h"

#import "MKBXTPeripheral.h"
#import "MKBXTOperation.h"
#import "MKBXTTaskAdopter.h"
#import "CBPeripheral+MKBXTAdd.h"
#import "MKBXTBaseBeacon.h"

NSString *const mk_bxt_peripheralConnectStateChangedNotification = @"mk_bxt_peripheralConnectStateChangedNotification";
NSString *const mk_bxt_centralManagerStateChangedNotification = @"mk_bxt_centralManagerStateChangedNotification";

NSString *const mk_bxt_deviceDisconnectTypeNotification = @"mk_bxt_deviceDisconnectTypeNotification";
NSString *const mk_bxt_receiveThreeAxisDataNotification = @"mk_bxt_receiveThreeAxisDataNotification";
NSString *const mk_bxt_receiveHallSensorStatusChangedNotification = @"mk_bxt_receiveHallSensorStatusChangedNotification";

static MKBXTCentralManager *manager = nil;
static dispatch_once_t onceToken;

//@interface NSObject (MKBXTCentralManager)
//
//@end
//
//@implementation NSObject (MKBXTCentralManager)
//
//+ (void)load{
//    [MKBXTCentralManager shared];
//}
//
//@end

@interface MKBXTCentralManager ()

@property (nonatomic, assign)mk_bxt_centralConnectStatus connectStatus;

@property (nonatomic, copy)void (^sucBlock)(CBPeripheral *peripheral);

@property (nonatomic, copy)void (^failedBlock)(NSError *error);

@property (nonatomic, copy)void (^needPasswordBlock)(NSDictionary *result);

@property (nonatomic, copy)NSString *password;

@property (nonatomic, assign)BOOL readingNeedPassword;

@property (nonatomic, copy)void (^characteristicWriteBlock)(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error);

@end

@implementation MKBXTCentralManager

- (instancetype)init {
    if (self = [super init]) {
        [[MKBLEBaseCentralManager shared] loadDataManager:self];
    }
    return self;
}

+ (MKBXTCentralManager *)shared {
    dispatch_once(&onceToken, ^{
        if (!manager) {
            manager = [MKBXTCentralManager new];
        }
    });
    return manager;
}

+ (void)sharedDealloc {
    [MKBLEBaseCentralManager singleDealloc];
    manager = nil;
    onceToken = 0;
}

+ (void)removeFromCentralList {
    [[MKBLEBaseCentralManager shared] removeDataManager:manager];
    manager = nil;
    onceToken = 0;
}

#pragma mark - MKBLEBaseScanProtocol
- (void)MKBLEBaseCentralManagerDiscoverPeripheral:(CBPeripheral *)peripheral
                                advertisementData:(NSDictionary<NSString *,id> *)advertisementData
                                             RSSI:(NSNumber *)RSSI {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *deviceList = [MKBXTBaseBeacon parseAdvData:advertisementData];
        for (NSInteger i = 0; i < deviceList.count; i ++) {
            MKBXTBaseBeacon *beaconModel = deviceList[i];
            beaconModel.identifier = peripheral.identifier.UUIDString;
            beaconModel.rssi = RSSI;
            beaconModel.peripheral = peripheral;
            beaconModel.deviceName = advertisementData[CBAdvertisementDataLocalNameKey];
            beaconModel.connectEnable = [advertisementData[CBAdvertisementDataIsConnectable] boolValue];
        }
        if ([self.delegate respondsToSelector:@selector(mk_bxt_receiveBeacon:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate mk_bxt_receiveBeacon:deviceList];
            });
        }
    });
}

- (void)MKBLEBaseCentralManagerStartScan {
    if ([self.delegate respondsToSelector:@selector(mk_bxt_startScan)]) {
        [self.delegate mk_bxt_startScan];
    }
}

- (void)MKBLEBaseCentralManagerStopScan {
    if ([self.delegate respondsToSelector:@selector(mk_bxt_stopScan)]) {
        [self.delegate mk_bxt_stopScan];
    }
}

#pragma mark - MKBLEBaseCentralManagerStateProtocol
- (void)MKBLEBaseCentralManagerStateChanged:(MKCentralManagerState)centralManagerState {
    [[NSNotificationCenter defaultCenter] postNotificationName:mk_bxt_centralManagerStateChangedNotification object:nil];
}

- (void)MKBLEBasePeripheralConnectStateChanged:(MKPeripheralConnectState)connectState {
    if (self.readingNeedPassword) {
        //正在读取lockState的时候不对连接状态做出回调
        return;
    }
    //连接成功的判断必须是发送密码成功之后
    if (connectState == MKPeripheralConnectStateUnknow) {
        self.connectStatus = mk_bxt_centralConnectStatusUnknow;
    }else if (connectState == MKPeripheralConnectStateConnecting) {
        self.connectStatus = mk_bxt_centralConnectStatusConnecting;
    }else if (connectState == MKPeripheralConnectStateDisconnect) {
        self.connectStatus = mk_bxt_centralConnectStatusDisconnect;
    }else if (connectState == MKPeripheralConnectStateConnectedFailed) {
        self.connectStatus = mk_bxt_centralConnectStatusConnectedFailed;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:mk_bxt_peripheralConnectStateChangedNotification object:nil];
}

#pragma mark - MKBLEBaseCentralManagerProtocol
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"+++++++++++++++++接收数据出错");
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA02"]]) {
        //引起设备断开连接的类型
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:characteristic.value];
        [[NSNotificationCenter defaultCenter] postNotificationName:mk_bxt_deviceDisconnectTypeNotification
                                                            object:nil
                                                          userInfo:@{@"type":[content substringWithRange:NSMakeRange(8, 2)]}];
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA06"]]) {
        //三轴数据
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:characteristic.value];
        NSNumber *xData = [MKBLEBaseSDKAdopter signedHexTurnString:[content substringWithRange:NSMakeRange(8, 4)]];
        NSString *xDataString = [NSString stringWithFormat:@"%ld",(long)[xData integerValue]];
        NSNumber *yData = [MKBLEBaseSDKAdopter signedHexTurnString:[content substringWithRange:NSMakeRange(12, 4)]];
        NSString *yDataString = [NSString stringWithFormat:@"%ld",(long)[yData integerValue]];
        NSNumber *zData = [MKBLEBaseSDKAdopter signedHexTurnString:[content substringWithRange:NSMakeRange(16, 4)]];
        NSString *zDataString = [NSString stringWithFormat:@"%ld",(long)[zData integerValue]];
        [[NSNotificationCenter defaultCenter] postNotificationName:mk_bxt_receiveThreeAxisDataNotification
                                                            object:nil
                                                          userInfo:@{@"xData":xDataString,
                                                                     @"yData":yDataString,
                                                                     @"zData":zDataString,
                                                                   }];
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA08"]]) {
        //引起设备断开连接的类型
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:characteristic.value];
        BOOL moved = ([[content substringWithRange:NSMakeRange(8, 2)] isEqualToString:@"01"]);
        [[NSNotificationCenter defaultCenter] postNotificationName:mk_bxt_receiveHallSensorStatusChangedNotification
                                                            object:nil
                                                          userInfo:@{@"moved":@(moved)}];
        return;
    }
}
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    if (self.characteristicWriteBlock) {
        self.characteristicWriteBlock(peripheral, characteristic, error);
    }
    if (error) {
        NSLog(@"+++++++++++++++++发送数据出错");
        return;
    }
}

#pragma mark - public method
- (CBCentralManager *)centralManager {
    return [MKBLEBaseCentralManager shared].centralManager;
}

- (CBPeripheral *)peripheral {
    return [MKBLEBaseCentralManager shared].peripheral;
}

- (mk_bxt_centralManagerStatus )centralStatus {
    return ([MKBLEBaseCentralManager shared].centralStatus == MKCentralManagerStateEnable)
    ? mk_bxt_centralManagerStatusEnable
    : mk_bxt_centralManagerStatusUnable;
}

- (nullable CBCharacteristic *)otaContralCharacteristic {
    if (self.connectStatus != mk_bxt_centralConnectStatusConnected || self.peripheral == nil) {
        return nil;
    }
    return self.peripheral.bxt_otaControl;
}

- (nullable CBCharacteristic *)otaDataCharacteristic {
    if (self.connectStatus != mk_bxt_centralConnectStatusConnected || self.peripheral == nil) {
        return nil;
    }
    return self.peripheral.bxt_otaData;
}

- (void)startScan {
    [[MKBLEBaseCentralManager shared] scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:@"FEAA"],
                                                                       [CBUUID UUIDWithString:@"FEAB"],
                                                                       [CBUUID UUIDWithString:@"EA01"]]
                                                             options:nil];
}

- (void)stopScan {
    [[MKBLEBaseCentralManager shared] stopScan];
}

- (void)readNeedPasswordWithPeripheral:(nonnull CBPeripheral *)peripheral
                              sucBlock:(void (^)(NSDictionary *result))sucBlock
                           failedBlock:(void (^)(NSError *error))failedBlock {
    if (self.readingNeedPassword) {
        [self operationFailedBlockWithMsg:@"Device is busy now" failedBlock:failedBlock];
        return;
    }
    self.readingNeedPassword = YES;
    self.needPasswordBlock = nil;
    self.failedBlock = nil;
    self.failedBlock = failedBlock;
    __weak typeof(self) weakSelf = self;
    self.needPasswordBlock = ^(NSDictionary *result) {
        __strong typeof(self) sself = weakSelf;
        if (!MKValidDict(result)) {
            [sself clearAllParams];
            [self operationFailedBlockWithMsg:@"Read Error" failedBlock:failedBlock];
            return;
        }
        [sself clearAllParams];
        if (sucBlock) {
            MKBLEBase_main_safe(^{sucBlock(result);});
        }
    };
    MKBXTPeripheral *bxbPeripheral = [[MKBXTPeripheral alloc] initWithPeripheral:peripheral];
    [[MKBLEBaseCentralManager shared] connectDevice:bxbPeripheral sucBlock:^(CBPeripheral * _Nonnull peripheral) {
        [self confirmNeedPassword];
    } failedBlock:^(NSError * _Nonnull error) {
        __strong typeof(self) sself = weakSelf;
        [sself clearAllParams];
        if (failedBlock) {
            failedBlock(error);
        }
    }];
}

- (void)connectPeripheral:(CBPeripheral *)peripheral
                 password:(NSString *)password
                 sucBlock:(void (^)(CBPeripheral * _Nonnull))sucBlock
              failedBlock:(void (^)(NSError * error))failedBlock {
    if (!peripheral) {
        [MKBLEBaseSDKAdopter operationConnectFailedBlock:failedBlock];
        return;
    }
    if (!MKValidStr(password) || password.length > 16 || ![MKBLEBaseSDKAdopter asciiString:password]) {
        [self operationFailedBlockWithMsg:@"The password should be no more than 16 characters." failedBlock:failedBlock];
        return;
    }
    self.password = @"";
    self.password = password;
    __weak typeof(self) weakSelf = self;
    [self connectPeripheral:peripheral successBlock:^(CBPeripheral *peripheral) {
        __strong typeof(self) sself = weakSelf;
        sself.sucBlock = nil;
        sself.failedBlock = nil;
        if (sucBlock) {
            sucBlock(peripheral);
        }
    } failedBlock:^(NSError *error) {
        __strong typeof(self) sself = weakSelf;
        sself.sucBlock = nil;
        sself.failedBlock = nil;
        if (failedBlock) {
            failedBlock(error);
        }
    }];
}

- (void)connectPeripheral:(nonnull CBPeripheral *)peripheral
                 sucBlock:(void (^)(CBPeripheral *peripheral))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock {
    if (!peripheral) {
        [MKBLEBaseSDKAdopter operationConnectFailedBlock:failedBlock];
        return;
    }
    self.password = @"";
    __weak typeof(self) weakSelf = self;
    [self connectPeripheral:peripheral successBlock:^(CBPeripheral *peripheral) {
        __strong typeof(self) sself = weakSelf;
        sself.sucBlock = nil;
        sself.failedBlock = nil;
        if (sucBlock) {
            sucBlock(peripheral);
        }
    } failedBlock:^(NSError *error) {
        __strong typeof(self) sself = weakSelf;
        sself.sucBlock = nil;
        sself.failedBlock = nil;
        if (failedBlock) {
            failedBlock(error);
        }
    }];
}

- (void)disconnect {
    [[MKBLEBaseCentralManager shared] disconnect];
}

- (void)addTaskWithTaskID:(mk_bxt_taskOperationID)operationID
           characteristic:(CBCharacteristic *)characteristic
              commandData:(NSString *)commandData
             successBlock:(void (^)(id returnData))successBlock
             failureBlock:(void (^)(NSError *error))failureBlock {
    MKBXTOperation <MKBLEBaseOperationProtocol>*operation = [self generateOperationWithOperationID:operationID
                                                                                    characteristic:characteristic
                                                                                       commandData:commandData
                                                                                      successBlock:successBlock
                                                                                      failureBlock:failureBlock];
    if (!operation) {
        return;
    }
    [[MKBLEBaseCentralManager shared] addOperation:operation];
}

- (void)addReadTaskWithTaskID:(mk_bxt_taskOperationID)operationID
               characteristic:(CBCharacteristic *)characteristic
                 successBlock:(void (^)(id returnData))successBlock
                 failureBlock:(void (^)(NSError *error))failureBlock {
    MKBXTOperation <MKBLEBaseOperationProtocol>*operation = [self generateReadOperationWithOperationID:operationID
                                                                                        characteristic:characteristic
                                                                                          successBlock:successBlock
                                                                                          failureBlock:failureBlock];
    if (!operation) {
        return;
    }
    [[MKBLEBaseCentralManager shared] addOperation:operation];
}

- (void)addCharacteristicWriteBlock:(void (^)(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error))block {
    self.characteristicWriteBlock = nil;
    self.characteristicWriteBlock = block;
}

- (BOOL)notifyThreeAxisData:(BOOL)notify {
    if (self.connectStatus != mk_bxt_centralConnectStatusConnected || self.peripheral == nil || self.peripheral.bxt_threeSensor == nil) {
        return NO;
    }
    [self.peripheral setNotifyValue:notify forCharacteristic:self.peripheral.bxt_threeSensor];
    return YES;
}

- (BOOL)notifyHallSensorData:(BOOL)notify {
    if (self.connectStatus != mk_bxt_centralConnectStatusConnected || self.peripheral == nil || self.peripheral.bxt_hallSensor == nil) {
        return NO;
    }
    [self.peripheral setNotifyValue:notify forCharacteristic:self.peripheral.bxt_hallSensor];
    return YES;
}

#pragma mark - password method
- (void)connectPeripheral:(CBPeripheral *)peripheral
             successBlock:(void (^)(CBPeripheral *peripheral))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock {
    self.sucBlock = nil;
    self.sucBlock = sucBlock;
    self.failedBlock = nil;
    self.failedBlock = failedBlock;
    MKBXTPeripheral *bxbPeripheral = [[MKBXTPeripheral alloc] initWithPeripheral:peripheral];
    [[MKBLEBaseCentralManager shared] connectDevice:bxbPeripheral sucBlock:^(CBPeripheral * _Nonnull peripheral) {
        if (MKValidStr(self.password) && self.password.length <= 16) {
            //需要密码登录
            [self sendPasswordToDevice];
            return;
        }
        //免密登录
        MKBLEBase_main_safe(^{
            self.connectStatus = mk_bxt_centralConnectStatusConnected;
            [[NSNotificationCenter defaultCenter] postNotificationName:mk_bxt_peripheralConnectStateChangedNotification object:nil];
            if (self.sucBlock) {
                self.sucBlock(peripheral);
            }
        });
    } failedBlock:failedBlock];
}

- (void)sendPasswordToDevice {
    NSString *lenString = [NSString stringWithFormat:@"%1lx",(long)self.password.length];
    if (lenString.length == 1) {
        lenString = [@"0" stringByAppendingString:lenString];
    }
    NSString *commandData = [@"ea0151" stringByAppendingString:lenString];
    for (NSInteger i = 0; i < self.password.length; i ++) {
        int asciiCode = [self.password characterAtIndex:i];
        commandData = [commandData stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
    }
    __weak typeof(self) weakSelf = self;
    MKBXTOperation *operation = [[MKBXTOperation alloc] initOperationWithID:mk_bxt_connectPasswordOperation commandBlock:^{
        [[MKBLEBaseCentralManager shared] sendDataToPeripheral:commandData characteristic:[MKBLEBaseCentralManager shared].peripheral.bxt_password type:CBCharacteristicWriteWithResponse];
    } completeBlock:^(NSError * _Nullable error, id  _Nullable returnData) {
        __strong typeof(self) sself = weakSelf;
        if (error || !MKValidDict(returnData) || ![returnData[@"success"] boolValue]) {
            //密码错误
            [sself operationFailedBlockWithMsg:@"Password Error" failedBlock:sself.failedBlock];
            return ;
        }
        //密码正确
        MKBLEBase_main_safe(^{
            sself.connectStatus = mk_bxt_centralConnectStatusConnected;
            [[NSNotificationCenter defaultCenter] postNotificationName:mk_bxt_peripheralConnectStateChangedNotification object:nil];
            if (sself.sucBlock) {
                sself.sucBlock([MKBLEBaseCentralManager shared].peripheral);
            }
        });
    }];
    [[MKBLEBaseCentralManager shared] addOperation:operation];
}

- (void)confirmNeedPassword {
    NSString *commandData = @"ea005300";
    __weak typeof(self) weakSelf = self;
    MKBXTOperation *operation = [[MKBXTOperation alloc] initOperationWithID:mk_bxt_taskReadNeedPasswordOperation commandBlock:^{
        [[MKBLEBaseCentralManager shared] sendDataToPeripheral:commandData characteristic:[MKBLEBaseCentralManager shared].peripheral.bxt_password type:CBCharacteristicWriteWithResponse];
    } completeBlock:^(NSError * _Nullable error, id  _Nullable returnData) {
        __strong typeof(self) sself = weakSelf;
        //读取成功
        MKBLEBase_main_safe(^{
            if (sself.needPasswordBlock) {
                sself.needPasswordBlock(returnData);
            }
        });
    }];
    [[MKBLEBaseCentralManager shared] addOperation:operation];
}

#pragma mark - task method
- (MKBXTOperation <MKBLEBaseOperationProtocol>*)generateOperationWithOperationID:(mk_bxt_taskOperationID)operationID
                                                                  characteristic:(CBCharacteristic *)characteristic
                                                                     commandData:(NSString *)commandData
                                                                    successBlock:(void (^)(id returnData))successBlock
                                                                    failureBlock:(void (^)(NSError *error))failureBlock{
    if (![[MKBLEBaseCentralManager shared] readyToCommunication]) {
        [self operationFailedBlockWithMsg:@"The current connection device is in disconnect" failedBlock:failureBlock];
        return nil;
    }
    if (!MKValidStr(commandData)) {
        [self operationFailedBlockWithMsg:@"The data sent to the device cannot be empty" failedBlock:failureBlock];
        return nil;
    }
    if (!characteristic) {
        [self operationFailedBlockWithMsg:@"Characteristic error" failedBlock:failureBlock];
        return nil;
    }
    __weak typeof(self) weakSelf = self;
    MKBXTOperation <MKBLEBaseOperationProtocol>*operation = [[MKBXTOperation alloc] initOperationWithID:operationID commandBlock:^{
        [[MKBLEBaseCentralManager shared] sendDataToPeripheral:commandData characteristic:characteristic type:CBCharacteristicWriteWithResponse];
    } completeBlock:^(NSError * _Nullable error, id  _Nullable returnData) {
        __strong typeof(self) sself = weakSelf;
        if (error) {
            MKBLEBase_main_safe(^{
                if (failureBlock) {
                    failureBlock(error);
                }
            });
            return ;
        }
        if (!returnData) {
            [sself operationFailedBlockWithMsg:@"Request data error" failedBlock:failureBlock];
            return ;
        }
        NSDictionary *resultDic = @{@"msg":@"success",
                                    @"code":@"1",
                                    @"result":returnData,
                                    };
        MKBLEBase_main_safe(^{
            if (successBlock) {
                successBlock(resultDic);
            }
        });
    }];
    return operation;
}

- (MKBXTOperation <MKBLEBaseOperationProtocol>*)generateReadOperationWithOperationID:(mk_bxt_taskOperationID)operationID
                                                                      characteristic:(CBCharacteristic *)characteristic
                                                                        successBlock:(void (^)(id returnData))successBlock
                                                                        failureBlock:(void (^)(NSError *error))failureBlock{
    if (![[MKBLEBaseCentralManager shared] readyToCommunication]) {
        [self operationFailedBlockWithMsg:@"The current connection device is in disconnect" failedBlock:failureBlock];
        return nil;
    }
    if (!characteristic) {
        [self operationFailedBlockWithMsg:@"Characteristic error" failedBlock:failureBlock];
        return nil;
    }
    __weak typeof(self) weakSelf = self;
    MKBXTOperation <MKBLEBaseOperationProtocol>*operation = [[MKBXTOperation alloc] initOperationWithID:operationID commandBlock:^{
        [[MKBLEBaseCentralManager shared].peripheral readValueForCharacteristic:characteristic];
    } completeBlock:^(NSError * _Nullable error, id  _Nullable returnData) {
        __strong typeof(self) sself = weakSelf;
        if (error) {
            MKBLEBase_main_safe(^{
                if (failureBlock) {
                    failureBlock(error);
                }
            });
            return ;
        }
        if (!returnData) {
            [sself operationFailedBlockWithMsg:@"Request data error" failedBlock:failureBlock];
            return ;
        }
        NSDictionary *resultDic = @{@"msg":@"success",
                                    @"code":@"1",
                                    @"result":returnData,
                                    };
        MKBLEBase_main_safe(^{
            if (successBlock) {
                successBlock(resultDic);
            }
        });
    }];
    return operation;
}

- (void)clearAllParams {
    self.sucBlock = nil;
    self.failedBlock = nil;
    self.characteristicWriteBlock = nil;
    if (!self.needPasswordBlock) {
        return;
    }
    //读取是否需要密码
    [self disconnect];
    self.needPasswordBlock = nil;
    self.readingNeedPassword = NO;
}

- (void)operationFailedBlockWithMsg:(NSString *)message failedBlock:(void (^)(NSError *error))failedBlock {
    NSError *error = [[NSError alloc] initWithDomain:@"com.moko.BXBCentralManager"
                                                code:-999
                                            userInfo:@{@"errorInfo":message}];
    MKBLEBase_main_safe(^{
        if (failedBlock) {
            failedBlock(error);
        }
    });
}

@end
