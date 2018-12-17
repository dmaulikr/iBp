//
//  ModuleListTableViewController.m
//  BrainPower
//
//  Created by nestcode on 1/16/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import "ModuleListTableViewController.h"

@interface ModuleListTableViewController ()

@end

@implementation ModuleListTableViewController{
    NSMutableArray *arrPartsData;
    NSUserDefaults *UserAuth, *moduleLock, *userFilePath, *userPass;
    NSString *strModuleID, *strCallType;
    DGActivityIndicatorView *activityIndicatorView;
    UIView *viewLoader;
    UIImageView *img;
    NSString *statusCode;
    NSUserDefaults *ColorCode;
    NSString *strColor;
    NSInteger variable;
    NSUserDefaults *userLanguage;
    NSString *strLang;
    NSUserDefaults *StepFlag, *isLogin;
    NSString *strModuleName, *strFilePath, *strPass;
    NSUserDefaults *Userprofileimg;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    isLogin = [NSUserDefaults standardUserDefaults];
    Userprofileimg = [NSUserDefaults standardUserDefaults];
    
    UIBarButtonItem *btnTitle = [[UIBarButtonItem alloc]
                                   initWithTitle:_strLevelName
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:nil];
    self.navigationItem.rightBarButtonItem = btnTitle;
    
    _arrModuleData = [[NSMutableArray alloc]init];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    ColorCode = [NSUserDefaults standardUserDefaults];
    strColor = [NSString stringWithFormat:@"%@",[ColorCode valueForKey:@"colorcode"]];
    
    userLanguage = [NSUserDefaults standardUserDefaults];
    strLang = [userLanguage valueForKey:@"AppleLanguages"];
    
    userFilePath = [NSUserDefaults standardUserDefaults];
    strFilePath = [NSString stringWithFormat:@"%@",[userFilePath valueForKey:@"userFilePath"]];
    
    userPass = [NSUserDefaults standardUserDefaults];
    strPass = [NSString stringWithFormat:@"%@",[userPass valueForKey:@"userPass"]];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    moduleLock = [NSUserDefaults standardUserDefaults];
    StepFlag = [NSUserDefaults standardUserDefaults];
    [self UnZipMusic];
}

- (void)appDidBecomeActive:(NSNotification *)notification {
    moduleLock = [NSUserDefaults standardUserDefaults];
    StepFlag = [NSUserDefaults standardUserDefaults];
    [self APILoadModules];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    moduleLock = [NSUserDefaults standardUserDefaults];
    StepFlag = [NSUserDefaults standardUserDefaults];
    [self APILoadModules];
}

-(void)UnZipMusic{
    NSString *unzipPath = [self tempUnzipPath];
    if (!unzipPath) {
        return;
    }
 //   NSString *path = [[NSBundle mainBundle] pathForResource:@"iBrainpower" ofType:@"zip"];
    NSLog(@"%@",unzipPath);
 //   NSLog(@"%@",path);
  //  NSString *password = @"ibrainpowers@maulik";
    
    NSString *searchFilename = @"brain.zip"; // name of the File you are searching for
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *getPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",searchFilename]];
        
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:strPass options:0];
    NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    
    /*
     
     /var/mobile/Containers/Data/Application/EF21C876-2D4F-415C-83D7-9686C0E6C993/Documents/brain.zip
     Printing description of getPath:
     /var/mobile/Containers/Data/Application/6BA75566-2945-482A-A6CC-70EF58ECAAED/Documents/brain.zip
     
     */
    
    
    BOOL success = [SSZipArchive unzipFileAtPath:getPath
                                   toDestination:unzipPath
                                       overwrite:YES
                                        password:decodedString.length > 0 ? decodedString : nil
                                           error:nil];
        
    if (!success) {
        NSLog(@"No success");
        return;
    }
    else{
        NSLog(@"success");
    }
    NSError *error = nil;
    
    NSMutableArray<NSString *> *items = [[[NSFileManager defaultManager]
                                          contentsOfDirectoryAtPath:unzipPath
                                          error:&error] mutableCopy];
    if (error) {
        return;
    }
    [items enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *strTemp = [NSString stringWithFormat:@"%@/%@",unzipPath,obj];
        NSURL *TempUrl = [NSURL URLWithString:strTemp];
        NSLog(@"file url: %@",TempUrl);
        [[NSUserDefaults standardUserDefaults] setURL:TempUrl forKey:@"UnZipPath"];
    }];
}

