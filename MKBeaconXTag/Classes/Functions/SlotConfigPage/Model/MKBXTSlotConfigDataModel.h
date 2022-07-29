//
//  MKBXTSlotConfigDataModel.h
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/7/23.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MKBXTSlotConfigDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKBXTSlotConfigDataModel : NSObject

@property (nonatomic, assign)bxt_slotType slotType;

#pragma mark - advContent Param
@property (nonatomic, copy)NSString *advInterval;

@property (nonatomic, copy)NSString *advDuration;

@property (nonatomic, copy)NSString *standbyDuration;

@property (nonatomic, assign)NSInteger rssi;

/*
 0:-40dBm
 1:-20dBm
 2:-16dBm
 3:-12dBm
 4:-8dBm
 5:-4dBm
 6:0dBm
 7:3dBm
 8:4dBm
 */
@property (nonatomic, assign)NSInteger txPower;

#pragma mark - UID
@property (nonatomic, copy)NSString *namespaceID;

@property (nonatomic, copy)NSString *instanceID;

#pragma mark - iBeacon
@property (nonatomic, copy)NSString *major;

@property (nonatomic, copy)NSString *minor;

@property (nonatomic, copy)NSString *uuid;

#pragma mark - Tag Info
@property (nonatomic, copy)NSString *deviceName;

@property (nonatomic, copy)NSString *tagID;

#pragma mark - URL
/// 0:@"http://www.",1:@"https://www.",2:@"http://",3:@"https://"
@property (nonatomic, assign)NSInteger urlType;

@property (nonatomic, copy)NSString *urlContent;

#pragma mark - Trigger
@property (nonatomic, assign)BOOL triggerIsOn;

/// 0:Motion detection   1:Magnetic detection
@property (nonatomic, assign)NSInteger triggerType;

#pragma mark - Motion Trigger(triggerType = 0)

/// 触发后广播状态
@property (nonatomic, assign)BOOL motionStart;

@property (nonatomic, copy)NSString *motionStartInterval;

@property (nonatomic, copy)NSString *motionStartStaticInterval;

@property (nonatomic, copy)NSString *motionStopStaticInterval;

#pragma mark - Magnetic Trigger(triggerType = 1)

/// 触发后广播状态
@property (nonatomic, assign)BOOL magneticStart;

@property (nonatomic, copy)NSString *magneticInterval;


- (instancetype)initWithSlotIndex:(NSInteger)index;

- (void)readWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
