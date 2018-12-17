//
//  FaqsViewController.h
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
#import "HTTPRequestHandler.h"
#import "JSON.h"
#import "Reachability.h"
#import "ApiCallManager.h"
#import "SKSTableView.h"
#import "SKSTableViewCell.h"

@interface FaqsViewController : UIViewController<ApiCallManagerDelegate,HTTPRequestHandlerDelegate,SKSTableViewDelegate>{
    HTTPRequestHandler *requestHandler;
    id<ApiCallManagerDelegate>_delegate;
}

@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property (weak, nonatomic) IBOutlet SKSTableView *faqTableView;

@end
