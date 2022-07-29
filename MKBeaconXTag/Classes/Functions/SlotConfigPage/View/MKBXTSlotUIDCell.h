//
//  MKBXTSlotUIDCell.h
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/7/23.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXTSlotUIDCellModel : NSObject

@property (nonatomic, copy)NSString *namespaceID;

@property (nonatomic, copy)NSString *instanceID;

@end

@protocol MKBXTSlotUIDCellDelegate <NSObject>

- (void)bxt_advContent_namespaceIDChanged:(NSString *)text;

- (void)bxt_advContent_instanceIDChanged:(NSString *)text;

@end

@interface MKBXTSlotUIDCell : MKBaseCell

@property (nonatomic, strong)MKBXTSlotUIDCellModel *dataModel;

@property (nonatomic, weak)id <MKBXTSlotUIDCellDelegate>delegate;

+ (MKBXTSlotUIDCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