- (NSString *)tempUnzipPath {
    NSString *path = [NSString stringWithFormat:@"%@/\%@",
                      NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0],
                      [NSUUID UUID].UUIDString];
    
    NSURL *url = [NSURL fileURLWithPath:path];
    NSError *error = nil;
    [[NSFileManager defaultManager] createDirectoryAtURL:url
                             withIntermediateDirectories:YES
                                              attributes:nil
                                                   error:&error];
    if (error) {
        return nil;
    }
    return url.path;
}


-(void)ShowActivityIndicator{
    NSArray *activityTypes = @[@(DGActivityIndicatorAnimationTypeBallClipRotateMultiple)];
    viewLoader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [viewLoader setBackgroundColor:[UIColor clearColor]];
    img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, viewLoader.frame.size.width, viewLoader.frame.size.height)];
    [img setBackgroundColor:[UIColor whiteColor]];
    img.alpha = 0.65;
    [viewLoader addSubview:img];
    NSLog(@"started");
    
    for (int i = 0; i < activityTypes.count; i++) {
        activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:(DGActivityIndicatorAnimationType)[activityTypes[i] integerValue] tintColor:[self colorWithHexString:strColor]];
        activityIndicatorView.center = viewLoader.center;
        [viewLoader addSubview:activityIndicatorView];
        [activityIndicatorView startAnimating];
    }
    [self.view addSubview:viewLoader];
}

-(void)HideActivityIndicator{
    viewLoader.hidden = YES;
    NSLog(@"stoped");
    //self.sidebarButton.enabled = YES;
    [activityIndicatorView stopAnimating];
    [activityIndicatorView removeFromSuperview];
}



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

-(void)APILoadModules{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
       [self CheckConnection];
    }
    else
    {
        strLang = [strLang uppercaseString];
        NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                             strLang, @"language",
                             _strLevelID, @"level_id",
                             nil];
        NSError* error;
        NSData* data = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
        
        [self ShowActivityIndicator];
        // [SVProgressHUD show];
        UserAuth = [NSUserDefaults standardUserDefaults];
        NSString *strAuth = [UserAuth valueForKey:@"UserAuth"];
        
        NSString *strUrl = [NSString stringWithFormat:@"%@",API_LOAD_MODULES];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [request setValue:strAuth forHTTPHeaderField:@"Authorization"];
        [request setHTTPBody:data];
        
        requestHandler = [[HTTPRequestHandler alloc] initWithRequest:request delegate:self andCallBack:CALL_TYPE_LOAD_MODULES];
        strCallType = @"module";
    }
}


