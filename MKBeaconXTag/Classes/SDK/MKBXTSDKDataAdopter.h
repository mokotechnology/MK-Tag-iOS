//
//  MKBXTSDKDataAdopter.h
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/7/13.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MKBXTSDKNormalDefines.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKBXTSDKDataAdopter : NSObject

+ (NSString *)getUrlscheme:(char)hexChar;
+ (NSString *)getEncodedString:(char)hexChar;

+ (NSString *)fetchThreeAxisDataRate:(mk_bxt_threeAxisDataRate)dataRate;
+ (NSString *)fetchThreeAxisDataAG:(mk_bxt_threeAxisDataAG)ag;

@end

NS_ASSUME_NONNULL_END
