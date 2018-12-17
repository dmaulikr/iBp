//
//  SupportChatTableViewCell.h
//  BrainPower
//
//  Created by nestcode on 10/24/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

NS_ASSUME_NONNULL_BEGIN

@interface SupportChatTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *viewReceived;
@property (weak, nonatomic) IBOutlet UIView *viewSent;

@property (weak, nonatomic) IBOutlet UILabel *lblSent;
@property (weak, nonatomic) IBOutlet UILabel *lblReceived;

@property (weak, nonatomic) IBOutlet UILabel *lblTimeSent;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeReceived;


@end

NS_ASSUME_NONNULL_END
