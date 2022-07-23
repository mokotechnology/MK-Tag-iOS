//
//  MKBXTBaseBeacon.m
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/7/13.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXTBaseBeacon.h"

#import <CoreBluetooth/CoreBluetooth.h>

#import "MKBLEBaseSDKDefines.h"
#import "MKBLEBaseSDKAdopter.h"

#import "MKBXTSDKDataAdopter.h"

@implementation MKBXTBaseBeacon

+ (NSArray <MKBXTBaseBeacon *>*)parseAdvData:(NSDictionary *)advData {
    if (!MKValidDict(advData)) {
        return @[];
    }
    NSDictionary *advDic = advData[CBAdvertisementDataServiceDataKey];
    NSMutableArray *beaconList = [NSMutableArray array];
    NSArray *keys = [advDic allKeys];
    for (id key in keys) {
        if ([key isEqual:[CBUUID UUIDWithString:@"FEAA"]]) {
            NSData *feaaData = advDic[[CBUUID UUIDWithString:@"FEAA"]];
            if (MKValidData(feaaData)) {
                MKBXTDataFrameType frameType = [self fetchFEAAFrameType:feaaData];
                MKBXTBaseBeacon *beacon = [self fetchBaseBeaconWithFrameType:frameType advData:feaaData];
                if (beacon) {
                    [beaconList addObject:beacon];
                }
            }
        }else if ([key isEqual:[CBUUID UUIDWithString:@"FEAB"]]) {
            NSData *feabData = advDic[[CBUUID UUIDWithString:@"FEAB"]];
            if (MKValidData(feabData)) {
                MKBXTDataFrameType frameType = [self fetchFEABFrameType:feabData];
                MKBXTBaseBeacon *beacon = [self fetchBaseBeaconWithFrameType:frameType advData:feabData];
                if ([beacon isKindOfClass:[MKBXTiBeacon class]]) {
                    MKBXTiBeacon *tempBeacon = (MKBXTiBeacon *)beacon;
                    tempBeacon.txPower = advData[CBAdvertisementDataTxPowerLevelKey];
                }
                if (beacon) {
                    [beaconList addObject:beacon];
                }
            }
        }else if ([key isEqual:[CBUUID UUIDWithString:@"EA01"]]) {
            NSData *feaData = advDic[[CBUUID UUIDWithString:@"EA01"]];
            if (MKValidData(feaData)) {
                MKBXTDataFrameType frameType = [self fetchEA01FrameType:feaData];
                MKBXTBaseBeacon *beacon = [self fetchBaseBeaconWithFrameType:frameType advData:feaData];
                if (beacon) {
                    [beaconList addObject:beacon];
                }
            }
        }
    }
    return beaconList;
}

+ (MKBXTBaseBeacon *)fetchBaseBeaconWithFrameType:(MKBXTDataFrameType)frameType advData:(NSData *)advData {
    MKBXTBaseBeacon *beacon = nil;
    switch (frameType) {
        case MKBXTUIDFrameType:
            beacon = [[MKBXTUIDBeacon alloc] initWithAdvertiseData:advData];
            beacon.advertiseData = advData;
            break;
        case MKBXTURLFrameType:
            beacon = [[MKBXTURLBeacon alloc] initWithAdvertiseData:advData];
            beacon.advertiseData = advData;
            break;
        case MKBXTTLMFrameType:
            beacon = [[MKBXTTLMBeacon alloc] initWithAdvertiseData:advData];
            beacon.advertiseData = advData;
            break;
        case MKBXTTagInfoFrameType:
            beacon = [[MKBXTTagInfoBeacon alloc] initWithAdvertiseData:advData];
            beacon.advertiseData = advData;
            break;
        case MKBXTBeaconFrameType:
            beacon = [[MKBXTiBeacon alloc] initWithAdvertiseData:advData];
            beacon.advertiseData = advData;
            break;
        default:
            return nil;
    }
    beacon.frameType = frameType;
    return beacon;
}

+ (MKBXTDataFrameType)parseDataTypeWithSlotData:(NSData *)slotData {
    if (slotData.length == 0) {
        return MKBXTUnknownFrameType;
    }
    const unsigned char *cData = [slotData bytes];
    switch (*cData) {
        case 0x00:
            return MKBXTUIDFrameType;
        case 0x10:
            return MKBXTURLFrameType;
        case 0x20:
            return MKBXTTLMFrameType;
        case 0x80:
            return MKBXTTagInfoFrameType;
        case 0x50:
            return MKBXTBeaconFrameType;
        case 0xff:
            return MKBXTNODATAFrameType;
        default:
            return MKBXTUnknownFrameType;
    }
}

