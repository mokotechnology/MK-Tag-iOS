//
//  CTMediator+MKBXTAdd.m
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/7/13.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "CTMediator+MKBXTAdd.h"

@implementation CTMediator (MKBXTAdd)

- (UIViewController *)CTMediator_Beacon_Tag_AboutPage {
    UIViewController *viewController = [self performTarget:@"BXPButton_Module"
                                                    action:@"BXPButton_Tag_AboutController"
                                                    params:@{}
                                         shouldCacheTarget:NO];
    if ([viewController isKindOfClass:[UIViewController class]]) {
        return viewController;
    }
    return [self performTarget:@"BXT_Module"
                        action:@"Beacon_Tag_Module_AboutController"
                        params:@{}
             shouldCacheTarget:NO];
}

@end
