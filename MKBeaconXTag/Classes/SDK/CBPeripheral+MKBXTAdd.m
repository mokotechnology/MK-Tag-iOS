//
//  CBPeripheral+MKBXTAdd.m
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/7/13.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "CBPeripheral+MKBXTAdd.h"

#import <objc/runtime.h>

#import "MKBXTSDKNormalDefines.h"

static const char *bxt_manufacturerKey = "bxt_manufacturerKey";
static const char *bxt_deviceModelKey = "bxt_deviceModelKey";
static const char *bxt_productDateKey = "bxt_productDateKey";
static const char *bxt_hardwareKey = "bxt_hardwareKey";
static const char *bxt_softwareKey = "bxt_softwareKey";
static const char *bxt_firmwareKey = "bxt_firmwareKey";

static const char *bxt_customKey = "bxt_customKey";
static const char *bxt_disconnectTypeKey = "bxt_disconnectTypeKey";
static const char *bxt_threeSensorKey = "bxt_threeSensorKey";
static const char *bxt_passwordKey = "bxt_passwordKey";
static const char *bxt_hallSensorKey = "bxt_hallSensorKey";

static const char *bxt_otaControlKey = "bxt_otaControlKey";
static const char *bxt_otaDataKey = "bxt_otaDataKey";

static const char *bxt_passwordNotifySuccessKey = "bxt_passwordNotifySuccessKey";
static const char *bxt_disconnectTypeNotifySuccessKey = "bxt_disconnectTypeNotifySuccessKey";
static const char *bxt_customNotifySuccessKey = "bxt_customNotifySuccessKey";

@implementation CBPeripheral (MKMTAdd)

- (void)bxt_updateCharacterWithService:(CBService *)service {
    NSArray *characteristicList = service.characteristics;
    if ([service.UUID isEqual:[CBUUID UUIDWithString:@"180A"]]) {
        //设备信息
        for (CBCharacteristic *characteristic in characteristicList) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A24"]]) {
                objc_setAssociatedObject(self, &bxt_deviceModelKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A25"]]) {
                objc_setAssociatedObject(self, &bxt_productDateKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A26"]]) {
                objc_setAssociatedObject(self, &bxt_firmwareKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A27"]]) {
                objc_setAssociatedObject(self, &bxt_hardwareKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A28"]]) {
                objc_setAssociatedObject(self, &bxt_softwareKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A29"]]) {
                objc_setAssociatedObject(self, &bxt_manufacturerKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
        return;
    }
    if ([service.UUID isEqual:[CBUUID UUIDWithString:@"AA00"]]) {
        //自定义
        for (CBCharacteristic *characteristic in characteristicList) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA01"]]) {
                objc_setAssociatedObject(self, &bxt_customKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                [self setNotifyValue:YES forCharacteristic:characteristic];
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA02"]]) {
                objc_setAssociatedObject(self, &bxt_disconnectTypeKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                [self setNotifyValue:YES forCharacteristic:characteristic];
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA06"]]) {
                objc_setAssociatedObject(self, &bxt_threeSensorKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA07"]]) {
                [self setNotifyValue:YES forCharacteristic:characteristic];
                objc_setAssociatedObject(self, &bxt_passwordKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA08"]]) {
                objc_setAssociatedObject(self, &bxt_hallSensorKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
        return;
    }
    if ([service.UUID isEqual:[CBUUID UUIDWithString:kBXTOtaServerUUIDString]]) {
        //OTA
        for (CBCharacteristic *characteristic in characteristicList) {
            if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kBXTOtaControlUUIDString]]) {
                objc_setAssociatedObject(self, &bxt_otaControlKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:kBXTOtaDataUUIDString]]) {
                objc_setAssociatedObject(self, &bxt_otaDataKey, characteristic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            }
        }
        return;
    }
}

- (void)bxt_updateCurrentNotifySuccess:(CBCharacteristic *)characteristic {
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA01"]]) {
        objc_setAssociatedObject(self, &bxt_customNotifySuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA02"]]) {
        objc_setAssociatedObject(self, &bxt_disconnectTypeNotifySuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"AA07"]]) {
        objc_setAssociatedObject(self, &bxt_passwordNotifySuccessKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        return;
    }
}

- (BOOL)bxt_connectSuccess {
    if (![objc_getAssociatedObject(self, &bxt_customNotifySuccessKey) boolValue] || ![objc_getAssociatedObject(self, &bxt_passwordNotifySuccessKey) boolValue] || ![objc_getAssociatedObject(self, &bxt_disconnectTypeNotifySuccessKey) boolValue]) {
        return NO;
    }
    if (!self.bxt_manufacturer || !self.bxt_deviceModel || !self.bxt_hardware || !self.bxt_software || !self.bxt_firmware || !self.bxt_productDate) {
        return NO;
    }
    if (!self.bxt_password || !self.bxt_disconnectType || !self.bxt_custom || !self.bxt_hallSensor || !self.bxt_threeSensor) {
        return NO;
    }
    return YES;
}

- (void)bxt_setNil {
    objc_setAssociatedObject(self, &bxt_manufacturerKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxt_deviceModelKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxt_productDateKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxt_hardwareKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxt_softwareKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxt_firmwareKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    objc_setAssociatedObject(self, &bxt_passwordKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxt_disconnectTypeKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxt_customKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxt_threeSensorKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxt_hallSensorKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    objc_setAssociatedObject(self, &bxt_otaControlKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxt_otaDataKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    objc_setAssociatedObject(self, &bxt_passwordNotifySuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxt_disconnectTypeNotifySuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &bxt_customNotifySuccessKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - getter

- (CBCharacteristic *)bxt_manufacturer {
    return objc_getAssociatedObject(self, &bxt_manufacturerKey);
}

- (CBCharacteristic *)bxt_deviceModel {
    return objc_getAssociatedObject(self, &bxt_deviceModelKey);
}

- (CBCharacteristic *)bxt_productDate {
    return objc_getAssociatedObject(self, &bxt_productDateKey);
}

- (CBCharacteristic *)bxt_hardware {
    return objc_getAssociatedObject(self, &bxt_hardwareKey);
}

- (CBCharacteristic *)bxt_software {
    return objc_getAssociatedObject(self, &bxt_softwareKey);
}

- (CBCharacteristic *)bxt_firmware {
    return objc_getAssociatedObject(self, &bxt_firmwareKey);
}

- (CBCharacteristic *)bxt_password {
    return objc_getAssociatedObject(self, &bxt_passwordKey);
}

- (CBCharacteristic *)bxt_disconnectType {
    return objc_getAssociatedObject(self, &bxt_disconnectTypeKey);
}

- (CBCharacteristic *)bxt_custom {
    return objc_getAssociatedObject(self, &bxt_customKey);
}

- (CBCharacteristic *)bxt_threeSensor {
    return objc_getAssociatedObject(self, &bxt_threeSensorKey);
}

- (CBCharacteristic *)bxt_hallSensor {
    return objc_getAssociatedObject(self, &bxt_hallSensorKey);
}

- (CBCharacteristic *)bxt_otaData {
    return objc_getAssociatedObject(self, &bxt_otaDataKey);
}

- (CBCharacteristic *)bxt_otaControl {
    return objc_getAssociatedObject(self, &bxt_otaControlKey);
}

@end
