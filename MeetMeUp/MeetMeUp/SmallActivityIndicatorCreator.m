//
//  ActivityIndicatorCreator.m
//  MeetMeUp
//
//  Created by Tanya on 8/11/14.
//  Copyright (c) 2014 ustwo.com.ty. All rights reserved.
//

#import "SmallActivityIndicatorCreator.h"

#define   IS_IPHONE_5     ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

@implementation SmallActivityIndicatorCreator

- (UIActivityIndicatorView *) createActivityindicator
{
    CGRect frame;
    frame = CGRectMake(140, 5, 30, 30);
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:frame];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    
    return activityIndicator;
}

@end
