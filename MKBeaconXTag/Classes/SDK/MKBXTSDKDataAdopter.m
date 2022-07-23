//
//  MKBXTSDKDataAdopter.m
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/7/13.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXTSDKDataAdopter.h"

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

@end
