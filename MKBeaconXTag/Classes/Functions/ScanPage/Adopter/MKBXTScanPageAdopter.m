//
//  MKBXTScanPageAdopter.m
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/7/17.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXTScanPageAdopter.h"

#import <CoreBluetooth/CoreBluetooth.h>

#import <objc/runtime.h>

#import "MKMacroDefines.h"

#import "MKBXScanBeaconCell.h"
#import "MKBXScanTLMCell.h"
#import "MKBXScanUIDCell.h"
#import "MKBXScanURLCell.h"

#import "MKBXTScanInfoCellModel.h"

#import "MKBXTScanTagInfoCell.h"
#import "MKBXTScanDeviceInfoCell.h"

#import "MKBXTBaseBeacon.h"

#pragma mark - *********************此处分类为了对数据列表里面的设备信息帧数据和设备信息帧数据里面的广播帧数据进行替换和排序使用**********************

static const char *advertiseKey = "advertiseKey";
static const char *indexKey = "indexKey";
static const char *frameTypeKey = "frameTypeKey";

@interface NSObject (MKBXScanAdd)

/// 如果是TLM、温湿度、三轴传感器中的一种，并且设备信息广播帧数组里面已经包含了该种广播帧，根据原始广播数据来判断二者是否一致，如果一致则舍弃，不一致则用新的广播帧替换广播帧数组里的该广播帧
@property (nonatomic, strong)NSData *advertiseData;

/// 用来标示数据model在设备列表或者设备信息广播帧数组里的index
@property (nonatomic, assign)NSInteger index;

/*
 用来对同一个设备的广播帧进行排序，顺序为
 MKBXTUIDFrameType,
 MKBXTURLFrameType,
 MKBXTTLMFrameType,
 MKBXTBeaconFrameType,
 注意，MKBXTTagInfoFrameType为每个section的第一个row数据，不在此进行排列了
 */
@property (nonatomic, assign)NSInteger frameIndex;

@end

@implementation NSObject (MKBXScanAdd)

