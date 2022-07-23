//
//  MKBXTHallSensorHeaderView.h
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/7/21.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MKBXTHallSensorHeaderViewDelegate <NSObject>

- (void)bxt_clearMagneticTriggerCountButtonPressed;

@end

@interface MKBXTHallSensorHeaderView : UIView

@property (nonatomic, weak)id <MKBXTHallSensorHeaderViewDelegate>delegate;

- (void)updateTriggerCount:(NSString *)count;

- (void)updateMagnetStatus:(NSString *)status;

@end

NS_ASSUME_NONNULL_END
