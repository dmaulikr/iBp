//
//  FaqsViewController.m
//  BrainPower
//
//  Created by nestcode on 1/16/18.
//  Copyright © 2018 nestcode. All rights reserved.
//

#import "FaqsViewController.h"

#define FONT_SIZE 14.0f
#define CELL_CONTENT_WIDTH 320.0f
#define CELL_CONTENT_MARGIN 10.0f

@interface FaqsViewController ()

@end

@implementation FaqsViewController{
    NSUserDefaults *ColorCode;
    NSString *strColor;
    NSUserDefaults *UserData, *UserAuth;
    NSMutableDictionary *userDictData;
    NSMutableArray *arrFAQ;
    NSUserDefaults *isLogin, *userLanguage, *Userprofileimg;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.faqTableView.tableFooterView = [UIView new];
    arrFAQ = [[NSMutableArray alloc]init];
    ColorCode = [NSUserDefaults standardUserDefaults];
    strColor = [NSString stringWithFormat:@"%@",[ColorCode valueForKey:@"colorcode"]];
    
    isLogin = [NSUserDefaults standardUserDefaults];
    Userprofileimg = [NSUserDefaults standardUserDefaults];
    userLanguage = [NSUserDefaults standardUserDefaults];
    
    SWRevealViewController *revealViewController = self.revealViewController;
    if ( revealViewController )
    {
        [self.sidebarButton setTarget: self.revealViewController];
        [self.sidebarButton setAction: @selector( revealToggle: )];
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    }
    [self APIFaq];
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

#pragma mark - Faqtable

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;//[arrFAQ count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrFAQ count];
}

- (NSInteger)tableView:(SKSTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath
{
    return 1;
}

- (BOOL)tableView:(SKSTableView *)tableView shouldExpandSubRowsOfCellAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SKSTableViewCell";
    
    SKSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
        cell = [[SKSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    [cell setBackgroundColor:[self colorWithHexString:strColor]];
    
    NSDictionary *dict = [arrFAQ objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [dict valueForKey:@"faq_que"];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    cell.textLabel.lineBreakMode = UILineBreakModeTailTruncation;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:FONT_SIZE];
    cell.textLabel.numberOfLines = 0;
    
    cell.expandable = YES;
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UITableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    NSDictionary *dict = [arrFAQ objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [dict valueForKey:@"faq_ans"];
    //[NSString stringWithFormat:@"%@", self.contents[indexPath.section][indexPath.row][indexPath.subRow]];
    
    cell.textLabel.lineBreakMode = UILineBreakModeTailTruncation;
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:FONT_SIZE];
    cell.textLabel.numberOfLines = 0;
    [cell.textLabel setTag:1];
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [arrFAQ objectAtIndex:indexPath.row];
    
    NSString *cellText = [dict valueForKey:@"faq_ans"];  // [NSString stringWithFormat:@"%@", self.contents[indexPath.section][indexPath.row][indexPath.subRow]];
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize size = [cellText sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeTailTruncation];
    
    CGFloat height = MAX(size.height, 20.0f);
    
    return height + (CELL_CONTENT_MARGIN * 2);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSDictionary *dict = [arrFAQ objectAtIndex:indexPath.row];
    
    NSString *cellText = [dict valueForKey:@"faq_que"];
    
   // NSString *cellText = [NSString stringWithFormat:@"%@", self.contents[indexPath.section][indexPath.row][indexPath.subRow]];
    
    CGSize constraint = CGSizeMake(CELL_CONTENT_WIDTH - (CELL_CONTENT_MARGIN * 2), 20000.0f);
    
    CGSize size = [cellText sizeWithFont:[UIFont systemFontOfSize:FONT_SIZE] constrainedToSize:constraint lineBreakMode:UILineBreakModeTailTruncation];
    
    CGFloat height = MAX(size.height, 20.0f);
    
    return height + (CELL_CONTENT_MARGIN * 2);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Section: %ld, Row:%ld, Subrow:%ld", (long)indexPath.section, (long)indexPath.row, (long)indexPath.subRow);
}

- (void)tableView:(SKSTableView *)tableView didSelectSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Section: %ld, Row:%ld, Subrow:%ld", (long)indexPath.section, (long)indexPath.row, (long)indexPath.subRow);
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


-(void)APIFaq{
    
    if ([[Reachability reachabilityForInternetConnection]currentReachabilityStatus]==NotReachable)
    {
        [self CheckConnection];
    }
    else
    {
        self.view.userInteractionEnabled = NO;
        UserAuth = [NSUserDefaults standardUserDefaults];
        NSString *strAuth = [UserAuth valueForKey:@"UserAuth"];
        
        NSString *strUrl = [NSString stringWithFormat:@"%@",API_FAQ];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
        request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strUrl]];
        
        [request setHTTPMethod:@"GET"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
        [request setValue:strAuth forHTTPHeaderField:@"Authorization"];
        [request setHTTPBody:nil];
        
        requestHandler = [[HTTPRequestHandler alloc] initWithRequest:request delegate:self andCallBack:CALL_TYPE_FAQ];
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
        [_delegate parserSuccessDelegateDidFinish:jsonRes andCallType:CALL_TYPE_FAQ];
        NSLog(@"%@",jsonRes);
        NSString *strStatus = [NSString stringWithFormat:@"%@",[jsonRes valueForKey:@"status"]];
        if ([strStatus isEqualToString:@"1"]) {
            arrFAQ = [jsonRes valueForKey:@"data"];
            NSLog(@"%@",arrFAQ);
            self.faqTableView.SKSTableViewDelegate = self;
            [_faqTableView reloadData];
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
