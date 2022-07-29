//
//  MKBXTSlotBeaconCell.h
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/7/23.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXTSlotBeaconCellModel : NSObject

@property (nonatomic, copy)NSString *major;

@property (nonatomic, copy)NSString *minor;

@property (nonatomic, copy)NSString *uuid;

@end

@protocol MKBXTSlotBeaconCellDelegate <NSObject>

- (void)bxt_advContent_majorChanged:(NSString *)major;

- (void)bxt_advContent_minorChanged:(NSString *)minor;

- (void)bxt_advContent_uuidChanged:(NSString *)uuid;

@end

@interface MKBXTSlotBeaconCell : MKBaseCell

@property (nonatomic, strong)MKBXTSlotBeaconCellModel *dataModel;

@property (nonatomic, weak)id <MKBXTSlotBeaconCellDelegate>delegate;

+ (MKBXTSlotBeaconCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
