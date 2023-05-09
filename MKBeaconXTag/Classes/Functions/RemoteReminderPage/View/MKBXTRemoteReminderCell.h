//
//  MKBXTRemoteReminderCell.h
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/3/3.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXTRemoteReminderCellModel : NSObject

@property (nonatomic, copy)NSString *msg;

@property (nonatomic, assign)NSInteger index;

@end

@protocol MKBXTRemoteReminderCellDelegate <NSObject>

- (void)bxt_remindButtonPressed:(NSInteger)index;

@end

@interface MKBXTRemoteReminderCell : MKBaseCell

@property (nonatomic, strong)MKBXTRemoteReminderCellModel *dataModel;

@property (nonatomic, weak)id <MKBXTRemoteReminderCellDelegate>delegate;

+ (MKBXTRemoteReminderCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
