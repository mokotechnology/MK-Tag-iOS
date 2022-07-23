//
//  MKBXTHallSensorModel.h
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/7/21.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXTHallSensorModel : NSObject

@property (nonatomic, copy)NSString *status;

@property (nonatomic, copy)NSString *count;

@property (nonatomic, assign)BOOL isOn;

- (void)readWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