+ (MKBXTDataFrameType)fetchFEAAFrameType:(NSData *)stoneData {
    if (!MKValidData(stoneData)) {
        return MKBXTUnknownFrameType;
    }
    //Eddystone信息帧
    if (stoneData.length == 0) {
        return MKBXTUnknownFrameType;
    }
    const unsigned char *cData = [stoneData bytes];
    switch (*cData) {
        case 0x00:
            return MKBXTUIDFrameType;
        case 0x10:
            return MKBXTURLFrameType;
        case 0x20:
            return MKBXTTLMFrameType;
        default:
            return MKBXTUnknownFrameType;
    }
}

+ (MKBXTDataFrameType)fetchFEABFrameType:(NSData *)customData {
    if (!MKValidData(customData) || customData.length == 0) {
        return MKBXTUnknownFrameType;
    }
    const unsigned char *cData = [customData bytes];
    switch (*cData) {
        case 0x50:
            return MKBXTBeaconFrameType;
        default:
            return MKBXTUnknownFrameType;
    }
}

+ (MKBXTDataFrameType)fetchEA01FrameType:(NSData *)customData {
    if (!MKValidData(customData) || customData.length == 0) {
        return MKBXTUnknownFrameType;
    }
    const unsigned char *cData = [customData bytes];
    switch (*cData) {
        case 0x80:
            return MKBXTTagInfoFrameType;
        default:
            return MKBXTUnknownFrameType;
    }
}

@end

@implementation MKBXTUIDBeacon

- (MKBXTUIDBeacon *)initWithAdvertiseData:(NSData *)advData {
    if (self = [super init]) {
        // On the spec, its 20 bytes. But some beacons doesn't advertise the last 2 RFU bytes.
        if (advData.length < 18) {
            return nil;
        }
        const unsigned char *cData = [advData bytes];
        unsigned char *data;
        // Malloc advertise data for char*
        data = malloc(sizeof(unsigned char) * advData.length);
        NSAssert(data, @"failed to malloc");
        for (int i = 0; i < advData.length; i++) {
            data[i] = *cData++;
        }
        unsigned char txPowerChar = *(data+1);
        if (txPowerChar & 0x80) {
            self.txPower = [NSNumber numberWithInt:(- 0x100 + txPowerChar)];
        }
        else {
            self.txPower = [NSNumber numberWithInt:txPowerChar];
        }
        self.namespaceId = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",*(data+2), *(data+3), *(data+4), *(data+5), *(data+6), *(data+7), *(data+8), *(data+9), *(data+10), *(data+11)];
        self.instanceId = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x",*(data+12), *(data+13), *(data+14), *(data+15), *(data+16), *(data+17)];
        // Free advertise data for char*
        free(data);
    }
    return self;
}

@end

@implementation MKBXTURLBeacon

- (MKBXTURLBeacon *)initWithAdvertiseData:(NSData *)advData {
    if (self = [super init]) {
        NSAssert1(!(advData.length < 3), @"Invalid advertiseData:%@", advData);
        const unsigned char *cData = [advData bytes];
        unsigned char *data;
        // Malloc advertise data for char*
        data = malloc(sizeof(unsigned char) * advData.length);
        if (!data) {
            return nil;
        }
        for (int i = 0; i < advData.length; i++) {
            data[i] = *cData++;
        }
        unsigned char txPowerChar = *(data+1);
        if (txPowerChar & 0x80) {
            self.txPower = [NSNumber numberWithInt:(- 0x100 + txPowerChar)];
        }
        else {
            self.txPower = [NSNumber numberWithInt:txPowerChar];
        }
        NSString *urlScheme = [MKBXTSDKDataAdopter getUrlscheme:*(data+2)];
        
        NSString *url = urlScheme;
        for (int i = 0; i < advData.length - 3; i++) {
            url = [url stringByAppendingString:[MKBXTSDKDataAdopter getEncodedString:*(data + i + 3)]];
        }
        self.shortUrl = url;
        // Free advertise data for char*
        free(data);
    }
    return self;
}

@end

@implementation MKBXTTLMBeacon

