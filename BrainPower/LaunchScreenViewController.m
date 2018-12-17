//
//  LaunchScreenViewController.m
//  EROSCOIN
//
//  Created by Maulik D'sai on 21/11/17.
//  Copyright © 2017 eroscoin. All rights reserved.
//

#import "LaunchScreenViewController.h"
#import "DGActivityIndicatorView.h"
#import "LanguageManager.h"

@interface LaunchScreenViewController ()

@end

static NSString * const LanguageSaveKey = @"currentLanguageKey";

@implementation LaunchScreenViewController{
    NSUserDefaults *isLogin;
    NSUserDefaults *UserAuth, *moduleLock;
    NSString *strCallType;
    NSUserDefaults *userLanguage;
    NSUserDefaults *userFireBaseToken, *StepFlag;
    NSUserDefaults *ColorCode;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ColorCode = [NSUserDefaults standardUserDefaults];
    //#1a8005
    
    [ColorCode setValue:@"009191" forKey:@"colorcode"];
    [ColorCode synchronize];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    StepFlag = [NSUserDefaults standardUserDefaults];
    moduleLock = [NSUserDefaults standardUserDefaults];
    userFireBaseToken = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dictLockAPI = [moduleLock objectForKey:@"dictLockAPI"];
    if ([[dictLockAPI valueForKey:@"moduleLock"]isEqualToString:@"1"]) {
        NSLog(@"Module id: %@",[dictLockAPI valueForKey:@"module_id"]);
        [self LockAPI];
    }
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"AppSplash" withExtension:@"gif"];
    _BackGifImageView.image = [UIImage animatedImageWithAnimatedGIFData:[NSData dataWithContentsOfURL:url]];
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    _lblVersion.text = [NSString stringWithFormat:@"v:%@",version];
    _lblVersion.hidden = YES;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self APIGetColor];
}

-(void)CheckConnection{
    NSString *strError = NSLocalizedString(@"Device is not connected to Internet!! Please connect to the Internet and try again!!", @"");
    NSString *strAlert = NSLocalizedString(@"Alert!!", @"");
    UIAlertController * alertController1 = [UIAlertController alertControllerWithTitle: strAlert
                                                                               message: strError
                                                                        preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController1 addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self APIGetColor];
    }]];
    [self presentViewController:alertController1 animated:YES completion:nil];
    //  [SVProgressHUD dismiss];
    self.view.userInteractionEnabled = YES;
}

-(void)APIGetColor{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [self CheckConnection];
    }
    else
    {
        NSString *strUrl = [NSString stringWithFormat:@"%@",API_GET_COLOR];
        NSMutableURLRequest *request1 = [[NSMutableURLRequest alloc]init];
        request1 = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
        
        [request1 setHTTPMethod:@"GET"];
        [request1 setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request1 setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [request1 setHTTPBody:nil];
        
        requestHandler = [[HTTPRequestHandler alloc] initWithRequest:request1 delegate:self andCallBack:CALL_TYPE_GET_COLOR];
        strCallType = @"color";
    }
}

-(void)LockAPI{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [self CheckConnection];
    }
    else
    {
        NSMutableDictionary *dictLockAPI = [moduleLock objectForKey:@"dictLockAPI"];
        NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                             [dictLockAPI valueForKey:@"module_id"], @"module_id",
                             nil];
        NSError* error;
        
        NSData* data = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
        
        // [SVProgressHUD show];
        UserAuth = [NSUserDefaults standardUserDefaults];
        NSString *strAuth = [UserAuth valueForKey:@"UserAuth"];
        
        NSString *strUrl = [NSString stringWithFormat:@"%@",API_USER_MODULE_COMPLETE];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [request setValue:strAuth forHTTPHeaderField:@"Authorization"];
        [request setHTTPBody:data];
        
        requestHandler = [[HTTPRequestHandler alloc] initWithRequest:request delegate:self andCallBack:CALL_TYPE_USER_MODULE_COMPLETE];
        strCallType = @"lock";
    }
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

-(void)UpdateToken{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [self CheckConnection];
    }
    else
    {
        NSString *strToken = [userFireBaseToken valueForKey:@"FireBaseToken"];
        
       
        NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                             strToken, @"notification_token",
                             nil];
        NSError* error;
        
        NSData* data = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
        
        // [SVProgressHUD show];
        UserAuth = [NSUserDefaults standardUserDefaults];
        NSString *strAuth = [UserAuth valueForKey:@"UserAuth"];
        
        NSString *strUrl = [NSString stringWithFormat:@"%@",API_UPDATE_TOKEN];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [request setValue:strAuth forHTTPHeaderField:@"Authorization"];
        [request setHTTPBody:data];
        
        requestHandler = [[HTTPRequestHandler alloc] initWithRequest:request delegate:self andCallBack:CALL_TYPE_UPDATE_TOKEN];
        strCallType = @"Token";
    }
}

