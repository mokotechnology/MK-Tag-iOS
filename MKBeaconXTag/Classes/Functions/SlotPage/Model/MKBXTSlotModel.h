//
//  MKBXTSlotModel.h
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/7/19.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXTSlotModel : NSObject

@property (nonatomic, copy)NSString *slot1;

@property (nonatomic, copy)NSString *slot2;

@property (nonatomic, copy)NSString *slot3;

@property (nonatomic, copy)NSString *slot4;

@property (nonatomic, copy)NSString *slot5;

@property (nonatomic, copy)NSString *slot6;

- (void)readDataWithSucBlock:(void (^)(void))sucBlock failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
