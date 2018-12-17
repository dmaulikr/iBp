//
//  PoliciesViewController.h
//  BrainPower
//
//  Created by nestcode on 3/16/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PoliciesViewController : UIViewController<UIWebViewDelegate>


@property (nonatomic)NSString *strTypeOfPolicy;
@property (weak, nonatomic) IBOutlet UIWebView *policiesPDFView;

- (IBAction)onBackClicked:(id)sender;


@end
