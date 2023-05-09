//
//  MKBXTQuickSwitchModel.h
//  MKBeaconXTag_Example
//
//  Created by aa on 2021/8/18.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXTQuickSwitchModel : NSObject

@property (nonatomic, assign)BOOL connectable;

@property (nonatomic, assign)BOOL trigger;

@property (nonatomic, assign)BOOL passwordVerification;

/// V1.0.4以后支持
@property (nonatomic, assign)BOOL scanResponse;


- (void)readWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
