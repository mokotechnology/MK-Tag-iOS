//
//  MKBXTRemoteReminderModel.h
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/2/21.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXTRemoteReminderModel : NSObject

#pragma mark - LED notification
@property (nonatomic, copy)NSString *blinkingTime;

@property (nonatomic, copy)NSString *blinkingInterval;

@end

NS_ASSUME_NONNULL_END
