//
//  AboutUsViewController.h
//  BrainPower
//
//  Created by nestcode on 1/16/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"
#import "Constants.h"
#import "ApiCallManager.h"
#import "Constants.h"
#import "HTTPRequestHandler.h"
#import "JSON.h"
#import "Reachability.h"
#import "Global.h"
#import "UIView+Toast.h"
#import "PoliciesViewController.h"

@interface AboutUsViewController : UIViewController<ApiCallManagerDelegate,HTTPRequestHandlerDelegate>
{
    HTTPRequestHandler *requestHandler;
    id<ApiCallManagerDelegate>_delegate;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (weak, nonatomic) IBOutlet UILabel *lblVersion;

- (IBAction)oniBrainPowersClicked:(id)sender;

- (IBAction)onSocialClicked:(id)sender;
- (IBAction)onYouTubeClicked:(id)sender;
- (IBAction)onTwitterClicked:(id)sender;
- (IBAction)onInstaClicked:(id)sender;
- (IBAction)onFacebookClicked:(id)sender;

- (IBAction)onPrivacyPolicyClicked:(id)sender;
- (IBAction)onTnCclicked:(id)sender;


@end
