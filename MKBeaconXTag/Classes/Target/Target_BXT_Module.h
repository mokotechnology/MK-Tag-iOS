//
//  Target_BXT_Module.h
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/7/13.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Target_BXT_Module : NSObject

/// 扫描页面
- (UIViewController *)Action_Beacon_Tag_Module_ScanController:(NSDictionary *)params;

/// 关于页面
- (UIViewController *)Action_Beacon_Tag_Module_AboutController:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
