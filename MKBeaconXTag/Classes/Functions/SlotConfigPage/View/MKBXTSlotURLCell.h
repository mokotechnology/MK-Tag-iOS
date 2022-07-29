//
//  MKBXTSlotURLCell.h
//  MKBeaconXTag_Example
//
//  Created by aa on 2022/7/23.
//  Copyright © 2022 aadyx2007@163.com. All rights reserved.
//

#import <MKBaseModuleLibrary/MKBaseCell.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKBXTSlotURLCellModel : NSObject

/// 0:@"http://www.",1:@"https://www.",2:@"http://",3:@"https://"
@property (nonatomic, assign)NSInteger urlType;

@property (nonatomic, copy)NSString *urlContent;

@end

@protocol MKBXTSlotURLCellDelegate <NSObject>

/// 用户选择了URL类型
/// @param urlType 0:@"http://www.",1:@"https://www.",2:@"http://",3:@"https://"
- (void)bxt_advContent_urlTypeChanged:(NSInteger)urlType;

- (void)bxt_advContent_urlContentChanged:(NSString *)content;

@end

@interface MKBXTSlotURLCell : MKBaseCell

@property (nonatomic, strong)MKBXTSlotURLCellModel *dataModel;

@property (nonatomic, weak)id <MKBXTSlotURLCellDelegate>delegate;

+ (MKBXTSlotURLCell *)initCellWithTableView:(UITableView *)tableView;

@end

NS_ASSUME_NONNULL_END
