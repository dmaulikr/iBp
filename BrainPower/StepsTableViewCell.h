//
//  StepsTableViewCell.h
//  BrainPower
//
//  Created by nestcode on 1/16/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StepsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblStepName;
@property (weak, nonatomic) IBOutlet UIImageView *imgStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UIImageView *imgCircle;
@property (weak, nonatomic) IBOutlet UIImageView *imgHeadPhones;
@property (weak, nonatomic) IBOutlet UIImageView *imgAirPlaneMode;


@end
