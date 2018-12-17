//
//  SidebarTableViewController.m
//  SidebarDemo
//
//  Created by Simon Ng on 10/11/14.
//  Copyright (c) 2014 AppCoda. All rights reserved.
//

#import "SidebarTableViewController.h"
#import "SWRevealViewController.h"
#import "SidebarTableViewCell.h"


@interface SidebarTableViewController ()

@end

@implementation SidebarTableViewController {
    NSArray *menuItems;
    NSUserDefaults *isLogin;
    NSUserDefaults *ColorCode, *Userprofileimg, *UserData, *UserHideShow, *UserPaymentURL;
    NSString *strColor;
    NSMutableDictionary *userDictData;
    NSUserDefaults *userLanguage;
    NSString *strLang;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    isLogin = [NSUserDefaults standardUserDefaults];
    
    ColorCode = [NSUserDefaults standardUserDefaults];
    strColor = [NSString stringWithFormat:@"%@",[ColorCode valueForKey:@"colorcode"]];
    
    UserHideShow = [NSUserDefaults standardUserDefaults];
    UserPaymentURL = [NSUserDefaults standardUserDefaults];
    
    NSString *strHideShow = [NSString stringWithFormat:@"%@",[UserHideShow valueForKey:@"HideShow"]];
    
    if ([strHideShow isEqualToString:@"0"]) {
         menuItems = @[@"logo", @"applications",@"home", @"profile", @"settings", @"communicate", @"faqs",  @"contactus",  @"support", @"aboutus",  @"share", @"logout"];
    }
    else{
         menuItems = @[@"logo", @"applications",@"home", @"profile", @"purchase", @"settings", @"communicate", @"faqs",  @"contactus",  @"support", @"aboutus",  @"share", @"logout"];
    }
    
    Userprofileimg = [NSUserDefaults standardUserDefaults];
    UserData = [NSUserDefaults standardUserDefaults];
    userDictData = [[NSMutableDictionary alloc]init];
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    userLanguage = [NSUserDefaults standardUserDefaults];
    strLang = [userLanguage valueForKey:@"AppleLanguages"];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    [self.revealViewController.frontViewController.view setUserInteractionEnabled:NO];
    [self.revealViewController.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
}
-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.revealViewController.frontViewController.view setUserInteractionEnabled:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [menuItems objectAtIndex:indexPath.row];
    SidebarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    userDictData = [UserData valueForKey:@"UserData"];

    NSString *strName = [NSString stringWithFormat:@"%@",[userDictData valueForKey:@"child_name"]];
    
    if ([strName isEqualToString:@""]) {
       cell.lbl_name.text = @"Welcome";
        cell.lbl_email.text = @"GUEST";
    }
    else{
        cell.lbl_name.text = strName;
        cell.lbl_email.text = [NSString stringWithFormat:@"%@",[userDictData valueForKey:@"email"]];
    }
    
    NSString *str_image = [NSString stringWithFormat:@"%@",[Userprofileimg valueForKey:@"user_profile_image"]];
    [cell.user_profile sd_setImageWithURL:[NSURL URLWithString:str_image] placeholderImage:[UIImage imageNamed:@"user_image.png"] options:SDWebImageCacheMemoryOnly | SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        [cell.user_profile updateImageDownloadProgress:(CGFloat)receivedSize/expectedSize];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [cell.user_profile reveal];
    }];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UserHideShow = [NSUserDefaults standardUserDefaults];
    NSString *strHideShow = [NSString stringWithFormat:@"%@",[UserHideShow valueForKey:@"HideShow"]];
    
    if ([strHideShow isEqualToString:@"0"]) {
        if (indexPath.row == 11) {
            
            NSString *strLogout = NSLocalizedString(@"Are you sure you want to logout?", @"");
            NSString *strLogoutAtt = NSLocalizedString(@"Attention!!", @"");
            NSString *strYES = NSLocalizedString(@"YES", @"");
            NSString *strNO = NSLocalizedString(@"NO", @"");
            
            
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:strLogoutAtt
                                         message:strLogout
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:strYES
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                            [isLogin setInteger:0 forKey:@"LoggedIn"];
                                            [isLogin synchronize];
                                            [userLanguage setValue:@"EN" forKey:@"AppleLanguages"];
                                            [Userprofileimg setObject:@"" forKey:@"user_profile_image"];
                                            [Userprofileimg synchronize];
                                            [self performSegueWithIdentifier:@"OutToLogin" sender:self];
                                        }];
            UIAlertAction* noButton = [UIAlertAction
                                       actionWithTitle:strNO
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {
                                       }];
            [alert addAction:yesButton];
            [alert addAction:noButton];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        else if (indexPath.row == 10){
            
            userDictData = [UserData valueForKey:@"UserData"];
            NSString *strName = [NSString stringWithFormat:@"%@",[userDictData valueForKey:@"child_name"]];
            NSString *strShareLink;
            
            if ([strName isEqualToString:@""]) {
                //partner_code
                strShareLink = @"http://onelink.to/ibrainpowers";
            }
            else{
                NSString *strPatner = [NSString stringWithFormat:@"%@",[userDictData valueForKey:@"partner_code"]];
                strShareLink = [NSString stringWithFormat: @"http://onelink.to/ibrainpowers\n Use Promocode for amazing OFFER and Unlock Challenge modules part 1 & 2 for FREE.: %@",strPatner];
            }
            
            NSArray * shareItems = @[strShareLink];
            NSLog(@"%@",shareItems);
            
            UIActivityViewController * avc = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
            avc.excludedActivityTypes = nil;
            [self presentViewController:avc animated:YES completion:nil];
            
        }
    }
    else{
        if (indexPath.row == 12) {
            
            NSString *strLogout = NSLocalizedString(@"Are you sure you want to logout?", @"");
            NSString *strLogoutAtt = NSLocalizedString(@"Attention!!", @"");
            NSString *strYES = NSLocalizedString(@"YES", @"");
            NSString *strNO = NSLocalizedString(@"NO", @"");
            
            
            UIAlertController * alert = [UIAlertController
                                         alertControllerWithTitle:strLogoutAtt
                                         message:strLogout
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:strYES
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
            UIAlertAction* noButton = [UIAlertAction
                                       actionWithTitle:strNO
                                       style:UIAlertActionStyleDefault
                                       handler:^(UIAlertAction * action) {
                                       }];
            [alert addAction:yesButton];
            [alert addAction:noButton];
            [self presentViewController:alert animated:YES completion:nil];
            
        }
        else if (indexPath.row == 11){
            
            userDictData = [UserData valueForKey:@"UserData"];
            
            NSString *strName = [NSString stringWithFormat:@"%@",[userDictData valueForKey:@"child_name"]];
            
            NSString *strShareLink;
            
            if ([strName isEqualToString:@""]) {
                //partner_code
                strShareLink = @"http://onelink.to/ibrainpowers";
            }
            else{
                NSString *strPatner = [NSString stringWithFormat:@"%@",[userDictData valueForKey:@"partner_code"]];
                strShareLink = [NSString stringWithFormat: @"http://onelink.to/ibrainpowers\n Use Promocode for amazing OFFER and Unlock Challenge modules part 1 & 2 for FREE.: %@",strPatner];
            }
            
            NSArray * shareItems = @[strShareLink];
            NSLog(@"%@",shareItems);
            
            UIActivityViewController * avc = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
            avc.excludedActivityTypes = nil;
            [self presentViewController:avc animated:YES completion:nil];
            
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // CGFloat height;
    if(indexPath.row==0)
    {
        return   140;
    }
    else if (indexPath.row == 1 || indexPath.row == 6){
        return 25;
    }
    else
    {
        return 50;
    }
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    
//    // Set the title of navigation bar by using the menu items
//    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//    UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
//    destViewController.title = [[menuItems objectAtIndex:indexPath.row] capitalizedString];
//    
//    // Set the photo if it navigates to the PhotoView
//   
//}


@end
