
typedef NS_ENUM(NSInteger, mk_bxt_taskOperationID) {
    mk_bxt_defaultTaskOperationID,
    
#pragma mark - Read
    mk_bxt_taskReadDeviceModelOperation,        //读取产品型号
    mk_bxt_taskReadProductDateOperation,        //读取生产日期
    mk_bxt_taskReadFirmwareOperation,           //读取固件版本
    mk_bxt_taskReadHardwareOperation,           //读取硬件类型
    mk_bxt_taskReadSoftwareOperation,           //读取软件版本
    mk_bxt_taskReadManufacturerOperation,       //读取厂商信息
    mk_bxt_taskReadDeviceTypeOperation,         //读取产品类型
    
#pragma mark - 密码相关
    
    
#pragma mark - 自定义读取
    mk_bxt_taskReadMacAddressOperation,         //读取mac地址
    mk_bxt_taskReadThreeAxisDataParamsOperation,    //读取三轴传感器参数
    mk_bxt_taskReadSlotParamsOperation,         //读取通道广播参数
    mk_bxt_taskReadSlotDataOperation,           //读取通道广播内容
    mk_bxt_taskReadSlotTriggerParamsOperation,  //读取通道触发参数
    mk_bxt_taskReadConnectableOperation,        //读取可连接性
    mk_bxt_taskReadPowerOffByHallSensorOperation,   //读取霍尔开关机状态
    mk_bxt_taskReadScanResponsePacketOperation,     //读取回应包开关状态
    mk_bxt_taskReadSlotDataTypeOperation,           //读取全部通道类型
    mk_bxt_taskReadTriggerLEDIndicatorStatusOperation,  //读取触发led提醒状态
    mk_bxt_taskReadBatteryVoltageOperation,     //读取电池电压
    mk_bxt_taskReadMotionTriggerCountOperation,    //读取移动触发次数
    mk_bxt_taskReadHallTriggerCountOperation,       //读取霍尔传感器触发次数
    mk_bxt_taskReadSensorStatusOperation,           //读取传感器类型
    mk_bxt_taskReadStaticHeartbeatOperation,        //读取心跳功能参数
    mk_bxt_taskReadBatteryModeOperation,            //读取电池类型
    
#pragma mark - 密码特征
    mk_bxt_taskReadNeedPasswordOperation,       //读取设备是否需要连接密码
    
#pragma mark - 霍尔传感器特征相关
    mk_bxt_taskReadMagnetStatusOperation,       //读取霍尔传感器状态
    
#pragma mark - 自定义协议配置
    mk_bxt_taskConfigThreeAxisDataParamsOperation,  //配置三轴传感器参数
    mk_bxt_taskConfigSlotParamOperation,            //配置通道广播参数
    mk_bxt_taskConfigSlotDataOperation,             //配置通道广播内容
    mk_bxt_taskConfigSlotTriggerParamsOperation,    //配置通道广播触发方式
    mk_bxt_taskConfigConnectableOperation,      //配置可连接状态
    mk_bxt_taskPowerOffOperation,               //关机
    mk_bxt_taskFactoryResetOperation,           //恢复出厂设置
    mk_bxt_taskConfigPowerOffByHallSensorOperation,         //配置霍尔传感器开关状态
    mk_bxt_taskConfigScanResponsePacketOperation,           //配置回应包开关状态
    mk_bxt_taskConfigTriggerLEDIndicatorStatusOperation,    //配置触发led提醒状态
    mk_bxt_taskClearMotionTriggerCountOperation,        //清除移动触发次数
    mk_bxt_taskClearHallTriggerCountOperation,          //清除霍尔传感器触发次数
    mk_bxt_taskConfigRemoteReminderLEDNotiParamsOperation,  //远程提醒
    mk_bxt_taskConfigStaticHeartbeatOperation,          //配置心跳功能参数
    mk_bxt_taskResetBatteryOperation,                   //重置设备电量
    
#pragma mark - 密码相关
    mk_bxt_connectPasswordOperation,            //连接密码
    mk_bxt_taskConfigConnectPasswordOperation,  //修改密码
    mk_bxt_taskConfigPasswordVerificationOperation, //配置是否需要连接密码
};
