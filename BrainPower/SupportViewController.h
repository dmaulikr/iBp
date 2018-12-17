//
//  SupportViewController.h
//  BrainPower
//
//  Created by nestcode on 10/15/18.
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
#import "SupportTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface SupportViewController : UIViewController<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,ApiCallManagerDelegate,HTTPRequestHandlerDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
{
    HTTPRequestHandler *requestHandler;
    id<ApiCallManagerDelegate>_delegate;
}

@property (weak, nonatomic) IBOutlet UITableView *tblTickets;

@property (weak, nonatomic) IBOutlet UIView *viewNotickets;
- (IBAction)onAddTicketClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnAddTickets;

@property (weak, nonatomic) IBOutlet UIView *viewCreateTicket;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;


- (IBAction)onCloseNewTicketsClicked:(id)sender;

@property (weak, nonatomic) IBOutlet NonCopyPasteField *txtCategories;
@property (weak, nonatomic) IBOutlet UITextField *txtTitle;
@property (weak, nonatomic) IBOutlet UITextView *txtDescription;
- (IBAction)onCreateTicketClicked:(id)sender;


@property (weak, nonatomic) IBOutlet UIView *viewCategory;
@property (weak, nonatomic) IBOutlet UIView *viewTitle;
@property (weak, nonatomic) IBOutlet UIView *viewDesc;





@end

NS_ASSUME_NONNULL_END
