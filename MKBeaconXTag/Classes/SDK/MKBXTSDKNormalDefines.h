
#pragma mark ****************************************Enumerate************************************************

#pragma mark - MKMTCentralManager

typedef NS_ENUM(NSInteger, mk_bxt_centralConnectStatus) {
    mk_bxt_centralConnectStatusUnknow,                                           //未知状态
    mk_bxt_centralConnectStatusConnecting,                                       //正在连接
    mk_bxt_centralConnectStatusConnected,                                        //连接成功
    mk_bxt_centralConnectStatusConnectedFailed,                                  //连接失败
    mk_bxt_centralConnectStatusDisconnect,
};

typedef NS_ENUM(NSInteger, mk_bxt_centralManagerStatus) {
    mk_bxt_centralManagerStatusUnable,                           //不可用
    mk_bxt_centralManagerStatusEnable,                           //可用状态
};

typedef NS_ENUM(NSInteger, mk_bxt_threeAxisDataRate) {
    mk_bxt_threeAxisDataRate1hz,           //1hz
    mk_bxt_threeAxisDataRate10hz,          //10hz
    mk_bxt_threeAxisDataRate25hz,          //25hz
    mk_bxt_threeAxisDataRate50hz,          //50hz
    mk_bxt_threeAxisDataRate100hz          //100hz
};

typedef NS_ENUM(NSInteger, mk_bxt_threeAxisDataAG) {
    mk_bxt_threeAxisDataAG0,               //±2g
    mk_bxt_threeAxisDataAG1,               //±4g
    mk_bxt_threeAxisDataAG2,               //±8g
    mk_bxt_threeAxisDataAG3                //±16g
};

typedef NS_ENUM(NSInteger, mk_bxt_txPower) {
    mk_bxt_txPowerNeg40dBm,   //RadioTxPower:-40dBm
    mk_bxt_txPowerNeg20dBm,   //-20dBm
    mk_bxt_txPowerNeg16dBm,   //-16dBm
    mk_bxt_txPowerNeg12dBm,   //-12dBm
    mk_bxt_txPowerNeg8dBm,    //-8dBm
    mk_bxt_txPowerNeg4dBm,    //-4dBm
    mk_bxt_txPower0dBm,       //0dBm
    mk_bxt_txPower3dBm,       //3dBm
    mk_bxt_txPower4dBm,       //4dBm
};

typedef NS_ENUM(NSInteger, mk_bxt_urlHeaderType) {
    mk_bxt_urlHeaderType1,             //http://www.
    mk_bxt_urlHeaderType2,             //https://www.
    mk_bxt_urlHeaderType3,             //http://
    mk_bxt_urlHeaderType4,             //https://
};

#pragma mark ****************************************Delegate************************************************

@class MKBXTBaseBeacon;
@protocol mk_bxt_centralManagerScanDelegate <NSObject>

/// Scan to new device.
/// @param beaconList device
- (void)mk_bxt_receiveBeacon:(NSArray <MKBXTBaseBeacon *>*)beaconList;

@optional

/// Starts scanning equipment.
- (void)mk_bxt_startScan;

/// Stops scanning equipment.
- (void)mk_bxt_stopScan;

@end
