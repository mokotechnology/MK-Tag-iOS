//
//  MKBXTStaticHeartbeatModel.h
//  MKBeaconXTag_Example
//
//  Created by aa on 2023/5/8.
//  Copyright © 2023 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXTStaticHeartbeatModel : NSObject

@property (nonatomic, assign)BOOL isOn;

@property (nonatomic, copy)NSString *cycleTime;

@property (nonatomic, copy)NSString *advDuration;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

- (void)configDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
