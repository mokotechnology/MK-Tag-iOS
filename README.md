# MK Tag iOS Software Development Kit Guide

* This SDK support the company's MK Tag series products.

# Design instructions

* We divide the communications between SDK and devices into two stages: Scanning stage, Connection stage.For ease of understanding, let's take a look at the related classes and the relationships between them.

`MKBXTCentralManager`：global manager, check system's bluetooth status, listen status changes, the most important is scan and connect to devices;

`MKBXTBaseBeacon`: instance of devices, MKBXTCentralManager will create an MKBXTBaseBeacon instance while it found a physical device, a device corresponds to an instance.Currently there are *MKBXTUIDBeacon(UID frame)*, *MKBXTURLBeacon(URL frame)*, *MKBXTTLMBeacon(TLM frame)*, *MKBXTTagInfoBeacon(Tag Info frame)*, *MKBXTiBeacon(iBeacon frame)*, *MKBXTProductionTestBeacon(Production test frame)*;

`MKBXTInterface`: When the device is successfully connected, the device data can be read through the interface in `MKBXTInterface`;

`MKBXTInterface+MKBXTConfig.h`: When the device is successfully connected, you can configure the device data through the interface in `MKBXTInterface+MKBXTConfig.h`;


## Scanning Stage

in this stage, `MKBXTCentralManager ` will scan and analyze the advertisement data of MK Tag devices, `MKBXTCentralManager ` will create `MKBXTBaseBeacon ` instance for every physical devices, developers can get all advertisement data by its property.


## Connection Stage

At this stage, first call `readNeedPasswordWithPeripheral:sucBlock:failedBlock:` to check whether the current device is connected to the password. If the user needs to enter a connection password, call `connectPeripheral:password:sucBlock:failedBlock` to connect; if no connection password is required, call `connectPeripheral:sucBlock:failedBlock:` to connect.


# Get Started

### Development environment:

* Xcode9+， due to the DFU and Zip Framework based on Swift4.0, so please use Xcode9 or high version to develop;
* iOS12, we limit the minimum iOS system version to 12.0；

### Import to Project

CocoaPods

