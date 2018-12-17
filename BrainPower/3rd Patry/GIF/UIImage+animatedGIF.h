//
//  AppDelegate.h
//  NightyNightBaby
//
//  Created by Trainee 11 on 07/09/17.
//  Copyright © 2017 Trainee 11. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIImage (animatedGIF)

+ (UIImage * _Nullable)animatedImageWithAnimatedGIFData:(NSData * _Nonnull)theData;
+ (UIImage * _Nullable)animatedImageWithAnimatedGIFURL:(NSURL * _Nonnull)theURL;

@end
