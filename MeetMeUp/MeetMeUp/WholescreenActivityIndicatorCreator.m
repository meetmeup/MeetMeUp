//
//  WholescreenActivityIndicator.m
//  MeetMeUp
//
//  Created by Tanya on 8/16/57 BE.
//  Copyright (c) 2557 ustwo.com.ty. All rights reserved.
//

#import "WholescreenActivityIndicatorCreator.h"

@implementation WholescreenActivityIndicatorCreator

- (UIActivityIndicatorView *) createActivityindicator
{
    CGRect frame;
    frame = [[UIScreen mainScreen] bounds];
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:frame];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [activityIndicator setBackgroundColor:[UIColor colorWithRed:44.0f/255.0f green:44.0f/255.0f blue:44.0f/255.0f alpha:0.50]];    
    return activityIndicator;
}


@end
