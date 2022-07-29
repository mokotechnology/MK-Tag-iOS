//
//  MKBXTSlotFrameTypePickView.h
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/7/25.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MKBXTSlotConfigDefines.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MKBXTSlotFrameTypePickViewDelegate <NSObject>

- (void)bxt_slotFrameTypeChanged:(bxt_slotType)frameType;

@end

@interface MKBXTSlotFrameTypePickView : UIView

@property (nonatomic, weak)id <MKBXTSlotFrameTypePickViewDelegate>delegate;

- (void)updateFrameType:(bxt_slotType)frameType;

@end

NS_ASSUME_NONNULL_END
