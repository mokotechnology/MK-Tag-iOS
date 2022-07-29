//
//  MKBXTSDKDataAdopter.m
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/7/13.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXTSDKDataAdopter.h"

#import "MKBLEBaseSDKAdopter.h"
#import "MKBLEBaseSDKDefines.h"

@implementation MKBXTSDKDataAdopter

+ (NSString *)getUrlscheme:(char)hexChar{
    switch (hexChar) {
        case 0x00:
            return @"http://www.";
        case 0x01:
            return @"https://www.";
        case 0x02:
            return @"http://";
        case 0x03:
            return @"https://";
        default:
            return @"";
    }
}

+ (NSString *)getEncodedString:(char)hexChar{
    switch (hexChar) {
        case 0x00:
            return @".com/";
        case 0x01:
            return @".org/";
        case 0x02:
            return @".edu/";
        case 0x03:
            return @".net/";
        case 0x04:
            return @".info/";
        case 0x05:
            return @".biz/";
        case 0x06:
            return @".gov/";
        case 0x07:
            return @".com";
        case 0x08:
            return @".org";
        case 0x09:
            return @".edu";
        case 0x0a:
            return @".net";
        case 0x0b:
            return @".info";
        case 0x0c:
            return @".biz";
        case 0x0d:
            return @".gov";
        default:
            return [NSString stringWithFormat:@"%c", hexChar];
    }
}

+ (NSString *)fetchThreeAxisDataRate:(mk_bxt_threeAxisDataRate)dataRate {
    switch (dataRate) {
        case mk_bxt_threeAxisDataRate1hz:
            return @"00";
        case mk_bxt_threeAxisDataRate10hz:
            return @"01";
        case mk_bxt_threeAxisDataRate25hz:
            return @"02";
        case mk_bxt_threeAxisDataRate50hz:
            return @"03";
        case mk_bxt_threeAxisDataRate100hz:
            return @"04";
    }
}

+ (NSString *)fetchThreeAxisDataAG:(mk_bxt_threeAxisDataAG)ag {
    switch (ag) {
        case mk_bxt_threeAxisDataAG0:
            return @"00";
        case mk_bxt_threeAxisDataAG1:
            return @"01";
        case mk_bxt_threeAxisDataAG2:
            return @"02";
        case mk_bxt_threeAxisDataAG3:
            return @"03";
    }
}

+ (NSString *)fetchTxPower:(mk_bxt_txPower)txPower {
    switch (txPower) {
        case mk_bxt_txPower4dBm:
            return @"04";
            
        case mk_bxt_txPower3dBm:
            return @"03";
            
        case mk_bxt_txPower0dBm:
            return @"00";
            
        case mk_bxt_txPowerNeg4dBm:
            return @"fc";
            
        case mk_bxt_txPowerNeg8dBm:
            return @"f8";
            
        case mk_bxt_txPowerNeg12dBm:
            return @"f4";
            
        case mk_bxt_txPowerNeg16dBm:
            return @"f0";
            
        case mk_bxt_txPowerNeg20dBm:
            return @"ec";
            
        case mk_bxt_txPowerNeg40dBm:
            return @"d8";
    }
}

+ (NSString *)fetchTxPowerValueString:(NSString *)content {
    if ([content isEqualToString:@"04"]) {
        return @"4dBm";
    }
    if ([content isEqualToString:@"03"]) {
        return @"3dBm";
    }
    if ([content isEqualToString:@"00"]) {
        return @"0dBm";
    }
    if ([content isEqualToString:@"fc"]) {
        return @"-4dBm";
    }
    if ([content isEqualToString:@"f8"]) {
        return @"-8dBm";
    }
    if ([content isEqualToString:@"f4"]) {
        return @"-12dBm";
    }
    if ([content isEqualToString:@"f0"]) {
        return @"-16dBm";
    }
    if ([content isEqualToString:@"ec"]) {
        return @"-20dBm";
    }
    if ([content isEqualToString:@"d8"]) {
        return @"-40dBm";
    }
    return @"0dBm";
}

