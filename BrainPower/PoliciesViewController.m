//
//  PoliciesViewController.m
//  BrainPower
//
//  Created by nestcode on 3/16/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import "PoliciesViewController.h"

@interface PoliciesViewController ()

@end

@implementation PoliciesViewController{
    NSURL *targetURL;
    NSUserDefaults *userTnC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[self navigationController] setNavigationBarHidden:NO animated:YES];
    
    _policiesPDFView.delegate = self;
    if ([_strTypeOfPolicy isEqualToString:@"1"]) {
        targetURL = [[NSBundle mainBundle] URLForResource:@"Terms and Conditions" withExtension:@"pdf"];
    }
    else if ([_strTypeOfPolicy isEqualToString:@"2"]) {
        targetURL = [[NSBundle mainBundle] URLForResource:@"Privacy Policy" withExtension:@"pdf"];
    }
    else{
        userTnC = [NSUserDefaults standardUserDefaults];
        NSString *str = [NSString stringWithFormat:@"%@",[userTnC valueForKey:@"userTnC"]];
        targetURL = [NSURL URLWithString:str];
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [_policiesPDFView loadRequest:request];
 
}



- (IBAction)onBackClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
