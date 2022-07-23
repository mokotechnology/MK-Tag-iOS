//
//  MKBXTScanTagInfoCell.h
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/7/18.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXTScanTagInfoCellModel : NSObject

@property (nonatomic, assign)BOOL magneticStatus;

@property (nonatomic, copy)NSString *magneticCount;

@property (nonatomic, assign)BOOL motionStatus;

@property (nonatomic, copy)NSString *motionCount;

@property (nonatomic, copy)NSString *xData;

@property (nonatomic, copy)NSString *yData;

@property (nonatomic, copy)NSString *zData;

@end

@interface MKBXTScanTagInfoCell : MKBaseCell

@property (nonatomic, strong)MKBXTScanTagInfoCellModel *dataModel;

+ (MKBXTScanTagInfoCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
