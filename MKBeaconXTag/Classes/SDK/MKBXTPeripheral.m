//
//  MKBXTPeripheral.m
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/7/13.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXTPeripheral.h"

#import <CoreBluetooth/CoreBluetooth.h>

#import "CBPeripheral+MKBXTAdd.h"
#import "MKBXTSDKNormalDefines.h"

@interface MKBXTPeripheral ()

@property (nonatomic, strong)CBPeripheral *peripheral;

@end

@implementation MKBXTPeripheral

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral {
    if (self = [super init]) {
        self.peripheral = peripheral;
    }
    return self;
}

- (void)discoverServices {
    NSArray *services = @[[CBUUID UUIDWithString:@"180A"],  //厂商信息
                          [CBUUID UUIDWithString:@"AA00"],
                          [CBUUID UUIDWithString:kBXTOtaServerUUIDString]]; //自定义
    [self.peripheral discoverServices:services];
}

- (void)discoverCharacteristics {
    for (CBService *service in self.peripheral.services) {
        if ([service.UUID isEqual:[CBUUID UUIDWithString:@"180A"]]) {
            NSArray *characteristics = @[[CBUUID UUIDWithString:@"2A24"],[CBUUID UUIDWithString:@"2A25"],
                                         [CBUUID UUIDWithString:@"2A26"],[CBUUID UUIDWithString:@"2A27"],
                                         [CBUUID UUIDWithString:@"2A28"],[CBUUID UUIDWithString:@"2A29"]];
            [self.peripheral discoverCharacteristics:characteristics forService:service];
        }else if ([service.UUID isEqual:[CBUUID UUIDWithString:@"AA00"]]) {
            NSArray *characteristics = @[[CBUUID UUIDWithString:@"AA01"],[CBUUID UUIDWithString:@"AA02"],
                                         [CBUUID UUIDWithString:@"AA06"],[CBUUID UUIDWithString:@"AA07"],
                                         [CBUUID UUIDWithString:@"AA08"]];
            [self.peripheral discoverCharacteristics:characteristics forService:service];
        }else if ([service.UUID isEqual:[CBUUID UUIDWithString:kBXTOtaServerUUIDString]]) {
            NSArray *characteristics = @[[CBUUID UUIDWithString:kBXTOtaControlUUIDString],
                                         [CBUUID UUIDWithString:kBXTOtaDataUUIDString]];
            [self.peripheral discoverCharacteristics:characteristics forService:service];
        }
    }
}

- (void)updateCharacterWithService:(CBService *)service {
    [self.peripheral bxt_updateCharacterWithService:service];
}

- (void)updateCurrentNotifySuccess:(CBCharacteristic *)characteristic {
    [self.peripheral bxt_updateCurrentNotifySuccess:characteristic];
}

- (BOOL)connectSuccess {
    return [self.peripheral bxt_connectSuccess];
}

- (void)setNil {
    [self.peripheral bxt_setNil];
}

@end
