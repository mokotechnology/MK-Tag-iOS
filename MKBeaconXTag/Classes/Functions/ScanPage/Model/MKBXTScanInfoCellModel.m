//
//  MKBXTScanInfoCellModel.m
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/7/17.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import "MKBXTScanInfoCellModel.h"

@implementation MKBXTScanInfoCellModel

- (NSMutableArray *)advertiseList {
    if (!_advertiseList) {
        _advertiseList = [NSMutableArray array];
    }
    return _advertiseList;
}

@end
