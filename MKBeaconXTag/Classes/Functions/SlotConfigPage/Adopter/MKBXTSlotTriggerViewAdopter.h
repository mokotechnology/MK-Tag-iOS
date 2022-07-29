//
//  MKBXTSlotTriggerViewAdopter.h
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/7/26.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - *********************Motion Detection Start**********************

@interface MKBXTSlotMotionDetectionStartViewModel : NSObject

@property (nonatomic, assign)BOOL selected;

@property (nonatomic, copy)NSString *startInterval;

@property (nonatomic, copy)NSString *staticInterval;

@end

@protocol MKBXTSlotMotionDetectionStartViewDelegate <NSObject>

- (void)bxt_motionDetectionStartView_startIntervalChanged:(NSString *)startInterval;

- (void)bxt_motionDetectionStartView_staticIntervalChanged:(NSString *)staticInterval;

@end

@interface MKBXTSlotMotionDetectionStartView : UIControl

@property (nonatomic, strong)MKBXTSlotMotionDetectionStartViewModel *dataModel;

@property (nonatomic, weak)id <MKBXTSlotMotionDetectionStartViewDelegate>delegate;

@end

#pragma mark - *********************Motion Detection Stop**********************

@interface MKBXTSlotMotionDetectionStopViewModel : NSObject

@property (nonatomic, assign)BOOL selected;

@property (nonatomic, copy)NSString *staticInterval;

@end

@protocol MKBXTSlotMotionDetectionStopViewDelegate <NSObject>

- (void)bxt_motionDetectionStopView_staticIntervalChanged:(NSString *)staticInterval;

@end

@interface MKBXTSlotMotionDetectionStopView : UIControl

@property (nonatomic, strong)MKBXTSlotMotionDetectionStopViewModel *dataModel;

@property (nonatomic, weak)id <MKBXTSlotMotionDetectionStopViewDelegate>delegate;

@end

#pragma mark - *********************Magnetic Detection Start**********************

@interface MKBXTSlotMagneticDetectionStartViewModel : NSObject

@property (nonatomic, assign)BOOL selected;

@property (nonatomic, copy)NSString *startInterval;

@end

@protocol MKBXTSlotMagneticDetectionStartViewDelegate <NSObject>

- (void)bxt_magneticDetectionStartView_startIntervalChanged:(NSString *)startInterval;

@end

@interface MKBXTSlotMagneticDetectionStartView : UIControl

@property (nonatomic, strong)MKBXTSlotMagneticDetectionStartViewModel *dataModel;

@property (nonatomic, weak)id <MKBXTSlotMagneticDetectionStartViewDelegate>delegate;

@end

#pragma mark - *********************Magnetic Detection Stop**********************

@interface MKBXTSlotMagneticDetectionStopViewModel : NSObject

@property (nonatomic, assign)BOOL selected;

@end

@interface MKBXTSlotMagneticDetectionStopView : UIControl

@property (nonatomic, strong)MKBXTSlotMagneticDetectionStopViewModel *dataModel;

@end


#pragma mark - *********************Motion Detection View**********************

@interface MKBXTSlotMotionDetectionViewModel : NSObject

@property (nonatomic, assign)BOOL start;

@property (nonatomic, copy)NSString *startAdvInterval;

@property (nonatomic, copy)NSString *startStaticInterval;

@property (nonatomic, copy)NSString *stopStaticInterval;

@end

@protocol MKBXTSlotMotionDetectionViewDelegate <NSObject>

- (void)bxt_motionDetectionView_startChanged:(BOOL)start;

- (void)bxt_motionDetectionView_startAdvIntervalChanged:(NSString *)startInterval;

- (void)bxt_motionDetectionView_startStaticIntervalChanged:(NSString *)staticInterval;

- (void)bxt_motionDetectionView_stopStaticIntervalChanged:(NSString *)staticInterval;

@end

@interface MKBXTSlotMotionDetectionView : UIView

@property (nonatomic, strong)MKBXTSlotMotionDetectionViewModel *dataModel;

@property (nonatomic, weak)id <MKBXTSlotMotionDetectionViewDelegate>delegate;

@end

#pragma mark - *********************Magnetic Detection View**********************

@interface MKBXTSlotMagneticDetectionViewModel : NSObject

@property (nonatomic, assign)BOOL start;

@property (nonatomic, copy)NSString *startAdvInterval;

@end

@protocol MKBXTSlotMagneticDetectionViewDelegate <NSObject>

- (void)bxt_magneticDetectionView_startChanged:(BOOL)start;

- (void)bxt_magneticDetectionView_startAdvIntervalChanged:(NSString *)startInterval;

@end

@interface MKBXTSlotMagneticDetectionView : UIView

@property (nonatomic, strong)MKBXTSlotMagneticDetectionViewModel *dataModel;

@property (nonatomic, weak)id <MKBXTSlotMagneticDetectionViewDelegate>delegate;

@end


#pragma mark - *********************Slot Trigger View Adopter**********************

@interface MKBXTSlotTriggerViewAdopter : NSObject

+ (UILabel *)loadMsgLabelWithMsg:(NSString *)msg;

@end

NS_ASSUME_NONNULL_END
