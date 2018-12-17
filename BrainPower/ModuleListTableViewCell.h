//
//  ModuleListTableViewCell.h
//  BrainPower
//
//  Created by nestcode on 1/16/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModuleListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblModuleName;
@property (weak, nonatomic) IBOutlet UIImageView *imgStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UIImageView *imgCircle;
@property (weak, nonatomic) IBOutlet UILabel *lblCounts;




@end
