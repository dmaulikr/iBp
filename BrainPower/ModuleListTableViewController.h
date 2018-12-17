//
//  ModuleListTableViewController.h
//  BrainPower
//
//  Created by nestcode on 1/16/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModuleListTableViewCell.h"
#import "StepsTableViewController.h"
#import "ApiCallManager.h"
#import "Constants.h"
#import "HTTPRequestHandler.h"
#import "JSON.h"
#import "Reachability.h"
#import "UIView+Toast.h"
#import "DGActivityIndicatorView.h"
#import "SCLAlertView.h"
#import "SSZipArchive.h"

@interface ModuleListTableViewController : UITableViewController<UITableViewDelegate,UITableViewDataSource,ApiCallManagerDelegate,HTTPRequestHandlerDelegate, UITextFieldDelegate>{
    HTTPRequestHandler *requestHandler;
    id<ApiCallManagerDelegate>_delegate;
}


@property(nonatomic, retain)NSMutableArray *arrModuleData;
@property(nonatomic)NSString *strLevelID;
@property(nonatomic)NSString *strLevelCanOpen;

@property(nonatomic)NSString *strLevelName;

@end