- (void)setAdvertiseData:(NSData *)advertiseData {
    objc_setAssociatedObject(self, &advertiseKey, advertiseData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSData *)advertiseData {
    return objc_getAssociatedObject(self, &advertiseKey);
}

- (void)setIndex:(NSInteger)index {
    objc_setAssociatedObject(self, &indexKey, @(index), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)index {
    return [objc_getAssociatedObject(self, &indexKey) integerValue];
}

- (void)setFrameIndex:(NSInteger)frameIndex {
    objc_setAssociatedObject(self, &frameTypeKey, @(frameIndex), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSInteger)frameIndex {
    return [objc_getAssociatedObject(self, &frameTypeKey) integerValue];
}

@end




#pragma mark - *****************************MKBXTScanPageAdopter**********************


@implementation MKBXTScanPageAdopter

+ (NSObject *)parseBeaconDatas:(MKBXTBaseBeacon *)beacon {
    if ([beacon isKindOfClass:MKBXTiBeacon.class]) {
        //iBeacon
        MKBXTiBeacon *tempModel = (MKBXTiBeacon *)beacon;
        MKBXScanBeaconCellModel *cellModel = [[MKBXScanBeaconCellModel alloc] init];
        cellModel.rssi = [NSString stringWithFormat:@"%ld",(long)[tempModel.rssi integerValue]];
        cellModel.rssi1M = [NSString stringWithFormat:@"%ld",(long)[tempModel.rssi1M integerValue]];
        cellModel.txPower = [NSString stringWithFormat:@"%ld",(long)[tempModel.txPower integerValue]];
        cellModel.interval = tempModel.interval;
        cellModel.major = tempModel.major;
        cellModel.minor = tempModel.minor;
        cellModel.uuid = [tempModel.uuid lowercaseString];
        return cellModel;
    }
    if ([beacon isKindOfClass:MKBXTTLMBeacon.class]) {
        //TLM
        MKBXTTLMBeacon *tempModel = (MKBXTTLMBeacon *)beacon;
        MKBXScanTLMCellModel *cellModel = [[MKBXScanTLMCellModel alloc] init];
        cellModel.version = [NSString stringWithFormat:@"%@",tempModel.version];
        cellModel.mvPerbit = [NSString stringWithFormat:@"%@",tempModel.mvPerbit];
        cellModel.temperature = [NSString stringWithFormat:@"%@",tempModel.temperature];
        cellModel.advertiseCount = [NSString stringWithFormat:@"%@",tempModel.advertiseCount];
        cellModel.deciSecondsSinceBoot = [NSString stringWithFormat:@"%@",tempModel.deciSecondsSinceBoot];
        return cellModel;
    }
    if ([beacon isKindOfClass:MKBXTUIDBeacon.class]) {
        //UID
        MKBXTUIDBeacon *tempModel = (MKBXTUIDBeacon *)beacon;
        MKBXScanUIDCellModel *cellModel = [[MKBXScanUIDCellModel alloc] init];
        cellModel.txPower = [NSString stringWithFormat:@"%ld",(long)[tempModel.txPower integerValue]];
        cellModel.namespaceId = tempModel.namespaceId;
        cellModel.instanceId = tempModel.instanceId;
        return cellModel;
    }
    if ([beacon isKindOfClass:MKBXTURLBeacon.class]) {
        //URL
        MKBXTURLBeacon *tempModel = (MKBXTURLBeacon *)beacon;
        MKBXScanURLCellModel *cellModel = [[MKBXScanURLCellModel alloc] init];
        cellModel.txPower = [NSString stringWithFormat:@"%ld",(long)[tempModel.txPower integerValue]];
        cellModel.shortUrl = tempModel.shortUrl;
        return cellModel;
    }
    if ([beacon isKindOfClass:MKBXTTagInfoBeacon.class]) {
        //Tag
        MKBXTTagInfoBeacon *tempModel = (MKBXTTagInfoBeacon *)beacon;
        MKBXTScanTagInfoCellModel *cellModel = [[MKBXTScanTagInfoCellModel alloc] init];
        cellModel.magneticStatus = tempModel.magnetStatus;
        cellModel.magneticCount = tempModel.hallSensorCount;
        cellModel.motionStatus = tempModel.moved;
        cellModel.motionCount = tempModel.movedCount;
        cellModel.xData = tempModel.xData;
        cellModel.yData = tempModel.yData;
        cellModel.zData = tempModel.zData;
        return cellModel;
    }
    return nil;
}

+ (MKBXTScanInfoCellModel *)parseBaseBeaconToInfoModel:(MKBXTBaseBeacon *)beacon {
    if (!beacon || ![beacon isKindOfClass:MKBXTBaseBeacon.class]) {
        return [[MKBXTScanInfoCellModel alloc] init];
    }
    MKBXTScanInfoCellModel *deviceModel = [[MKBXTScanInfoCellModel alloc] init];
    deviceModel.identifier = beacon.peripheral.identifier.UUIDString;
    deviceModel.rssi = [NSString stringWithFormat:@"%ld",(long)[beacon.rssi integerValue]];
    deviceModel.deviceName = (ValidStr(beacon.deviceName) ? beacon.deviceName : @"");
    deviceModel.displayTime = @"N/A";
    deviceModel.lastScanDate = [[NSDate date] timeIntervalSince1970] * 1000;
    deviceModel.connectEnable = beacon.connectEnable;
    deviceModel.peripheral = beacon.peripheral;
    if (beacon.frameType == MKBXTTagInfoFrameType) {
        //如果是设备信息帧
        MKBXTTagInfoBeacon *tempInfoModel = (MKBXTTagInfoBeacon *)beacon;
        deviceModel.battery = tempInfoModel.battery;
        deviceModel.tagID = tempInfoModel.tagID;
    }
    //如果是URL、TLM、UID、iBeacon、温湿度、三轴中的一种，直接加入到deviceModel中的数据帧数组里面
    NSObject *obj = [self parseBeaconDatas:beacon];
    if (!obj) {
        return deviceModel;
    }
    NSInteger frameType = [self fetchFrameIndex:obj];
    obj.advertiseData = beacon.advertiseData;
    obj.index = 0;
    obj.frameIndex = frameType;
    [deviceModel.advertiseList addObject:obj];
    
    return deviceModel;
}

+ (void)updateInfoCellModel:(MKBXTScanInfoCellModel *)exsitModel beaconData:(MKBXTBaseBeacon *)beacon {
    exsitModel.connectEnable = beacon.connectEnable;
    exsitModel.peripheral = beacon.peripheral;
    exsitModel.rssi = [NSString stringWithFormat:@"%ld",(long)[beacon.rssi integerValue]];
    if (ValidStr(beacon.deviceName)) {
        exsitModel.deviceName = beacon.deviceName;
    }
    if (exsitModel.lastScanDate > 0) {
        NSTimeInterval space = [[NSDate date] timeIntervalSince1970] * 1000 - exsitModel.lastScanDate;
        if (space > 10) {
            exsitModel.displayTime = [NSString stringWithFormat:@"%@%ld%@",@"<->",(long)space,@"ms"];
            exsitModel.lastScanDate = [[NSDate date] timeIntervalSince1970] * 1000;
        }
    }
    if (beacon.frameType == MKBXTTagInfoFrameType) {
        //设备信息帧
        MKBXTTagInfoBeacon *tempInfoModel = (MKBXTTagInfoBeacon *)beacon;
        exsitModel.battery = tempInfoModel.battery;
        exsitModel.tagID = tempInfoModel.tagID;
    }
    
    //如果是URL、TLM、UID、iBeacon的一种，
    //如果eddStone帧数组里面已经包含该类型数据，则判断是否是TLM，如果是TLM直接替换数组中的数据，如果不是，则判断广播内容是否一样，如果一样，则不处理，如果不一样，直接加入到帧数组
    NSObject *tempModel = [MKBXTScanPageAdopter parseBeaconDatas:beacon];
    if (!tempModel) {
        return;
    }
    NSInteger frameType = [self fetchFrameIndex:tempModel];
    tempModel.advertiseData = beacon.advertiseData;
    tempModel.frameIndex = frameType;
    for (NSObject *model in exsitModel.advertiseList) {
        if ([model.advertiseData isEqualToData:tempModel.advertiseData]) {
            //如果广播内容一样，直接舍弃数据
            return;
        }
        if ([NSStringFromClass(tempModel.class) isEqualToString:NSStringFromClass(model.class)] &&
            ([model isKindOfClass:MKBXScanTLMCellModel.class] || [model isKindOfClass:MKBXTScanTagInfoCellModel.class])) {
            //TLM、Tag需要替换
            tempModel.index = model.index;
            [exsitModel.advertiseList replaceObjectAtIndex:model.index withObject:tempModel];
            return;
        }
    }
    //如果eddStone帧数组里面不包含该数据，直接添加
    [exsitModel.advertiseList addObject:tempModel];
    tempModel.index = exsitModel.advertiseList.count - 1;
    NSArray *tempArray = [NSArray arrayWithArray:exsitModel.advertiseList];
    NSArray *sortedArray = [tempArray sortedArrayUsingComparator:^NSComparisonResult(NSObject *p1, NSObject *p2){
        if (p1.frameIndex > p2.frameIndex) {
            return NSOrderedDescending;
        }else{
            return NSOrderedAscending;
        }
    }];
    [exsitModel.advertiseList removeAllObjects];
    for (NSInteger i = 0; i < sortedArray.count; i ++) {
        NSObject *tempModel = sortedArray[i];
        tempModel.index = i;
        [exsitModel.advertiseList addObject:tempModel];
    }
}

+ (UITableViewCell *)loadCellWithTableView:(UITableView *)tableView dataModel:(NSObject *)dataModel {
    if ([dataModel isKindOfClass:MKBXScanUIDCellModel.class]) {
        //UID
        MKBXScanUIDCell *cell = [MKBXScanUIDCell initCellWithTableView:tableView];
        cell.dataModel = dataModel;
        return cell;
    }
    if ([dataModel isKindOfClass:MKBXScanURLCellModel.class]) {
        //URL
        MKBXScanURLCell *cell = [MKBXScanURLCell initCellWithTableView:tableView];
        cell.dataModel = dataModel;
        return cell;
    }
    if ([dataModel isKindOfClass:MKBXScanTLMCellModel.class]){
        //TLM
        MKBXScanTLMCell *cell = [MKBXScanTLMCell initCellWithTableView:tableView];
        cell.dataModel = dataModel;
        return cell;
    }
    if ([dataModel isKindOfClass:MKBXScanBeaconCellModel.class]){
        //iBeacon
        MKBXScanBeaconCell *cell = [MKBXScanBeaconCell initCellWithTableView:tableView];
        cell.dataModel = dataModel;
        return cell;
    }
    if ([dataModel isKindOfClass:MKBXTScanTagInfoCellModel.class]) {
        //Tag Info
        MKBXTScanTagInfoCell *cell = [MKBXTScanTagInfoCell initCellWithTableView:tableView];
        cell.dataModel = dataModel;
        return cell;
    }
    
    return [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MKBXTScanPageAdopterIdenty"];
}

+ (CGFloat)loadCellHeightWithDataModel:(NSObject *)dataModel {
    if ([dataModel isKindOfClass:MKBXScanUIDCellModel.class]) {
        //UID
        return 85.f;
    }
    if ([dataModel isKindOfClass:MKBXScanURLCellModel.class]) {
        //URL
        return 70.f;
    }
    if ([dataModel isKindOfClass:MKBXScanTLMCellModel.class]){
        //TLM
        return 110.f;
    }
    if ([dataModel isKindOfClass:MKBXScanBeaconCellModel.class]){
        //iBeacon
        MKBXScanBeaconCellModel *model = (MKBXScanBeaconCellModel *)dataModel;
        return [MKBXScanBeaconCell getCellHeightWithUUID:model.uuid];
    }
    if ([dataModel isKindOfClass:MKBXTScanTagInfoCellModel.class]) {
        //Tag Info
        return 140.f;
    }
    return 0;
}

+ (NSInteger)fetchFrameIndex:(NSObject *)dataModel {
    if ([dataModel isKindOfClass:NSClassFromString(@"MKBXScanUIDCellModel")]) {
        //UID
        return 0;
    }
    if ([dataModel isKindOfClass:NSClassFromString(@"MKBXScanURLCellModel")]) {
        //URL
        return 1;
    }
    if ([dataModel isKindOfClass:NSClassFromString(@"MKBXScanTLMCellModel")]) {
        //TLM
        return 2;
    }
    if ([dataModel isKindOfClass:NSClassFromString(@"MKBXScanBeaconCellModel")]) {
        //iBeacon
        return 3;
    }
    if ([dataModel isKindOfClass:NSClassFromString(@"MKBXTScanTagInfoCellModel")]) {
        //Tag Info
        return 4;
    }
    
    return 5;
}

@end
