//
//  CBPeripheral+MKBXTAdd.h
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/7/13.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBPeripheral (MKBXTAdd)

#pragma mark - 系统信息下面的特征
/// R
@property (nonatomic, strong, readonly)CBCharacteristic *bxt_manufacturer;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *bxt_deviceModel;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *bxt_hardware;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *bxt_software;

/// R
@property (nonatomic, strong, readonly)CBCharacteristic *bxt_firmware;

@property (nonatomic, strong, readonly)CBCharacteristic *bxt_productDate;


#pragma mark - 自定义

/// W/N
@property (nonatomic, strong, readonly)CBCharacteristic *bxt_custom;

/// N
@property (nonatomic, strong, readonly)CBCharacteristic *bxt_disconnectType;

/// N
@property (nonatomic, strong, readonly)CBCharacteristic *bxt_threeSensor;

/// W/N
@property (nonatomic, strong, readonly)CBCharacteristic *bxt_password;

/// R/N
@property (nonatomic, strong, readonly)CBCharacteristic *bxt_hallSensor;

#pragma mark - OTA

@property (nonatomic, strong, readonly)CBCharacteristic *bxt_otaData;

@property (nonatomic, strong, readonly)CBCharacteristic *bxt_otaControl;

- (void)bxt_updateCharacterWithService:(CBService *)service;

- (void)bxt_updateCurrentNotifySuccess:(CBCharacteristic *)characteristic;

- (BOOL)bxt_connectSuccess;

- (void)bxt_setNil;

@end

NS_ASSUME_NONNULL_END
