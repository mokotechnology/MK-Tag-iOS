//
//  MKBXTDFUModule.h
//  MKLoRaWAN-BG_Example
//
//  Created by aa on 2021/6/18.
//  Copyright © 2021 aadyx2007@163.com. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*
 DFU升级流程
 1、先判断设备是否有otaContral特征(@"f7bf3564-fb6d-4e53-88a4-5e37e0326063")特征，如果没有则直接认为失败。通过otaContral特征发送0x00通知设备开启dfu模式。
 2、收到设备接收0x00成功之后，判断设备是否有otaData特征(@"984227f3-34fc-4045-a5d0-2c581f81a153")，如果有的话，直接通过otaData发送一帧帧的升级数据，如果没有otaData特征，则需要先断开设备的连接，延时4s之后重新连接设备，然后跳到步骤1。
 3、当最后一帧dfu数据发送成功之后，则通过otaContral特征发送0x03通知设备结束ota，此时DFU升级完毕。
 */

@interface MKBXTDFUModule : NSObject

- (void)updateWithFileUrl:(NSString *)url
                 sucBlock:(void (^)(void))sucBlock
              failedBlock:(void (^)(NSError *error))failedBlock;

@end

NS_ASSUME_NONNULL_END
