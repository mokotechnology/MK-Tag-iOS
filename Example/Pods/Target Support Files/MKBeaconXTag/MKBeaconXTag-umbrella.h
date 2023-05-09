#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "CTMediator+MKBXTAdd.h"
#import "MKBXTConnectManager.h"
#import "MKBXTAboutController.h"
#import "MKBXTAccelerationController.h"
#import "MKBXTAccelerationModel.h"
#import "MKBXTAccelerationHeaderView.h"
#import "MKBXTAccelerationParamsCell.h"
#import "MKBXTDeviceInfoController.h"
#import "MKBXTDeviceInfoModel.h"
#import "MKBXTHallSensorController.h"
#import "MKBXTHallSensorModel.h"
#import "MKBXTHallSensorHeaderView.h"
#import "MKBXTHallSensorStatusCell.h"
#import "MKBXTQuickSwitchController.h"
#import "MKBXTQuickSwitchModel.h"
#import "MKBXTRemoteReminderController.h"
#import "MKBXTRemoteReminderModel.h"
#import "MKBXTRemoteReminderCell.h"
#import "MKBXTScanPageAdopter.h"
#import "MKBXTScanController.h"
#import "MKBXTScanInfoCellModel.h"
#import "MKBXTScanDeviceInfoCell.h"
#import "MKBXTScanFilterView.h"
#import "MKBXTScanTagInfoCell.h"
#import "MKBXTSensorConfigController.h"
#import "MKBXTSettingController.h"
#import "MKBXTSlotTriggerViewAdopter.h"
#import "MKBXTSlotConfigController.h"
#import "MKBXTSlotConfigDefines.h"
#import "MKBXTSlotConfigDataModel.h"
#import "MKBXTSlotBeaconCell.h"
#import "MKBXTSlotFrameTypePickView.h"
#import "MKBXTSlotParamCell.h"
#import "MKBXTSlotTagInfoCell.h"
#import "MKBXTSlotTriggerCell.h"
#import "MKBXTSlotUIDCell.h"
#import "MKBXTSlotURLCell.h"
#import "MKBXTSlotController.h"
#import "MKBXTSlotModel.h"
#import "MKBXTStaticHeartbeatController.h"
#import "MKBXTStaticHeartbeatModel.h"
#import "MKBXTTabBarController.h"
#import "MKBXTUpdateController.h"
#import "MKBXTDFUModule.h"
#import "CBPeripheral+MKBXTAdd.h"
#import "MKBXTBaseBeacon.h"
#import "MKBXTCentralManager.h"
#import "MKBXTInterface+MKBXTConfig.h"
#import "MKBXTInterface.h"
#import "MKBXTOperation.h"
#import "MKBXTOperationID.h"
#import "MKBXTPeripheral.h"
#import "MKBXTSDK.h"
#import "MKBXTSDKDataAdopter.h"
#import "MKBXTSDKNormalDefines.h"
#import "MKBXTTaskAdopter.h"
#import "Target_BXT_Module.h"

FOUNDATION_EXPORT double MKBeaconXTagVersionNumber;
FOUNDATION_EXPORT const unsigned char MKBeaconXTagVersionString[];

