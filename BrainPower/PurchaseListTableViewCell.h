//
//  PurchaseListTableViewCell.h
//  BrainPower
//
//  Created by nestcode on 9/25/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

NS_ASSUME_NONNULL_BEGIN

@interface PurchaseListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgCart;
@property (weak, nonatomic) IBOutlet UILabel *lblPackageName;
@property (weak, nonatomic) IBOutlet UILabel *lblLastAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblDiscount;
@property (weak, nonatomic) IBOutlet UIView *viewDiscount;
@property (weak, nonatomic) IBOutlet UIView *viewBack;

@property (weak, nonatomic) IBOutlet UIView *viewPurchased;


@end

NS_ASSUME_NONNULL_END
