//
//  MKBXTTabBarController.m
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/2/19.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXTTabBarController.h"

#import "MKMacroDefines.h"
#import "MKBaseNavigationController.h"

#import "MKAlertView.h"

#import "MKBLEBaseLogManager.h"

#import "MKBXTCentralManager.h"

#import "MKBXTSlotController.h"
#import "MKBXTSettingController.h"
#import "MKBXTDeviceInfoController.h"

@interface MKBXTTabBarController ()

/// 当触发
/// 01:表示连接成功后，1分钟内没有通过密码验证（未输入密码，或者连续输入密码错误）认为超时，返回结果， 然后断开连接
/// 02:修改密码成功后，返回结果，断开连接
/// 03:恢复出厂设置
/// 04:关机

@property (nonatomic, assign)BOOL disconnectType;

/// 设备如果正在进行dfu，会出现断开连接让设备进入升级模式的现象，
@property (nonatomic, assign)BOOL dfu;

@end

@implementation MKBXTTabBarController

- (void)dealloc {
    NSLog(@"MKBXTTabBarController销毁");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (![[self.navigationController viewControllers] containsObject:self]){
        [[MKBXTCentralManager shared] disconnect];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadSubPages];
    [self addNotifications];
}

- (void)addNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(gotoScanPage)
                                                 name:@"mk_bxt_popToRootViewControllerNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(dfuUpdateComplete)
                                                 name:@"mk_bxt_centralDeallocNotification"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(centralManagerStateChanged)
                                                 name:mk_bxt_centralManagerStateChangedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(disconnectTypeNotification:)
                                                 name:mk_bxt_deviceDisconnectTypeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceConnectStateChanged)
                                                 name:mk_bxt_peripheralConnectStateChangedNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deviceStartDFUProcess)
                                                 name:@"mk_bxt_startDfuProcessNotification"
                                               object:nil];
}

#pragma mark - notes
- (void)gotoScanPage {
    @weakify(self);
    [self dismissViewControllerAnimated:YES completion:^{
        @strongify(self);
        if ([self.delegate respondsToSelector:@selector(mk_bxt_needResetScanDelegate:)]) {
            [self.delegate mk_bxt_needResetScanDelegate:NO];
        }
    }];
}

- (void)dfuUpdateComplete {
    @weakify(self);
    [self dismissViewControllerAnimated:YES completion:^{
        @strongify(self);
        if ([self.delegate respondsToSelector:@selector(mk_bxt_needResetScanDelegate:)]) {
            [self.delegate mk_bxt_needResetScanDelegate:YES];
        }
    }];
}

- (void)disconnectTypeNotification:(NSNotification *)note {
    NSString *type = note.userInfo[@"type"];
    //02:修改密码成功后，返回结果，断开连接
    //03:恢复出厂设置
    //04:关机
    self.disconnectType = YES;
    if ([type isEqualToString:@"02"]) {
        [self showAlertWithMsg:@"Modify password success! Please reconnect the Device." title:@""];
        return;
    }
    if ([type isEqualToString:@"03"]) {
        [self showAlertWithMsg:@"Factory reset successfully!Please reconnect the device." title:@"Factory Reset"];
        return;
    }
    if ([type isEqualToString:@"04"]) {
        [self gotoScanPage];
//        [self showAlertWithMsg:@"Beacon is disconnected." title:@"Reset success!"];
        return;
    }
}

- (void)centralManagerStateChanged{
    if (self.disconnectType || self.dfu) {
        return;
    }
    if ([MKBXTCentralManager shared].centralStatus != mk_bxt_centralManagerStatusEnable) {
        [self showAlertWithMsg:@"The current system of bluetooth is not available!" title:@"Dismiss"];
    }
}

- (void)deviceConnectStateChanged {
     if (self.disconnectType || self.dfu) {
        return;
    }
    [self showAlertWithMsg:@"The device is disconnected." title:@"Dismiss"];
    return;
}

- (void)deviceStartDFUProcess {
    self.dfu = YES;
}

#pragma mark - private method
- (void)showAlertWithMsg:(NSString *)msg title:(NSString *)title{
    //让setting页面推出的alert消失
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_bxt_needDismissAlert" object:nil];
    //让所有MKPickView消失
    [[NSNotificationCenter defaultCenter] postNotificationName:@"mk_customUIModule_dismissPickView" object:nil];
    
    @weakify(self);
    MKAlertViewAction *confirmAction = [[MKAlertViewAction alloc] initWithTitle:@"OK" handler:^{
        @strongify(self);
        [self gotoScanPage];
    }];
    MKAlertView *alertView = [[MKAlertView alloc] init];
    [alertView addAction:confirmAction];
    [alertView showAlertWithTitle:title message:msg notificationName:@"mk_bxt_needDismissAlert"];
}

- (void)loadSubPages {
    MKBXTSlotController *slotPage = [[MKBXTSlotController alloc] init];
    slotPage.tabBarItem.title = @"SLOT";
    slotPage.tabBarItem.image = LOADICON(@"MKBeaconXTag", @"MKBXTTabBarController", @"bxt_slotTabBarItemUnselected.png");
    slotPage.tabBarItem.selectedImage = LOADICON(@"MKBeaconXTag", @"MKBXTTabBarController", @"bxt_slotTabBarItemSelected.png");
    MKBaseNavigationController *slotNav = [[MKBaseNavigationController alloc] initWithRootViewController:slotPage];

    MKBXTSettingController *settingPage = [[MKBXTSettingController alloc] init];
    settingPage.tabBarItem.title = @"SETTING";
    settingPage.tabBarItem.image = LOADICON(@"MKBeaconXTag", @"MKBXTTabBarController", @"bxt_settingTabBarItemUnselected.png");
    settingPage.tabBarItem.selectedImage = LOADICON(@"MKBeaconXTag", @"MKBXTTabBarController", @"bxt_settingTabBarItemSelected.png");
    MKBaseNavigationController *settingNav = [[MKBaseNavigationController alloc] initWithRootViewController:settingPage];

    MKBXTDeviceInfoController *devicePage = [[MKBXTDeviceInfoController alloc] init];
    devicePage.tabBarItem.title = @"DEVICE";
    devicePage.tabBarItem.image = LOADICON(@"MKBeaconXTag", @"MKBXTTabBarController", @"bxt_deviceTabBarItemUnselected.png");
    devicePage.tabBarItem.selectedImage = LOADICON(@"MKBeaconXTag", @"MKBXTTabBarController", @"bxt_deviceTabBarItemSelected.png");
    MKBaseNavigationController *deviceNav = [[MKBaseNavigationController alloc] initWithRootViewController:devicePage];
    
    self.viewControllers = @[slotNav,settingNav,deviceNav];
}

@end