-(void)APIParts{
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [self CheckConnection];
    }
    else
    {
        strLang = [strLang uppercaseString];
        NSDictionary *tmp = [[NSDictionary alloc] initWithObjectsAndKeys:
                             strLang, @"language",
                             strModuleID, @"module_id",
                             nil];
        NSError* error;
        NSData* data = [NSJSONSerialization dataWithJSONObject:tmp options:0 error:&error];
        [self ShowActivityIndicator];
        // [SVProgressHUD show];
        UserAuth = [NSUserDefaults standardUserDefaults];
        NSString *strAuth = [UserAuth valueForKey:@"UserAuth"];
        
        NSString *strUrl = [NSString stringWithFormat:@"%@",API_LOAD_PARTS];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [request setValue:strAuth forHTTPHeaderField:@"Authorization"];
        [request setHTTPBody:data];
        
        requestHandler = [[HTTPRequestHandler alloc] initWithRequest:request delegate:self andCallBack:CALL_TYPE_LOAD_PARTS];
        strCallType = @"parts";
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrModuleData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ModuleListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSDictionary *dict = [_arrModuleData objectAtIndex:indexPath.row];
    cell.lblCounts.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"module_steps"]];
    cell.lblModuleName.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"module_name"]];
    
    NSString *strActive = NSLocalizedString(@"ACTIVE", @"");
    NSString *strComplt = NSLocalizedString(@"COMPLETED", @"");
    NSString *strLocked = NSLocalizedString(@"LOCKED", @"");
    NSString *strOPEN = NSLocalizedString(@"OPEN", @"");
    
    if ([_strLevelCanOpen isEqualToString:@"1"]) {
        cell.lblStatus.text = strOPEN;
        [cell.lblStatus setBackgroundColor:[UIColor colorWithRed:24.0f/255.0f green:168.0f/255.0f blue:224.0f/255.0f alpha:1]];
        cell.imgStatus.image = [UIImage imageNamed:@"open_module.png"];
        cell.lblStatus.layer.cornerRadius = 5;
        cell.lblStatus.layer.masksToBounds = YES;
    }
    else{
        int status = [[dict valueForKey:@"module_status"]intValue];
        cell.lblStatus.layer.cornerRadius = 5;
        cell.lblStatus.layer.masksToBounds = YES;
        
        switch (status) {
            case 0:
                cell.lblStatus.text = strActive;
                [cell.lblStatus setBackgroundColor:[UIColor colorWithRed:228.0f/255.0f green:174.0f/255.0f blue:114.0f/255.0f alpha:1]];
                cell.imgStatus.image = [UIImage imageNamed:@"active_module.png"];
                break;
            case 1:
                cell.lblStatus.text = strLocked;
                [cell.lblStatus setBackgroundColor:[UIColor colorWithRed:225.0f/255.0f green:128.0f/255.0f blue:111.0f/255.0f alpha:1]];
                cell.imgStatus.image = [UIImage imageNamed:@"locked_module.png"];
                break;
            case 2:
                cell.lblStatus.text = strComplt;
                [cell.lblStatus setBackgroundColor:[UIColor colorWithRed:92.0f/255.0f green:160.0f/255.0f blue:163.0f/255.0f alpha:1]];
                cell.imgStatus.image = [UIImage imageNamed:@"completed_module.png"];
                break;
            default:
                break;
        }
    }
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict = [_arrModuleData objectAtIndex:indexPath.row];
    strModuleID  = [NSString stringWithFormat:@"%@",[dict valueForKey:@"module_id"]];
    strModuleName = [NSString stringWithFormat:@"%@",[dict valueForKey:@"module_name"]];
    variable = (int)indexPath.row;
    
    NSString *strStatus = [NSString stringWithFormat:@"%@",[dict valueForKey:@"module_status"]];
    if ([strStatus isEqualToString:@"0"]) {
        [self APIParts];
    }
    else{
        NSString *strError = NSLocalizedString(@"Level is locked!", @"");
        CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
        style.messageColor = [self colorWithHexString:strColor];
        [self.view makeToast:strError
                    duration:3.0
                    position:CSToastPositionTop
                       style:style];
        
        [CSToastManager setSharedStyle:style];
        [CSToastManager setTapToDismissEnabled:YES];
        [CSToastManager setQueueEnabled:NO];
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
    [self HideActivityIndicator];
}

