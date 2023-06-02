//
//  MKBXTSlotTriggerCell.h
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/7/25.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXTSlotTriggerCellModel : NSObject

@property (nonatomic, assign)BOOL isOn;

/// 0:Motion detection   1:Magnetic detection
@property (nonatomic, assign)NSInteger triggerType;

#pragma mark - Motion Trigger(triggerType = 0)

/// 触发后广播状态
@property (nonatomic, assign)BOOL motionStart;

@property (nonatomic, copy)NSString *motionStartInterval;

@property (nonatomic, copy)NSString *motionStartStaticInterval;

@property (nonatomic, copy)NSString *motionStopStaticInterval;

#pragma mark - Magnetic Trigger(triggerType = 1)

/// 触发后广播状态
@property (nonatomic, assign)BOOL magneticStart;

@property (nonatomic, copy)NSString *magneticInterval;

/// 可以按键（霍尔）关机 -- 禁用触发类型选择
@property (nonatomic, assign)BOOL enableTypeButton;

@end

@protocol MKBXTSlotTriggerCellDelegate <NSObject>

- (void)bxt_trigger_statusChanged:(BOOL)isOn;

/// 触发类型改变
/// @param triggerType 0:Motion detection   1:Magnetic detection
- (void)bxt_trigger_triggerTypeChanged:(NSInteger)triggerType;

#pragma mark - Motion Trigger(triggerType = 0)
- (void)bxt_trigger_motion_startStatusChanged:(BOOL)start;

- (void)bxt_trigger_motion_startIntervalChanged:(NSString *)startInterval;

- (void)bxt_trigger_motion_startStaticIntervalChanged:(NSString *)staticInterval;

- (void)bxt_trigger_motion_stopStaticIntervalChanged:(NSString *)staticInterval;

#pragma mark - Magnetic Trigger(triggerType = 1)
- (void)bxt_trigger_magnetic_startStatusChanged:(BOOL)start;

- (void)bxt_trigger_magnetic_startIntervalChanged:(NSString *)startInterval;

@end

@interface MKBXTSlotTriggerCell : MKBaseCell

@property (nonatomic, strong)MKBXTSlotTriggerCellModel *dataModel;

@property (nonatomic, weak)id <MKBXTSlotTriggerCellDelegate>delegate;

+ (MKBXTSlotTriggerCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
