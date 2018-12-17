  //
//  LaunchScreenViewController.h
//  EROSCOIN
//
//  Created by Maulik D'sai on 21/11/17.
//  Copyright © 2017 eroscoin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "ApiCallManager.h"
#import "Constants.h"
#import "HTTPRequestHandler.h"
#import "Reachability.h"
#import "UIImage+animatedGIF.h"

@interface LaunchScreenViewController : UIViewController<ApiCallManagerDelegate,HTTPRequestHandlerDelegate>{
    HTTPRequestHandler *requestHandler;
    id<ApiCallManagerDelegate>_delegate;
}

@property (weak, nonatomic) IBOutlet UILabel *lblVersion;

@property (weak, nonatomic) IBOutlet UIImageView *BackGifImageView;
@property (weak, nonatomic) IBOutlet UIImageView *imgLogo;
@property (weak, nonatomic) IBOutlet UILabel *lblBrain;

@property (weak, nonatomic) IBOutlet UIView *viewLoader;

@end
