//
//  NonCopyPasteField.m
//  Redbull_11
//
//  Created by Maulik Desai on 08/06/17.
//  Copyright © 2017 Trainee 11. All rights reserved.
//

#import "NonCopyPasteField.h"

@implementation NonCopyPasteField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(copy:) || action == @selector(paste:))
    {
        return NO;
    }
    return [super canPerformAction:action withSender:sender];
}

- (CGRect)caretRectForPosition:(UITextPosition *)position {
    return CGRectZero;
}

@end
