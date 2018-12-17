//
//  StepsTableViewController.h
//  BrainPower
//
//  Created by nestcode on 1/16/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StepsTableViewCell.h"
#import "PlayerViewController.h"
#import "ApiCallManager.h"
#import "Constants.h"
#import "HTTPRequestHandler.h"
#import "JSON.h"
#import "Reachability.h"
#import "UIView+Toast.h"
#import "SCLAlertView.h"
#import "SSZipArchive.h"

@interface StepsTableViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource,ApiCallManagerDelegate,HTTPRequestHandlerDelegate, UITextFieldDelegate>{
    HTTPRequestHandler *requestHandler;
    id<ApiCallManagerDelegate>_delegate;
}


@property(nonatomic, retain)NSMutableArray *arrPartsData;

@property(nonatomic)NSString *strModuleID;
@property(nonatomic)NSString *strLevelCanOpen;

@property(nonatomic) int FlagModule;
@property(nonatomic) int ModuleCounts;

@property(nonatomic)NSString *strModuleName;

@end