+ (NSDictionary *)parseSlotData:(NSString *)content advData:(NSData *)advData {
    if (content.length < 4 || advData.length < 6) {
        return @{};
    }
    NSString *slotIndex = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)];
    NSString *slotType = [content substringWithRange:NSMakeRange(2, 2)];
    if ([[slotType uppercaseString] isEqualToString:@"FF"]) {
        //No Data
        return @{
            @"slotIndex":slotIndex,
            @"slotType":slotType,
        };
    }
    if ([slotType isEqualToString:@"00"] && content.length == 36) {
        //UID
        NSString *namespaceID = [content substringWithRange:NSMakeRange(4, 20)];
        NSString *instanceID = [content substringWithRange:NSMakeRange(24, 12)];
        return @{
            @"slotIndex":slotIndex,
            @"slotType":slotType,
            @"namespaceID":namespaceID,
            @"instanceID":instanceID
        };
    }
    if ([slotType isEqualToString:@"10"] && content.length > 8) {
        //URL
        NSString *urlType = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(4, 2)];
        NSData *subData = [advData subdataWithRange:NSMakeRange(7, advData.length - 7)];
        NSString *urlContent = @"";
        
        const unsigned char *cData = [subData bytes];
        unsigned char *data = malloc(sizeof(unsigned char) * subData.length);
        if (!data) {
            return @{};
        }
        for (int i = 0; i < subData.length; i++) {
            data[i] = *cData++;
        }
        for (int i = 0; i < advData.length - 3; i++) {
            urlContent = [urlContent stringByAppendingString:[self getEncodedString:*(data + i + 3)]];
        }
        
        return @{
            @"slotIndex":slotIndex,
            @"slotType":slotType,
            @"urlType":urlType,
            @"urlContent":urlContent,
            @"advData":advData
        };
    }
    if ([slotType isEqualToString:@"20"]) {
        //TLM
        return @{
            @"slotIndex":slotIndex,
            @"slotType":slotType,
        };
    }
    if ([slotType isEqualToString:@"50"] && content.length == 44) {
        //iBeacon
        NSString *major = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(4, 4)];
        NSString *minor = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(8, 4)];
        NSString *uuid = [content substringWithRange:NSMakeRange(12, 32)];
        return @{
            @"slotIndex":slotIndex,
            @"slotType":slotType,
            @"major":major,
            @"minor":minor,
            @"uuid":uuid
        };
    }
    if ([slotType isEqualToString:@"80"] && content.length > 3) {
        //Tag Info
        NSInteger nameLen = [MKBLEBaseSDKAdopter getDecimalWithHex:content range:NSMakeRange(4, 2)];
        NSString *deviceName = [[NSString alloc] initWithData:[advData subdataWithRange:NSMakeRange(7, nameLen)] encoding:NSUTF8StringEncoding];
        NSInteger tagLen = [MKBLEBaseSDKAdopter getDecimalWithHex:content range:NSMakeRange(6 + 2 * nameLen, 2)];
        NSString *tagID = [content substringFromIndex:(6 + 2 * nameLen + 2)];
        return @{
            @"slotIndex":slotIndex,
            @"slotType":slotType,
            @"deviceName":deviceName,
            @"tagID":tagID
        };
    }
    return @{};
}

+ (NSString *)fetchUrlString:(mk_bxt_urlHeaderType)urlType urlContent:(NSString *)urlContent {
    if (!MKValidStr(urlContent)) {
        return @"";
    }
    NSString *header = @"";
    if (urlType == mk_bxt_urlHeaderType1) {
        header = @"http://www.";
    }else if (urlType == mk_bxt_urlHeaderType2){
        header = @"https://www.";
    }else if (urlType == mk_bxt_urlHeaderType3){
        header = @"http://";
    }else if (urlType == mk_bxt_urlHeaderType4){
        header = @"https://";
    }
    NSString *url = [header stringByAppendingString:urlContent];
    BOOL legal = [self regularUrl:url];
    if (legal) {
        //合法的URL
        NSString *tempString = [self getUrlIllegalContent:urlContent];
        return [[self fetchUrlTypeString:urlType] stringByAppendingString:tempString];
    }
    //如果不合法
    if (urlContent.length > 17 || urlContent.length < 2) {
        return @"";
    }
    NSString *content = [self fetchUrlTypeString:urlType];
    for (NSInteger i = 0; i < urlContent.length; i ++) {
        int asciiCode = [urlContent characterAtIndex:i];
        content = [content stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
    }
    return content;
}

+ (NSDictionary *)parseSlotTriggerParam:(NSString *)content {
    if (!MKValidStr(content) || content.length < 4) {
        return @{};
    }
    NSString *slotIndex = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(0, 2)];
    NSString *triggerType = [content substringWithRange:NSMakeRange(2, 2)];
    if ([triggerType isEqualToString:@"00"]) {
        //无触发
        return @{
            @"slotIndex":slotIndex,
            @"triggerType":triggerType,
        };
    }
    if ([triggerType isEqualToString:@"05"] && content.length == 14) {
        //移动触发
        BOOL start = [[content substringWithRange:NSMakeRange(4, 2)] isEqualToString:@"01"];
        NSString *advInterval = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(6, 4)];
        NSString *staticInterval = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(10, 4)];
        return @{
            @"slotIndex":slotIndex,
            @"triggerType":triggerType,
            @"start":@(start),
            @"advInterval":advInterval,
            @"staticInterval":staticInterval
        };
    }
    if ([triggerType isEqualToString:@"06"] && content.length == 10) {
        //移动触发
        BOOL start = [[content substringWithRange:NSMakeRange(4, 2)] isEqualToString:@"01"];
        NSString *advInterval = [MKBLEBaseSDKAdopter getDecimalStringWithHex:content range:NSMakeRange(6, 4)];
        return @{
            @"slotIndex":slotIndex,
            @"triggerType":triggerType,
            @"start":@(start),
            @"advInterval":advInterval,
        };
    }
    return @{};
}

