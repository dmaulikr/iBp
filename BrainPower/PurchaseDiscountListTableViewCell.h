//
//  PurchaseDiscountListTableViewCell.h
//  BrainPower
//
//  Created by nestcode on 10/25/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PurchaseDiscountListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblDiscountAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@end

NS_ASSUME_NONNULL_END
