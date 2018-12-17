//
//  SupportChatViewController.h
//  BrainPower
//
//  Created by nestcode on 10/15/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import <UIKit/UIKit.h>
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
#import "SupportChatTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface SupportChatViewController : UIViewController<UITextFieldDelegate,ApiCallManagerDelegate,HTTPRequestHandlerDelegate,UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
{
    HTTPRequestHandler *requestHandler;
    id<ApiCallManagerDelegate>_delegate;
}
@property (weak, nonatomic) IBOutlet UIView *viewCloseTicket;
@property (weak, nonatomic) IBOutlet UIView *viewEnterMessage;
@property (weak, nonatomic) IBOutlet UIView *viewAboutTickets;

- (IBAction)onCloseClicked:(id)sender;
- (IBAction)onCloseTicketClicked:(id)sender;
- (IBAction)onCancelClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtEnterMessage;
- (IBAction)onSendClicked:(id)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeight;

@property (weak, nonatomic) IBOutlet UITableView *tblSupportChat;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *btnCloseTicket;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomDistanceTextField;

@end

NS_ASSUME_NONNULL_END
