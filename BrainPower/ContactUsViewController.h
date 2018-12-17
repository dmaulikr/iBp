//
//  ContactUsViewController.h
//  BrainPower
//
//  Created by nestcode on 1/16/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "Constants.h"
#import "UIView+Toast.h"
#import "DGActivityIndicatorView.h"
#import "NonCopyPasteField.h"
#import "LanguageManager.h"
#import "AppDelegate.h"
#import "ApiCallManager.h"
#import "Constants.h"
#import "HTTPRequestHandler.h"
#import "JSON.h"
#import "Reachability.h"
#import "Global.h"
#import "SVProgressHUD.h"
#import "LanguagesTableViewCell.h"

@interface ContactUsViewController : UIViewController<UITextFieldDelegate,ApiCallManagerDelegate,HTTPRequestHandlerDelegate,UITableViewDelegate,UITableViewDataSource>
{
    HTTPRequestHandler *requestHandler;
    id<ApiCallManagerDelegate>_delegate;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property (weak, nonatomic) IBOutlet UILabel *lblLanguageSettings;

@property (weak, nonatomic) IBOutlet NonCopyPasteField *txtLanguage;

@property (weak, nonatomic) IBOutlet UISegmentedControl *select_language;

- (IBAction)onLangugageSelectClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UITableView *tblLanguage;

@end
