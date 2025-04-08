//
//  Target_BXT_Module.m
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/7/13.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "Target_BXT_Module.h"

#import "MKBXTScanController.h"
#import "MKBXTAboutController.h"

@implementation Target_BXT_Module

- (UIViewController *)Action_Beacon_Tag_Module_ScanController:(NSDictionary *)params {
    return [[MKBXTScanController alloc] init];
}

- (UIViewController *)Action_Beacon_Tag_Module_AboutController:(NSDictionary *)params {
    return [[MKBXTAboutController alloc] init];
}

@end