-(void)toNewViewController
{
    NSString *currentLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:LanguageSaveKey];
    
    if ([currentLanguage containsString:@"en"]) {
        currentLanguage = @"EN";
    }
    
    if ([currentLanguage containsString:@"hi"]) {
        currentLanguage = @"HI";
    }
    userLanguage = [NSUserDefaults standardUserDefaults];
    
    [userLanguage setValue:currentLanguage forKey:@"AppleLanguages"];
    [userLanguage synchronize];
    
    //[[NSUserDefaults standardUserDefaults] setObject:@[currentLanguage] forKey:@"AppleLanguages"];
    
   isLogin = [NSUserDefaults standardUserDefaults];
    NSInteger fav = [isLogin integerForKey:@"LoggedIn"];

    if (fav == 1) {
        
            [self performSegueWithIdentifier:@"directToHome" sender:self];
       
    }
    else
    {
        [isLogin setInteger:0 forKey:@"LoggedIn"];
        [isLogin synchronize];
        [self performSegueWithIdentifier:@"toLogin" sender:self];
    }
}

#pragma mark - API HANDLER

- (void)parserDidFailWithError:(NSError *)error andCallType:(CallTypeEnum)callType{
    NSLog(@"%s : Error : %@",__FUNCTION__, [error localizedDescription]);
}

- (void)requestHandler:(HTTPRequestHandler *)requestHandler didFailedWithError:(NSError *)error andCallBack:(CallTypeEnum)callType
{
    
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

- (void)requestHandler:(HTTPRequestHandler *)requestHandler didFinishWithData:(NSData *)data andCallBack:(CallTypeEnum)callType
{
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
                                     //   [self performSegueWithIdentifier:@"hometoLogout" sender:self];
                                    }];
        [alert addAction:yesButton];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    else{
        if ([strCallType isEqualToString:@"color"]) {
            [_delegate parserSuccessDelegateDidFinish:jsonRes andCallType:CALL_TYPE_GET_COLOR];
            NSLog(@"%@",jsonRes);
            
            NSString *strColor = [NSString stringWithFormat:@"%@",[jsonRes valueForKey:@"data"]];
            strColor = [strColor stringByReplacingOccurrencesOfString:@"#" withString:@""];
            
            [ColorCode setValue:strColor forKey:@"colorcode"];
            [ColorCode synchronize];
            
            [self performSelector:@selector(toNewViewController) withObject:nil afterDelay:2.0];
            
            [_imgLogo setBackgroundColor:[self colorWithHexString:strColor]];
            [_lblBrain setTextColor:[self colorWithHexString:strColor]];
            
            NSArray *activityTypes = @[@(DGActivityIndicatorAnimationTypeLineScaleParty)];
            
            for (int i = 0; i < activityTypes.count; i++) {
                DGActivityIndicatorView *activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)[activityTypes[i] integerValue] tintColor:[self colorWithHexString:strColor]];
                CGFloat width = self.view.bounds.size.width / 6.0f;
                CGFloat height = self.view.bounds.size.height / 6.0f;
                
                activityIndicatorView.center = CGPointMake(_viewLoader.frame.size.width  / 2,
                                                           _viewLoader.frame.size.height / 2);
                
              //  activityIndicatorView.frame = CGRectMake(5, ([[UIScreen mainScreen] bounds].size.height)-80, width, height);
                [self.viewLoader addSubview:activityIndicatorView];
                [activityIndicatorView startAnimating];
            }
        }
        else if([strCallType isEqualToString:@"lock"]){
            [_delegate parserSuccessDelegateDidFinish:jsonRes andCallType:CALL_TYPE_USER_MODULE_COMPLETE];
            NSLog(@"%@",jsonRes);
            
            NSString *status = [NSString stringWithFormat:@"%@",[jsonRes valueForKey:@"status"]];
            NSLog(@"%@",status);
            NSMutableDictionary *dictLockAPI = [[NSMutableDictionary alloc]init];
            [dictLockAPI setValue:@"0" forKey:@"moduleLock"];
            
            [StepFlag setInteger:0 forKey:@"StepFlag"];
            [StepFlag synchronize];
            
            [moduleLock setObject:dictLockAPI forKey:@"dictLockAPI"];
            [moduleLock synchronize];
            
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
            
        }
    }
}


@end