- (MKBXTTLMBeacon *)initWithAdvertiseData:(NSData *)advData {
    if (self = [super init]) {
        NSAssert1(!(advData.length < 14), @"Invalid advertiseData:%@", advData);
        
        const unsigned char *cData = [advData bytes];
        unsigned char *data;
        // Malloc advertise data for char*
        data = malloc(sizeof(unsigned char) * advData.length);
        if (!data) {
            return nil;
        }
        for (int i = 0; i < advData.length; i++) {
            data[i] = *cData++;
        }
        /* [TDOO] Set TML Beacon Properties */
        self.version = [NSNumber numberWithInt:*(data+1)];
        self.mvPerbit = [NSNumber numberWithInt:((*(data+2) << 8) + *(data+3))];
        unsigned char temperatureInt = *(data+4);
        if (temperatureInt & 0x80) {
            self.temperature = [NSNumber numberWithFloat:(float)(- 0x100 + temperatureInt) + *(data+5) / 256.0];
        }
        else {
            self.temperature = [NSNumber numberWithFloat:(float)temperatureInt + *(data+5) / 256.0];
        }
        float advertiseCount = (*(data+6) * 16777216) + (*(data+7) * 65536) + (*(data+8) * 256) + *(data+9);
        self.advertiseCount = [NSNumber numberWithLong:advertiseCount];
        float deciSecondsSinceBoot = (((int)(*(data+10) * 16777216) + (int)(*(data+11) * 65536) + (int)(*(data+12) * 256) + *(data+13)) / 10.0);
        self.deciSecondsSinceBoot = [NSNumber numberWithFloat:deciSecondsSinceBoot];
        // Free advertise data for char*
        free(data);
    }
    return self;
}

@end

@implementation MKBXTTagInfoBeacon

- (MKBXTTagInfoBeacon *)initWithAdvertiseData:(NSData *)advData {
    if (self = [super init]) {
        NSAssert1(!(advData.length < 16), @"Invalid advertiseData:%@", advData);
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:advData];
        content = [content substringFromIndex:2];
        NSString *state = [content substringWithRange:NSMakeRange(0, 2)];
        NSString *binary = [MKBLEBaseSDKAdopter binaryByhex:state];
        self.magnetStatus = [[binary substringWithRange:NSMakeRange(7, 1)] isEqualToString:@"1"];
        self.moved = [[binary substringWithRange:NSMakeRange(6, 1)] isEqualToString:@"1"];
        self.triaxialSensor = [[binary substringWithRange:NSMakeRange(6, 1)] isEqualToString:@"1"];
        self.hallSensorCount = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(2, 4)];
        self.movedCount = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(6, 4)];
        self.xData = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(10, 4)];
        self.yData = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(14, 4)];
        self.zData = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(18, 4)];
        self.battery = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(30, 4)];
        self.tagID = [content substringFromIndex:34];
    }
    return self;
}

@end


@implementation MKBXTiBeacon

- (MKBXTiBeacon *)initWithAdvertiseData:(NSData *)advData {
    if (self = [super init]) {
        NSAssert1(!(advData.length < 7), @"Invalid advertiseData:%@", advData);

        const unsigned char *cData = [advData bytes];
        unsigned char *data;
        // Malloc advertise data for char*
        data = malloc(sizeof(unsigned char) * 2);
        if (!data) {
            return nil;
        }
        for (int i = 0; i < 2; i++) {
            data[i] = *cData++;
        }
        unsigned char txPowerChar = *(data+1);
        if (txPowerChar & 0x80) {
            self.rssi1M = [NSNumber numberWithInt:(- 0x100 + txPowerChar)];
        }
        else {
            self.rssi1M = [NSNumber numberWithInt:txPowerChar];
        }
        NSString *content = [MKBLEBaseSDKAdopter hexStringFromData:advData];
        NSString *temp = [content substringWithRange:NSMakeRange(4, content.length - 4)];
        self.interval = [MKBLEBaseSDKAdopter getDecimalStringWithHex:temp range:NSMakeRange(0, 2)];
        NSMutableArray *array = [NSMutableArray arrayWithObjects:[temp substringWithRange:NSMakeRange(2, 8)],
                                 [temp substringWithRange:NSMakeRange(10, 4)],
                                 [temp substringWithRange:NSMakeRange(14, 4)],
                                 [temp substringWithRange:NSMakeRange(18,4)],
                                 [temp substringWithRange:NSMakeRange(22, 12)], nil];
        [array insertObject:@"-" atIndex:1];
        [array insertObject:@"-" atIndex:3];
        [array insertObject:@"-" atIndex:5];
        [array insertObject:@"-" atIndex:7];
        NSString *uuid = @"";
        for (NSString *string in array) {
            uuid = [uuid stringByAppendingString:string];
        }
        self.uuid = [uuid uppercaseString];
        self.major = [NSString stringWithFormat:@"%ld",(long)strtoul([[temp substringWithRange:NSMakeRange(34, 4)] UTF8String],0,16)];
        self.minor = [NSString stringWithFormat:@"%ld",(long)strtoul([[temp substringWithRange:NSMakeRange(38, 4)] UTF8String],0,16)];
        free(data);
    }
    return self;
}

@end

