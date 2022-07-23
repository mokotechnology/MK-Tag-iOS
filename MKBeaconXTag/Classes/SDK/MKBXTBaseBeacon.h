//
//  MKBXTBaseBeacon.h
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/7/13.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Advertising data frame type
 
 - MKBXTUIDFrameType: UID
 - MKBXTURLFrameType: URL
 - MKBXTTLMFrameType: TLM
 - MKBXTTagInfoFrameType: Tag information
 - MKBXTBeaconFrameType: iBeacon
 - MKBXTNODATAFrameType: NO DATA
 - MKBXTUnkonwFrameType: Unknown
 */
typedef NS_ENUM(NSInteger, MKBXTDataFrameType) {
    MKBXTUIDFrameType,
    MKBXTURLFrameType,
    MKBXTTLMFrameType,
    MKBXTTagInfoFrameType,
    MKBXTBeaconFrameType,
    MKBXTNODATAFrameType,
    MKBXTUnknownFrameType,
};

@class CBPeripheral;
@interface MKBXTBaseBeacon : NSObject

/**
 Frame type
 */
@property (nonatomic, assign)MKBXTDataFrameType frameType;
/**
 rssi
 */
@property (nonatomic, strong)NSNumber *rssi;

@property (nonatomic, assign) BOOL connectEnable;

/**
 Scanned device identifier
 */
@property (nonatomic, copy)NSString *identifier;
/**
 Scanned devices
 */
@property (nonatomic, strong)CBPeripheral *peripheral;
/**
 Advertisement data of device
 */
@property (nonatomic, strong)NSData *advertiseData;

@property (nonatomic, copy)NSString *deviceName;

+ (NSArray <MKBXTBaseBeacon *>*)parseAdvData:(NSDictionary *)advData;

+ (MKBXTDataFrameType)parseDataTypeWithSlotData:(NSData *)slotData;

@end

@interface MKBXTUIDBeacon : MKBXTBaseBeacon

//RSSI@0m
@property (nonatomic, strong) NSNumber *txPower;
@property (nonatomic, copy) NSString *namespaceId;
@property (nonatomic, copy) NSString *instanceId;

- (MKBXTUIDBeacon *)initWithAdvertiseData:(NSData *)advData;

@end

@interface MKBXTURLBeacon : MKBXTBaseBeacon

//RSSI@0m
@property (nonatomic, strong) NSNumber *txPower;
//URL Content
@property (nonatomic, copy) NSString *shortUrl;

- (MKBXTURLBeacon *)initWithAdvertiseData:(NSData *)advData;

@end

@interface MKBXTTLMBeacon : MKBXTBaseBeacon

@property (nonatomic, strong) NSNumber *version;
@property (nonatomic, strong) NSNumber *mvPerbit;
@property (nonatomic, strong) NSNumber *temperature;
@property (nonatomic, strong) NSNumber *advertiseCount;
@property (nonatomic, strong) NSNumber *deciSecondsSinceBoot;

- (MKBXTTLMBeacon *)initWithAdvertiseData:(NSData *)advData;

@end

@interface MKBXTTagInfoBeacon : MKBXTBaseBeacon

/// Hall sensor status. 1: The magnet is away (absent); 0: The magnet is close (present).
@property (nonatomic, assign)BOOL magnetStatus;

/// Triaxial sensor status. 1: In progress; 0: Still (No mvt)
@property (nonatomic, assign)BOOL moved;

/// Whether the device has a triaxial sensor.
@property (nonatomic, assign)BOOL triaxialSensor;

/// In the power-on state, the state of the Hall sensor changes every cycle, that is, when the magnet is close, if the magnet is far away, the count will be triggered once, and the count will not be counted when the magnet approaches again. Only the number of times after the Hall trigger is turned on is recorded. If the Hall trigger is set for multiple channels, it will only be counted according to the actual switching times of the Hall switch.
@property (nonatomic, copy)NSString *hallSensorCount;

/// The number of motion triggers, each time the three-axis sensor wakes up from an interrupt, the trigger counts once. Only the number of times after the motion trigger is turned on is recorded. If the motion trigger is set for multiple channels, it will only be counted according to the actual number of sensor interrupts and wake-ups.
@property (nonatomic, copy)NSString *movedCount;

/// X-axis data.(mg)
@property (nonatomic, copy)NSString *xData;

/// Y-axis data.(mg)
@property (nonatomic, copy)NSString *yData;

/// Z-axis data.(mg)
@property (nonatomic, copy)NSString *zData;

/// mV
@property (nonatomic, copy)NSString *battery;

@property (nonatomic, copy)NSString *tagID;

- (MKBXTTagInfoBeacon *)initWithAdvertiseData:(NSData *)advData;

@end

@interface MKBXTiBeacon : MKBXTBaseBeacon

//RSSI@1m
@property (nonatomic, copy)NSNumber *rssi1M;
@property (nonatomic, copy)NSNumber *txPower;
//Advetising Interval
@property (nonatomic, copy) NSString *interval;

@property (nonatomic, copy)NSString *major;

@property (nonatomic, copy)NSString *minor;

@property (nonatomic, copy)NSString *uuid;

- (MKBXTiBeacon *)initWithAdvertiseData:(NSData *)advData;

@end

NS_ASSUME_NONNULL_END
