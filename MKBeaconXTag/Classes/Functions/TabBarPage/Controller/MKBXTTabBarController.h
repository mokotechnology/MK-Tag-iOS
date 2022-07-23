//
//  MKBXTTabBarController.h
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/2/19.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKBXTTabBarControllerDelegate <NSObject>

/// 返回到扫描页面，肯定需要开启扫描，当dfu升级之后返回扫描页面，则需要重新设置扫描代理
/// @param need YES:DFU升级情况下返回，需要设置扫描代理,NO:不需要重设代理
- (void)mk_bxt_needResetScanDelegate:(BOOL)need;

@end

@interface MKBXTTabBarController : UITabBarController

@property (nonatomic, weak)id <MKBXTTabBarControllerDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
