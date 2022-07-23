//
//  MKBXTScanFilterView.h
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/7/19.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXTScanFilterView : UIView

/// 加载扫描过滤页面
/// @param name 过滤的名字
/// @param rssi 过滤的rssi
/// @param searchBlock 回调
+ (void)showSearchName:(NSString *)name
                  rssi:(NSInteger)rssi
           searchBlock:(void (^)(NSString *searchName, NSInteger searchRssi))searchBlock;

@end

NS_ASSUME_NONNULL_END