#pragma mark - private method
+ (NSString *)fetchUrlTypeString:(mk_bxt_urlHeaderType)urlType {
    switch (urlType) {
        case mk_bxt_urlHeaderType1:
            return @"00";
        case mk_bxt_urlHeaderType2:
            return @"01";
        case mk_bxt_urlHeaderType3:
            return @"03";
        case mk_bxt_urlHeaderType4:
            return @"04";
    }
}

+ (NSString *)getUrlIllegalContent:(NSString *)urlContent{
    if (!MKValidStr(urlContent)) {
        return @"";
    }
    NSArray *tempList = [urlContent componentsSeparatedByString:@"."];
    if (!MKValidArray(tempList)) {
        return @"";
    }
    NSString *content = @"";
    NSString *expansion = [self getExpansionHex:[@"." stringByAppendingString:[tempList lastObject]]];
    if (!MKValidStr(expansion)) {
        //如果不是符合官方要求的后缀名，判断长度是否小于2，如果是小于2则认为错误，否则直接认为符合要求
        //如果不是符合官方要求的后缀名，判断长度是否大于17，如果是大于17则认为错误，否则直接认为符合要求
        if (urlContent.length > 17 || urlContent.length < 2) {
            return nil;
        }
        for (NSInteger i = 0; i < urlContent.length; i ++) {
            int asciiCode = [urlContent characterAtIndex:i];
            content = [content stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
        }
    }else{
        NSString *tempString = @"";
        for (NSInteger i = 0; i < tempList.count - 1; i ++) {
            tempString = [tempString stringByAppendingString:[NSString stringWithFormat:@".%@",tempList[i]]];
        }
        tempString = [tempString substringFromIndex:1];
        if (tempString.length > 16 || tempString.length < 1) {
            return nil;
        }
        for (NSInteger i = 0; i < tempString.length; i ++) {
            int asciiCode = [tempString characterAtIndex:i];
            content = [content stringByAppendingString:[NSString stringWithFormat:@"%1lx",(unsigned long)asciiCode]];
        }
        content = [content stringByAppendingString:expansion];
    }
    return content;
}

+ (BOOL)regularUrl:(NSString *)url{
    if (!MKValidStr(url)) {
        return NO;
    }
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",@"[a-zA-z]+://[^\\s]*"];
    return [pred evaluateWithObject:url];
}

/**
 根据后缀名返回写入数据时候的hex
 
 @param expansion 后缀名
 @return hex
 */
+ (NSString *)getExpansionHex:(NSString *)expansion{
    if (!MKValidStr(expansion)) {
        return @"";
    }
    if ([expansion isEqualToString:@".com/"]) {
        return @"00";
    }else if ([expansion isEqualToString:@".org/"]){
        return @"01";
    }else if ([expansion isEqualToString:@".edu/"]){
        return @"02";
    }else if ([expansion isEqualToString:@".net/"]){
        return @"03";
    }else if ([expansion isEqualToString:@".info/"]){
        return @"04";
    }else if ([expansion isEqualToString:@".biz/"]){
        return @"05";
    }else if ([expansion isEqualToString:@".gov/"]){
        return @"06";
    }else if ([expansion isEqualToString:@".com"]){
        return @"07";
    }else if ([expansion isEqualToString:@".org"]){
        return @"08";
    }else if ([expansion isEqualToString:@".edu"]){
        return @"09";
    }else if ([expansion isEqualToString:@".net"]){
        return @"0a";
    }else if ([expansion isEqualToString:@".info"]){
        return @"0b";
    }else if ([expansion isEqualToString:@".biz"]){
        return @"0c";
    }else if ([expansion isEqualToString:@".gov"]){
        return @"0d";
    }else{
        return @"";
    }
}

@end
