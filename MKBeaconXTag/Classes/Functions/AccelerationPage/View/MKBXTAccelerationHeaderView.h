//
//  MKBXTAccelerationHeaderView.h
//  MKBeaconXTag_Example
//
//  Created by aa on 2021/3/3.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKBXTAccelerationHeaderViewDelegate <NSObject>

- (void)bxt_updateThreeAxisNotifyStatus:(BOOL)notify;

- (void)bxt_clearMotionTriggerCountButtonPressed;

@end

@interface MKBXTAccelerationHeaderView : UIView

@property (nonatomic, weak)id <MKBXTAccelerationHeaderViewDelegate>delegate;

- (void)updateTriggerCount:(NSString *)count;

- (void)updateDataWithXData:(NSString *)xData yData:(NSString *)yData zData:(NSString *)zData;

@end

NS_ASSUME_NONNULL_END
