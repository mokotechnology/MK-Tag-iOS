//
//  MKBXTSlotConfigTagInfoCell.h
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/7/23.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXTSlotConfigTagInfoCellModel : NSObject

@property (nonatomic, copy)NSString *deviceName;

@property (nonatomic, copy)NSString *tagID;

@end

@interface MKBXTSlotConfigTagInfoCell : MKBaseCell

@property (nonatomic, strong)MKBXTSlotConfigTagInfoCellModel *dataModel;

+ (MKBXTSlotConfigTagInfoCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
