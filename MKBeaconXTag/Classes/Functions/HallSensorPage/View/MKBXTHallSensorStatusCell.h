//
//  MKBXTHallSensorStatusCell.h
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/7/22.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXTHallSensorStatusCellModel : NSObject

@property (nonatomic, assign)BOOL isOn;

@end

@protocol MKBXTHallSensorStatusCellDelegate <NSObject>

- (void)bxt_hallSensorStatusChanged:(BOOL)isOn;

@end

@interface MKBXTHallSensorStatusCell : MKBaseCell

@property (nonatomic, strong)MKBXTHallSensorStatusCellModel *dataModel;

@property (nonatomic, weak)id <MKBXTHallSensorStatusCellDelegate>delegate;

+ (MKBXTHallSensorStatusCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
