//
//  ModuleListTableViewCell.m
//  BrainPower
//
//  Created by nestcode on 1/16/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import "ModuleListTableViewCell.h"

@implementation ModuleListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _lblStatus.layer.cornerRadius = 5.0f;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