- (void)requestHandler:(HTTPRequestHandler *)requestHandler didFinishWithData:(NSData *)data andCallBack:(CallTypeEnum)callType
{
    // [SVProgressHUD dismiss];
    
    [self HideActivityIndicator];
    
    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *jsonRes = [response JSONValue];
    
    if ([[jsonRes valueForKey:@"message"] isEqualToString:@"Unauthenticated."]) {
        //  [SVProgressHUD dismiss];
        //  [isLogin setInteger:0 forKey:@"LoggedIn"];
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
    else{
        if ([strCallType isEqualToString:@"module"]) {
            [_delegate parserSuccessDelegateDidFinish:jsonRes andCallType:CALL_TYPE_LOAD_MODULES];
            NSLog(@"%@",jsonRes);
            
            NSString *status = [NSString stringWithFormat:@"%@",[jsonRes valueForKey:@"status"]];
            NSLog(@"%@",status);
            if ([status isEqualToString:@"1"]) {
                _arrModuleData = [jsonRes valueForKey:@"data"];
                NSMutableDictionary *dictLockAPI = [moduleLock objectForKey:@"dictLockAPI"];
                if ([_strLevelCanOpen isEqualToString:@"0"]) {
                    if ([[dictLockAPI valueForKey:@"moduleLock"]isEqualToString:@"1"]) {
                        NSLog(@"Module id: %@",[dictLockAPI valueForKey:@"module_id"]);
                        [self LockAPI];
                    }
                }
                
                NSString *strStatusCode = [NSString stringWithFormat:@"%@",[jsonRes valueForKey:@"statusCode"]];
                if ([strStatusCode isEqualToString:@"521"]) {
                    UIAlertController * alert = [UIAlertController
                                                 alertControllerWithTitle:@"Alert!!"
                                                 message:[jsonRes valueForKey:@"message"]
                                                 preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* yesButton = [UIAlertAction
                                                actionWithTitle:@"OK"
                                                style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction * action) {
                                                    [self.navigationController popViewControllerAnimated:YES];
                                                }];
                    [alert addAction:yesButton];
                    [self presentViewController:alert animated:YES completion:nil];
                }
                
                [self.tableView reloadData];
            }
            else{
                CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
                style.messageColor = [self colorWithHexString:strColor];
                [self.view makeToast:[jsonRes valueForKey:@"message"]
                            duration:3.0
                            position:CSToastPositionTop
                               style:style];
                
                [CSToastManager setSharedStyle:style];
                [CSToastManager setTapToDismissEnabled:YES];
                [CSToastManager setQueueEnabled:NO];
            }
        }
        else if ([strCallType isEqualToString:@"parts"]){
        [_delegate parserSuccessDelegateDidFinish:jsonRes andCallType:CALL_TYPE_LOAD_PARTS];
        NSLog(@"%@",jsonRes);
        
        NSString *status = [NSString stringWithFormat:@"%@",[jsonRes valueForKey:@"status"]];
        NSLog(@"%@",status);
        if ([status isEqualToString:@"1"]) {
            statusCode = [NSString stringWithFormat:@"%@",[jsonRes valueForKey:@"statusCode"]];
            if ([statusCode isEqualToString:@"532"]) {
                SCLAlertView *alert = [[SCLAlertView alloc] init];
                //  alert.customViewColor = [self colorWithHexString:strColor];
                NSString *strMessage = NSLocalizedString(@"You can complete 2 modules in 24 hours and you already have completed 2 modules in 24hrs. Please Visit after 24hrs", @"");
                
                [alert showWarning:self.parentViewController title:@"Alert" subTitle:strMessage closeButtonTitle:@"OK" duration:0.0f];
            }
            else{
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[Global getStoryBoardName] bundle:nil];
                StepsTableViewController *stepsVC = (StepsTableViewController *)[storyboard instantiateViewControllerWithIdentifier:@"StepsTableViewController"];
                
                stepsVC.strModuleID = strModuleID;
                stepsVC.strLevelCanOpen = _strLevelCanOpen;
                stepsVC.arrPartsData = [jsonRes valueForKey:@"data"];
                stepsVC.FlagModule = (int)variable;
                stepsVC.ModuleCounts = (int)_arrModuleData.count;
                stepsVC.strModuleName = strModuleName;
                
                [self.navigationController pushViewController:stepsVC animated:YES];
            }
        }
        else{
            
            UIAlertController * alertController1 = [UIAlertController alertControllerWithTitle: nil
                                                                                       message: [jsonRes valueForKey:@"message"]
                                                                                preferredStyle:UIAlertControllerStyleAlert];
            [alertController1 addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                
            }]];
            [self presentViewController:alertController1 animated:YES completion:nil];
            
          /*  CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
            style.messageColor = [self colorWithHexString:strColor];
            [self.view makeToast:[jsonRes valueForKey:@"message"]
                        duration:3.0
                        position:CSToastPositionTop
                           style:style];
            
            [CSToastManager setSharedStyle:style];
            [CSToastManager setTapToDismissEnabled:YES];
            [CSToastManager setQueueEnabled:NO];*/
        }
        }
        else if ([strCallType isEqualToString:@"lock"]) {
            [_delegate parserSuccessDelegateDidFinish:jsonRes andCallType:CALL_TYPE_USER_MODULE_COMPLETE];
            NSLog(@"%@",jsonRes);
            
            NSString *status = [NSString stringWithFormat:@"%@",[jsonRes valueForKey:@"status"]];
            NSLog(@"%@",status);
            NSMutableDictionary *dictLockAPI = [[NSMutableDictionary alloc]init];
            [dictLockAPI setValue:@"0" forKey:@"moduleLock"];
            
            [moduleLock setObject:dictLockAPI forKey:@"dictLockAPI"];
            [moduleLock synchronize];
            
            [StepFlag setInteger:0 forKey:@"StepFlag"];
            [StepFlag synchronize];
            
            if ([status isEqualToString:@"1"]) {
                
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
                
                [self APILoadModules];
            }
            else{
                CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
                style.messageColor = [self colorWithHexString:strColor];
                [self.view makeToast:[jsonRes valueForKey:@"message"]
                            duration:3.0
                            position:CSToastPositionTop
                               style:style];
                
                [CSToastManager setSharedStyle:style];
                [CSToastManager setTapToDismissEnabled:YES];
                [CSToastManager setQueueEnabled:NO];
            }
        }
    }
    
}

@end