SDK-BXB is available through [CocoaPods](https://cocoapods.org).To install it, simply add the following line to your Podfile, and then import <MKBeaconXTag/MKBXTSDK.h>：

**pod 'MKBeaconXTag/SDK'**


* <font color=#FF0000 face="黑体">!!!on iOS 10 and above, Apple add authority control of bluetooth, you need add the string to "info.plist" file of your project: Privacy - Bluetooth Peripheral Usage Description - "your description". as the screenshot below.</font>

* <font color=#FF0000 face="黑体">!!! In iOS13 and above, Apple added permission restrictions on Bluetooth APi. You need to add a string to the project's info.plist file: Privacy-Bluetooth Always Usage Description-"Your usage description".</font>


## Start Developing

### Get sharedInstance of Manager

First of all, the developer should get the sharedInstance of Manager:

```
MKBXTCentralManager *manager = [MKBXTCentralManager shared];
```

#### 1.Start scanning task to find devices around you,please follow the steps below:

* 1.`manager.delegate = self;` //Set the scan delegate and complete the related delegate methods.
* 2.you can start the scanning task in this way:`[manager startScan];`    
* 3.at the sometime, you can stop the scanning task in this way:`[manager stopScan];`

#### 2.Connect to device

* 1.Read whether the device requires a connection password.

```
[[MKBXTCentralManager shared] readNeedPasswordWithPeripheral:peripheral sucBlock:^(NSDictionary * _Nonnull result) {
        if ([result[@"state"] isEqualToString:@"00"]) {
            //No password required.
            return;
        }
        if ([result[@"state"] isEqualToString:@"01"]) {
            //Password required.
            return;
        }
    } failedBlock:^(NSError * _Nonnull error) {
       
    }];
```

* 2.Connect the device with password:

```
[[MKBXTCentralManager shared] connectPeripheral:peripheral password:password sucBlock:^(CBPeripheral * _Nonnull peripheral) {
        //Success
    } failedBlock:^(NSError * _Nonnull error) {
        //Failed
    }];
```

* 3.Connect the device without password:

```
[[MKBXTCentralManager shared] connectPeripheral:peripheral sucBlock:^(CBPeripheral * _Nonnull peripheral) {
        //Success
    } failedBlock:^(NSError * _Nonnull error) {
        //Failed   dispatch_semaphore_signal(self.semaphore);
    }];
```

#### 3.Get State

Through the manager, you can get the current Bluetooth status of the mobile phone and the connection status of the device. If you want to monitor the changes of these two states, you can register the following notifications to achieve:

*  When the Bluetooth status of the mobile phone changes，<font color=#FF0000 face="黑体">`mk_bxt_centralManagerStateChangedNotification`</font> will be posted.You can get status in this way:

```
[[MKBXTCentralManager shared] centralStatus];
```

*  When the device connection status changes，<font color=#FF0000 face="黑体"> `mk_bxt_peripheralConnectStateChangedNotification` </font> will be posted.You can get the status in this way:
```
[MKBXTCentralManager shared].connectStatus;
```

#### 4.Monitoring device disconnect reason.

Register for <font color=#FF0000 face="黑体"> `mk_bxt_deviceDisconnectTypeNotification` </font> notifications to monitor data.


```
[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(disconnectTypeNotification:)
                                                 name:@"mk_bxt_deviceDisconnectTypeNotification"
                                               object:nil];

```

```
- (void)disconnectTypeNotification:(NSNotification *)note {
    NSString *type = note.userInfo[@"type"];
    /*
    After connecting the device, if no password is entered within one minute, it returns 0x01. After successful password change, it returns 0x02.The device reset ,it returns 0x03.Power Off the device ,it returns 0x04.
    */
}
```


#### 5.Monitor three-axis data.

When the device is connected, the developer can monitor the three-axis data of the device through the following steps:

*  1.Open data monitoring by the following method:

```
[[MKBXTCentralManager shared] notifyThreeAxisData:YES];
```

*  2.Register for `mk_bxt_receiveThreeAxisDataNotification ` notifications to monitor device three-axis data changes.

```

[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveAxisDatas:)
                                                 name:mk_bxt_receiveThreeAxisDataNotification
                                               object:nil];
```


```
- (void)receiveAxisDatas:(NSNotification *)note {
    NSDictionary *dic = note.userInfo;
    
}
```


#### 6.Monitor three-axis data.

When the device is connected, the developer can monitor the hall-sensor data of the device through the following steps:

*  1.Open data monitoring by the following method:

```
[[MKBXTCentralManager shared] notifyHallSensorData:YES];
```

*  2.Register for `mk_bxt_receiveHallSensorStatusChangedNotification ` notifications to monitor device three-axis data changes.

```

[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveHallSensorDatas:)
                                                 name: mk_bxt_receiveHallSensorStatusChangedNotification
                                               object:nil];
```


```
- (void)receiveHallSensorDatas:(NSNotification *)note {
    NSDictionary *dic = note.userInfo;
    if (!ValidDict(dic)) {
        return;
    }
    BOOL moved = [dic[@"moved"] boolValue];
    self.dataModel.status = (moved ? @"Absent" : @"Present");
    
}
```

## Notes

* In development progress, you may find there are multiple MKBXTBaseAdvModel instance correspond to a physical device. On this point, we consulted Apple's engineers. they told us that currently on the iOS platform, CoreBluetooth framework unfriendly to the multiple slot devices(especially the advertisement data in changing). due to that sometimes app can't connect to the device, Google Eddystone solve this issue by press button on eddystone devices, our device support this operation too.
* In scanning stage, some properties may nil, especially MAC address(restriction of iOS),if current device advertise MKBXTProductionTestBeacon frame, then you can get name and MAC address.


# Change log

* 20230802 first version;
