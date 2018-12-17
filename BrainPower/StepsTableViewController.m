//
//  StepsTableViewController.m
//  BrainPower
//
//  Created by nestcode on 1/16/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import "StepsTableViewController.h"

@interface StepsTableViewController ()

@end

@implementation StepsTableViewController{
    NSUserDefaults *UserAuth;
    NSString *strPartID;
    int FlagStatus;
    NSMutableArray *arrData;
    NSUserDefaults *StepFlag;
    NSUserDefaults *ColorCode;
    NSString *strColor;
    int airplane;
    NSUserDefaults *userPass, *userFilePath;
    NSString *strFilePath, *strPass;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *btnTitle = [[UIBarButtonItem alloc]
                                 initWithTitle:_strModuleName
                                 style:UIBarButtonItemStyleBordered
                                 target:self
                                 action:nil];
    self.navigationItem.rightBarButtonItem = btnTitle;
    
    FlagStatus = 0;
     NSLog(@"%@",_arrPartsData);

    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    userFilePath = [NSUserDefaults standardUserDefaults];
    strFilePath = [NSString stringWithFormat:@"%@",[userFilePath valueForKey:@"userFilePath"]];
    
    userPass = [NSUserDefaults standardUserDefaults];
    strPass = [NSString stringWithFormat:@"%@",[userPass valueForKey:@"userPass"]];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if ([_strLevelCanOpen isEqualToString:@"1"]) {}
    
    StepFlag = [NSUserDefaults standardUserDefaults];

    if([[[StepFlag dictionaryRepresentation] allKeys] containsObject:@"StepFlag"]){
        NSInteger flag = [StepFlag integerForKey:@"StepFlag"];
        FlagStatus = (int)flag;
        NSLog(@"%d",FlagStatus);
        [self.tableView reloadData];
    }
    
    NSUserDefaults *goback = [NSUserDefaults standardUserDefaults];
    if ([[goback valueForKey:@"goback"] isEqualToString:@"1"]) {
        [goback setValue:@"0" forKey:@"goback"];
        [goback synchronize];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    ColorCode = [NSUserDefaults standardUserDefaults];
    strColor = [NSString stringWithFormat:@"%@",[ColorCode valueForKey:@"colorcode"]];
    
    [self UnZipMusic];
    
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
    
    NSString *searchFilename = @"brain.zip"; // name of the PDF you are searching for
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *getPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",searchFilename]];
    
    NSData *decodedData = [[NSData alloc] initWithBase64EncodedString:strPass options:0];
    NSString *decodedString = [[NSString alloc] initWithData:decodedData encoding:NSUTF8StringEncoding];
    
    BOOL success = [SSZipArchive unzipFileAtPath:strFilePath
                                   toDestination:unzipPath
                                       overwrite:YES
                                        password:decodedString.length > 0 ? decodedString : nil
                                           error:nil];
    
    if (!success) {
        NSLog(@"No success");
        return;
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrPartsData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StepsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    NSDictionary *dict = [_arrPartsData objectAtIndex:indexPath.row];
    
    cell.lblStepName.text = [NSString stringWithFormat:@"%@",[dict valueForKey:@"part_name"]];
    
    NSString *strActive = NSLocalizedString(@"ACTIVE", @"");
    NSString *strComplt = NSLocalizedString(@"COMPLETED", @"");
    NSString *strLocked = NSLocalizedString(@"LOCKED", @"");
    NSString *strOPEN = NSLocalizedString(@"OPEN", @"");
    
    if ([_strLevelCanOpen isEqualToString:@"1"]) {
        cell.lblStatus.text = strOPEN;
        [cell.lblStatus setBackgroundColor:[UIColor colorWithRed:24.0f/255.0f green:168.0f/255.0f blue:224.0f/255.0f alpha:1]];
        cell.imgStatus.image = [UIImage imageNamed:@"open_module.png"];
        [cell.imgHeadPhones setBackgroundColor:[UIColor colorWithRed:24.0f/255.0f green:168.0f/255.0f blue:224.0f/255.0f alpha:1]];
        [cell.imgAirPlaneMode setBackgroundColor:[UIColor colorWithRed:24.0f/255.0f green:168.0f/255.0f blue:224.0f/255.0f alpha:1]];
    }
    else{
        if (FlagStatus == indexPath.row) {
            cell.lblStatus.text = strActive;
            cell.imgStatus.image = [UIImage imageNamed:@"active_module.png"];
            [cell.lblStatus setBackgroundColor:[UIColor colorWithRed:228.0f/255.0f green:174.0f/255.0f blue:114.0f/255.0f alpha:1]];
        }
        else{
            if (FlagStatus > indexPath.row) {
                cell.lblStatus.text = strComplt;
                [cell.lblStatus setBackgroundColor:[UIColor colorWithRed:92.0f/255.0f green:160.0f/255.0f blue:163.0f/255.0f alpha:1]];
                cell.imgStatus.image = [UIImage imageNamed:@"completed_module.png"];
                [cell.imgHeadPhones setBackgroundColor:[UIColor colorWithRed:92.0f/255.0f green:160.0f/255.0f blue:163.0f/255.0f alpha:1]];
                [cell.imgAirPlaneMode setBackgroundColor:[UIColor colorWithRed:92.0f/255.0f green:160.0f/255.0f blue:163.0f/255.0f alpha:1]];
            }
            else{
                cell.lblStatus.text = strLocked;
                [cell.lblStatus setBackgroundColor:[UIColor colorWithRed:225.0f/255.0f green:128.0f/255.0f blue:111.0f/255.0f alpha:1]];
                cell.imgStatus.image = [UIImage imageNamed:@"locked_module.png"];
                [cell.imgHeadPhones setBackgroundColor:[UIColor colorWithRed:225.0f/255.0f green:128.0f/255.0f blue:111.0f/255.0f alpha:1]];
                [cell.imgAirPlaneMode setBackgroundColor:[UIColor colorWithRed:225.0f/255.0f green:128.0f/255.0f blue:111.0f/255.0f alpha:1]];
            }
        }
    }
    
    airplane = [[dict valueForKey:@"airplane_mode_required"]intValue];
    int headPhone = [[dict valueForKey:@"handsfree_required"]intValue];
    
    if (airplane == 0) {
        cell.imgAirPlaneMode.hidden = YES;
    }
    else{
        cell.imgAirPlaneMode.hidden = NO;
    }
    
    if (headPhone == 0) {
        cell.imgHeadPhones.hidden = YES;
    }
    else{
        cell.imgHeadPhones.hidden = NO;
    }
    
    cell.lblStatus.layer.cornerRadius = 5;
    cell.lblStatus.layer.masksToBounds = YES;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (BOOL)isHeadsetPluggedIn {
    AVAudioSessionRouteDescription* route = [[AVAudioSession sharedInstance] currentRoute];
    for (AVAudioSessionPortDescription* desc in [route outputs]) {
        if ([[desc portType] isEqualToString:AVAudioSessionPortHeadphones]|| [[desc portType] isEqualToString:AVAudioSessionPortBluetoothA2DP])
            return YES;
    }
    return NO;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable && airplane != 1)
    {
        [self CheckConnection];
    }
    else{
        NSDictionary *dict = [_arrPartsData objectAtIndex:indexPath.row];
        
        airplane = [[dict valueForKey:@"airplane_mode_required"]intValue];
        
        int headPhone = [[dict valueForKey:@"handsfree_required"]intValue];
        
        NSString *strMessageAir = NSLocalizedString(@"Please enable phone to Airplane Mode.", @"");
        NSString *strMessageHeadP = NSLocalizedString(@"Please plugin HEADPHONE and Keep Volume Maximum.", @"");
        
        if ([_strLevelCanOpen isEqualToString:@"1"]) {
            if (headPhone == 0) {
                [self CallNextView:(int)indexPath.row];
            }
            else{
                if (self.isHeadsetPluggedIn) {
                    NSLog(@"TRUE");
                    if (airplane == 1) {
                        if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable){
                            [StepFlag setInteger:FlagStatus forKey:@"StepFlag"];
                            [StepFlag synchronize];
                            
                            [self CallNextView:(int)indexPath.row];
                            
                            NSUserDefaults *index = [NSUserDefaults standardUserDefaults];
                            [index setInteger:indexPath.row forKey:@"indexPath"];
                            [index synchronize];
                        }
                        else{
                            SCLAlertView *alert = [[SCLAlertView alloc] init];
                            [alert addButton:@"OK" actionBlock:^(void) {
                                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                            }];
                            [alert showWarning:self.parentViewController title:@"iBrainPowers" subTitle:strMessageAir closeButtonTitle:nil duration:0.0f];
                        }
                    }
                    else{
                        [StepFlag setInteger:FlagStatus forKey:@"StepFlag"];
                        [StepFlag synchronize];
                        
                        [self CallNextView:(int)indexPath.row];
                        
                        NSUserDefaults *index = [NSUserDefaults standardUserDefaults];
                        [index setInteger:indexPath.row forKey:@"indexPath"];
                        [index synchronize];
                    }
                }
                else{
                    SCLAlertView *alert = [[SCLAlertView alloc] init];
                    [alert addButton:@"OK" actionBlock:^(void) {
                        
                    }];
                    [alert showWarning:self.parentViewController title:@"iBrainPowers" subTitle:strMessageHeadP closeButtonTitle:nil duration:0.0f];
                }
            }
        }
        else{
            if (FlagStatus == indexPath.row) {
                if (headPhone == 0) {
                    [StepFlag setInteger:FlagStatus forKey:@"StepFlag"];
                    [StepFlag synchronize];
                    
                    [self CallNextView:(int)indexPath.row];
                    
                    NSUserDefaults *index = [NSUserDefaults standardUserDefaults];
                    [index setInteger:indexPath.row forKey:@"indexPath"];
                    [index synchronize];
                }
                else{
                    if (self.isHeadsetPluggedIn) {
                        NSLog(@"TRUE");
                        if (airplane == 1) {
                            if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable){
                                [StepFlag setInteger:FlagStatus forKey:@"StepFlag"];
                                [StepFlag synchronize];
                                
                                [self CallNextView:(int)indexPath.row];
                                
                                NSUserDefaults *index = [NSUserDefaults standardUserDefaults];
                                [index setInteger:indexPath.row forKey:@"indexPath"];
                                [index synchronize];
                            }
                            else{
                                SCLAlertView *alert = [[SCLAlertView alloc] init];
                                [alert addButton:@"OK" actionBlock:^(void) {
                                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                }];
                                [alert showWarning:self.parentViewController title:@"iBrainPowers" subTitle:strMessageAir closeButtonTitle:nil duration:0.0f];
                            }
                        }
                        else{
                            [StepFlag setInteger:FlagStatus forKey:@"StepFlag"];
                            [StepFlag synchronize];
                            
                            [self CallNextView:(int)indexPath.row];
                            
                            NSUserDefaults *index = [NSUserDefaults standardUserDefaults];
                            [index setInteger:indexPath.row forKey:@"indexPath"];
                            [index synchronize];
                        }
                    }
                    else{
                        SCLAlertView *alert = [[SCLAlertView alloc] init];
                        [alert addButton:@"OK" actionBlock:^(void) {
                            
                        }];
                        [alert showWarning:self.parentViewController title:@"iBrainPowers" subTitle:strMessageHeadP closeButtonTitle:nil duration:0.0f];
                    }
                }
            }
            else{
                if (FlagStatus > indexPath.row) {
                    if (headPhone == 0) {
                          [self CallNextView:(int)indexPath.row];
                        
                    }
                    else{
                        if (self.isHeadsetPluggedIn) {
                            NSLog(@"TRUE");
                            if (airplane == 1) {
                                if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable){
                                    [StepFlag setInteger:FlagStatus forKey:@"StepFlag"];
                                    [StepFlag synchronize];
                                    
                                    [self CallNextView:(int)indexPath.row];
                                    
                                    NSUserDefaults *index = [NSUserDefaults standardUserDefaults];
                                    [index setInteger:indexPath.row forKey:@"indexPath"];
                                    [index synchronize];
                                }
                                else{
                                    SCLAlertView *alert = [[SCLAlertView alloc] init];
                                    [alert addButton:@"OK" actionBlock:^(void) {
                                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
                                    }];
                                    [alert showWarning:self.parentViewController title:@"iBrainPowers" subTitle:strMessageAir closeButtonTitle:nil duration:0.0f];
                                }
                            }
                            else{
                                [StepFlag setInteger:FlagStatus forKey:@"StepFlag"];
                                [StepFlag synchronize];
                                [self CallNextView:(int)indexPath.row];
                                
                                NSUserDefaults *index = [NSUserDefaults standardUserDefaults];
                                [index setInteger:indexPath.row forKey:@"indexPath"];
                                [index synchronize];
                            }
                        }
                        else{
                            SCLAlertView *alert = [[SCLAlertView alloc] init];
                            [alert addButton:@"OK" actionBlock:^(void) {
                            }];
                            [alert showWarning:self.parentViewController title:@"iBrainPowers" subTitle:strMessageHeadP closeButtonTitle:nil duration:0.0f];
                        }
                    }
                }
            }
        }
    }
}

-(void)CallNextView:(int)index{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[Global getStoryBoardName] bundle:nil];
    PlayerViewController *playerVC = (PlayerViewController *)[storyboard instantiateViewControllerWithIdentifier:@"PlayerViewController"];
    playerVC.dictPartData = [_arrPartsData objectAtIndex:index];
    playerVC.index = (int)index;
    playerVC.arrCount = (int)_arrPartsData.count;
    playerVC.strModuleID = _strModuleID;
    NSLog(@"%d",_FlagModule);
    playerVC.FlagModule = _FlagModule;
    playerVC.ModuleCounts = _ModuleCounts;
    playerVC.strLevelCanOpen = _strLevelCanOpen;
    playerVC.isAirPlaneReq = airplane;
    [self.navigationController pushViewController:playerVC animated:YES];
}

@end
