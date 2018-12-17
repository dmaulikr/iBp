//
//  SupportTableViewCell.h
//  BrainPower
//
//  Created by nestcode on 10/20/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SupportTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDate;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblCategory;




@end

NS_ASSUME_NONNULL_END
