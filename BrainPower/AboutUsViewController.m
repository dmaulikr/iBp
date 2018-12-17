//
//  AboutUsViewController.m
//  BrainPower
//
//  Created by nestcode on 1/16/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController{
    NSUserDefaults *ColorCode;
    NSString *strColor, *strPrivacy, *strTnC;
    NSUserDefaults *UserData, *UserAuth;
    NSMutableDictionary *userDictData;
    NSUserDefaults *isLogin, *userLanguage, *Userprofileimg;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    isLogin = [NSUserDefaults standardUserDefaults];
    Userprofileimg = [NSUserDefaults standardUserDefaults];
    userLanguage = [NSUserDefaults standardUserDefaults];
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    _lblVersion.text = [NSString stringWithFormat:@"v:%@",version];
    
    ColorCode = [NSUserDefaults standardUserDefaults];
    strColor = [NSString stringWithFormat:@"%@",[ColorCode valueForKey:@"colorcode"]];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    
    [self APITerms];
}

-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
    
- (IBAction)oniBrainPowersClicked:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://ibrainpowers.com"]];
}

- (IBAction)onSocialClicked:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"http://www.pinterest.com/ibrainpowers"]];
}

- (IBAction)onYouTubeClicked:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://www.youtube.com/channel/UCv-URsbvQapOZQLBhH3qRng"]];
}

- (IBAction)onTwitterClicked:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://twitter.com/ibrainpowers"]];
}

- (IBAction)onInstaClicked:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://www.instagram.com/ibrainpowers/"]];
}

- (IBAction)onFacebookClicked:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://www.facebook.com/IBrainPowers-168772733915255/"]];
}

- (IBAction)onPrivacyPolicyClicked:(id)sender {
    NSUserDefaults *userTnC = [NSUserDefaults standardUserDefaults];
    [userTnC setValue:strTnC forKey:@"userTnC"];
    [userTnC synchronize];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[Global getStoryBoardName] bundle:nil];
    PoliciesViewController *policyVC = (PoliciesViewController *)[storyboard instantiateViewControllerWithIdentifier:@"PoliciesViewController"];
    policyVC.strTypeOfPolicy = @"3";
    [self presentViewController:policyVC animated:YES completion:nil];
}

- (IBAction)onTnCclicked:(id)sender {
    NSUserDefaults *userTnC = [NSUserDefaults standardUserDefaults];
    [userTnC setValue:strPrivacy forKey:@"userTnC"];
    [userTnC synchronize];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[Global getStoryBoardName] bundle:nil];
    PoliciesViewController *policyVC = (PoliciesViewController *)[storyboard instantiateViewControllerWithIdentifier:@"PoliciesViewController"];
    policyVC.strTypeOfPolicy = @"3";
    [self presentViewController:policyVC animated:YES completion:nil];
}

#pragma mark - API WORK

-(void)CheckConnection{
    NSString *strError = NSLocalizedString(@"Device is not connected to Internet!! Please connect to the Internet and try again!!", @"");
    NSString *strAlert = NSLocalizedString(@"Alert!!", @"");
    UIAlertController * alertController1 = [UIAlertController alertControllerWithTitle: strAlert
                                                                               message: strError
                                                                        preferredStyle:UIAlertControllerStyleAlert];
    [alertController1 addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
    }]];
    [self presentViewController:alertController1 animated:YES completion:nil];
    //  [SVProgressHUD dismiss];
    self.view.userInteractionEnabled = YES;
}


-(void)APITerms{
    
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [self CheckConnection];
    }
    else
    {
        self.view.userInteractionEnabled = NO;
        UserAuth = [NSUserDefaults standardUserDefaults];
        NSString *strAuth = [UserAuth valueForKey:@"UserAuth"];
        
        NSString *strUrl = [NSString stringWithFormat:@"%@",API_GET_TERMS];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
        
        [request setHTTPMethod:@"GET"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [request setValue:strAuth forHTTPHeaderField:@"Authorization"];
        [request setHTTPBody:nil];
        
        requestHandler = [[HTTPRequestHandler alloc] initWithRequest:request delegate:self andCallBack:CALL_TYPE_GET_TERMS];
    }
}

#pragma mark - API HANDLER

- (void)parserDidFailWithError:(NSError *)error andCallType:(CallTypeEnum)callType{
    NSString *strError = NSLocalizedString(@"Something went wrong!!, Please try again", @"");
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Error"
                                 message:strError
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    
                                }];
    [alert addAction:yesButton];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)requestHandler:(HTTPRequestHandler *)requestHandler didFailedWithError:(NSError *)error andCallBack:(CallTypeEnum)callType
{
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:@"Error"
                                 message:@"Something went wrong!!, Please try again"
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    
                                }];
    [alert addAction:yesButton];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)requestHandler:(HTTPRequestHandler *)requestHandler didFinishWithData:(NSData *)data andCallBack:(CallTypeEnum)callType
{
    self.view.userInteractionEnabled = YES;
    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *jsonRes = [response JSONValue];
    
    if ([[jsonRes valueForKey:@"message"] isEqualToString:@"Unauthenticated."]) {
        //    [SVProgressHUD dismiss];
        // [isLogin setInteger:0 forKey:@"LoggedIn"];
        //  [isLogin synchronize];
        
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Error"
                                     message:@"Unauthenticated"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"OK"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        
                                        NSFileManager *fileManager = [NSFileManager defaultManager];
                                        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                                        
                                        NSString *filePath = [documentsPath stringByAppendingPathComponent:@"brain.zip"];
                                        NSError *error;
                                        BOOL success = [fileManager removeItemAtPath:filePath error:&error];
                                        if (success) {
                                            NSLog(@"DONE");
                                        }
                                        else
                                        {
                                            NSLog(@"Could not delete file -:%@ ",[error localizedDescription]);
                                        }
                                        [isLogin setInteger:0 forKey:@"LoggedIn"];
                                        [isLogin synchronize];
                                        [userLanguage setValue:@"EN" forKey:@"AppleLanguages"];
                                        [Userprofileimg setObject:@"" forKey:@"user_profile_image"];
                                        [Userprofileimg synchronize];
                                        [self performSegueWithIdentifier:@"OutToLogin" sender:self];
                                    }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    else  {
        [_delegate parserSuccessDelegateDidFinish:jsonRes andCallType:CALL_TYPE_GET_TERMS];
        NSLog(@"%@",jsonRes);
        NSString *strStatus = [NSString stringWithFormat:@"%@",[jsonRes valueForKey:@"status"]];
        if ([strStatus isEqualToString:@"1"]) {
            strTnC = [NSString stringWithFormat:@"%@",[[jsonRes valueForKey:@"data"]valueForKey:@"terms_condition"]];
            strPrivacy = [NSString stringWithFormat:@"%@",[[jsonRes valueForKey:@"data"]valueForKey:@"privacy_policy"]];
        }
        else{
            CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
            style.messageColor = [self colorWithHexString:strColor];
            [self.view makeToast:[jsonRes valueForKey:@"message"]
                        duration:3.0
                        position:CSToastPositionBottom
                           style:style];
            
            [CSToastManager setSharedStyle:style];
            [CSToastManager setTapToDismissEnabled:YES];
            [CSToastManager setQueueEnabled:NO];
        }
    }
}


@end
